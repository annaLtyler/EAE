#Change directory to a folder where output will be housed (this is specific to individual users).
cd ~/Documents/Projects/Cube/T2D\ human\ genetics/results

#For your SNP location file you'll need to extract SNP id column, the chromosome column, and the Genomic position column.
#These are commonly coded as SNP, CHR, and BP but may be different for your data depending on which program was used to generate your data. Change the column identifiers ($1, $2, $3) to select those columns in your data so that the SNP column is first, CHR is second, and BP is third.
awk '{print $1, $2, $3}' ~/Documents/Projects/Cube/T2D\ human\ genetics/data/DIAGRAMv3.2012DEC17.txt > snp_summary_stats_loc

#Remove column headers
tail -n +2 snp_summary_stats_loc > snp_summary_stats_loc_prepped

#Call the annotation MAGMA function from magma to map SNPs onto genes based on shared genomic location (from the downloaded gene location file, named here "NCBI37.3.gene.loc").
#The specified annotation window is 10kb here. This function will output a file named "sum_stats_annotated" appended with ".gene.annot". Choice of mapping window is up to you. A wider mapping window includes snps that could effect transcription start and stop sites for the gene. If you just want to annotate snps that are only within the bounds of the gene don't specify a window after annotate.
~/Documents/Projects/Cube/T2D\ human\ genetics/code/magma_v1/magma --annotate window=10 --snp-loc snp_summary_stats_loc_prepped --gene-loc ~/Documents/Projects/Cube/T2D\ human\ genetics/data/NCBI38/NCBI38.gene.loc --out ./sum_stats_annotated

#Next we want to extract the SNP ids and p-values for MAGMA to calculate the gene-level p-value. You'll need to change the column accessors to match your SNP and Pvalue columns in that order.
awk '{print $1, $6, $12}' ~/Documents/Projects/Cube/T2D\ human\ genetics/data/DIAGRAMv3.2012DEC17.txt > T2D_pvals
#Remove column headers
tail -n +2 T2D_pvals > snp_sum_stats_pvals_prepped

#Run MAGMA to get genes and their p-values. The bfile flag directs to the reference dataset (the European population reference data file directory here "g1000_eur") to better estimate linkage disequilibrium between SNPs. The N is the number of samples used in the GWAS (here, specific to JAE N = 415 cases with epilepsy + 24218 controls = 24633). The output is a file named "JAE_genes" appended with ".genes.out", which can now be used in the following R workflow.
#NOTE: There are 4 different files within the g1000_eur directory appended as .bed, .bim, .fam and .synonyms. All you have to do is provide g1000_eur prepension (is that a word?) and MAGMA will read them in.

#For the N option of the pvalue flag you should put the sample size of the data the SNP p-values were obtained from. Alternatively, if your data has a column that lists the sample size per snp you can provide that column name by using ncol=[col_name] instead of N
~/Documents/Projects/Cube/T2D\ human\ genetics/code/magma_v1/magma --bfile ~/Documents/Projects/Cube/T2D\ human\ genetics/data/g1000_eur/g1000_eur --pval snp_sum_stats_pvals_prepped ncol=3 --gene-annot sum_stats_annotated.genes.annot --out ./T2D_genes

#And now you should have a shiny new file with mapped genes and their p-values! From here you can read them into R or your favorite programming language to analyze further.
