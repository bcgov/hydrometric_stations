# Copyright 2020 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.


## Create realtime url
real_url <- function(station_number){
  paste0("https://wateroffice.ec.gc.ca/report/real_time_e.html?stn=", station_number)
}

## Create archival url
archive_url <- function(station_number){
  paste0("https://wateroffice.ec.gc.ca/report/historical_e.html?stn=", station_number)
}


get_current_hydat <- function(){
  base_url <- "http://collaboration.cmc.ec.gc.ca/cmc/hydrometrics/www/"

  x <- httr::GET(base_url)
  httr::stop_for_status(x)

  ## Extract newest HYDAT
  new_hydat <- as.Date(substr(gsub(
    "^.*\\Hydat_sqlite3_", "",
    httr::content(x, "text")
    ), 1, 8), "%Y%m%d")

  as.character(new_hydat)


}
