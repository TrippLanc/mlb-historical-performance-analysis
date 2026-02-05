SELECT 
    pi.player_id,
    p.name_first,
    p.name_last,
    pi.year_id,
    pi.team_id,
    pi.w,
    pi.l,
    pi.g,
    pi.gs,
    pi.ipouts,
    ROUND(CAST(pi.ipouts AS DECIMAL) / 3, 1) as ip,
    pi.h,
    pi.er,
    pi.hr,
    pi.bb,
    pi.so,
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
    ) as bb_per_9,
    ROUND(
        CAST(pi.so AS DECIMAL) / 
        NULLIF(pi.bb, 0), 
        2
    ) as k_bb_ratio,
    ROUND(
        (CAST(pi.hr AS DECIMAL) * 9) / 
        NULLIF(CAST(pi.ipouts AS DECIMAL) / 3, 0), 
        2
    ) as hr_per_9
FROM pitching pi
JOIN people p ON pi.player_id = p.player_id
WHERE pi.year_id >= 1980 
    AND pi.ipouts >= 150  
ORDER BY pi.year_id DESC, whip ASC;