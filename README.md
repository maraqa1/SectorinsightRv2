# SectorinsightRv2

**SectorinsightRv2** is an R package designed for Natural Language Processing (NLP) tasks, with a focus on clustering and topic modeling for structured and unstructured text data. It provides a streamlined interface for analyzing text data using pre-trained models, identifying key topics, and visualizing results.

---

## Key Features

- **Pre-trained Models**: Supports pre-trained topic models (e.g., 15-topic and 23-topic KMeans models).
- **Text Analysis**: Enables single text analysis and batch text analysis.
- **Topic Prediction**: Predicts top N clusters/topics for input text.
- **Visualization**: Includes bar charts and other visualizations for topic results.
- **Dynamic Topic Selection**: Allows model selection based on predefined topics or clusters.
- **Batch Processing**: Handles large datasets efficiently.

---

## Installation

To install **SectorinsightRv2**, use the following command:

```r
# Install SectorinsightRv2 from your local environment or GitHub
devtools::install_github("maraqa1/SectorinsightRv2")
```
Ensure that you have the required dependencies installed. Missing dependencies can be installed using the following command:

```r
install.packages(c("dplyr", "ggplot2", "quanteda", "stringr", "DT", "future.apply"))
```
## Usage
Loading the Package
```r
library(SectorinsightRv2)
```

## Key Functions
1. load_model()
Loads a pre-trained model by specifying the number of topics.
Example:
```r
SectorinsightRv2::load_model(15)  # Loads the 15-topic model
```
2. list_models()
Lists all the available pre-trained models in the package.
```r
topics <- SectorinsightRv2::list_all_topics()
print(topics)
```
4. find_topic()
Finds models and clusters containing a specific topic.

Example:
```r
matches <- SectorinsightRv2::find_topic("Cybersecurity")
print(matches)
```

5. predict_top_n_clusters()
Predicts the top N clusters/topics for input text.

Example:
```r
result <- SectorinsightRv2::predict_top_n_clusters(
  texts = "This project focuses on AI-powered solutions for urban development.", 
  n = 2
)
print(result)
```
6. predict_by_topic()
Predicts the cluster or topic for input text based on a specific topic or cluster number.

Example:
```r

result <- SectorinsightRv2::predict_by_topic(
  text = "This project focuses on renewable energy and wind power technologies.", 
  topic_keyword = "Renewable Energy"
)
print(result)
```
### Shiny App Integration
The package can be integrated with an advanced Shiny App for interactive NLP analysis. The app provides:

- **Model Selection**: Choose models (15-topic, 23-topic) or load models by topic.
- **Single Text Analysis**: Input text and analyze the predicted topics visually.
- **Batch Analysis**: Upload a CSV file with text data for batch processing.

Running the Shiny App
Use the following command to launch the app:

```r
library(shiny)
runApp(system.file("shiny_app", package = "SectorinsightRv2"))
```
Example Workflow
Single Text Analysis
```r
# Load the model
SectorinsightRv2::load_model(15)

# Perform single text analysis
text <- "AI-powered systems are transforming urban planning and development."
result <- SectorinsightRv2::predict_top_n_clusters(texts = text, n = 3)
print(result)
```
Batch File Analysis
```r
# Load the model
SectorinsightRv2::load_model(23)

# Perform batch analysis
texts <- c(
  "AI and data science are revolutionizing industries.",
  "Renewable energy systems are critical for sustainability.",
  "Space exploration requires advanced materials."
)

result <- SectorinsightRv2::predict_top_n_clusters(texts = texts, n = 2)
print(result)
```
## Dependencies
The package depends on the following R packages:

- dplyr: For data manipulation
- ggplot2: For creating visualizations
- quanteda: For NLP and text processing
- stringr: For string manipulation
- DT: For interactive tables
- future.apply: For parallelized batch processing

  Install missing dependencies using:

```r
install.packages(c("dplyr", "ggplot2", "quanteda", "stringr", "DT", "future.apply"))
```
Known Issues
Model Loading Errors: Ensure the package is correctly installed and the pre-trained models are available in the expected directory (inst/extdata/models).
Batch Processing: Ensure the input CSV file has a text_column containing the texts to be analyzed.
Startup Messages: Suppress package initialization messages using suppressMessages().
Contributing
Contributions are welcome! Please follow these steps:

Fork the repository.
Create a feature branch (git checkout -b feature-branch-name).
Commit your changes (git commit -m "Add new feature").
Push to the branch (git push origin feature-branch-name).
Create a pull request.
License
This package is licensed under the MIT License. See the LICENSE file for details.

Acknowledgments
Special thanks to the contributors and developers who made this package possible. If you encounter any issues, please report them in the GitHub Issues section.

This README file provides a comprehensive overview of the SectorinsightRv2 package, including installation instructions, function usage, examples, dependencies, and troubleshooting. You can enhance it further with additional examples or screenshots of the Shiny app.
