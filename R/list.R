# disease -----------------------------------------------------------------

#' Disease list
#'
#' @description Get a list of available disease name.
#'
#' @export
disease_list <- function() {
  unique(dislib::mortality$disease)
}


# country -----------------------------------------------------------------

#' Country list
#'
#' @description Get a list of available country name.
#'
#' @export
country_list <- function() {
  unique(dislib::mortality$country)
}


# year --------------------------------------------------------------------

#' Year list
#'
#' @description Get a list of available year for the country specified.
#'
#' @param country A character of country name you want to learn about the diseases rank. See a full list of country by `country_list()`.
#'
#' @return A vector of available year data for particular country.
#'
#' @examples
#' year_list(country = "Australia")
#'
#' @export
#' @importFrom rlang .data
year_list <- function(country = NULL) {
  if (is.null(country)) {
    stop("Country input are required")
  }

  if(!(country %in% dislib::country_list())) {
    stop("Country name is not known, refer back to country_list() to check the available country information.")
  }

  else {
    country <- dislib::mortality %>%
      dplyr::filter(.data$country == {{country}})

    unique(country$year)
  }
}
