# Functions to make saving light/dark plots easier

#' Save a dark/light version of ggplot
#'
#' @param plot Plot save, defaults to last plot displayed
#' @param dark Whether to save as dark or light
#' @param ... Other parameters passed to \code{\link[ggplot2]{ggsave}}
#'
#' @importFrom ggplot2 ggsave
#'
#' @export
ggsave_dark <- function(plot = last_plot(), dark = FALSE, ...) {
  if (dark) set_geom_defaults(dark = TRUE)
  else set_geom_defaults(dark = FALSE)
  if (length(plot$theme) == 0) plot$theme <- theme_get()
  save_as_is <- (theme_is_dark(plot$theme) && dark) ||
    (!theme_is_dark(plot$theme) && !dark)
  if (!save_as_is) {
    plot$theme <- invert_theme_elements(plot$theme)
  }
  ggsave(plot, ...)
}
