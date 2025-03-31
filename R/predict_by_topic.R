#' Find Topics Across Models
#'
#' Searches for a specific topic keyword across all models in the package. The function allows either
#' exact matching or approximate (fuzzy) matching of topic names and returns a list of models containing
#' the matching topics.
#'
#' @param topic_keyword A character string specifying the topic keyword to search for in cluster labels.
#' @param fuzzy Logical. If TRUE, performs approximate (fuzzy) matching using \code{agrepl}. If FALSE, performs
#'   exact matching using \code{grepl}. Default is FALSE.
#' @param verbose Logical. If TRUE, prints debug information about the matching process. Default is FALSE.
#' @param pkgname A character string specifying the name of the package. Default is the name of the current package.
#'
#' @return A list where each element corresponds to a model containing matching topics. Each element is a data frame
#'   of matching clusters with columns:
#'   \describe{
#'     \item{\code{Cluster}}{Cluster ID within the model.}
#'     \item{\code{Suggested_Label}}{Cluster label containing the matched topic keyword.}
#'   }
#'   If no matches are found, returns \code{NULL}.
#'
#' @examples
#' \dontrun{
#' # Example 1: Find topics using exact matching
#' exact_matches <- find_topic("Hydrogen Energy and Renewable Fuels", fuzzy = FALSE, verbose = TRUE)
#'
#' # Example 2: Find topics using fuzzy matching
#' fuzzy_matches <- find_topic("Renewable Energy", fuzzy = TRUE, verbose = TRUE)
#'
#' # Example 3: Check all matching models and topics
#' if (!is.null(fuzzy_matches)) {
#'   print(fuzzy_matches)
#' }
#' }
#'
#' @export
find_topic <- function(topic_keyword, fuzzy = FALSE, verbose = FALSE, pkgname = utils::packageName()) {
  # Fetch all available topics from the models
  topics_df <- SectorinsightRv2::list_all_topics()

  if (nrow(topics_df) == 0) {
    stop("No topics found across available models.")
  }

  # Perform matching based on the `fuzzy` argument
  if (fuzzy) {
    # Fuzzy matching using `agrepl` (allows approximate matches)
    matched_topics <- topics_df[agrepl(topic_keyword, topics_df$Topic, ignore.case = TRUE), ]
  } else {
    # Exact matching using `grepl` (case-insensitive)
    matched_topics <- topics_df[grepl(topic_keyword, topics_df$Topic, ignore.case = TRUE), ]
  }

  if (verbose) {
    message("DEBUG: Searching for topic '", topic_keyword, "'")
    if (fuzzy) {
      message("DEBUG: Fuzzy matching enabled.")
    } else {
      message("DEBUG: Exact matching enabled.")
    }
    message("DEBUG: Total matches found: ", nrow(matched_topics))
  }

  # If no matches found, return NULL
  if (nrow(matched_topics) == 0) {
    warning("No models found for the specified topic: ", topic_keyword)
    return(NULL)
  }

  # Group matches by model name
  matches <- split(matched_topics, matched_topics$Model)

  if (verbose) {
    message("DEBUG: Matched models and topics:\n")
    print(matches)
  }

  return(matches)
}

