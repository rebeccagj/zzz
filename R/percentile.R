#' A simple percentilization function for tidyverse pipes (or standalone use cases)
#'
#' This function takes a vector of int/num and calculates percentile rank
#' @param message calculates percentile rank on a vector
#' @keywords percentile quantile
#' @export
#' @examples
#' df %>% mutate_all(percentile)
#' percentile(df[[1]])

percentile = function(x) { (rank(x)/length(x))*100 }
