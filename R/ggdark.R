#' ggdark: Dark mode for ggplot2 themes
#'
#' The only function you're likely to need from ggdark is [darken()]
#' which activates dark mode on your favorite ggplot2 theme. See the
#' README at github.com/nsgrantham/ggdark for more information.
#'
#' @docType package
#' @name ggdark
NULL

#' Activate dark mode on a ggplot2 theme
#'
#' @param .theme ggplot2 theme object
#' @param background Background fill
#' @param geom_fill Default fill value for ggplot2::geom_*
#' @param geom_color Default color value for ggplot2::geom_*
#' @param geom_colour Alias of geom_color
#' @param update_geoms Overwrite default fill and color values for ggplot2::geom_*?
#'
#' @return Theme with dark mode elements
#'
#' @importFrom ggplot2 theme theme_get element_rect element_line element_text
#' @export
#'
#' @examples
#' library(ggplot2)
#'
#' p1 <- ggplot(iris, aes(Sepal.Width, Sepal.Length)) +
#' geom_point(aes(color = Species))
#'
#' p1  # theme_gray(), the default
#' p1 + darken()  # activate dark mode on theme_gray()
#' p1 + darken(theme_minimal())  # darken a different ggplot2 theme
#' p1 + darken(theme_minimal(), background = "grey20")  # lighten black background
#'
#' p2 <- ggplot(iris, aes(Sepal.Width, Sepal.Length)) +
#'   geom_point() +
#'   facet_wrap(~ Species)
#'
#' p2 + darken()  # geom color is now white
#' p2 + darken(geom_color = "grey80")  # or perhaps a light grey
#'
#' # you can update the geoms outside of darken, but make
#' # sure they're not overwritten when darken is run again
#' update_geom_colors(color = "orange", fill = "gold")
#' p2 + darken(update_geoms = FALSE)
#'
#' restore_geom_colors()  # restore defaults fill = "black", color = "black"
#'
#' @rdname darken
darken <- function(.theme = ggplot2::theme_get(), background = "black", geom_fill = "white",
                   geom_color = "white", geom_colour = geom_color, update_geoms = TRUE) {
  stopifnot(all(class(.theme) == c("theme", "gg")))
  element_names <- names(.theme)
  updated_elements <- list()
  for (element_name in element_names) {
    element <- .theme[[element_name]]
    element_class <- class(element)
    if (("element" %in% element_class) & !("element_blank" %in% element_class)) {
      element_type <- element_class[1]
      if (element_type == "element_rect") {
        updated_element <- ggplot2::element_rect(colour = greyscale_complement(element$colour),
                                                 fill = greyscale_complement(element$fill))
      } else if (element_type == "element_line") {
        updated_element <- ggplot2::element_line(colour = greyscale_complement(element$colour))
      } else if (element_type == "element_text") {
        updated_element <- ggplot2::element_text(colour = greyscale_complement(element$colour))
      } else {
        stop("Element class not one of rect, line, or text.")
      }
      updated_elements[[element_name]] <- updated_element
    }
  }

  if (update_geoms) {
    update_geom_colors(fill = geom_fill, color = geom_color)
  }

  .theme +
    do.call("theme", updated_elements) +  # calls ggplot2::theme()
    ggplot2::theme(plot.background = element_rect(fill = background))
}

#' Update geom defaults for fill and color/colour
#'
#' @param fill Default fill value for ggplot2::geom_*
#' @param color Default color value for ggplot2::geom_*
#' @param colour Alias of color
#'
#' @importFrom ggplot2 update_geom_defaults
#' @export
#'
#' @examples
#' library(ggplot2)
#'
#' p2 <- ggplot(iris, aes(Sepal.Width, Sepal.Length)) +
#'   geom_point() +
#'   facet_wrap(~ Species)
#'
#' # geom colors are updated by ggdark::darken if its
#' # update_geoms arg is TRUE
#' p2 + darken()  # update_geoms = TRUE by default
#'
#' # you can update the geoms outside of darken, but make
#' # sure they're not overwritten when darken is run again
#' update_geom_colors(color = "orange", fill = "gold")
#' p2 + darken(update_geoms = FALSE)
#'
#' restore_geom_colors()  # update_geom_colors(fill = "black", color = "black")
#'
#' @seealso [update_geom_colours()]
#' @rdname update_geom_colors
update_geom_colors <- function(fill, color, colour = color) {
  geoms <- c("abline", "area", "bar", "boxplot", "col", "crossbar",
             "density", "dotplot", "errorbar", "hline", "label",
             "line", "linerange", "map", "path", "point", "polygon",
             "rect", "ribbon", "rug", "segment", "sf", "step",
             "text", "tile", "violin", "vline")

  for (geom in geoms) {
    ggplot2::update_geom_defaults(geom, list(colour = colour, fill = fill))
  }
}

