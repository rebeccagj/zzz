#' Split ggplot2 violin plot inspired by seaborn plots
#'
#' Thanks to jan-glx on stackoverflow: https://stackoverflow.com/a/45614547 for this function. Can pipe to a ggplot with `+`
#' @import ggplot2
#' @inheritParams ggplot2::geom_violin
#' @keywords geom split violin
#' @export
#' @examples
#' print_message("Starting Clustering")
#' print_message(c("Current WD:", getwd()))

geom_split_violin <- function(
  mapping = NULL,
  data = NULL,
  stat = "ydensity",
  position = "identity",
  ...,
  draw_quantiles = NULL,
  trim = TRUE,
  scale = "area",
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
  ) {
  layer(data = data, mapping = mapping, stat = stat, geom = GeomSplitViolin,
        position = position, show.legend = show.legend, inherit.aes = inherit.aes,
        params = list(trim = trim, scale = scale, draw_quantiles = draw_quantiles, na.rm = na.rm, ...))
}
