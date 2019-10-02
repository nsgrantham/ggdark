context("Verify dark_mode operates as expected.")

library(ggplot2)

light_theme <- theme_void() +
  theme(
    plot.background = element_rect(fill = "#FFFFFF", color = "#D3D3D3"),
    panel.grid.major = element_line(color = "#CCCCCC"),
    axis.text.x = element_text(color = "#C0C0C0")
  )

dark_theme <- dark_mode(light_theme)

test_that(
  "dark_mode inverts fill and colour aesthetics of all theme elements", {
  expect_equal(dark_theme$plot.background$fill, "#000000")
  expect_equal(dark_theme$plot.background$colour, "#2C2C2C")
  expect_equal(dark_theme$panel.grid.major$colour, "#333333")
  expect_equal(dark_theme$axis.text.x$colour, "#3F3F3F")
})

light_theme_alt <- dark_mode(dark_theme)

test_that(
  "dark_mode applied twice returns the original fill and colour aesthetics", {
  expect_equal(
    light_theme_alt$plot.background$fill, light_theme$plot.background$fill
  )
  expect_equal(
    light_theme_alt$plot.background$colour, light_theme$plot.background$colour
  )
  expect_equal(
    light_theme_alt$panel.grid.major$colour, light_theme$panel.grid.major$colour
  )
  expect_equal(
    light_theme_alt$axis.text.x$colour, light_theme$axis.text.x$colour
  )
})

light_theme_blank <- light_theme + theme(plot.background = element_blank())
light_theme_null <- light_theme + theme(plot.background = NULL)
dark_theme_blank <- dark_mode(light_theme_blank)
dark_theme_null <- dark_mode(light_theme_null)

test_that("dark_mode adds a black plot background if missing", {
  expect_equal(dark_theme_blank$plot.background$fill, "#000000")
  expect_equal(dark_theme_null$plot.background$fill, "#000000")
})

invert_geom_defaults()
p <- ggplot(iris, aes(Sepal.Width, Sepal.Length)) + geom_point()

test_that("invert_geom_defaults changes fill and colour to 'black'", {
  expect_equal(p$layers[[1]]$geom$default_aes$colour, "#000000")
})

p + dark_mode()

test_that("Activating dark mode updates the geom fill and color defaults", {
  expect_equal(p$layers[[1]]$geom$default_aes$colour, "#FFFFFF")
})

test_that("Setting defaults works", {
  set_geom_defaults(dark = FALSE)
  p <- ggplot(iris, aes(Sepal.Width, Sepal.Length)) + geom_point()
  expect_equal(p$layers[[1]]$geom$default_aes$colour, "#000000")
  set_geom_defaults(dark = TRUE)
  p <- ggplot(iris, aes(Sepal.Width, Sepal.Length)) + geom_point()
  expect_equal(p$layers[[1]]$geom$default_aes$colour, "#FFFFFF")
})

test_that("Themes are correctly detected as dark" {
  def_themes <- list(theme_bw(), theme_classic())
  dark_themes <- list(dark_theme_bw(), dark_theme_classic())
  def_check <- sapply(def_themes, theme_is_dark)
  dark_check <- sapply(dark_themes, theme_is_dark)
  expect_true(!any(def_check))
  expect_true(all(dark_check))
})
