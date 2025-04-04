#' Find Topics Across Models
#'
#' Searches all available models for a specific topic keyword in the cluster labels.
#'
#' @param topic_keyword A keyword to search for in cluster labels (case-insensitive).
#' @param pkgname The name of the package. Default is the current package name.
#' @param verbose Logical. If TRUE, prints debug information. Default is FALSE.
#'
#' @return A list of models containing the topic of interest, where each list element
#' is a data frame of clusters and their labels.
#'
#' @examples
#' \dontrun{
#' find_topic("Cybersecurity")
#' }
#'
#' @export
find_topic <- function(topic_keyword, pkgname = utils::packageName(), verbose = FALSE) {
  # Get the directory containing KMeans models
  kmeans_dir <- system.file("extdata/models/kmeans", package = pkgname)
  model_files <- list.files(kmeans_dir, pattern = "\\.rds$", full.names = TRUE)
  matches <- list()  # Initialize a list to store matching models

  if (verbose) {
    message("DEBUG: Searching for topic '", topic_keyword, "' across models...")
    message("DEBUG: Found ", length(model_files), " model files.")
  }

  # Iterate through each model file
  for (model_file in model_files) {
    if (verbose) {
      message("DEBUG: Checking file: ", basename(model_file))
    }

    # Load the KMeans model safely
    kmeans_model <- tryCatch(readRDS(model_file), error = function(e) {
      warning("Failed to read model file: ", basename(model_file), " - Skipping.")
      return(NULL)
    })

    # Skip to the next model if the current model could not be loaded
    if (is.null(kmeans_model)) {
      next
    }

    # Check for cluster labels
    if (!is.null(kmeans_model$labels)) {
      # Generate sequential cluster IDs if names are missing or mismatched
      cluster_ids <- if (is.null(names(kmeans_model$labels)) ||
                         length(names(kmeans_model$labels)) != length(kmeans_model$labels)) {
        seq_along(kmeans_model$labels)
      } else {
        as.numeric(names(kmeans_model$labels))
      }

      # Create a data frame of cluster IDs and labels
      cluster_labels <- data.frame(
        Cluster = cluster_ids,
        Suggested_Label = unname(kmeans_model$labels),
        stringsAsFactors = FALSE
      )

      # Filter clusters that match the topic keyword (case-insensitive search)
      matching_clusters <- cluster_labels[grepl(topic_keyword, cluster_labels$Suggested_Label, ignore.case = TRUE), ]

      # If matches are found, add to results
      if (nrow(matching_clusters) > 0) {
        # Remove duplicates from the matching clusters
        matching_clusters <- matching_clusters %>%
          dplyr::distinct(Suggested_Label, .keep_all = TRUE)

        if (verbose) {
          message("DEBUG: Found ", nrow(matching_clusters), " unique matching clusters in ", basename(model_file))
        }
        matches[[basename(model_file)]] <- matching_clusters
      }
    } else if (verbose) {
      message("DEBUG: No cluster labels found in ", basename(model_file))
    }
  }

  # Return results or a message if no matches are found
  if (length(matches) == 0) {
    if (verbose) {
      message("No models contain the topic: ", topic_keyword)
    }
    return(list())  # Return an empty list instead of stopping
  } else {
    return(matches)
  }
}
