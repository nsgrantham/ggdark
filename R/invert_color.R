#' Invert color(s)
#'
#' Invert a vector of colors, provided the colors are valid hex codes
#' or have valid names (i.e., they belong to base::colors()), and
#' return a vector of inverted colors in hex code.
#'
#' @param color color(s) to invert
#' @param colour alias of color
#'
#' @return Inverted color(s) in hex code
#'
#' @importFrom grDevices col2rgb rgb
#'
#' @examples
#' invert_color("white") # "black"
#' invert_color("gray20") # "gray80"
#' invert_color("grey80") # "grey20"
#' invert_color(c("#000000", "#333333")) # "#FFFFFF","#CCCCCC"
#' @export
#' @rdname invert_color
invert_color <- function(color, colour = color) {
  inv_rgb <- abs(255 - col2rgb(colour))
  inv_color <- rgb(
    inv_rgb[1, ], inv_rgb[2, ], inv_rgb[3, ], maxColorValue = 255
  )
  inv_color[is.na(colour)] <- NA
  inv_color[is.null(colour)] <- NULL
  inv_color
}

#' @export
#' @rdname invert_color
invert_colour <- invert_color
