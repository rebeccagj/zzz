% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/print_message.R
\name{print_message}
\alias{print_message}
\title{A Fancy Print + Timestamp Function}
\usage{
print_message(message)
}
\arguments{
\item{message}{Anything classically able to be wrapped in c()}
}
\description{
This function from Ravi Patel combines printing a custom message with Sys.time()
}
\examples{
print_message("Starting Clustering")
print_message(c("Current WD:", getwd()))
}
\keyword{log}
\keyword{message}
\keyword{print}
