#' Convert between mouse or human genes
#'
#' A function which uses BioMart and takes a list of human or mouse genes and returns a dataframe with inital query and the other species' homologs 
#'
#' @param genelist A character vector of mouse: c(Gene1, Gene1) or human: c(GENE1, GENE2) genes; the function will determine whether you currently have mouse or human genes based on case.
#' @param unique A true/false Boolean for whether you get unique genes for a 1:1 conversion
#' @keywords genes convert
#' @export
#' @examples
#' convert_mu_or_hu_genes("DPPA3", unique = FALSE)
#' convert_mu_or_hu_genes("DPPA3")
#' convert_mu_or_hu_genes("Dppa3", unique = FALSE)
#' convert_mu_or_hu_genes("Dppa3")


convert_mu_or_hu_genes = function(genelist, unique = FALSE){
  #if (is.null(from)) stop("Specify whether your genelist is 'mouse' or 'human' currently")
  
  #strips out numbers and tests if resulting char vector is all caps or not
  #base "from" on result
  tf = all(grepl("^[[:upper:]]+$", gsub('[[:digit:]]+', '', genelist))) 
  
  from='var'
  if (isTRUE(tf)) { 
    assign(x = 'from', value = 'human')
    print('from assigned to human') 
  } else if (!isTRUE(tf)) {
    assign(x = from, value = 'mouse')
    print('from assigned to mouse')
  }
  
  #tests whether the marts exist already; if so, doesn't redundantly start this long process again
  if ( !exists('human_mart') ) {
    require("biomaRt")
    human_mart = useMart("ensembl", dataset = "hsapiens_gene_ensembl", host = "dec2021.archive.ensembl.org")
    assign(x = 'human_mart', value = human_mart, .GlobalEnv)
    
    if ( !exists('mouse_mart') ) {
      mouse_mart = useMart("ensembl", dataset = "mmusculus_gene_ensembl", host = "dec2021.archive.ensembl.org")
      assign(x = 'mouse_mart', value = mouse_mart, .GlobalEnv)
    }
  } else {
    print('marts already exist in .GlobalEnv, starting conversion')
  }
  
  #if from is human, get mouse
  if ( from == 'human' ) {
    print("converting from human to mouse")
    genesV2 = getLDS(attributes = c("hgnc_symbol"), filters = "hgnc_symbol", mart = human_mart, #from
                     values = genelist,
                     attributesL = c("mgi_symbol"), martL = mouse_mart, #to
                     uniqueRows=T)
  } else { #else if from is mouse, get human
    print("converting from mouse to human")
    genesV2 = getLDS(attributes = c("mgi_symbol"), filters = "mgi_symbol", mart = mouse_mart, #from
                     values = genelist,
                     attributesL = c("hgnc_symbol","hgnc_id",'ensembl_gene_id'), martL = human_mart,  #to
                     uniqueRows=T)
  }
  
  #get unique genes for a 1:1 conversion
  if ( isTRUE(unique) ){
    genesV2_unique = unique(genesV2[, 2])
    print(head(genesV2_unique))
    return(genesV2_unique)
  } else {
    print(head(genesV2))
    return(genesV2)
  }
}
