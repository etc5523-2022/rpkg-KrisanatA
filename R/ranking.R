#'
#' @export
ranking <- function(country = NULL, year = NULL) {
  if (is.null(country) | is.null(year)) {
    stop("The country and year input are required for this function.")
  }
  else {
    mortality %>%
      dplyr::filter(country == country,
             year == year) %>%
      dplyr::group_by(disease) %>%
      dplyr::summarise(Mortality_rate = mean(`mortality_rate`), .groups = "drop") %>%
      dplyr::arrange(-Mortality_rate) %>%
      dplyr::select(-Mortality_rate) %>%
      dplyr::mutate(Rank = paste0(1:21,".")) %>%
      dplyr::relocate(disease, .after = Rank) %>%
      head(10)
  }
}
