# Script 
library(tidyverse)
library(maps)


# To download data from the IHME website: https://ghdx.healthdata.org
# library(downloader)
# url <- "https://ghdx.healthdata.org/sites/default/files/record-attached-files/IHME_AMR_PATHOGEN_DATA_Y2022M11D21.zip"
# download(url, dest="data/dataset.zip", mode="wb") 
# unzip ("data/dataset.zip", exdir = "data")
# # delete the zip file
# unlink("data/dataset.zip")
# read the csv and assign it to a variable named "df"
# df <- read_csv("data/IHME_AMR_PATHOGEN_DATA_Y2022M11D21/IHME_AMR_PATHOGEN_2019_DATA_Y2022M11D21.CSV")
# delete the csv file (it is over 1k)
# unlink("data/IHME_AMR_PATHOGEN_DATA_Y2022M11D21/IHME_AMR_PATHOGEN_2019_DATA_Y2022M11D21.CSV")



# Load IHME data from the folder data/pathogens.RData
# the variable will be located in the environment as "df"
load("data/pathogens.RData")

# Get data ready for the app to use
df1 <- df %>%
  mutate(measure_name=ifelse(measure_name=="YLLs (Years of Life Lost)","YLLs",measure_name))%>%
  filter(val>0,
         age_group_name=="Age-standardized") %>%
  select(location_name,measure_name,metric_name,
         infectious_syndrome,pathogen,val,upper,lower)%>%
  mutate(location_name=case_when(location_name=="United Kingdom"~"UK",
                                 location_name=="Democratic People's Republic of Korea"~"Korea",
                                 location_name=="Republic of Korea"~"Korea",
                                 location_name=="United States of America"~"USA",
                                 TRUE~location_name))

my_countries <- df1$location_name
# Load data for mapping
world <- ggplot2::map_data("world")
world_countries <- world$region
missing_locations <- setdiff(my_countries,world_countries)%>%sort()

df2 <- df1%>%
  filter(!location_name %in% missing_locations)%>%
  arrange(location_name)

Country <- ordered(df2$location_name,levels=unique(df2$location_name))

centroids <- world%>%
  select(-order,-subregion)%>%
  group_by(region)%>%
  mutate(long=mean(range(long)),lat=mean(range(lat)))%>%
  distinct()

centroids_full <- df2 %>%
  left_join(centroids,by=c("location_name"="region"))


rm(df,df1,df2,missing_locations,my_countries,world_countries)


