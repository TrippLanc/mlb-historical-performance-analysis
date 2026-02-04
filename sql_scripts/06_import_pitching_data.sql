SELECT COUNT(*) as total_pitching_records FROM pitching;

SELECT
    p.player_id,
    pe.name_first,
    pe.name_last,
    p.year_id,
    p.team_id,
    p.era,
    p.w,
    p.l,
    p.era,
    p.so
FROM pitching p
JOIN people pe ON p.player_id = pe.player_id
WHERE p.year_id >= 2020 AND p.gs > 10
ORDER BY p.era ASC
LIMIT 20;

SELECT
    MIN(year_id) as earliest_year,
    MAX(year_id) as latest_year
FROM pitching;