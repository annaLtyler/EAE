#This function converts a 3D genotype array, as we would use
#in cape or download from the UNC webside into a qtl2 genoprobs
#object.
array2qtl2 <- function(genoprob_array, marker_info, chr = c(1:19, "X"), chr.col = "chr", 
    pos.col = "bp_mm10", crosstype = "risib8"){

    chr.idx <- lapply(chr, function(x) which(marker_info[,chr.col] == x))
    marker_map <- lapply(chr.idx, function(x) marker_info[x,pos.col])
    names(marker_map) <- chr
    
    for(ch in 1:length(marker_map)){
        names(marker_map[[ch]]) <- marker_info[chr.idx[[ch]],"marker"]
    }

    x.chr <- rep(FALSE, length(chr))
    x.chr[which(chr == "X")] <- TRUE
    names(x.chr) <- chr
    attr(marker_map, "is_x_chr") <- x.chr

    #break up the genoprobs to match the map
    genoprobs_list <- vector(mode = "list", length = length(chr))
    names(genoprobs_list) <- chr
    for(ch in 1:length(chr)){
        common.markers <- intersect(names(marker_map[[ch]]), dimnames(genoprob_array)[[3]])
        marker.idx <- match(common.markers, dimnames(genoprob_array)[[3]])
        marker.idx <- marker.idx[which(!is.na(marker.idx))]
        chr.marker <- genoprob_array[,,marker.idx]
        genoprobs_list[[ch]] <- chr.marker
    }

    attr(genoprobs_list, "crosstype") <- crosstype
    attr(genoprobs_list, "is_x_chr") <- x.chr
    attr(genoprobs_list, "alleles") <- colnames(genoprob_array)
    attr(genoprobs_list, "class") <- c("calc_genoprob", "list")

    cross_obj <- list("genoprobs" = genoprobs_list, "map" = marker_map)

}