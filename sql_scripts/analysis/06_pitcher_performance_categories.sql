SELECT 
    CASE 
        WHEN gs >= g * 0.5 THEN 'Starter'
        ELSE 'Reliever'
    END as pitcher_type,
    COUNT(DISTINCT player_id) as num_pitchers,
    ROUND(AVG(era), 2) as avg_era,
    ROUND(AVG(whip), 2) as avg_whip,
    ROUND(AVG(k_per_9), 2) as avg_k_per_9,
    ROUND(AVG(bb_per_9), 2) as avg_bb_per_9
FROM (
    SELECT 
        pi.player_id,
        pi.year_id,
        pi.g,
        pi.gs,
        pi.era,
        ROUND(
            CAST(pi.bb + pi.h AS DECIMAL) / 
            NULLIF(CAST(pi.ipouts AS DECIMAL) / 3, 0), 
            2
        ) as whip,
        ROUND(
            (CAST(pi.so AS DECIMAL) * 9) / 
            NULLIF(CAST(pi.ipouts AS DECIMAL) / 3, 0), 
            2
        ) as k_per_9,
        ROUND(
            (CAST(pi.bb AS DECIMAL) * 9) / 
            NULLIF(CAST(pi.ipouts AS DECIMAL) / 3, 0), 
            2
        ) as bb_per_9
    FROM pitching pi
    WHERE pi.year_id >= 1980 
        AND pi.ipouts >= 150
        AND pi.era IS NOT NULL
) pitcher_stats
GROUP BY pitcher_type;

SELECT 
    name_first,
    name_last,
    career_era,
    career_whip,
    career_k_per_9,
    total_wins,
    total_strikeouts,
    first_season,
    last_season
FROM career_pitching_1980s
ORDER BY career_era ASC
LIMIT 20;

SELECT 
    name_first,
    name_last,
    career_k_per_9,
    career_era,
    career_whip,
    total_strikeouts,
    total_wins
FROM career_pitching_1980s
ORDER BY career_k_per_9 DESC
LIMIT 20;