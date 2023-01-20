#' A simple unpercenting function for tidyverse pipes (or standalone use cases)
#'
#' This function takes a vector of int/num and divides it by 100
#' @param message divides what you pass to it by 100
#' @keywords percent unpercent
#' @export
#' @examples
#' df %>% mutate_all(unpercent)
#' unpercent(df[[1]])

unpercent = function(x) { x = x/100 }
