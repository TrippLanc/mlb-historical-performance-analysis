SELECT COUNT(*) as total_team_seasons FROM teams;

SELECT year_id, name, w, l, ws_win
FROM teams
WHERE year_id >= 2015 AND ws_win = 'Y'
ORDER BY year_id DESC;

SELECT
    MIN(year_id) as earliest_year,
    MAX(year_id) as latest_year
FROM teams;