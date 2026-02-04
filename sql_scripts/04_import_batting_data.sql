SELECT COUNT(*) as total_batting_records FROM batting;

SELECT
    b.player_id,
    p.name_first,
    p.name_last,
    b.year_id,
    b.team_id,
    b.h,
    b.hr,
    b.rbi
FROM batting b
JOIN people p ON b.player_id = p.player_id
ORDER BY b.year_id DESC, b.h DESC
LIMIT 20;

SELECT
    MIN(year_id) as earliest_year,
    MAX(year_id) as latest_year
FROM batting;