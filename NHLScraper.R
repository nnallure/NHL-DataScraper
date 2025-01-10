# Nikitha Nallure
# 10/27/2023
# HW4

rm(list=ls())

#1
library(xml2)
library(dplyr)
library(readxl)
library(readr)

scrape_page <- function(url) {
  
Sys.sleep(5)

user_agent <- "Chrome/89.0.4389.82"

page <- read_html(url, user_agent = user_agent)

table_data <- page %>%
html_nodes("table") %>%
html_table(fill = TRUE)
  
df <- as.data.frame(table_data[[1]], stringsAsFactors = FALSE)
  
}

base_url <- "https://www.scrapethissite.com/pages/forms/"

num_pages <- 24

name <- character()
year <- character()
wins <- character()
losses <- character()

start_time <- Sys.time()

for (page_num in 1:num_pages) {
url <- paste0(base_url, "?page=", page_num)
scraped_data <- scrape_page(url)

colnames(scraped_data) <- make.names(colnames(scraped_data))

name <- c(name, scraped_data$Team.Name)
year <- c(year, scraped_data$Year)
wins <- c(wins, scraped_data$Wins)
losses <- c(losses, scraped_data$Losses)
  
wait_time <- sample(2:20, 1)
cat("Scraped page", page_num, ". Waiting for", wait_time, "seconds...\n")
Sys.sleep(wait_time)
}

stop_time <- Sys.time()

elapsed_time <- stop_time - start_time

cat("Time Elapsed: ", elapsed_time, "\n")

nhl <- data.frame(Team = name, Year = year, Wins = wins, Losses = losses)

#2
nhl <- nhl %>%
  mutate_all(~ trimws(gsub("\\n", "", .)))

nhl$Year <- as.integer(nhl$Year)
nhl$Wins <- as.integer(nhl$Wins)
nhl$Losses <- as.integer(nhl$Losses)

#3
nhl_expanded <- read_excel("nhl_2012-2021.xlsx")

nhl_expanded <- nhl_expanded[, c(2, 33, 5, 6)]

nhl_expanded <- nhl_expanded[-1,]

colnames(nhl_expanded) <- c("Team", "Year", "Wins", "Losses")

str(nhl_expanded)
nhl_expanded$Year <- as.integer(nhl_expanded$Year)
nhl_expanded$Wins <- as.integer(nhl_expanded$Wins)
nhl_expanded$Losses <- as.integer(nhl_expanded$Losses)
str(nhl_expanded)

nhl_expanded$Team <- gsub("\\*$", "", nhl_expanded$Team)

nhl2 <- rbind(nhl, nhl_expanded)

nhl2$Win_Percent <- nhl2$Wins / (nhl2$Wins + nhl2$Losses)

#4
arena <- read.csv("nhl_hockey_arenas.csv")

nhl3 <- merge(nhl2, arena, by.x = "Team", by.y = "Arena.Name", all.x = TRUE)

colnames(nhl3) <- c("Name", "Year", "Wins", "Losses", "Win_Percent", "Arena", "Location", "Capacity")

nhl3 <- nhl3[, c("Name", "Year", "Wins", "Losses", "Win_Percent", "Arena", "Location", "Capacity")]

unique_team_names_nhl2 <- unique(nhl2$Team)
unique_team_names_arena <- unique(arena$Team.Name)

for (discrepancy in setdiff(unique_team_names_nhl2, unique_team_names_arena)) {
  corrected_name <- unique_team_names_arena[grep(tolower(discrepancy), tolower(unique_team_names_arena))]
  arena$`Team Name`[grep(tolower(discrepancy), tolower(arena$`Team Name`))] <- corrected_name
}

team_name_changes <- data.frame(
  OriginalName = c("Mighty Ducks of Anaheim"),
  NewName = c("Anaheim Ducks")
)

for (i in 1:nrow(team_name_changes)) {
  nhl3$Name <- ifelse(nhl3$Name == team_name_changes[i, "OriginalName"],
                             team_name_changes[i, "NewName"],
                             nhl3$Name)
}

write.csv(nhl3, "hockey_data.csv", row.names = FALSE)
