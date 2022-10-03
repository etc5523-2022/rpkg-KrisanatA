#' Mortality rate overtime
#'
#' @description This function plot the mortality rate overtime for the disease and country chosen.
#' For a list of available disease and country refer back to [disease_list()], [country_list()].
#'
#' @param disease A character of disease name you want to see. See a full list of disease by `disease_list()`.
#' @param country A character of country name you want to learn. See a full list of country by `country_list()`.
#'
#' @return Return a `ggplot` object.
#'
#' @examples
#' plot_dis(disease = "Cardiovascular diseases", country = "Australia")
#'
#' @export
#' @importFrom rlang .data
plot_dis <- function(disease = NULL, country = NULL) {
  if(is.null(disease) | is.null(country)) {
    stop("Disease and country input are required for this function.")
  }

  if(!(disease %in% dislib::disease_list())) {
    stop("Disease name is not known, refer back to diseases_list() to check the available diseases information.")
  }

  if(!(country %in% dislib::country_list())) {
    stop("Country name is not known, refer back to country_list() to check the available country information.")
  }

  else {
    mortality_rate <- year <- NULL

    dislib::mortality %>%
      dplyr::filter(.data$country == {{country}},
                    .data$disease == {{disease}}) %>%
      ggplot2::ggplot(ggplot2::aes(x = year, y = `mortality_rate`)) +
      ggplot2::geom_line(color = "red") +
      ggplot2::geom_point(color = "red") +
      ggplot2::theme_bw() +
      ggplot2::labs(x = "Year", y = "Mortality Rate (Percentage)") +
     ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 50, vjust = 1, hjust = 1))
  }
}
