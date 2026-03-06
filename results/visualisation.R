# Load the library for making heatmaps
library(gplots)

# --- Load the Normalized Counts ---
data <- read.table("norm-matrix-deseq2.txt", header = TRUE, sep = "\t", as.is = TRUE)

# Extract gene names and the count data (excluding the gene column)
gene_names <- data[, 1]
count_matrix <- as.matrix(data[, 2:ncol(data)])

# Add a tiny amount of noise to prevent clustering errors on data with zero variance.
count_matrix <- jitter(count_matrix, factor = 1, amount = 0.00001)

# --- Calculate Z-scores for Each Gene ---
# Z-scores center the data so we can see the *relative* change for each gene,
# regardless of its absolute expression level. A high z-score means high
# expression for that gene in that sample relative to its own average.
zscore_matrix <- NULL
for (i in 1:nrow(count_matrix)) {
  row <- count_matrix[i, ]
  zscore <- (row - mean(row)) / sd(row)
  zscore_matrix <- rbind(zscore_matrix, zscore)
}
rownames(zscore_matrix) <- gene_names
colnames(zscore_matrix) <- colnames(count_matrix)

# --- Generate and Save the Heatmap ---
# Open a PDF device to save the plot
pdf('heatmap_output.pdf', width = 10, height = 8)

# Define a color palette (green = low, black = medium, red = high)
my_colors <- colorRampPalette(c("green", "black", "red"))(256)

# Create the heatmap
heatmap.2(zscore_matrix,
          col = my_colors,
          density.info = "none",
          trace = "none",
          margins = c(10, 10),   # Increase bottom/right margins for sample/gene names
          lhei = c(1, 5),         # Adjust the height of the dendrogram vs. the main plot
          main = "Top 50 Differentially Expressed Genes: Control vs. Fermentation")

# Close the PDF device
invisible(dev.off())
