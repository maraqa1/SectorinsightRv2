#' Predict Top N Clusters for Multiple Texts
#'
#' Predicts the top N clusters for each input text based on pre-loaded models.
#'
#' @param texts A character vector of texts to classify.
#' @param n The number of top clusters to retrieve. Default is 2.
#' @param verbose A logical indicating whether diagnostic messages should be printed.
#'        Default is TRUE.
#' @return A data frame with:
#' - `text`: The original input text.
#' - `overlapping_terms`: Overlapping terms between the input text and the model's vocabulary.
#' - `topic_1`, `topic_2`, ..., `topic_n`: The top N clusters with their scores and labels.
#' @export
predict_top_n_clusters <- function(texts, n = 2, verbose = TRUE) {
  # Access models and labels from package_env
  dfm_model <- SectorinsightRv2:::package_env$dfm_model
  kmeans_model <- SectorinsightRv2:::package_env$kmeans_model
  cluster_labels_df <- SectorinsightRv2:::package_env$cluster_labels_df

  # Initialize a list to store results
  results_list <- vector("list", length(texts))

  # Extract cluster centers
  cluster_centers <- as.data.frame(kmeans_model$centers)

  # Loop through each text
  for (i in seq_along(texts)) {
    text <- texts[i]

    # Step 1: Tokenize and create DFM for the current text
    dfm_new <- quanteda::dfm(
      quanteda::tokens(
        text,
        remove_punct = TRUE
      ) %>%
        quanteda::tokens_tolower()
    )

    # Step 2: Match the features of the new DFM to the loaded DFM model
    dfm_new <- quanteda::dfm_match(dfm_new, features = colnames(dfm_model))

    # Step 3: Check for overlapping terms
    overlap_terms <- colnames(dfm_new)[quanteda::colSums(dfm_new) > 0]
    if (verbose) message("Overlapping terms: ", paste(overlap_terms, collapse = ", "))

    if (length(overlap_terms) > 0) {
      # Step 4: Calculate similarity scores for each cluster
      overlap_contribution <- cluster_centers[, overlap_terms, drop = FALSE]
      cluster_scores <- rowSums(overlap_contribution, na.rm = TRUE)

      # Get the top N clusters
      top_n_indices <- order(cluster_scores, decreasing = TRUE)[1:n]
      top_n_labels <- cluster_labels_df$Suggested_Label[match(top_n_indices, cluster_labels_df$Cluster)]
      top_n_scores <- cluster_scores[top_n_indices]

      # Create result columns for top N clusters
      result_row <- list(
        text = text,
        overlapping_terms = paste(overlap_terms, collapse = ", ")  # Save overlapping terms as a string
      )
      for (j in seq_len(n)) {
        result_row[[paste0("topic_", j)]] <- paste0("Cluster ", top_n_indices[j], ": ", top_n_labels[j],
                                                    " (Score: ", round(top_n_scores[j], 3), ")")
      }
      results_list[[i]] <- result_row
    } else {
      # If no overlap, assign NA
      result_row <- list(
        text = text,
        overlapping_terms = "No overlapping terms found"
      )
      for (j in seq_len(n)) {
        result_row[[paste0("topic_", j)]] <- NA
      }
      results_list[[i]] <- result_row
    }
  }

  # Combine results into a data frame
  results <- do.call(rbind, lapply(results_list, as.data.frame))

  return(results)
}

