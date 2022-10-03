test_that("dis_summary works", {
  library(dplyr)
  library(utils)

  test <- dislib::mortality %>%
    filter(country == "Australia",
           year == 2019) %>%
    group_by(disease) %>%
    summarise(Mortality_rate = mean(mortality_rate), .groups = "drop") %>%
    arrange(desc(Mortality_rate)) %>%
    mutate(Rank = as.numeric(paste0(1:21, ""))) %>%
    relocate(c(disease, Mortality_rate), .after = c(Rank, disease)) %>%
    head(10)

  output <- dislib::dis_summary("Australia", 2019)

  expect_true(identical(test, output))
  expect_identical(test, output)
})
