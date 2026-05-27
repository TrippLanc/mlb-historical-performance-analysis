# MLB Historical Performance Analysis

A comprehensive SQL-based analysis of Major League Baseball player and team performance using the **Lahman Baseball Database (1871–2025)**, with a focus on the modern era (1980–present).

---

## Live Dashboard

**[View the Tableau Dashboard →](https://public.tableau.com/app/profile/tripp.lancaster/viz/MLB_Dashboard_Final/Dashboard1?publish=yes)**

---

## Project Overview

This project demonstrates advanced SQL skills through the creation of a relational database, complex analytical queries, and performance metrics calculations. The analysis explores batting statistics, pitching performance, fielding defense, awards history, salary trends, and team success across multiple decades of baseball history — all visualized in an interactive Tableau dashboard.

---

## Database Schema

### Core Tables

| Table | Description | Records |
|---|---|---|
| `people` | Player biographical info — birth/death dates, physical stats, career span | 20,000+ players |
| `batting` | Season-by-season batting statistics (AB, H, 2B, 3B, HR, RBI, BB, SO, etc.) | 110,000+ records |
| `pitching` | Season-by-season pitching statistics (W, L, ERA, SO, BB, IPouts, etc.) | 50,000+ records |
| `teams` | Team-level statistics by season (W, L, runs, championships, park factors) | 3,000+ team-seasons |
| `fielding` | Season-by-season fielding statistics by position (PO, A, E, DP, CS, etc.) | 174,000+ records |
| `awards_players` | Player award history (MVP, Cy Young, Gold Glove, Silver Slugger, etc.) | — |
| `hall_of_fame` | HOF ballot records and inductee data | — |
| `salaries` | Player salary data by season and team (1985–present) | — |

### Views

| View | Description |
|---|---|
| `career_batting_1980s` | Aggregated career batting stats for players active since 1980 (min 1,000 AB) |
| `career_pitching_1980s` | Aggregated career pitching stats since 1980 (min 1,500 IP outs) |
| `league_pitching_averages` | League-level ERA, HR, BB, SO totals per season — used for ERA+/FIP |
| `fip_constants` | FIP constant calculated per league-season |
| `career_pitching_era_plus_fip` | Career ERA+, FIP, and all advanced pitching metrics (min 500 IP) |
| `career_fielding_1980s` | Career fielding stats by position (min 200 games) |
| `player_award_summary` | Award counts per player since 1980 (MVP, Cy Young, Gold Glove, etc.) |
| `hof_inductees` | All inducted players with vote percentages and career stats |
| `career_earnings` | Career salary totals, peak salary, and average annual salary per player |

---

## Key Analyses

### Advanced Batting Metrics
- Batting Average (BA), On-Base Percentage (OBP), Slugging Percentage (SLG), OPS
- Career totals and averages (1980–present, min 1,000 AB)

### Advanced Pitching Metrics
- ERA, WHIP, K/9, BB/9, HR/9, H/9, K/BB ratio
- **ERA+** — park and league-adjusted ERA (100 = league average, higher is better)
- **FIP** — Fielding Independent Pitching, isolating outcomes the pitcher controls
- **FIP−** — FIP relative to league average
- ERA vs. FIP gap analysis identifying over and underperformers relative to defense
- Career views for all metrics (min 500 IP)

### Fielding & Defense
- Fielding Percentage and Range Factor per 9 innings
- Catcher Caught Stealing % (CS%)
- Career defensive rankings by position (min 200 games)

### Team Performance
- Win percentage and run differential by season (1980–present)
- World Series, pennant, and division title tracking
- Franchise success rankings since 1980

---

## Project Structure
```
mlb-historical-performance-analysis/
├── data/                               # Lahman Database CSVs (not committed to git)
│   ├── People.csv
│   ├── Batting.csv
│   ├── Pitching.csv
│   ├── Teams.csv
│   ├── Fielding.csv
│   ├── Salaries.csv
│   ├── AwardsPlayers.csv
│   ├── HallOfFame.csv
│   └── ... (additional Lahman tables)
│
├── schema/                             # Table creation and data import scripts
│   ├── 01_create_people_table.sql
│   ├── 02_import_people_data.sql
│   ├── 03_create_batting_table.sql
│   ├── 04_import_batting_data.sql
│   ├── 05_create_pitching_table.sql
│   ├── 06_import_pitching_data.sql
│   ├── 07_create_teams_table.sql
│   ├── 08_import_teams_data.sql
│   ├── 09_create_fielding_table.sql
│   └── 10_import_fielding_data.sql
│
├── analysis/                           # SQL analysis and metrics queries
│   ├── 01_batting_advanced_metrics.sql
│   ├── 02_career_batting_stats.sql
│   ├── 03_team_performance.sql
│   ├── 04_pitching_advanced_metrics.sql
│   ├── 05_career_pitching_stats.sql
│   ├── 06_pitcher_performance_categories.sql
│   ├── 07_pitching_era_plus_fip.sql
│   ├── 08_fielding_stats.sql
│   ├── 09_awards_hof.sql
│   └── 10_salary_analysis.sql
│
├── tableau/                            # Tableau exports and workbook
│   ├── career_batting.csv
│   ├── career_fielding.csv
│   ├── career_pitching_advanced.csv
│   ├── player_awards.csv
│   ├── team_seasons.csv
│   └── MLB_Dashboard_Final.twbx
│
└── README.md
```
---

## Getting Started

### Prerequisites
- PostgreSQL 15+
- psql or a compatible SQL client (e.g., VS Code + SQLTools)
- [Lahman Baseball Database (2025 edition)](http://www.seanlahman.com/)

### Setup

1. **Clone the repository**
```bash
   git clone https://github.com/yourusername/mlb-historical-performance-analysis.git
   cd mlb-historical-performance-analysis
```

2. **Create the database**
```bash
   psql -U postgres -c "CREATE DATABASE mlb_analysis;"
```

3. **Run schema scripts in order**
```bash
   psql -U postgres -d mlb_analysis -f schema/01_create_people_table.sql
   psql -U postgres -d mlb_analysis -f schema/02_import_people_data.sql
   # ... continue through schema/10_import_fielding_data.sql
```

4. **Run analysis scripts in order**
```bash
   psql -U postgres -d mlb_analysis -f analysis/01_batting_advanced_metrics.sql
   # ... continue through analysis/10_salary_analysis.sql
```
   > Note: Analysis scripts must be run in order — later scripts depend on views created by earlier ones.

---

## Technologies Used

| Category | Tool |
|---|---|
| Database | PostgreSQL 15 |
| IDE / Client | VS Code + SQLTools, psql |
| Version Control | Git / GitHub |
| Data Source | [Lahman Baseball Database](http://www.seanlahman.com/) (2025 edition) |
| Visualization | Tableau Public |

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
