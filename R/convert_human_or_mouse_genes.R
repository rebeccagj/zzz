#' Convert between mouse or human genes
#'
#' A function which uses BioMart and takes a list of human or mouse genes and returns a dataframe with inital query and the other species' homologs
#'
#' @import biomaRt
#' @param genelist A character vector of mouse: c(Gene1, Gene1) or human: c(GENE1, GENE2) genes; the function will determine whether you currently have mouse or human genes based on case.
#' @param unique an "in R" calculation of unique values in the converted data frame; different than biomaRt's server-side `uniqueRows` calculation, which is `FALSE` in this function
#' @param host Host to connect to. Defaults to `https://dec2021.archive.ensembl.org`, but will take any `url` from `listEnsemblArchives()` or `https://www.ensembl.org`
#' @keywords genes convert
#' @export
#' @examples
#' convert_human_or_mouse_genes("DPPA3", host = 'https://www.ensembl.org')
#' convert_human_or_mouse_genes("DPPA3", unique = TRUE)
#' convert_human_or_mouse_genes("DPPA3")
#' convert_human_or_mouse_genes("Dppa3", unique = TRUE)
#' convert_human_or_mouse_genes("Dppa3")


convert_human_or_mouse_genes = function (genelist, unique = FALSE, host = "https://dec2021.archive.ensembl.org") {
  if (is.null(genelist))
    stop("Pass a mouse or human gene or vector of genes to convert")
  tf = all(grepl("^[[:upper:]]+$", gsub("[[:digit:]]+", "",
                                        genelist)))
  from = "var"
  if (isTRUE(tf)) {
    assign(x = "from", value = "human")
    print("A list of human genes will be converted to mouse")
  }
  else if (!isTRUE(tf)) {
    assign(x = from, value = "mouse")
    print("A list of mouse genes will be converted to human")
  }
  if ( exists("human_mart") ) {
    mart_id = sub("org:","org",sub("443.*","", human_mart@host))
    if ( mart_id == host) {
      print("marts already exist in .GlobalEnv, starting conversion")
    }
    else {
      print("marts in .GlobalEnv don't match requested host; refreshing...")
      require("biomaRt")
      print(paste0("host is: ", host, " - loading now"))
      human_mart = useEnsembl("ensembl", dataset = "hsapiens_gene_ensembl",
                              host = host)
      assign(x = "human_mart", value = human_mart, .GlobalEnv)
      mouse_mart = useEnsembl("ensembl", dataset = "mmusculus_gene_ensembl",
                              host = host)
      assign(x = "mouse_mart", value = mouse_mart,
             .GlobalEnv)
    }
  } else {
    require("biomaRt")
    print(paste0("host is: ", host, " - loading now"))
    human_mart = useEnsembl("ensembl", dataset = "hsapiens_gene_ensembl",
                            host = host)
    assign(x = "human_mart", value = human_mart, .GlobalEnv)
    mouse_mart = useEnsembl("ensembl", dataset = "mmusculus_gene_ensembl",
                            host = host)
    assign(x = "mouse_mart", value = mouse_mart,
           .GlobalEnv)
  }
  if (from == "human") {
    print("converting from human to mouse")
    ens = getBM(attributes = c("hgnc_symbol", "ensembl_gene_id"),
                mart = human_mart, values = genelist, filters = "hgnc_symbol",
                uniqueRows = F)
    genesV2 = getLDS(attributes = c("hgnc_symbol", "ensembl_gene_id"),
                     filters = c("ensembl_gene_id"), mart = human_mart,
                     values = ens$ensembl_gene_id, attributesL = c("mgi_symbol",
                                                                   "ensembl_gene_id"), martL = mouse_mart, uniqueRows = F)
  }
  else {
    print("converting from mouse to human")
    ens = getBM(attributes = c("mgi_symbol", "ensembl_gene_id"),
                mart = mouse_mart, values = genelist, filters = "mgi_symbol",
                uniqueRows = F)
    genesV2 = getLDS(attributes = c("mgi_symbol", "ensembl_gene_id"),
                     filters = c("ensembl_gene_id"), mart = mouse_mart,
                     values = ens$ensembl_gene_id, attributesL = c("hgnc_symbol",
                                                                   "ensembl_gene_id"), martL = human_mart, uniqueRows = F)
  }
  if (isTRUE(unique)) {
    genesV2_unique = unique(genesV2[, 2])
    print(head(genesV2_unique))
    return(genesV2_unique)
  }
  else {
    print(head(genesV2))
    return(genesV2)
  }
}
