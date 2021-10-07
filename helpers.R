# Load data
base <- readRDS("fiscal_disparities_formatted.RDS")

# map 2 bivariate palette
bivar_cols <- c("#caeed1", "#8edb9d", "#52c769", "#dde0fd", "#959cf7", "#5561f2", "#fedae4", "#fd95b4", "#fa1459")

# run palettes

pal1 <- colorFactor("PuOr", domain = base$ci_pct_change_bin)

pal2 <- colorFactor(bivar_cols, base$bivar_ci_medinc)

# Make map labels

mapLabels <- sprintf("<strong>%s</strong><br/>County: %s<br/>Community Type: %s<br/>Change in CI Tax Base: %g&#37<br/> Median Income: %s", base$community, sub(" .*", "", base$county), base$community_designation_thrive_msp2040, base$pct_change_ci_base, format_dollars(base$med_income)) %>%
  lapply(htmltools::HTML)

# Import picture of legend I had to make manually

legend2 <- imager::load.image("https://user-images.githubusercontent.com/7897840/101764167-5bda9a80-3aa5-11eb-8ac0-d875be7491c6.png")