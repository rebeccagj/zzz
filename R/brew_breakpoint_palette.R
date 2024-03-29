#' Function for setting to a specific color
#'
#' commonly used to set 0 to the transition color, or set up a custom color ramp centered on a specific value. returns a `col_break_list` list object with coordinated breaks and colors, with `col_break_list[[1]]` or `col_break_list$breaks` being the breaks and `col_break_list[[2]]` or `col_break_list$colors` being the colors
#' @seealso [`RColorBrewer::display.brewer.all()`]
#' @import RColorBrewer
#' @param df data-frame to which values are to be synchronized
#' @param break_val `0`, or another value on which to center the transition color
#' @param by_val step indicator, used to ensure transitions are seamless. defaults to `0.01`, but `0.1` or `0.001` are also suggested
#' @param min_val optional, to set the minimum value to which a color can be associated, defaults to `min(df)`
#' @param max_val optional, to set the maximum value to which a color can be associated, defaults to `min(df)`
#' @param low_col specification of the color to represent the low range, defaults to `forestgreen`
#' @param mid_col specification of the color to represent the 0/midpoint transition, defaults to `black`
#' @param high_col specification of the color to represent the high range, defaults to `magenta`
#' @export
#' @examples
#' brew_breakpoint_palette(df)
#' brew_breakpoint_palette(df, break_val = 0, low_col = "blue", mid_col = "yellow", high_col = "red")

brew_breakpoint_palette = function(df, break_val = 0, by_val = 0.01, common_col = NULL, min_val = NULL, max_val = NULL, low_col = NULL, mid_col = NULL, high_col = NULL){
  if (is.null(min_val)) {
    min_val = min(df)
    print(paste('min val is null, setting min to min(df):',min_val))
  }
  if (is.null(max_val)) {
    max_val = max(df)
    print(paste('max val is null, setting min to max(df):',max_val))
  }
  if (is.null(low_col)) {
    low_col = 'forestgreen'
  }
  if (is.null(mid_col)) {
    mid_col = 'black'
  }
  if (is.null(high_col)) {
    high_col = 'magenta'
  }

  break_low <- seq(min_val,break_val-0.001,by=by_val)
  break_high <- seq(break_val,max_val+by_val,by=by_val)
  break_list <- c(break_low,break_high)  #combine the break limits for purpose of graphing

  col_low = colorRampPalette(c(low_col, mid_col))((length(break_low)))
  col_high = colorRampPalette(c(mid_col, high_col))((length(break_high)))

  color_list = c(col_low,col_high)

  col_break_list = list(break_list,color_list)
  names(col_break_list) = c('breaks', 'colors')
  return(col_break_list)
}
