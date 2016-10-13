library(reshape2)
library(ape)
options(expressions=100000)

### LOAD GENOTYPE DATA ###########################
data <- read.table(
  "output/kelch13_variants_filtered.tsv.gz", 
  sep="\t", 
  header=T)

numeric_GT <- ifelse(
  data$GT == "0/0", 0, 
  ifelse(data$GT == "./.", NA, 1))

data$GTn <- numeric_GT

print("done loading data")

# Reshape data to genotype matrix
gt <- acast(data, POS ~ SAMPLE, value.var="GTn")
nsamples <- dim(gt)[2]
nvariants <- dim(gt)[1]
print("done reshaping data")

### READ METADATA #########################
meta <- read.table(
  "data/pf3k_release_5_metadata.txt", 
  sep="\t", 
  header=T, 
  row.names=1)

asian_countries <- c("Bangladesh", "Cambodia", "Laos", "Myanmar", "Thailand", "Vietnam")
meta$Continent <- ifelse(meta$country %in% asian_countries, "Asia", "Africa")

# Determine missingness in samples
missing = apply(gt, MARGIN=2, function(x){ sum(is.na(x))})
pdf("output/plot.pdf")
hist(missing)
ok_missing = missing < 30

# Compute distance matrix
gt_ok <- t(gt[,ok_missing])
distance_matrix = dist(x=gt_ok, method="manhattan")
njt <- ape::nj(distance_matrix)
ape::plot.phylo(njt, type="unr", show.tip.label=T,edge.width=0.1)

# Again, but excludesome samples
exclude_samples <- rownames(gt_ok) %in% c("PF0345-C", "PA0190-C", "PT0154-C", "PT0154-Cx")
gt_filtered <- gt_ok[!exclude_samples, ]
distance_matrix = dist(x=gt_filtered, method="manhattan")
njt <- ape::nj(distance_matrix)
ape::plot.phylo(njt, type="unr", show.tip.label=T,edge.width=0.1)

# Again, with colour
gt_filt_cont <- meta[rownames(gt_filtered),]$Continent
branch_col <- ifelse(gt_filt_cont == "Africa", "green", "red")
ape::plot.phylo(njt, type="fan", show.tip.label=F,edge.width=0.1, edge.color=branch_col)

dev.off()
