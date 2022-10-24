#' A Fancy Print + Timestamp Function
#'
#' This function from Ravi Patel combines printing a custom message with Sys.time()
#' @param message Anything classically able to be wrapped in c()
#' @keywords print message log
#' @export
#' @examples
#' print_message("Starting Clustering")
#' print_message(c("Current WD:", getwd()))

print_message <- function(message) {
  cat("[", format(Sys.time()), "]", message, "\n")
}
