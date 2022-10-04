# The code needed to prepare the `mortality` dataset ----------------------


# Library -----------------------------------------------------------------

library(dplyr)
library(tidyr)
library(readr)
library(stringr)
library(owidR)


# Download data needed ----------------------------------------------------

# Using the owidR package, we can get the data on the mortality rate for each cause
cause_of_death <- owid("share-of-deaths-by-cause")

# URL for downloading data on country name and region
url <- 'https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv'

# Read country code and region data
country <- read_csv(url)

# Extract country code
alpha_3 <- country %>%
  pull(`alpha-3`) %>%
  tolower()


# Clean data --------------------------------------------------------------

# Join mortality and country data set together
data <- cause_of_death %>%
  filter(tolower(code) %in% alpha_3) %>%
  group_by(code) %>%
  right_join(country, by = c("code" = "alpha-3")) %>%
  ungroup()

mortality <- data %>%
  # select only relevant variable
  select(entity,
         code,
         year,
         `Deaths - Cardiovascular diseases - Sex: Both - Age: All Ages (Percent)`,
         `Deaths - Neoplasms - Sex: Both - Age: All Ages (Percent)`,
         `Deaths - Maternal disorders - Sex: Both - Age: All Ages (Percent)`,
         `Deaths - Chronic respiratory diseases - Sex: Both - Age: All Ages (Percent)`,
         `Deaths - Digestive diseases - Sex: Both - Age: All Ages (Percent)`,
         `Deaths - Diabetes mellitus - Sex: Both - Age: All Ages (Percent)`,
         `Deaths - Lower respiratory infections - Sex: Both - Age: All Ages (Percent)`,
         `Deaths - Neonatal disorders - Sex: Both - Age: All Ages (Percent)`,
         `Deaths - Diarrheal diseases - Sex: Both - Age: All Ages (Percent)`,
         `Deaths - Cirrhosis and other chronic liver diseases - Sex: Both - Age: All Ages (Percent)`,
         `Deaths - Tuberculosis - Sex: Both - Age: All Ages (Percent)`,
         `Deaths - Chronic kidney disease - Sex: Both - Age: All Ages (Percent)`,
         `Deaths - Alzheimer's disease and other dementias - Sex: Both - Age: All Ages (Percent)`,
         `Deaths - Parkinson's disease - Sex: Both - Age: All Ages (Percent)`,
         `Deaths - HIV/AIDS - Sex: Both - Age: All Ages (Percent)`,
         `Deaths - Acute hepatitis - Sex: Both - Age: All Ages (Percent)`,
         `Deaths - Malaria - Sex: Both - Age: All Ages (Percent)`,
         `Deaths - Nutritional deficiencies - Sex: Both - Age: All Ages (Percent)`,
         `Deaths - Meningitis - Sex: Both - Age: All Ages (Percent)`,
         `Deaths - Protein-energy malnutrition - Sex: Both - Age: All Ages (Percent)`,
         `Deaths - Enteric infections - Sex: Both - Age: All Ages (Percent)`,
         region) %>%
  # Remove NA value
  na.omit() %>%
  # Put data into long format
  pivot_longer(-c(entity, code, year, region),
               names_to = "disease",
               values_to = "mortality_rate") %>%
  # Clean Disease name
  mutate(disease = str_replace_all(disease, c("Deaths - " = "", " - Sex: Both - Age: All Ages \\(Percent\\)" = "")),
         mortality_rate = round(mortality_rate, 4)) %>%
  # Rename column
  rename(country = entity,
         continent = region) %>%
  # Relocate the column
  relocate(c(continent, year, disease, mortality_rate),
           .after = c(code, continent, year, disease))


usethis::use_data(mortality, overwrite = TRUE)
