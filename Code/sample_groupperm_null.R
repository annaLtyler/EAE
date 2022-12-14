#Same as sample_perm_null except that you can put a vector
#containing group labels for replicated genotypes.
#Instead of permuting by individual, individual groups (strains)
#get swapped with each other. We shuffle the labels
#and then rebuild the genotype and kinship objects relative
#to the phenotype and covariate vectors.
#This function is built for CC lines, so we assume that
#The genotypes within groups are identical.

sample_groupperm_null = function(genoprobs, pheno, groups, 
    addcovar = NULL, intcovar = NULL, kinship = NULL, cores = 1){
    
    nind = length(pheno)
    k = dim(genoprobs[[1]])[2] # Number of alleles
  
    #permute the group names
    u_group <- unique(groups)
    orig_idx <- lapply(u_group, function(x) which(groups == x))
    perm_groups <- sample(u_group)
    perm_idx <- lapply(perm_groups, function(x) which(groups == x))

    #rebuild the genoprobs in the new group order
    #use the number of individuals from the original 
    #order but the genotypes from the new order, so
    #that each value in the phenotype vector is matched
    #up to a new strain.
    new_idx <- lapply(1:length(orig_idx), 
        function(x) rep(perm_idx[[x]][1], length(orig_idx[[x]])))
    new_idx_v <- unlist(new_idx)

    null_geno <- genoprobs
    for(i in 1:length(null_geno)){
        null_geno[[i]] <- genoprobs[[i]][new_idx_v,,]
        rownames(null_geno[[i]])  <- 1:nrow(null_geno[[1]])
    }

    if(!is.null(kinship)){
        null_kin <- kinship
        for(i in 1:length(null_kin)){
            null_kin[[i]] <- kinship[[i]][new_idx_v,new_idx_v]
            rownames(null_kin[[i]]) <- colnames(null_kin[[i]]) <- 1:nrow(null_kin[[1]])
        }
    }else{
        null_kin <- NULL
    }

  scan1_null = scan1(null_geno, pheno, kinship = null_kin, addcovar = addcovar, 
    intcovar = intcovar, cores = cores)
  #plot(scan1_null, map = map)

  null_p = lod2p(scan1_null, nind, k)
  #plot(-log10(null_p), map = map)
  return(null_p)
}


