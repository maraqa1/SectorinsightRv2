#' Extract Topics from All Models
#'
#' Extracts all unique topics from the available KMeans models in the package.
#'
#' @param pkgname The package name (default is the current package).
#' @return A data frame containing topics and the associated models.
#' @examples
#' SectorinsightRv2::list_all_topics()
#' @export
list_all_topics <- function(pkgname = utils::packageName()) {
  # Get all models
  model_metadata <- list_models(pkgname = pkgname)
  #model_metadata <- list_models(pkgname="SectorinsightRv2")
  #print(model_metadata)

  # Initialize a list for topics
  all_topics <- list()

  # Iterate through each model and extract topics
  for (i in seq_len(nrow(model_metadata))) {
    model_file <- model_metadata$File_Path[i]
    model_name <- model_metadata$Model_Name[i]

    # Load the KMeans model
    kmeans_model <- tryCatch(readRDS(model_file), error = function(e) NULL)
    if (!is.null(kmeans_model) && !is.null(kmeans_model$labels)) {
      #cluster_labels <- unname(kmeans_model$labels)
      cluster_labels <- unique(unlist(kmeans_model$labels))

      # Clean escaped quotes (if any)
      cluster_labels <- gsub("^\"|\"$", "", cluster_labels)



      topics_df <- data.frame(
        Model = model_name,
        Topic = cluster_labels,
        stringsAsFactors = FALSE
      )
      all_topics[[model_name]] <- topics_df
    }
  }

  # Combine all topics into a single data frame
  combined_topics <- do.call(rbind, all_topics)

  if (is.null(combined_topics)) {
    stop("No topics found in the available models.")
  }

  # Return unique topics and their associated models
  combined_topics <- combined_topics %>%
    dplyr::distinct()

  return(combined_topics)
}
