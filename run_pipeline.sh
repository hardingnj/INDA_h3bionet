echo "Welcome to the comparative genomics pipeline"
source activate pf3kanalysis

tabix -h data/SNP_INDEL_Pf3D7_13_v3.combined.filtered.INDA.vcf.gz \
  Pf3D7_13_v3:1724817-1726997 | bgzip > output/kelch13_variants.vcf.gz

tabix -p vcf output/kelch13_variants.vcf.gz

echo "Done filtering by position"

vcffilter -f "VariantType = SNP & QUAL > 100" output/kelch13_variants.vcf.gz | bgzip > output/kelch13_variants_filtered.vcf.gz

tabix -p vcf output/kelch13_variants_filtered.vcf.gz

echo "Done filtering by type and quality"

vcfkeepgeno output/kelch13_variants_filtered.vcf.gz GT \
  | vcf2tsv -g \
  | bgzip > output/kelch13_variants_filtered.tsv.gz

echo "Done converting to text format"
