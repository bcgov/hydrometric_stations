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


library(projmgr)

## Define a current hydat
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

## Read record hydat date
record_hydat <- readLines("record_hydat_date.txt")

## Pull current data
current_hydat <- "2020-05-27" #get_current_hydat()

## if they are different create an issue
if (current_hydat != record_hydat) {
  repo_ref <- create_repo_ref("bcgov", "hydrometric_stations")

  post_issue(repo_ref,
             title = "Update Layer",
             body = paste0("Hydat was updated on ", current_hydat, ". The record needs updating."),
             labels = 'update',
             assignees = "boshek")

  ## write a new file to the repo
  writeLines(current_hydat, "record_hydat_date.txt")
}

