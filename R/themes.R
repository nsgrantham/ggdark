#' Complete dark themes
#'
#' These are dark versions of complete themes from 'ggplot2' which control all
#' non-data display. Use theme() if you just need to tweak the display of
#' an existing theme.
#'
#' @param base_size base font size
#' @param base_family base font family
#' @param base_line_size base size for line elements
#' @param base_rect_size base size for rect elements
#'
#' @importFrom ggplot2 ggplot
#'
#' @details
#' \describe{
#'
#' \item{`dark_theme_gray`}{
#' Dark version of theme_gray(), the signature 'ggplot2' theme with a grey background and white gridlines,
#' designed to put the data forward yet make comparisons easy.}
#'
#' \item{`dark_theme_bw`}{
#' Dark version of theme_bw(), the classic dark-on-light 'ggplot2' theme. May work better for presentations
#' displayed with a projector.}
#'
#' \item{`dark_theme_linedraw`}{
#' Dark version of theme_linedraw(), a theme with only black lines of various widths on white backgrounds,
#' reminiscent of a line drawings. Serves a purpose similar to theme_bw().
#' Note that this theme has some very thin lines (<< 1 pt) which some journals
#' may refuse.}
#'
#' \item{`dark_theme_light`}{
#' Dark version of theme_light(), a theme similar to theme_linedraw() but with light grey lines and axes,
#' to direct more attention towards the data.}
#'
#' \item{`dark_theme_dark`}{
#' Dark verion of theme_dark(), the dark cousin of theme_light(), with similar line sizes but a dark background. Useful to make thin coloured lines pop out.}
#'
#' \item{`dark_theme_minimal`}{
#' Dark version of theme_minimal(), a minimalistic theme with no background annotations.}
#'
#' \item{`dark_theme_classic`}{
#' Dark version of theme_classic(), a classic-looking theme, with x and y axis lines and no gridlines.}
#'
#' \item{`dark_theme_void`}{
#' Dark version of theme_void(), a completely empty theme.}
#'
#' \item{`dark_theme_test`}{
#' Dark version of theme_test(), a theme for visual unit tests. It should ideally never change except
#' for new features.}
#'
#' }
#'
#' @examples
#' library(ggplot2)
#'
#' mtcars2 <- within(mtcars, {
#'   vs <- factor(vs, labels = c("V-shaped", "Straight"))
#'   am <- factor(am, labels = c("Automatic", "Manual"))
#'   cyl  <- factor(cyl)
#'   gear <- factor(gear)
#' })
#'
#' p1 <- ggplot(mtcars2) +
#'   geom_point(aes(x = wt, y = mpg, colour = gear)) +
#'   labs(title = "Fuel economy declines as weight increases",
#'        subtitle = "(1973-74)",
#'        caption = "Data from the 1974 Motor Trend US magazine.",
#'        tag = "Figure 1",
#'        x = "Weight (1000 lbs)",
#'        y = "Fuel economy (mpg)",
#'        colour = "Gears")
#'
#' p1 + dark_theme_gray()
#' p1 + dark_theme_bw()
#' p1 + dark_theme_linedraw()
#' p1 + dark_theme_light()  # quite dark
#' p1 + dark_theme_dark()   # quite light
#' p1 + dark_theme_minimal()
#' p1 + dark_theme_classic()
#' p1 + dark_theme_void()
#'
#' # Theme examples with panels
#' \donttest{
#' p2 <- p1 + facet_grid(vs ~ am)
#'
#' p2 + dark_theme_gray()
#' p2 + dark_theme_bw()
#' p2 + dark_theme_linedraw()
#' p2 + dark_theme_light()  # quite dark
#' p2 + dark_theme_dark()   # quite light
#' p2 + dark_theme_minimal()
#' p2 + dark_theme_classic()
#' p2 + dark_theme_void()
#' }
#' @name ggdarktheme
#' @aliases NULL
NULL

#' @importFrom ggplot2 theme_bw
#' @export
#' @rdname ggdarktheme
dark_theme_bw <- function(base_size = 11, base_family = "", base_line_size = base_size/22,
                          base_rect_size = base_size/22) {
  dark_mode(theme_bw(base_size, base_family, base_line_size, base_rect_size))
}

#' @importFrom ggplot2 theme_classic
#' @export
#' @rdname ggdarktheme
dark_theme_classic <- function(base_size = 11, base_family = "", base_line_size = base_size/22,
                               base_rect_size = base_size/22) {
  dark_mode(theme_classic(base_size, base_family, base_line_size, base_rect_size))
}

#' @importFrom ggplot2 theme_gray
#' @export
#' @rdname ggdarktheme
dark_theme_gray <- function(base_size = 11, base_family = "", base_line_size = base_size/22,
                            base_rect_size = base_size/22) {
  dark_mode(theme_gray(base_size, base_family, base_line_size, base_rect_size))
}

#' @export
#' @rdname ggdarktheme
dark_theme_grey <- dark_theme_gray

#' @importFrom ggplot2 theme_minimal
#' @export
#' @rdname ggdarktheme
dark_theme_minimal <- function(base_size = 11, base_family = "", base_line_size = base_size/22,
                               base_rect_size = base_size/22) {
  dark_mode(theme_minimal(base_size, base_family, base_line_size, base_rect_size))
}

#' @importFrom ggplot2 theme_light
#' @export
#' @rdname ggdarktheme
dark_theme_light <- function(base_size = 11, base_family = "", base_line_size = base_size/22,
                             base_rect_size = base_size/22) {
  dark_mode(theme_light(base_size, base_family, base_line_size, base_rect_size))
}

#' @importFrom ggplot2 theme_dark
#' @export
#' @rdname ggdarktheme
dark_theme_dark <- function(base_size = 11, base_family = "", base_line_size = base_size/22,
                            base_rect_size = base_size/22) {
  dark_mode(theme_dark(base_size, base_family, base_line_size, base_rect_size))
}

#' @importFrom ggplot2 theme_void
#' @export
#' @rdname ggdarktheme
dark_theme_void <- function(base_size = 11, base_family = "", base_line_size = base_size/22,
                            base_rect_size = base_size/22) {
  dark_mode(theme_void(base_size, base_family, base_line_size, base_rect_size))
}

#' @importFrom ggplot2 theme_test
#' @export
#' @rdname ggdarktheme
dark_theme_test <- function(base_size = 11, base_family = "", base_line_size = base_size/22,
                            base_rect_size = base_size/22) {
  dark_mode(theme_test(base_size, base_family, base_line_size, base_rect_size))
}

#' @importFrom ggplot2 theme_linedraw
#' @export
#' @rdname ggdarktheme
dark_theme_linedraw <- function(base_size = 11, base_family = "", base_line_size = base_size/22,
                                base_rect_size = base_size/22) {
  dark_mode(theme_linedraw(base_size, base_family, base_line_size, base_rect_size))
}
