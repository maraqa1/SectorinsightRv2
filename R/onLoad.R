#' Package Startup
#'
#' Automatically loads the default 15-topic models (DFM and KMeans) along with cluster labels
#' when the package is loaded.
#'
#' @param libname The library path where the package is installed.
#' @param pkgname The name of the package.
#'
#' @keywords internal

.onLoad <- function(libname, pkgname) {
  message("DEBUG: Initializing package and loading default models...")

  # Define paths to the default models
  dfm_model_path <- system.file("extdata/models/dfm/15_topic_dfm.rds", package = pkgname)
  kmeans_model_path <- system.file("extdata/models/kmeans/15_topic_kmeans.rds", package = pkgname)

  # Load the default DFM model
  if (file.exists(dfm_model_path)) {
    package_env$dfm_model <- readRDS(dfm_model_path)
    message("DEBUG: Default DFM model loaded successfully.")
  } else {
    warning("Default DFM model could not be loaded: File not found.")
  }

  # Load the default KMeans model
  if (file.exists(kmeans_model_path)) {
    kmeans_model <- readRDS(kmeans_model_path)
    package_env$kmeans_model <- kmeans_model
    message("DEBUG: Default KMeans model loaded successfully.")

    # Extract cluster labels
    if (!is.null(kmeans_model$labels)) {
      cluster_labels_df <- data.frame(
        Cluster = as.numeric(names(kmeans_model$labels)),  # Cluster IDs
        Suggested_Label = unname(kmeans_model$labels)      # Labels from the model
      )

      # Annotate clusters
      cluster_assignments <- data.frame(
        Text = names(kmeans_model$cluster),  # Observation names
        Cluster = kmeans_model$cluster       # Assigned cluster IDs
      )
      library(dplyr)
      annotated_clusters <- cluster_assignments %>%
        dplyr::left_join(cluster_labels_df, by = "Cluster") %>%
        dplyr::select(Cluster, Suggested_Label) %>%
        dplyr::distinct() %>%
        dplyr::arrange(Cluster)

      package_env$cluster_labels_df <- annotated_clusters
      message("DEBUG: Annotated clusters created and loaded successfully.")
    } else {
      stop("ERROR: The KMeans model does not contain cluster labels.")
    }
  } else {
    warning("Default KMeans model could not be loaded: File not found.")
  }

  message("DEBUG: Package initialization complete.")
}
