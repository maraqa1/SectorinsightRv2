#' Predict Based on a Topic of Interest
#'
#' Selects and loads a pre-trained model containing the specified topic of interest,
#' then makes predictions for the provided text using the selected model.
#'
#' @param text A character string containing the text to classify.
#' @param topic_keyword A character string specifying the topic of interest (e.g., "Cybersecurity").
#' @param pkgname The package name (default is the current package name).
#' @param verbose A logical value indicating whether to print diagnostic messages. Default is `TRUE`.
#'
#' @return A data frame containing:
#' - The input text.
#' - The predicted cluster ID.
#' - The suggested label for the predicted cluster.
#'
#' @examples
#' \dontrun{
#' # Predict the sector for a cybersecurity-related text
#' predict_by_topic("This is about cybersecurity advancements.", "Cybersecurity")
#' }
#'
#' @export

predict_by_topic <- function(text, topic_keyword, pkgname = utils::packageName(), verbose = TRUE) {
  matches <- find_topic(topic_keyword, pkgname)

  cat("Matching models:\n")
  for (model_name in names(matches)) {
    cat("Model:", model_name, "\n")
    print(matches[[model_name]])
    cat("\n")
  }

  model_index <- as.integer(readline(prompt = "Enter the index of the model to use: "))
  if (is.na(model_index) || model_index < 1 || model_index > length(matches)) {
    stop("Invalid selection.")
  }

  selected_model_file <- names(matches)[model_index]
  topics <- as.numeric(strsplit(selected_model_file, "_")[[1]][1])
  load_model(topics, pkgname)

  return(predict_sector(text, verbose = verbose))
}
