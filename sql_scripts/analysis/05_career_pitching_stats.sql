CREATE OR REPLACE VIEW career_pitching_1980s AS
SELECT 
    pi.player_id,
    p.name_first,
    p.name_last,
    MIN(pi.year_id) as first_season,
    MAX(pi.year_id) as last_season,
    COUNT(DISTINCT pi.year_id) as seasons_played,
    SUM(pi.g) as total_games,
    SUM(pi.gs) as total_starts,
    SUM(pi.w) as total_wins,
    SUM(pi.l) as total_losses,
    SUM(pi.sv) as total_saves,
    SUM(pi.ipouts) as total_ipouts,
    ROUND(CAST(SUM(pi.ipouts) AS DECIMAL) / 3, 1) as total_ip,
    SUM(pi.h) as total_hits_allowed,
    SUM(pi.er) as total_earned_runs,
    SUM(pi.hr) as total_hr_allowed,
    SUM(pi.bb) as total_walks,
    SUM(pi.so) as total_strikeouts,
    ROUND(
        (CAST(SUM(pi.er) AS DECIMAL) * 9) / 
        NULLIF(CAST(SUM(pi.ipouts) AS DECIMAL) / 3, 0), 
        2
    ) as career_era,
    ROUND(
        CAST(SUM(pi.bb) + SUM(pi.h) AS DECIMAL) / 
        NULLIF(CAST(SUM(pi.ipouts) AS DECIMAL) / 3, 0), 
        2
    ) as career_whip,
    ROUND(
        (CAST(SUM(pi.so) AS DECIMAL) * 9) / 
        NULLIF(CAST(SUM(pi.ipouts) AS DECIMAL) / 3, 0), 
        2
    ) as career_k_per_9,
    ROUND(
        (CAST(SUM(pi.bb) AS DECIMAL) * 9) / 
        NULLIF(CAST(SUM(pi.ipouts) AS DECIMAL) / 3, 0), 
        2
    ) as career_bb_per_9,
    ROUND(
        CAST(SUM(pi.so) AS DECIMAL) / 
        NULLIF(SUM(pi.bb), 0), 
        2
    ) as career_k_bb_ratio
FROM pitching pi
JOIN people p ON pi.player_id = p.player_id
WHERE pi.year_id >= 1980
GROUP BY pi.player_id, p.name_first, p.name_last
HAVING SUM(pi.ipouts) >= 1500;  

SELECT *
FROM career_pitching_1980s
ORDER BY career_era ASC
LIMIT 20;