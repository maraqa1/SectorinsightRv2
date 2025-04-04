% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/predict.R
\name{predict_top_n_clusters}
\alias{predict_top_n_clusters}
\title{Predict Top N Clusters for Multiple Texts}
\usage{
predict_top_n_clusters(texts, n = 2, verbose = TRUE)
}
\arguments{
\item{texts}{A character vector of texts to classify.}

\item{n}{The number of top clusters to retrieve. Default is 2.}

\item{verbose}{A logical indicating whether diagnostic messages should be printed.
Default is TRUE.}
}
\value{
A data frame with:
\itemize{
\item \code{text}: The original input text.
\item \code{overlapping_terms}: Overlapping terms between the input text and the model's vocabulary.
\item \code{topic_1}, \code{topic_2}, ..., \code{topic_n}: The top N clusters with their scores and labels.
}
}
\description{
Predicts the top N clusters for each input text based on pre-loaded models.
}
