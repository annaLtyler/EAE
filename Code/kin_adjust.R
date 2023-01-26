#' Corrects genotypes, phenotypes, and covariates
#' for kinship.
#' 
#' This function uses linear mixed models to adjust the
#' genotype matrix, phenotype matrix, and covariate matrix
#' for kinship based on the kinship matrix calculated 
#' by \code{\link{kinship}}.
#'
#' @param kin_obj A kinship matrix
#' @param geno an array containing individuals in rows, alleles in columns, and markers in the third dimension.
#' @param phenoV The phenotype vector
#' @param covarV The covariate vector or matrix
#' @param verbose A logical value indicating whether to print progress to the screen
#'

#' @return This function returns a list with the corrected phenotype,
#' genotypes, and covariates. These are used in \code{\link{singlescan}}
#' and \code{\link{pairscan_kin}}.
#'
#' @importFrom regress regress
#' @keywords internal

kin_adjust <- function(kin_obj, geno, phenoV = NULL, 
covarV = NULL, verbose = FALSE){
  

    full_kin <- kin_obj

    #remove individuals with NAs
    is_na_pheno <- which(is.na(phenoV))
    if(length(covarV) > 0){
        is_na_covar <- unique(which(is.na(covarV), arr.ind = TRUE)[,1])
        }else{
        is_na_covar <- NULL
        }
    all_na <- unique(c(is_na_pheno, is_na_covar))
    not_na <- setdiff(1:length(phenoV), all_na)
    no_na_ind <- rownames(phenoV)[not_na]
    common_ind <- intersect(no_na_ind, colnames(full_kin))

    kin_locale <- match(common_ind, colnames(full_kin))  
    K <- full_kin[kin_locale,kin_locale]
    pheno_locale <- match(common_ind, rownames(phenoV))

    #for the corrections below, look into including epistatic kinship 
    #matrices. This may help us gain power to see epistatic interactions

    #if we are correcting the covariate only don't put it in the model
    if(verbose){cat("\tFitting model...\n")}
    if(is.null(covarV)){
        model = regress(as.vector(phenoV[pheno_locale])~1,~K, pos = c(TRUE, TRUE), 
        tol = 1e-2)
    }else{
        model = regress(as.vector(phenoV)[pheno_locale]~covarV[pheno_locale,], ~K, 
        pos = c(TRUE, TRUE), tol = 1e-2)
    }

    #This err_cov is the same as err_cov in Dan's code using estVC
    #err_cov = summary(model)$sigma[1]*K+summary(model)$sigma[2]*diag(nrow(K))
    #if(verbose){cat("\tCalculating err_cov...\n")}
    err_cov = model$sigma[1]*K+model$sigma[2]*diag(nrow(K))

    if(verbose){cat("\tCalculating eW...\n")}
    eW = eigen(err_cov, symmetric = TRUE)
    if(min(eW$values) < 0 && abs(min(eW$values)) > sqrt(.Machine$double.eps)){
    }else{
        eW$values[eW$values <= 0] = Inf
    } 
    err_cov = eW$vector %*% diag(eW$values^-0.5) %*% t(eW$vector)

    new_pheno <- err_cov %*% phenoV[pheno_locale,]

    if(length(dim(geno)) == 3){
        l_geno <- lapply(1:dim(geno)[2], function(x) err_cov %*% geno[pheno_locale,x,]); #hist(new_geno)
        new_geno <- array(NA, dim = dim(geno[pheno_locale,,]))
        for(i in 1:length(l_geno)){
        new_geno[,i,] <- l_geno[[i]]
        }
        dimnames(new_geno) <- dimnames(geno[pheno_locale,,])
    }else{
        new_geno <- err_cov %*% geno[pheno_locale,]
        dimnames(new_geno) <- dimnames(geno[pheno_locale,])				
    }

    if(!is.null(covarV)){
        new_covar <- err_cov %*% covarV[pheno_locale,]
    }else{
        new_covar <- NULL	
    }

    results = list(err_cov, new_pheno, new_geno, new_covar)
    names(results) <- c("err_cov", "corrected_pheno", "corrected_geno", "corrected_covar")
    return(results)
  
}
