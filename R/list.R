# disease -----------------------------------------------------------------

#' Disease list
#'
#' @description Get a list of available disease names.
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
#' @description Get a list of the available year for the country specified.
#'
#' @param country A character of the country name you want to learn about the disease's rank. See a full list of countries by `country_list()`.
#'
#' @return A vector of available year value for a particular country.
#'
#' @examples
#' year_list(country = "Australia")
#'
#' @export
#' @importFrom rlang .data
year_list <- function(country = NULL) {
  if (is.null(country)) {
    stop("Country input are required.")
  }

  if(!(country %in% dislib::country_list())) {
    stop("The country's name is not known. Refer back to country_list() to check the available country information.")
  }

  else {
    country <- dislib::mortality %>%
      dplyr::filter(.data$country == {{country}})

    unique(country$year)
  }
}
