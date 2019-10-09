library(ggplot2)
library(ggdark)

test_that("themes are changed appropriately", {
  themes <- list(
    theme_bw(), theme_classic(), theme_dark(), theme_gray(), theme_minimal(),
    theme_linedraw(), theme_light(), theme_test(), theme_void()
  )
  dark_thmes <- lapply(themes, darken_theme)
  light_themes <- lapply(themes, lighten_theme)
  expect_true(all(!sapply(themes, theme_is_dark)))
  expect_true(all(sapply(dark_thmes, theme_is_dark)))
  expect_true(all(!sapply(light_themes, theme_is_dark)))
})
