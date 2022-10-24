#' A Function to Quickly Alter GGPlot legend size
#'
#' Quickly change many aspects of legend, defaulting to a size decrease; if you are using aes to assign legend variables, this might behave unpredictably.
#' @param my_plot a previous generated ggplot
#' @param point_size defaults to 0.5, controls the dot size of legend elements
#' @param text_size defaults to 12, controls the size of the legend text
#' @param space_legend defaults to 0.1, controls the line spacing of elements of the legend
#' @param n_col defaults to 1, controls how many columns the legend is put in
#' @keywords ggplot legend
#' @export
#' @examples
#' plot = add_small_legend(plot)

modify_legend_size <- function(my_plot, point_size = 0.5, text_size = 12, space_legend = 0.1, n_col = 1) {
  my_plot +
    guides(shape = guide_legend(override.aes = list(size = point_size)),
           color = guide_legend(override.aes = list(size = point_size), ncol = n_col)) +
    theme(legend.title = element_text(size = text_size), 
          legend.text  = element_text(size = text_size),
          legend.key.size = unit(space_legend, "lines"))
}
