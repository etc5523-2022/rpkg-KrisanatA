#' Disease summary
#'
#' @description Rank the highest mortality rate by disease in a particular country and year.
#' For a list of available country and year refer back to [country_list()], [year_list()].
#'
#' @param country A character of the country name you want to learn about the disease's rank. See a full list of countries by `country_list()`.
#' @param year A numeric for a specific year of interest. See a full list of the year by `year_list()`.
#'
#' @return A data frame on the top 10 diseases ranks by mortality rate from highest to lowest.
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
    stop("The country's name is not known. Refer back to country_list() to check the available country information.")
  }

  if(!(year %in% dislib::year_list(country))) {
    stop("This year is not available. Refer back to year_list() to check the available year.")
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
