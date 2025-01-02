#' List All Available Models
#'
#' Returns a list of all available KMeans models in the package along with their metadata (e.g., number of topics).
#'
#' @param pkgname The package name (default is the current package).
#' @return A data frame containing model names, number of topics, and file paths.
#' @examples
#' SectorinsightRv2::list_models()
#' @export
list_models <- function(pkgname = utils::packageName()) {
  # Path to KMeans model directory
  kmeans_dir <- system.file("extdata/models/kmeans", package = pkgname)

  # Check if directory exists
  if (!dir.exists(kmeans_dir)) {
    stop("KMeans model directory not found: ", kmeans_dir)
  }

  # List all RDS files in the directory
  model_files <- list.files(kmeans_dir, pattern = "\\.rds$", full.names = TRUE)

  if (length(model_files) == 0) {
    stop("No KMeans models found in the directory: ", kmeans_dir)
  }

  # Extract metadata from model file names
  model_metadata <- data.frame(
    Model_Name = basename(model_files),
    Topics = as.numeric(stringr::str_extract(basename(model_files), "\\d+")),
    File_Path = model_files,
    stringsAsFactors = FALSE
  )

  # Sort by number of topics
  model_metadata <- model_metadata[order(model_metadata$Topics), ]

  return(model_metadata)
}
