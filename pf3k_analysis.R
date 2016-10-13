### FUNCTION DEFINITIONS ########################
hamming_distance <- function(a, b){

  missing <- (a == -1)|(b == -1)
  d <- sum((a == b) & (!missing))

  return(d/sum(!missing)) 
}

### LOAD GENOTYPE DATA ###########################
data <- read.table(
  "output/kelch13_variants_filtered.tsv.gz", 
  sep="\t", 
  header=T)

numeric_GT <- ifelse(
  data$GT == "0/0", 0, 
  ifelse(data$GT == "./.", -1, 1))

data$GT <- numeric_GT

nsamples <- dim(gt)[2]
nvariants <- dim(gt)[1]

# Reshape data to genotype matrix
gt <- acast(data, POS ~ SAMPLE, value.var="GT")

missing = apply(gt, MARGIN=2, function(x){ sum(x == -1)})
pdf("output/plot.pdf")
hist(missing)
ok_missing = missing < 30

# Compute distance matrix
dist_matrix <- matrix(nrow=nsamples, ncol=nsamples)
rownames(dist_matrix) <- colnames(dist_matrix) <-  colnames(gt)

for (i in 1:nsamples){
  for (j in i:nsamples){
    di <- hamming_distance(gt[, i], gt[, j])
    dist_matrix[i, j] = di
    dist_matrix[j, i] = di
  }
}

rdm <- dist_matrix[ok_missing, ok_missing]

hist(rdm[,1])
dev.off()
