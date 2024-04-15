# Packages ----
library(tidytable)


# 1. Import Data ----
survey <- fread("C:/Users/wb622077/Downloads/cps_00004.csv") # CPS data extract

# 2. Prepare data ----
## (filter and make some columns strings)
survey_subset <- survey |> filter(YEAR <= 2013) |>
                           mutate(across(starts_with('OCC') | starts_with('IND'),
                                         ~ as.character(.x)),
                                  CPSIDP = CPSIDP/100)



# 3. Prepare altered dataset ----
survey_modified <- survey_subset
string_columns_to_alter <- c('OCC50LY', 'INDLY')
numeric_columns_to_alter <- c('CPSIDP', 'ASECWTH', 'CLASSWLY')


## 3.1 Introduce NAs randomly in random rows across string_columns_to_alter
set.seed(123)
rows_to_alter_string <- sample(1:nrow(survey_modified), 20)
survey_modified[rows_to_alter_string, string_columns_to_alter] <- NA

## 3.2 Change values in random rows (different ones) across numeric_columns_to_alter
set.seed(456)
rows_to_alter_numeric <- sample(1:nrow(survey_modified), 20)

survey_modified <- survey_modified |>
  mutate(row_index = row_number())

survey_modified <- survey_modified |>
  mutate(across(.cols = all_of(numeric_columns_to_alter), 
                .fns = ~ if_else(row_index %in% rows_to_alter_numeric, 
                                 .x * runif(length(.x), min = 0.95, max = 1.05), .x)))

# 4. Save
saveRDS(survey_modified, "data/survey_modified.rds")
saveRDS(survey_subset, "data/survey_subset.rds")

