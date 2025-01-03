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
## Shiny App Integration
The package can be integrated with an advanced Shiny App for interactive NLP analysis. The app provides:

- **Model Selection**: Choose models (15-topic, 23-topic) or load models by topic.
- **Single Text Analysis**: Input text and analyze the predicted topics visually.
- **Batch Analysis**: Upload a CSV file with text data for batch processing.

### Running the Shiny App
Use the following command to launch the app:

```r
library(shiny)
runApp(system.file("shiny_app", package = "SectorinsightRv2"))
```
Example Workflow
Single Text Analysis
```r
## Load the model
SectorinsightRv2::load_model(15)

### Perform single text analysis
text <- "AI-powered systems are transforming urban planning and development."
result <- SectorinsightRv2::predict_top_n_clusters(texts = text, n = 3)
print(result)
```
Batch File Analysis
```r
## Load the model
SectorinsightRv2::load_model(23)

## Perform batch analysis
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

## How to Add New Models to SectorinsightRv2
This guide explains how to add new models (e.g., KMeans models for clustering or DFM models for feature extraction) to the SectorinsightRv2 package so they can be used for text analysis tasks.

### Folder Structure for Models
The models used by the package are stored in the following directory structure under the inst/extdata/ folder:

``` graphql

inst/extdata/
├── models/
│   ├── dfm/      # Stores the Document-Feature Matrix (DFM) models
│   │   ├── 15_topic_dfm.rds
│   │   ├── 23_topic_dfm.rds
│   │   └── [new_dfm_model].rds
│   ├── kmeans/   # Stores the KMeans clustering models
│   │   ├── 15_topic_kmeans.rds
│   │   ├── 23_topic_kmeans.rds
│   │   └── [new_kmeans_model].rds
```
### Requirements for New Models
1. For DFM Models:
The model must be created using the quanteda::dfm() function or be compatible with quanteda objects.
Ensure the feature names (columns) of the new DFM model are aligned with the feature names in the KMeans model. This ensures proper feature matching during predictions.

2. For KMeans Models:
The model must be created using the stats::kmeans() function.

The KMeans object must include:
  - centers: A matrix of cluster centers.
  - labels: A named vector where cluster IDs (names) map to suggested cluster labels (values).
Ensure cluster labels are meaningful and represent the topics covered by each cluster.
### Adding New Models to the Package

Step 1: Save Your Models
Save your DFM and KMeans models in .rds format:

```r
# Save a DFM model
saveRDS(dfm_model, file = "30_topic_dfm.rds")
# Save a KMeans model
saveRDS(kmeans_model, file = "30_topic_kmeans.rds")
```
Step 2: Place Models in the Correct Folders
  - Place the DFM model (30_topic_dfm.rds) in the inst/extdata/models/dfm/ folder.
  - Place the KMeans model (30_topic_kmeans.rds) in the inst/extdata/models/kmeans/ folder.
Adding Cluster Labels to KMeans Models
  Each KMeans model should have meaningful cluster labels for better interpretability. These labels should be stored in the labels attribute of the KMeans object. Here’s how to add or modify the labels:

```r
# Assume `kmeans_model` is your KMeans object
# Define cluster labels (adjust as needed for your model)
cluster_labels <- c(
  "Cluster 1: Renewable Energy and Wind Power",
  "Cluster 2: Artificial Intelligence in Education",
  "Cluster 3: Sustainable Agriculture"
)

# Add labels to the KMeans model
kmeans_model$labels <- cluster_labels

# Save the updated KMeans model
saveRDS(kmeans_model, file = "new_kmeans_model.rds")
```

Verifying the Models
After adding your models to the correct folders, you can verify them using the following commands:

```r
# List all available models
SectorinsightRv2::list_models()

# List all topics across all models
SectorinsightRv2::list_all_topics()
```
These commands will confirm that the new models are properly loaded and their topics are available.

Example: Adding a New 30-Topic Model
Here’s a complete example of how to add a 30-topic model:

#### Prepare the Models

Create the DFM model using quanteda:
```r

dfm_model <- quanteda::dfm(corpus, tolower = TRUE, remove_punct = TRUE)
saveRDS(dfm_model, file = "30_topic_dfm.rds")
```
Train a KMeans model:
```r
kmeans_model <- kmeans(quanteda::convert(dfm_model, to = "matrix"), centers = 30)
kmeans_model$labels <- paste("Cluster", 1:30, ": Example Topic")  # Add labels
saveRDS(kmeans_model, file = "30_topic_kmeans.rds")
```

### Move the Files

  - Place 30_topic_dfm.rds in inst/extdata/models/dfm/.

  - Place 30_topic_kmeans.rds in inst/extdata/models/kmeans/.

Verify the Models
```r
SectorinsightRv2::list_models()
SectorinsightRv2::list_all_topics()
```
Use the New Models

### To load the model manually:
```r
SectorinsightRv2::load_model(30)  # Assuming 30 is the number for the new model
To analyze text:
```r

result <- SectorinsightRv2::predict_top_n_clusters(
  text = "This project focuses on AI and renewable energy.",
  n = 2
)
print(result)
```

## Notes on Compatibility
Ensure the DFM and KMeans models are compatible (e.g., have matching feature names).
Always add meaningful cluster labels to improve interpretability.
For large models, consider optimizing storage (e.g., using sparse matrices).

FAQs

How can I confirm if my new model is loaded?
Use the following commands:

```r
SectorinsightRv2::list_models()       # Lists all available models
SectorinsightRv2::list_all_topics()   # Lists topics across all models
```

What if my new model doesn't appear in the list?
Ensure the .rds files are in the correct folders (dfm/ or kmeans/).
Verify that the models are properly saved and compatible with SectorinsightRv2.
How can I remove or replace an existing model?
Simply replace or delete the .rds files in the corresponding inst/extdata/models/ folder


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
