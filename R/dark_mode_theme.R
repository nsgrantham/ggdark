#' Manipulate themes for dark mode
#'
#' \code{invert_theme_elements} returns the inverted theme
#' (blank elements will be made black).
#' \code{theme_is_dark} checks if the theme is dark.
#' \code{darken_theme} darkens theme (unless it's dark already).
#' \code{lighten_theme} lightens theme (unless it's light already).
#'
#' @param .theme A ggplot theme
#'
#' @name dark_mode_theme
NULL

#' @importFrom ggplot2 is.theme
#' @export
#' @rdname dark_mode_theme
invert_theme_elements <- function(.theme) {
  stopifnot(is.theme(.theme))
  element_names <- names(.theme)
  for (element_name in element_names) {
    element <- .theme[[element_name]]
    # element_line, element_rect, element_text, element_blank
    if (inherits(element, "element")) {
      if (!is.null(element$colour)) {
        .theme[[element_name]]$colour <- invert_color(element$colour)
      }
      if (!is.null(element$fill)) {
        .theme[[element_name]]$fill <- invert_color(element$fill)
      }
    }
  }
  # For a few themes, like theme_minimal() and theme_void() from 'ggplot2',
  # the background is blank or NULL and displays as white, so fill the plot
  # background with black.
  blank_bg <- inherits(.theme$plot.background, "element_blank")
  if (blank_bg | is.null(.theme$plot.background)) {
    .theme <- .theme + theme(plot.background = element_rect(fill = "#000000"))
  }
  .theme
}

#' @export
#' @rdname dark_mode_theme
theme_is_dark <- function(.theme) {
  stopifnot(is.theme(.theme))
  !.theme$text$colour %in% c("black", "#000000")
}

#' @export
#' @rdname dark_mode_theme
darken_theme <- function(.theme) {
  if (!theme_is_dark(.theme)) .theme <- invert_theme_elements(.theme)
  .theme
}

#' @export
#' @rdname dark_mode_theme
lighten_theme <- function(.theme) {
  if (theme_is_dark(.theme)) .theme <- invert_theme_elements(.theme)
  .theme
}
