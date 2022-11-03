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
#' convert_mu_or_hu_genes("DPPA3", host = 'www.ensembl.org')
#' convert_mu_or_hu_genes("DPPA3", unique = TRUE)
#' convert_mu_or_hu_genes("DPPA3")
#' convert_mu_or_hu_genes("Dppa3", unique = TRUE)
#' convert_mu_or_hu_genes("Dppa3")


convert_mu_or_hu_genes = function (genelist, unique = FALSE, host = "https://dec2021.archive.ensembl.org") {
  #tests if the characters in the vector are in all caps
  tf = all(grepl("^[[:upper:]]+$", gsub("[[:digit:]]+", "",
                                        genelist)))

  #based on boolean tf, assigns from to "human" or "mouse"
  from = "var"
  if (isTRUE(tf)) {
    assign(x = "from", value = "human")
    print("from assigned to human")
  }
  else if (!isTRUE(tf)) {
    assign(x = from, value = "mouse")
    print("from assigned to mouse")
  }

  #loads in biomarts if they haven't been loaded already
  if (!exists("human_mart")) {
    if ( isTRUE(grepl(host, human_mart@host)) ) {
      print("marts already exist in .GlobalEnv, starting conversion")
    } else {
      require("biomaRt")
      print(paste0("host is: ",host," - loading now"))
      human_mart = useEnsembl(
        "ensembl",
        dataset = "hsapiens_gene_ensembl",
        host = host)
      assign(x = "human_mart", value = human_mart, .GlobalEnv)
      if (!exists("mouse_mart")) {
        mouse_mart = useEnsembl("ensembl",
                                dataset = "mmusculus_gene_ensembl",
                                host = host)
        assign(x = "mouse_mart", value = mouse_mart, .GlobalEnv)
      }
    }
  }
  else {
    print("marts already exist in .GlobalEnv, starting conversion")
  }

  #convert from human to mouse
  if (from == "human") {
    print("converting from human to mouse")
    ens = getBM(attributes = c("hgnc_symbol","ensembl_gene_id"),
                mart = human_mart, values = genelist, filters = "hgnc_symbol", uniqueRows = F)
    genesV2 = getLDS(attributes = c("hgnc_symbol","ensembl_gene_id"), filters = c("ensembl_gene_id"),
                     mart = human_mart, values = ens$ensembl_gene_id, attributesL = c("mgi_symbol", "ensembl_gene_id"),
                     martL = mouse_mart, uniqueRows = F)
  }
  else {
    #convert from mouse to human
    print("converting from mouse to human")
    ens = getBM(attributes = c("mgi_symbol","ensembl_gene_id"),
                mart = mouse_mart, values = genelist, filters = "mgi_symbol", uniqueRows = F)
    genesV2 = getLDS(attributes = c("mgi_symbol","ensembl_gene_id"), filters = c("ensembl_gene_id"),
                     mart = mouse_mart, values = ens$ensembl_gene_id, attributesL = c("hgnc_symbol", "ensembl_gene_id"),
                     martL = human_mart,
                     uniqueRows = F)
  }

  # an in R calculation of unique values in the genesV2 dataframe; different than the biomart serverside uniqueRows calculation
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
