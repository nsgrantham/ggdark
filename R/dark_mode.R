#' Activate dark/light mode
#'
#' These functions change theme colors and geom defaults.
#'
#' To check if geoms are dark-friendly, they checks whether the default value of
#' geom point colour is black. If so, \code{dark_mode} will invert all geom
#' defaults, otherwise it will leave the geoms alone. Use
#' \code{force_geom_invert = TRUE} to invert the geoms regardless.
#'
#' To check if the theme is dark, they checks whether the default text color is
#' black. If so, \code{dark_mode} inverts theme elements. If not, returns
#' \code{.theme} unchanged.
#'
#' \code{light_mode} does the opposite of \code{dark_mode}.
#'
#' @param .theme ggplot2 theme object.
#' @param geoms geoms as a list of ggproto objects.
#' @param verbose print messages (default: \code{TRUE}).
#' @param force_geom_invert Force the inversion of geom defaults for fill and
#'   color/colour (default: \code{FALSE}).
#' @param force_theme_invert Force the inversion of the theme. (default:
#'   \code{FALSE}).
#'
#' @return Dark version of \code{.theme}
#'
#' @examples
#' library(ggplot2)
#'
#' p1 <- ggplot(iris, aes(Sepal.Width, Sepal.Length, color = Species)) +
#'   geom_point()
#'
#' p1 # theme returned by theme_get()
#' p1 + dark_mode() # activate dark mode on theme returned by theme_get()
#'
#' p2 <- ggplot(iris, aes(Sepal.Width, Sepal.Length)) +
#'   geom_point() +
#'   facet_wrap(~Species)
#'
#' p2 + dark_mode(theme_minimal()) # activate dark mode on another theme
#'
#' lighten_geoms() # restore geom defaults to their original values
#'
#' @importFrom ggplot2 theme theme_get is.theme element_rect
#' @export
#' @rdname dark_mode
dark_mode <- function(.theme = theme_get(),
                      geoms = get_geoms(),
                      verbose = TRUE,
                      force_geom_invert = FALSE,
                      force_theme_invert = FALSE) {

  stopifnot(is.theme(.theme))

  if (force_geom_invert) invert_geom_defaults(geoms, verbose)
  else darken_geoms(geoms, verbose)

  if (force_theme_invert) .theme <- invert_theme_elements(.theme)
  else .theme <- darken_theme(.theme)

  .theme
}

#' @export
#' @rdname dark_mode
light_mode <- function(.theme = theme_get(),
                       geoms = get_geoms(),
                       verbose = TRUE,
                       force_geom_invert = FALSE,
                       force_theme_invert = FALSE) {

  stopifnot(is.theme(.theme))

  if (force_geom_invert) invert_geom_defaults(geoms, verbose)
  else lighten_geoms(geoms, verbose)

  if (force_theme_invert) .theme <- invert_theme_elements(.theme)
  else .theme <- lighten_theme(.theme)

  .theme
}