#' @export
#' @rdname update_geom_colors
update_geom_colours <- update_geom_colors

#' Restore the geom defaults of fill = "white and color = "black"
#'
#' @export
#'
#' @examples
#' library(ggplot2)
#'
#' p2 <- ggplot(iris, aes(Sepal.Width, Sepal.Length)) +
#'   geom_point() +
#'   facet_wrap(~ Species)
#'
#' p2 + darken()  # updates geom fill = "white", color = "white"
#' p2  # oh no! we can't see the points anymore because they are white on white
#' restore_geom_colors()
#' p2  # back to normal
#'
#' @seealso [restore_geom_colours()]
#' @rdname restore_geom_colors
restore_geom_colors <- function() update_geom_colors(fill = "black", color = "black")

#' @export
#' @rdname restore_geom_colors
restore_geom_colours <- restore_geom_colors


#' Get greyscale complement
#'
#' @param color Greyscale color to complement
#'
#' @return Complementary greyscale color
#'
#' @export
#'
#' @examples
#' greyscale_complement("white")    # "black"
#' greyscale_complement("black")    # "white"
#' greyscale_complement("gray20")   # "gray80"
#' greyscale_complement("grey20")   # "grey80"
#' greyscale_complement("indigo")   # "indigo" (not on greyscale, so not complemented)
#' greyscale_complement("#000000")  # "#FFFFFF"
#' greyscale_complement("#333333")  # "#CCCCCC"
#' greyscale_complement("#4B0082")  # "#4B0082" (not on greyscale, so not complemented)
#'
#' @rdname greyscale_complement
greyscale_complement <- function(color) {
  if (is.null(color) || is.na(color)) {
    comp <- color
  } else if (startsWith(color, "#")) {
    comp <- greyscale_complement_hex(color)
  } else {
    comp <- greyscale_complement_name(color)
  }
  comp
}

#' Get greyscale complement to color by hexcode
#'
#' @param color Greyscale color to complement (hexcode)
#'
#' @return Complementary greyscale color (hexcode)
#'
#' @importFrom grDevices col2rgb rgb
#'
#' @examples
#' # Wrapped by greyscale_compelement
#' greyscale_complement("#333333")  # calls greyscale_complement_hex
#'
#' @rdname greyscale_complement_hex
greyscale_complement_hex <- function(color) {
  color_rgb <- c(grDevices::col2rgb(color))
  if (length(unique(color_rgb)) == 1) {  # if rgb all equal then grey scale
    comp_rgb <- abs(255 - color_rgb)
    comp <- grDevices::rgb(comp_rgb[1], comp_rgb[2], comp_rgb[3], maxColorValue=255)
  } else {
    comp <- color  # not in greyscale so return unchanged
  }
  comp
}

#' Get greyscale complement to color by name
#'
#' @param color Greyscale color to complement (name)
#'
#' @return Complementary greyscale color (name)
#'
#' @examples
#' # Wrapped by greyscale_compelement
#' greyscale_complement("grey80")  # calls greyscale_complement_name
#'
#' @rdname greyscale_complement_name
greyscale_complement_name <- function(color) {
  if (color == "black") {
    comp <- "white"
  } else if (color == "white") {
    comp <- "black"
  } else if (startsWith(color, "grey")) {
    comp <- greyscale_complements_list[[color]]
  } else if (startsWith(color, "gray")) {
    comp <- grayscale_complements_list[[color]]
  } else {
    comp <- color  # not in greyscale so return unchanged
  }
  comp
}
