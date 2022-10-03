#' Disease summary
#'
#' @description Rank the highest mortality rate by disease in a particular country and year.
#' For a list of available country and year refer back to [country_list()], [year_list()].
#'
#' @param country A character of country name you want to learn about the diseases rank. See a full list of country by `country_list()`.
#' @param year A numeric for a specific year of interest. See a full list of year by `year_list()`.
#'
#' @return A data frame on the top 10 diseases mortality rate from highest to lowest.
#'
#' @examples
#' dis_summary(country = "Australia", year = 2019)
#'
#' @export
#' @importFrom rlang .data
dis_summary <- function(country = NULL, year = NULL) {
  if (is.null(country) | is.null(year)) {
    stop("The country and year input are required for this function.")
  }

  if(!(country %in% dislib::country_list())) {
    stop("Country name is not known, refer back to country_list() to check the available country information.")
  }

  if(!(year %in% dislib::year_list(country))) {
    stop("This year is not available, refer back to year_list() to check the available year.")
  }

  else {
    dislib::mortality %>%
      dplyr::filter(.data$country == {{country}},
                    .data$year == {{year}}) %>%
      dplyr::group_by(.data$disease) %>%
      dplyr::summarise(Mortality_rate = mean(.data$mortality_rate), .groups = "drop") %>%
      dplyr::arrange(dplyr::desc(.data$Mortality_rate)) %>%
      dplyr::mutate(Rank = as.numeric(paste0(1:21, ""))) %>%
      dplyr::relocate(c(.data$disease, .data$Mortality_rate), .after = c(.data$Rank, .data$disease)) %>%
      utils::head(10)
  }
}
