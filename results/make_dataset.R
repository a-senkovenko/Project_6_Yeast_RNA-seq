# Load the DESeq2 library
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("DESeq2")
library(DESeq2)

# --- Load the Count Data ---
# Read the count table from the file.
# row.names=1 tells R to use the first column (geneid) as the row names.
countData <- read.table("simple_fcounts.txt", header=TRUE, sep="\t", row.names=1)

# Take a look at the first few rows to ensure it loaded correctly
head(countData)

# --- Define the Experimental Design ---
# Create a data frame describing each sample and its condition.
# The samples are in the same order as the columns in countData.
samples <- colnames(countData)
condition <- factor(c("control", "control", "fermentation", "fermentation"))
colData <- data.frame(samples = samples, condition = condition)

# Check the design
print(colData)


