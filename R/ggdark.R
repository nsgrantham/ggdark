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
#' @return Theme with dark mode elements
#' @importFrom ggplot2 theme theme_get element_rect element_line element_text
#' @export
#' @rdname darken
darken <- function(.theme = ggplot2::theme_get(), background = "black", geom_fill = "white",
                   geom_color = "white", geom_colour = geom_color) {
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

  update_geom_colors(fill = geom_fill, color = geom_color)

  .theme +
    do.call("theme", updated_elements) +  # calls ggplot2::theme()
    ggplot2::theme(plot.background = element_rect(fill = background))
}

#' Update geom defaults for fill and color/colour
#'
#' @param fill Default fill value for ggplot2::geom_*
#' @param color Default color value for ggplot2::geom_*
#' @param colour Alias of color
#' @seealso [update_geom_colours()]
#' @importFrom ggplot2 update_geom_defaults
#' @export
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
#' @rdname restore_geom_colors
restore_geom_colors <- function() update_geom_colors(fill = "black", color = "black")

#' @export
#' @rdname restore_geom_colors
restore_geom_colours <- restore_geom_colors


#' Get greyscale complement
#'
#' @param color Greyscale color to complement
#' @export
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
#' @param color Greyscale color to complement
#' @importFrom grDevices col2rgb rgb
#' @export
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
#' @param color Greyscale color to complement
#' @export
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
