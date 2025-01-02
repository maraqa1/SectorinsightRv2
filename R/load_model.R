#' Load a Pre-Trained Model
#'
#' Dynamically loads a pre-trained DFM and KMeans model for a specified number of topics.
#' It also extracts cluster labels from the KMeans model and annotates the cluster assignments.
#'
#' @param topics An integer specifying the number of topics (e.g., 15, 25).
#' @param pkgname The package name (default is the current package name).
#'
#' @return Loads the models and assigns them to the package's namespace:
#' - `dfm_model`: The loaded DFM model.
#' - `kmeans_model`: The loaded KMeans model.
#' - `cluster_labels_df`: A data frame containing cluster IDs and their suggested labels.
#'
#' @examples
#' \dontrun{
#' # Load the 25-topic model
#' load_model(topics = 25)
#' }
#'
#' @export
load_model <- function(topics, pkgname = utils::packageName()) {
  if (missing(topics)) {
    stop("ERROR: The 'topics' argument is required. Please specify the number of topics (e.g., 15, 21, etc.).")
  }

  message(sprintf("DEBUG: Loading models for %d topics...", topics))

  # Access the package environment dynamically
  package_env <- get("package_env", envir = asNamespace(pkgname))

  # Define paths to the models
  dfm_model_path <- system.file("extdata/models/dfm", paste0(topics, "_topic_dfm.rds"), package = pkgname)
  kmeans_model_path <- system.file("extdata/models/kmeans", paste0(topics, "_topic_kmeans.rds"), package = pkgname)

  # Load the DFM model
  if (file.exists(dfm_model_path)) {
    dfm_model <- readRDS(dfm_model_path)
    package_env$dfm_model <- dfm_model
    message(sprintf("DEBUG: DFM model for %d topics loaded successfully.", topics))
  } else {
    stop(sprintf("ERROR: DFM model for %d topics could not be loaded. File not found.", topics))
  }

  # Load the KMeans model
  if (file.exists(kmeans_model_path)) {
    kmeans_model <- readRDS(kmeans_model_path)
    package_env$kmeans_model <- kmeans_model
    message(sprintf("DEBUG: KMeans model for %d topics loaded successfully.", topics))

    # Generate cluster-level labels
    if (!is.null(kmeans_model$labels)) {
      if (length(kmeans_model$labels) == length(kmeans_model$cluster)) {
        message("DEBUG: Aggregating observation-level labels to cluster-level labels...")
        cluster_labels_df <- data.frame(
          Cluster = unique(kmeans_model$cluster),
          Suggested_Label = sapply(unique(kmeans_model$cluster), function(cluster_id) {
            cluster_labels <- kmeans_model$labels[kmeans_model$cluster == cluster_id]
            names(sort(table(cluster_labels), decreasing = TRUE))[1]
          })
        )
      } else if (length(kmeans_model$labels) == nrow(kmeans_model$centers)) {
        cluster_labels_df <- data.frame(
          Cluster = as.numeric(names(kmeans_model$labels)),
          Suggested_Label = unname(kmeans_model$labels)
        )
      } else {
        stop("ERROR: The length of kmeans_model$labels is inconsistent with both observation and cluster counts.")
      }
    } else {
      stop("ERROR: kmeans_model does not contain any labels.")
    }

    # Save cluster labels in package_env
    package_env$cluster_labels_df <- cluster_labels_df
    message("DEBUG: Cluster labels created and loaded successfully.")
  } else {
    stop(sprintf("ERROR: KMeans model for %d topics could not be loaded. File not found.", topics))
  }
}
