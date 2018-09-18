#' Enable dark mode of a ggplot2 theme
#'
#' @param .theme ggplot2 theme object
#' @param background Background fill
#' @param geom_fill Default fill value for ggplot2::geom_*
#' @param geom_color Default color value for ggplot2::geom_*
#' @param geom_colour Alias of geom_color
#'
#' @return darkened_theme
#'
#' @export
darken <- function(.theme, background = "black", geom_fill = "white",
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
        updated_element <- element_rect(colour = greyscale_complement(element$colour),
                                        fill = greyscale_complement(element$fill))
      } else if (element_type == "element_line") {
        updated_element <- element_line(colour = greyscale_complement(element$colour))
      } else if (element_type == "element_text") {
        updated_element <- element_text(colour = greyscale_complement(element$colour))
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
#'
#' @export
update_geom_colors <- function(fill, color, colour = color) {
  geoms <- c("abline", "area", "bar", "boxplot", "col", "crossbar",
             "density", "dotplot", "errorbar", "hline", "label",
             "line", "linerange", "map", "path", "point", "polygon",
             "rect", "ribbon", "rug", "segment", "step", "text",
             "tile", "violin", "vline")

  for (geom in geoms) {
    ggplot2::update_geom_defaults(geom, list(colour = colour, fill = fill))
  }
}

#' @export
update_geom_colours <- update_geom_colors

#' @export
restore_geom_colors <- function() update_geom_colors(fill = "white", color = "black")

#' @export
restore_geom_colours <- restore_geom_colors


#' Get complement on grey scale
#'
#' @param color Greyscale color for which to find its complement
#'
#' @export
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

greyscale_complement_hex <- function(color) {
  color_rgb <- c(col2rgb(color))
  if (length(unique(color_rgb)) == 1) {  # if rgb all equal then grey scale
    comp_rgb <- abs(255 - color_rgb)
    comp <- rgb(comp_rgb[1], comp_rgb[2], comp_rgb[3], maxColorValue=255)
  } else {
    comp <- color  # not in grey scale so return unchanged
  }
  comp
}

greyscale_complement_name <- function(color) {
  if (color == "black") {
    comp <- "white"
  } else if (color == "white") {
    comp <- "black"
  } else if (startsWith(color, "gray")) {
    comp <- grayscale_complements_list[[color]]
  } else if (startsWith(color, "grey")) {
    comp <- greyscale_complements_list[[color]]
  } else {
    comp <- color  # not in grey scale so return unchanged
  }
  comp
}

grayscale_complements_list <- setNames(rev(paste0("gray", 0:100)), paste0("gray", 0:100))
greyscale_complements_list <- setNames(rev(paste0("grey", 0:100)), paste0("grey", 0:100))
