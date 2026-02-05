# MLB Historical Performance Analysis

A comprehensive SQL-based analysis of Major League Baseball player and team performance using the Lahman Baseball Database (1871-2025), with a focus on the modern era (1980-present).

## Project Overview

This project demonstrates advanced SQL skills through the creation of a relational database, complex analytical queries, and performance metrics calculations. The analysis explores batting statistics, pitching performance, and team success across multiple decades of baseball history.

## Project Status

- Database setup (PostgreSQL)
- Core tables created and populated
  - People table (~20,000+ players)
  - Batting table (~110,000+ records)
  - Pitching table (~50,000+ records)
  - Teams table (~3,000+ team-seasons)
- Advanced batting metrics (BA, OBP, SLG, OPS)
- Career statistics aggregation (1980-present)
- Team performance analysis
- Pitching advanced metrics (in progress)
- Data visualization dashboards (upcoming)

## Database Schema

### Core Tables
- **people**: Player biographical information including birth/death dates, physical stats, and career span
- **batting**: Season-by-season batting statistics (at-bats, hits, doubles, triples, home runs, RBIs, etc.)
- **pitching**: Season-by-season pitching statistics (wins, losses, ERA, strikeouts, walks, etc.)
- **teams**: Team-level statistics by season (wins, losses, runs scored/allowed, championships)

### Views
- **career_batting_1980s**: Aggregated career statistics for players active since 1980 (minimum 1000 AB)

## Key Analyses

### Advanced Batting Metrics
- Batting Average (BA)
- On-Base Percentage (OBP)
- Slugging Percentage (SLG)
- On-Base Plus Slugging (OPS)
- Career totals and averages (1980-present)

### Team Performance
- Win percentage calculations
- World Series/Pennant/Division title tracking
- Run differential analysis
- Franchise success rankings since 1980

## Technologies Used

- **Database**: PostgreSQL 15
- **Tools**: VS Code, SQLTools, psql
- **Version Control**: Git/GitHub
- **Data Source**: Lahman Baseball Database (2025 edition)
- **Planned**: Tableau/Power BI for visualization

## Project Structure
