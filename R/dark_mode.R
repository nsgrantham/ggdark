#' Activate dark mode on a 'ggplot2' theme
#'
#' @param .theme ggplot2 theme object
#' @param verbose print messages (default: TRUE)
#' @param force_geom_invert Force the inversion of geom defaults for fill and color/colour (default: FALSE)
#'
#' @return dark version of theme
#'
#' @importFrom ggplot2 theme theme_get is.theme element_rect
#' @export
#'
#' @examples
#' library(ggplot2)
#'
#' p1 <- ggplot(iris, aes(Sepal.Width, Sepal.Length, color = Species)) +
#'   geom_point()
#'
#' p1  # theme returned by theme_get()
#' p1 + dark_mode()  # activate dark mode on theme returned by theme_get()
#'
#' p2 <- ggplot(iris, aes(Sepal.Width, Sepal.Length)) +
#'   geom_point() +
#'   facet_wrap(~ Species)
#'
#' p2 + dark_mode(theme_minimal())  # activate dark mode on another theme
#'
#' invert_geom_defaults()  # restore geom defaults to their original values
#' @rdname dark_mode
dark_mode <- function(.theme = theme_get(), verbose = TRUE, force_geom_invert = FALSE) {
  stopifnot(is.theme(.theme))

  # Detect whether the default value of geom point colour is black. If so, invert all geom
  # defaults, otherwise leave the geoms alone. Use force_geom_invert to invert the geom When the geom point color is not black but
  # the geom defaults force_geom_invert.
  geoms <- get_geoms()
  geoms_are_dark <- geoms[["GeomPoint"]]$default_aes$colour %in% c("black", "#000000")
  if (geoms_are_dark || force_geom_invert) {
    invert_geom_defaults(geoms)
    if (verbose) {
      message("Inverted geom defaults of fill and color/colour.\n",
              "To change them back, use invert_geom_defaults().")
    }
  }

  .theme <- invert_theme_elements(.theme)
  if (inherits(.theme$plot.background, "element_blank") | is.null(.theme$plot.background)) {
    # For a few themes, like theme_minimal() and theme_void() from 'ggplot2', the background
    # is blank or NULL and displays as white, so fill the plot background with black.
    .theme <- .theme + theme(plot.background = element_rect(fill = "#000000"))
  }

  .theme
}

#' Invert theme elements
#'
#' @param .theme theme to invert
#'
#' @return Inverted theme
#'
#' @importFrom ggplot2 is.theme
#' @export
#'
#' @rdname invert_theme_elements
invert_theme_elements <- function(.theme) {
  stopifnot(is.theme(.theme))
  element_names <- names(.theme)
  for (element_name in element_names) {
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
  .theme
}


#' Invert geom defaults for fill and color/colour
#'
#' @param geoms List of geoms as ggproto objects
#'
#' @importFrom ggplot2 is.ggproto
#'
#' @examples
#' library(ggplot2)
#'
#' p <- ggplot(iris, aes(Sepal.Width, Sepal.Length)) +
#'   geom_point() +
#'   facet_wrap(~ Species)
#'
#' p + dark_theme_gray()  # geom defaults changed
#'
#' p + theme_gray()  # oh no! geoms are not visible on light background
#'
#' invert_geom_defaults()  # geom defaults changed back
#'
#' p + theme_gray() # back to normal
#' @export
#' @rdname invert_geom_defaults
invert_geom_defaults <- function(geoms = get_geoms()) {
  for (geom in geoms) {
    stopifnot(is.ggproto(geom))
    if (!is.null(geom$default_aes$fill)) {
      geom$default_aes$fill <- invert_color(geom$default_aes$fill)
    }
    if (!is.null(geom$default_aes$colour)) {
      geom$default_aes$colour <- invert_color(geom$default_aes$colour)
    }
  }
  invisible(geoms)
}

#' Get all geoms from loaded namespaces
#'
#' @importFrom utils apropos
#'
#' @export
#' @rdname get_geoms
#' @keywords internal
get_geoms <- function() {
  geom_names <- apropos("^Geom", ignore.case = FALSE)
  geoms <- list()
  namespaces <- loadedNamespaces()
  for (namespace in namespaces) {
    geoms_in_namespace <- mget(geom_names, envir = asNamespace(namespace), ifnotfound = list(NULL))
    for (geom_name in geom_names) {
      if (is.ggproto(geoms_in_namespace[[geom_name]])) {
        geoms[[geom_name]] <- geoms_in_namespace[[geom_name]]
      }
    }
  }
  geoms
}


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
#' invert_color("white")    # "black"
#' invert_color("gray20")   # "gray80"
#' invert_color("grey80")   # "grey20"
#' invert_color(c("#000000", "#333333"))  # "#FFFFFF","#CCCCCC"
#'
#' @export
#' @rdname invert_color
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
