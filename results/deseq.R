library(DESeq2)
# --- Create the DESeq2 Dataset Object ---
# This combines the count data and the experimental design.
dds <- DESeqDataSetFromMatrix(countData = countData,
                              colData = colData,
                              design = ~ condition)

# Set the "control" condition to be the baseline for comparison
dds$condition <- relevel(dds$condition, ref = "control")

# --- Run the Core DESeq2 Analysis ---
# This single function performs normalization, dispersion estimation,
# and statistical testing.
dds <- DESeq(dds)

# --- Extract and Format the Results ---
# Get the results table, which compares 'fermentation' vs 'control'
res <- results(dds)

# Sort the results by the adjusted p-value (padj), so the most significant
# genes are at the top.
sorted_res <- res[order(res$padj), ]

# Convert the results to a data frame for easy handling and saving.
sorted_df <- data.frame("gene" = rownames(sorted_res), sorted_res)

# Write the full results to a file.
write.table(sorted_df, file = "result.txt", sep = "\t", row.names = FALSE, quote = FALSE)

# Get the normalized count matrix and save it for visualization.
normalized_counts <- counts(dds, normalized = TRUE)
norm_df <- data.frame("gene" = rownames(normalized_counts), normalized_counts)
write.table(norm_df, file = "norm-matrix-deseq2.txt", sep = "\t", row.names = FALSE, quote = FALSE)

# Let's see the top 6 most significantly changed genes.
head(sorted_df)
