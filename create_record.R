# Copyright 2018 Province of British Columbia
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



# Packages ----------------------------------------------------------------

library(dplyr)
library(readr)
library(purrr)
library(tidyhydat)
library(bcdata)
library(sf)



# Functions ---------------------------------------------------------------

## Create realtime url
real_url <- function(station_number){
  paste0("https://wateroffice.ec.gc.ca/report/real_time_e.html?stn=", station_number)
}

## Create archival url
archive_url <- function(station_number){
  paste0("https://wateroffice.ec.gc.ca/report/historical_e.html?stn=", station_number)
}


# Get data ----------------------------------------------------------------

#bc_stns <- tidyhydat::hy_stations(prov_terr_state_loc = "BC")
## Using allstations here
bc_stns <- filter(allstations, PROV_TERR_STATE_LOC == "BC")


# Add in watershed info ---------------------------------------------------

## TODO: Add in stream order

## Find watershed group
## This will take a little while to download
ws_group <- bcdc_query_geodata("51f20b1a-ab75-42de-809d-bf415a0f9c62") %>%
  select(WATERSHED_GROUP_ID, WATERSHED_GROUP_CODE) %>%
  collect() %>%
  select(WATRSHD_ID = WATERSHED_GROUP_ID, WTr_GRP_CD = WATERSHED_GROUP_CODE)


bc_stns_sp <- st_as_sf(bc_stns, coords = c("LONGITUDE", "LATITUDE"),
           agr = "constant",
           crs = 4326) %>%
  mutate(LATITUDE = unlist(map(.$geometry,1)),
         LONGITUDE = unlist(map(.$geometry,2))) %>%
  st_transform(3005)

bc_stns_ws <- bc_stns_sp %>%
  st_join(ws_group) %>%
  st_set_geometry(NULL)




## Finding the date range of the data for all measurement (level, flow etc)

## This will take quite some time to run. (~5 minutes)
full_date_range <- hy_daily(prov_terr_state_loc = "BC") %>%
  filter(!is.na(Value)) %>%
  group_by(STATION_NUMBER) %>%
  summarise(DATE_FROM = min(Date), DATE_TO = max(Date)) %>%
  mutate(DATE_FROM = as.character(as.Date(DATE_FROM, "%m/%d/%Y"), "%Y%m%d") ) %>%
  mutate(DATE_TO = as.character(as.Date(DATE_TO, "%m/%d/%Y"), "%Y%m%d") ) ## date requested in YYYYMMDD

## Regulation data
stn_regulation <- hy_stn_regulation(prov_terr_state_loc = "BC") %>%
  mutate(REGULATED = case_when(
    REGULATED == FALSE ~ "NATURAL",
    REGULATED == TRUE ~ "REGULATED"
    ))

# Add relevant columns ----------------------------------------------------

## Columns to do/ filled with NA's:
## STREAM_ORD
## CAPTR_SCAL
## GEOMETRY

## Columns with Uncertain Status
# HDRMTRCSTT

## Be nice to find a way to test if the urls work
## A faulty url like this: https://wateroffice.ec.gc.ca/report/real_time_e.html?stn=13EA004 just directs to the search page

## Assign stations to drainages
bc_stns <- bc_stns_ws %>%
  mutate(REALTM_URL = case_when(
    REAL_TIME == TRUE ~ real_url(STATION_NUMBER)
  )) %>% ## generate realtime links
  mutate(ARCHIV_URL = archive_url(STATION_NUMBER)) %>% ## generate archival links
  mutate(FEAT_CODE = "CF29300000") %>%
  left_join(select(stn_regulation, STATION_NUMBER, REGULATED)) %>%
  left_join(select(full_date_range, STATION_NUMBER, DATE_FROM, DATE_TO)) %>%
  mutate(HDRMTRCSTT = NA_character_, STREAM_ORD = NA_character_, GEOMETRY = NA_character_,
         OBJECTID = NA_character_, CAPTR_SCAL = NA_character_) %>%
  select(WATRSHD_ID, DATE_FROM, HDRMTRCSTT, WTr_GRP_CD, STREAM_ORD, HYD_STATUS, REAL_TIME, DATE_TO, REALTM_URL,
         ARCHIV_URL, REGULATED, GEOMETRY, OBJECTID, STATION_NUMBER, CAPTR_SCAL, STATION_NAME, FEAT_CODE, LATITUDE, LONGITUDE)

colnames(bc_stns) <- c("WATRSHD_ID", "START_DATE", "HDRMTRCSTT", "WTr_GRP_CD", "STREAM_ORD",
                       "STN_OP_STA", "STN_RT_STA", "END_DATE", "REALTM_URL", "ARCHIV_URL", "FLOW_TYPE",
                       "GEOMETRY", "OBJECTID", "STATION_NO", "CAPTR_SCAL", "STATN_NAME",
                       "FEAT_CODE", "X", "Y")



## Output data to keep a record of the data history
write_csv(bc_stns, paste0("previous_records/bc_hydrometric_",Sys.Date(),".csv"))

## Output .csv file
write_csv(bc_stns, "bc_hydrometric.csv")








