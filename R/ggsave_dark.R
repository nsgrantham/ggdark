# Functions to make saving light/dark plots easier

#' Save a dark/light version of ggplot
#'
#' @param filename File name to create on disk.
#' @param plot Plot to save, defaults to last plot displayed.
#' @param dark Whether to save as dark (\code{TRUE}) or light (\code{FALSE}).
#' @param ... Other parameters passed to \code{\link[ggplot2]{ggsave}}
#'
#' @importFrom ggplot2 ggsave last_plot
#'
#' @export
ggsave_dark <- function(filename, plot = last_plot(), dark = FALSE, ...) {

  if (length(plot$theme) == 0) plot$theme <- theme_get()

  cur_geoms_dark <- geoms_are_dark()
  on.exit(if (cur_geoms_dark) darken_geoms() else lighten_geoms())

  if (dark) {
    darken_geoms()
    plot$theme <- darken_theme(plot$theme)
  } else {
    lighten_geoms()
    plot$theme <- lighten_theme(plot$theme)
  }

  ggsave(filename, plot, ...)
}
