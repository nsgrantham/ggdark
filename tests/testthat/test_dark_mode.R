context("Verify dark_mode operates as expected.")

light_theme <- theme_void() +
  theme(plot.background = element_rect(fill = "#FFFFFF", color = "#D3D3D3"),
        panel.grid.major = element_line(color = "#CCCCCC"),
        axis.text.x = element_text(color = "#C0C0C0"))

dark_theme <- dark_mode(light_theme)

test_that("dark_mode inverts fill and colour aesthetics of all theme elements", {
  expect_equal(dark_theme$plot.background$fill, "#000000")
  expect_equal(dark_theme$plot.background$colour, "#2C2C2C")
  expect_equal(dark_theme$panel.grid.major$colour, "#333333")
  expect_equal(dark_theme$axis.text.x$colour, "#3F3F3F")
})

light_theme_alt <- dark_mode(dark_theme)

test_that("dark_mode applied twice returns the original fill and colour aesthetics", {
  expect_equal(light_theme_alt$plot.background$fill, light_theme$plot.background$fill)
  expect_equal(light_theme_alt$plot.background$colour, light_theme$plot.background$colour)
  expect_equal(light_theme_alt$panel.grid.major$colour, light_theme$panel.grid.major$colour)
  expect_equal(light_theme_alt$axis.text.x$colour, light_theme$axis.text.x$colour)
})

light_theme_blank <- light_theme + theme(plot.background = element_blank())
light_theme_null <- light_theme + theme(plot.background = NULL)
dark_theme_blank <- dark_mode(light_theme_blank)
dark_theme_null <- dark_mode(light_theme_null)

test_that("dark_mode adds a black plot background if missing", {
  expect_equal(dark_theme_blank$plot.background$fill, "#000000")
  expect_equal(dark_theme_null$plot.background$fill, "#000000")
})

update_geom_colors()
p <- ggplot(iris, aes(Sepal.Width, Sepal.Length)) + geom_point()

test_that("update_geom_colors changes fill and colour to 'black'", {
  expect_equal(p$layers[[1]]$geom$default_aes$fill, "black")
  expect_equal(p$layers[[1]]$geom$default_aes$colour, "black")
})

p + dark_mode()

test_that("Activating dark mode updates the geom fill and color defaults", {
  expect_equal(p$layers[[1]]$geom$default_aes$fill, "white")
  expect_equal(p$layers[[1]]$geom$default_aes$colour, "white")
})

update_geom_colors(fill = "grey20", color = "grey50")

test_that("update_geom_colors accepts custom values", {
  expect_equal(p$layers[[1]]$geom$default_aes$fill, "grey20")
  expect_equal(p$layers[[1]]$geom$default_aes$colour, "grey50")
})

update_geom_colours(fill = "grey80", colour = "grey80")

test_that("update_geom_colour alias works just as update_geom_color", {
  expect_equal(p$layers[[1]]$geom$default_aes$fill, "grey80")
  expect_equal(p$layers[[1]]$geom$default_aes$colour, "grey80")
})
