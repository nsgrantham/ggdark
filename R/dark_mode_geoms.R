#' Manipulate geoms for dark mode
#'
#' These functions help change default colors for color and fill aesthetics for
#' all geoms in the loaded namespaces that have them.
#'
#' \code{get_geoms} Returns all the geoms from loaded namespaces.
#'
#' \code{invert_geom_defaults} inverts geom defaults for fill and color.
#'
#' \code{geoms_are_ggdefault} checks if the geoms are at their ggplot default
#' values for color and fill.
#'
#' \code{darken_geoms} sets defaults to be dark-mode friendly.
#'
#' \code{lighten_geoms} sets defaults to the ggplot2 defaults.
#'
#' @param geoms List of geoms as ggproto objects.
#' @param verbose Whether to print a message whenever inversion occurs.
#'
#' @name dark_mode_geoms
NULL

#' Get all geoms from loaded namespaces
#'
#' @importFrom utils apropos
#'
#' @export
#' @rdname dark_mode_geoms
get_geoms <- function() {
  geom_names <- apropos("^Geom", ignore.case = FALSE)
  geoms <- list()
  namespaces <- loadedNamespaces()
  for (namespace in namespaces) {
    geoms_in_namespace <- mget(
      geom_names, envir = asNamespace(namespace), ifnotfound = list(NULL)
    )
    for (geom_name in geom_names) {
      if (is.ggproto(geoms_in_namespace[[geom_name]])) {
        geoms[[geom_name]] <- geoms_in_namespace[[geom_name]]
      }
    }
  }
  geoms
}

#' @importFrom ggplot2 is.ggproto
#'
#' @examples
#' library(ggplot2)
#'
#' p <- ggplot(iris, aes(Sepal.Width, Sepal.Length)) +
#'   geom_point() +
#'   facet_wrap(~Species)
#'
#' p + dark_theme_gray() # geom defaults changed
#'
#' p + theme_gray() # oh no! geoms are not visible on light background
#'
#' lighten_geoms() # geom defaults changed back
#'
#' p + theme_gray() # back to normal
#'
#' @export
#' @rdname dark_mode_geoms
invert_geom_defaults <- function(geoms = get_geoms(), verbose = FALSE) {
  for (geom in geoms) {
    stopifnot(is.ggproto(geom))
    if (!is.null(geom$default_aes$fill)) {
      geom$default_aes$fill <- invert_color(geom$default_aes$fill)
    }
    if (!is.null(geom$default_aes$colour)) {
      geom$default_aes$colour <- invert_color(geom$default_aes$colour)
    }
  }
  if (verbose) {
    message(
      "Inverted geom defaults of fill and color/colour.\n",
      "To change them back, use invert_geom_defaults()."
    )
  }
  invisible(geoms)
}

#' @rdname dark_mode_geoms
#' @export
geoms_are_ggdefault <- function(geoms = get_geoms()) {
  geoms[["GeomPoint"]]$default_aes$colour %in% c("black", "#000000")
}

#' @rdname dark_mode_geoms
#' @export
darken_geoms <- function(geoms = get_geoms(), verbose = FALSE) {
  if (geoms_are_ggdefault(geoms)) invert_geom_defaults(geoms, verbose)
  invisible(geoms)
}

#' @rdname dark_mode_geoms
#' @export
lighten_geoms <- function(geoms = get_geoms(), verbose = FALSE) {
  if (!geoms_are_ggdefault(geoms)) invert_geom_defaults(geoms, verbose)
  invisible(geoms)
}
