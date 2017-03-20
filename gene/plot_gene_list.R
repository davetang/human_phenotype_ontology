#!/usr/bin/env Rscript
#
# Usage: plot_gene_list.R <gene_list.txt>
#

if("igraph" %in% rownames(installed.packages()) == FALSE){
  stop("Please install the igraph package first by running: install.packages('igraph')")
}

suppressPackageStartupMessages(library(igraph))

args <- commandArgs(TRUE)
if (length(args) != 1){
  stop('Please input gene list file')
}

library(igraph)

my_file <- args[1]
my_base <- gsub(pattern = '.*/(.*)', replacement = '\\1', x = my_file, perl = TRUE)
my_base <- gsub(pattern = '(.*)\\.\\w+$', replacement = '\\1', x = my_base, perl = TRUE)

# http://stackoverflow.com/questions/1815606/rscript-determine-path-of-the-executing-script
initial.options <- commandArgs(trailingOnly = FALSE)
file.arg.name <- "--file="
script.name <- sub(file.arg.name, "", initial.options[grep(file.arg.name, initial.options)])
script.basename <- dirname(script.name)

load(paste(script.basename, '/my_jaccard_matrix_gene_all.Robj', sep=''))

orig_mar <- par()$mar

gene_list <- read.table(my_file, header = FALSE)

my_gene <- unique(gene_list$V1)
length(my_gene)

my_gene <- my_gene[my_gene %in% colnames(my_jaccard_matrix)]
length(my_gene)

df <- data.frame(from = combn(my_gene, m=2)[1,],
                 to = combn(my_gene, m=2)[2,],
                 weight = apply(combn(my_gene, m=2), 2, function(x) my_jaccard_matrix[x[1], x[2]]))

my_summary <- summary(df$weight)
# df <- subset(df, weight > as.vector(my_summary['Median']))
# df <- subset(df, weight > 0.107)
# use the third quartile to limit the number of edges
df <- subset(df, weight > as.vector(my_summary['3rd Qu.']))

net <- graph.data.frame(df, directed = FALSE)

# plot(net, layout = layout_components(net), edge.width = E(net)$weight, vertex.shape="none")

ceb <- cluster_edge_betweenness(net)

my_pdf <- paste(my_base, '.pdf', sep='')
pdf(file = my_pdf, width = 10, height = 10)

par(mar=c(0,0,2,0))
plot(ceb, net, main = paste('Edge density: ', round(edge_density(net, loops = FALSE), 3), sep=''))

par(mar=orig_mar)
dendPlot(ceb, mode="hclust")

dev.off()
# membership(ceb)
# V(net)
# edge_density(net, loops = FALSE)

file.remove('Rplots.pdf')

