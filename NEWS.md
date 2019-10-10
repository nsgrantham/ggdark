# ggdark 0.2.1-dev

Added utilities:

* `geoms_are_dark` checks if geoms are dark-mode friendly.
* `darken_geoms` makes geoms dark-mode friendly (if they are not already).
* `lighten_geoms` returns geoms to ggplot2 default (if they are not already).

* `theme_is_dark` checks if theme is dark.
* `darken_theme` makes theme dark (if it is not already).
* `lighten_theme` makes theme light (if it is not already).

* `light_mode` does the opposite of `dark_mode`

* `ggsave_dark` a wrapper around `ggsave` with and additional argument: `dark`.
When `TRUE`, will make sure the geoms are dark-mode friendly and the theme of 
the plot is dark before saving. When `FALSE`, does the opposite.

Changed behaviour:

* `dark_mode` no longer "darkens" already dark themes. Set `force_theme_invert = TRUE` to get the old behaviour.
