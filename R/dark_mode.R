#' Activate dark mode on a ggplot2 theme
#'
#' @param .theme ggplot2 theme object
#' @param geom_color new geom color
#' @param geom_colour alias of geom_color
#' @param geom_fill new geom fill
#'
#' @return dark version of theme
#'
#' @importFrom ggplot2 theme_get is.theme
#' @export
#'
#' @examples
#' library(ggplot2)
#'
#' p1 <- ggplot(iris, aes(Sepal.Width, Sepal.Length)) +
#'   geom_point(aes(color = Species))
#'
#' p1  # theme_gray(), the default
#' p1 + dark_mode()  # activate dark mode on theme_gray()
#'
#' p2 <- ggplot(iris, aes(Sepal.Width, Sepal.Length)) +
#'   geom_point() +
#'   facet_wrap(~ Species)
#'
#' p2 + dark_mode()  # geom color is white
#' p2 + dark_mode(geom_color = "grey80")  # or perhaps a light grey
#'
#' update_geom_colors()  # restore defaults fill = "black", color = "black"
#'
#' @rdname dark_mode
#' @export
dark_mode <- function(.theme = theme_get(), geom_colour = "white",
                      geom_color = geom_colour, geom_fill = "white") {
  stopifnot(is.theme(.theme))
  update_geom_colors(colour = geom_colour, fill = geom_fill)
  invert_theme_elements(.theme)
}

#' Invert theme elements
#'
#' @param .theme theme to invert
#'
#' @importFrom ggplot2 theme element_rect
#'
#' @return Inverted theme
#'
#' @export
#' @rdname invert_theme_elements
invert_theme_elements <- function(.theme) {
  stopifnot(is.theme(.theme))
  for (element_name in names(.theme)) {
    element <- .theme[[element_name]]
    if (inherits(element, "element")) {  # element_line, element_rect, element_text, element_blank
      if (!is.null(element$colour)) {
        .theme[[element_name]]$colour <- invert_color(element$colour)
      }
      if (!is.null(element$fill)) {
        .theme[[element_name]]$fill <- invert_color(element$fill)
      }
    }
  }
  if (inherits(.theme$plot.background, "element_blank") | is.null(.theme$plot.background)) {
    .theme <- .theme + theme(plot.background = element_rect(fill = "#000000"))  # black
  }
  .theme
}


#' Update geom defaults for fill and color/colour
#'
#' @param fill new geom fill
#' @param color new geom color
#' @param colour alias of color
#'
#' @return List of geoms and their new defaults for fill and color/colour (invisibly returned)
#'
#' @importFrom ggplot2 update_geom_defaults
#'
#' @examples
#' library(ggplot2)
#'
#' p <- ggplot(iris, aes(Sepal.Width, Sepal.Length)) +
#'   geom_point() +
#'   facet_wrap(~ Species)
#'
#' old <- theme_set(dark_mode())  # color and fill changed to "white"
#' p
#'
#' update_geom_colors(color = "grey80", fill = "grey80")  # or perhaps a light grey
#' p
#'
#' theme_set(old)
#' p  # oh no! geom defaults are still "white"
#'
#' update_geom_colors()  # color and fill changed to "black"
#' p  # back to normal
#'
#' @export
#' @rdname update_geom_colors
update_geom_colors <- function(color = "black", colour = color, fill = "black") {
  geoms <- c("abline", "area", "bar", "boxplot", "col", "crossbar",
             "density", "dotplot", "errorbar", "hline", "label",
             "line", "linerange", "map", "path", "point", "polygon",
             "rect", "ribbon", "rug", "segment", "sf", "step",
             "text", "tile", "violin", "vline")
  geom_colors <- list()
  any_updated_geoms <- FALSE
  for (geom in geoms) {
    g <- ggplot2:::check_subclass(geom, "Geom", env = parent.frame())
    if (!(colour %in% g$default_aes$colour & fill %in% g$default_aes$fill)) {
      any_updated_geoms <- TRUE
      geom_colors[[geom]] <- list(colour = colour, fill = fill)
      update_geom_defaults(geom, geom_colors[[geom]])
    }
  }
  if (any_updated_geoms) {
    message(paste0("Geom defaults updated to fill = '", fill, "', color = '", colour, "'."))
    if (!all(c(colour, fill) %in% c("black", "#000000"))) {
      message(paste0("To restore the original values, use update_geom_colors()."))
    }
  }
  invisible(geom_colors)
}

#' @export
#' @rdname update_geom_colors
update_geom_colours <- update_geom_colors


#' Invert color(s)
#'
#' Invert a vector of colors, provided the colors have valid names
#' (i.e., belongs to [base::colors()]) or valid hex codes, returning
#' a vector of inverted colors in hex code.
#'
#' @param color color(s) to invert
#' @param colour alias of color
#'
#' @return Inverted color(s) in hex code
#'
#' @importFrom grDevices col2rgb rgb
#'
#' @examples
#' invert_color("white")    # "black"
#' invert_color("gray20")   # "gray80"
#' invert_color("grey80")   # "grey20"
#' invert_color(c("#000000", "#333333"))  # "#FFFFFF","#CCCCCC"
#'
#' @export
#' @rdname invert_color
#' @keywords internal
invert_color <- function(color, colour = color) {
  inv_rgb <- abs(255 - col2rgb(colour))
  inv_color <- rgb(inv_rgb[1, ], inv_rgb[2, ], inv_rgb[3, ], maxColorValue = 255)
  inv_color[is.na(colour)] <- NA
  inv_color[is.null(colour)] <- NULL
  inv_color
}

#' @export
#' @rdname invert_color
invert_colour <- invert_color
