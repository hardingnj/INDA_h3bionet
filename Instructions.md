## Aims

To investigate the variation present in African vs Asian strains of plasmodium falciparum. We will focus on the kelch13 gene. We hopeto answer the following specific questions:

a) Are samples from The Gambia more similar to Senegal or Malawi?

b) Is there more diversity in African or Asian populations?

c) Are the samples from unknown countries more similar to African or Asian populations?

## Day 1

By the end of the day we should have the metadata information loaded into an Rstudio session.

1. Download the metadata file from the pf3k website.
2. Load metadata into R
3. Create a table of how many samples we have from each country.
4. Create a new variable describing whether the sample is from Asia or Africa.

## Day 2

By the end of the day we want to have a VCF file filtered by:
a. Position
b. Variant type is SNP 
c. Quality


As a first step, get onto a linux terminal and create the following directory structure:

```
# first make sure you are in your home directory
cd

# create a directory that will contain all of your analysis data and code
mkdir h3bionet

# and change directory to the directory we have just created
cd h3bionet
mkdir data

# copy all of your *data* files to this directory
# NOTE: If you prefer you can do this via the file explorer.

# follow the structure I have created in: https://github.com/hardingnj/INDA_h3bionet
# now move your R script files to the INDA_h3bionet directory
# create a new bash script (run_pipeline.sh) in this directory
```
You should now have a directory on a linux machine containing: 

- your metadata file in "data"
- your R analysis script
- your (empty) pipeline script


The next step is to install our software. We are fortunate that both `vcflib` and `tabix` are avavailable in bioconda- a package manager for bioinformatics- this should save us lots of work. 

Both of these tools must be installed on linux. Both are written in C, and so need to be compiled. This means transforming the code wecan understand into some instructions that the computer can understand. It is very inefficient for a computer to read the code like we do. 

First, we need to install miniconda. Find out whether you have a 32 or 64 bit system. (hint: use google).

When you know this, go to http://conda.pydata.org/miniconda.html, and choose the corresponding installer (Use python 3.5). The file you download will be called something like `Miniconda3-latest-Linux-x86_64.sh`.

Run the script, and follow the prompts:
`bash Miniconda3-latest-Linux-x86_64.sh`

If this installed correctly we can use conda to create a new environment:let's call this pf3kanalysis:

`conda create --name pf3kanalysis --channel bioconda htslib`

Now we need to activate our environment:

`source activate pf3kanalysis`

Now install `vcflib` as well:

`conda install --channel bioconda vcflib`

Test this has worked:
`vcffilter -h`

and:

`tabix -h`


### Task 1: 
see if you can find the two vcflib commands we will be using to filter the vcf file and convert it to text format. 

### Task 2:
Create a directory named `output` in your h3bionet directory

## Day 3

###Task 3: 
A: Using tabix create a new vcf file in the output directory, containing only positions in kelch13. This file should be called `kelch13_variants.vcf`.

B: Compress this file using bgzip. What is the file size before and after compression? (`ls -lah`).

C: Index this file using tabix

D: Put the commands A, B, and C in your `run_pipeline.sh` file. Delete all the files in `output`, and recreate them using `bash run_pipeline.sh`. Congratulations- you have run your first pipeline!

E: In the github repository there is my `run_pipeline.sh` file. Copy the commands to filter variants by type and quality into your script. Try to understand what each step is doing!

Now you should be able to run `bash run_pipeline.sh` from your `h3bionet` directory, and generate all the data files.

## Day 3
### Task 4

Now we can start some comparative genomics!

First load the `kelch13_variants.tsv.gz` into R. Notice the data is in long format, we will later need to reshape this.  

*P. falciparum* is a haploid organism, why do we see heterozygote calls?

Create a new variable which is a numeric representation of the genotype:

`numeric_GT <- ifelse(f$GT == "0/0", 0, ifelse(f$GT == "./.", NA, 1))`

How are we treating the heterozygote calls vs the homozygous alt calls?

Replace the "GT" field in the data with this vector.

Now we need to reshape the data. We use the `reshape2` package, which you will need to install.

`gt <- acast(f, POS ~ SAMPLE, value.var="GT", fill=NA)`

This object is your genotype matrix. We can use this to calculate distances between samples.

Tasks:

- how many variants in each sample are missing? Plot a histogram.
- First, we need to drop some samples... create a boolean vector `missing_ok` that is True if a sample has fewer than 30 missing values.
- Create a new variable `gt_ok` from `gt` that is transposed AND excludes samples with many missing values using `missing_ok`.
- Create a distance matrix using the `dist()` function. Use the `manhattan` method to calculate distance. 

```
dm = dist(x=gt_ok, method="manhattan")
njt <- ape::nj(dm)
ape::plot.phylo(njt, type="unr", show.tip.label=T,edge.width=0.1)
```
What do you see?

Someone tells you that there are some problems with samples PF0345-C, PA0190-C PT0154-Cx & PT0154-C. Exclude them, and recreate the distance matrix and tree plot.

Something else you notice, is that kelch13 is a small gene, and doesn't contain enough SNPs to separate populations meaningfully! Increase the size of the window we are using, I suggest `1720000-1730000`.

Now, it would be really nice to have some colour- we need to pass the plot a colour vector. Let's colour by continent- Africa in green and Asia in red.

You will need to load the metadata into your R session, and keep all rows this time. Do not exclude the laboratory samples.

`gt_filt_continent <- meta[rownames(filtered_GT)]$Continent`

`colour <- ifelse(gt_filt_continent == "Africa", "green", "red")`

`ape::plot.phylo(njt, type="unr", show.tip.label=F, edge.width=0.1, edge.col=colour)`

