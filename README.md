# NHL Data Scraper, Cleaner, and Analysis

This project involves scraping, cleaning, and analyzing NHL hockey data to create a comprehensive dataset of team performance and arena information. The dataset integrates multiple data sources, providing valuable insights into team statistics and venue details.

---

## Requirements

To run the code, ensure the following R packages are installed:

- `xml2`
- `dplyr`
- `readxl`
- `readr`

Install any missing packages using `install.packages()`.

---

## Project Workflow

### 1. Web Scraping NHL Data
- Scrapes team performance data from multiple pages on a hockey statistics website using the `xml2` package.
- Implements rate-limiting to prevent server overload with `Sys.sleep()` delays.
- Extracts raw HTML tables and processes them into structured data frames.

### 2. Data Cleaning
- Removes unnecessary whitespace and newline characters.
- Converts columns to appropriate data types (e.g., integers for numerical fields).
- Resolves team name discrepancies using regex and predefined mappings.

### 3. Data Integration
- Combines scraped data with external datasets:
  - `nhl_2012-2021.xlsx`: Team performance data for seasons 2012 to 2021.
  - `nhl_hockey_arenas.csv`: Arena details including location and capacity.
- Adds a calculated column for team win percentage.
- Ensures consistent team naming conventions across all datasets.

### 4. Data Export
- Outputs a clean and unified dataset, `hockey_data.csv`, with the following columns:
  - Team Name
  - Year
  - Wins
  - Losses
  - Win Percentage
  - Arena
  - Location
  - Capacity

---

## How to Use

### Run the Script
1. Clone this repository and navigate to the project directory.
2. Open the `NHLScraper.R` script in your R environment.
3. Place the required datasets in the working directory:
   - `nhl_2012-2021.xlsx`
   - `nhl_hockey_arenas.csv`
4. Execute the script to generate the processed dataset.

### Customize Rate-Limiting
Modify the `Sys.sleep()` parameters in the `scrape_page()` function to adjust the time delay between web requests.

### Inspect Output
- The processed data is saved as `hockey_data.csv` in the working directory.
- Review the output for potential mismatches or discrepancies in team names before running the final merge.

---

## Outputs

The final dataset, `hockey_data.csv`, includes:

- **Name**: Team name  
- **Year**: Season year  
- **Wins**: Number of games won  
- **Losses**: Number of games lost  
- **Win_Percent**: Win percentage (calculated as Wins / (Wins + Losses))  
- **Arena**: Home arena name  
- **Location**: Arena location  
- **Capacity**: Arena seating capacity  

