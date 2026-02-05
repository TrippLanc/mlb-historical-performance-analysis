CREATE OR REPLACE VIEW career_batting_1980s AS
SELECT 
    b.player_id,
    p.name_first,
    p.name_last,
    MIN(b.year_id) as first_season,
    MAX(b.year_id) as last_season,
    COUNT(DISTINCT b.year_id) as seasons_played,
    SUM(b.g) as total_games,
    SUM(b.ab) as total_ab,
    SUM(b.h) as total_hits,
    SUM(b.doubles) as total_doubles,
    SUM(b.triples) as total_triples,
    SUM(b.hr) as total_hr,
    SUM(b.rbi) as total_rbi,
    SUM(b.bb) as total_bb,
    SUM(b.so) as total_so,
    SUM(b.sb) as total_sb,
    -- Career BA
    ROUND(CAST(SUM(b.h) AS DECIMAL) / NULLIF(SUM(b.ab), 0), 3) as career_ba,
    -- Career OBP
    ROUND(
        CAST(SUM(b.h) + SUM(b.bb) + SUM(COALESCE(b.hbp, 0)) AS DECIMAL) / 
        NULLIF(SUM(b.ab) + SUM(b.bb) + SUM(COALESCE(b.hbp, 0)) + SUM(COALESCE(b.sf, 0)), 0), 
        3
    ) as career_obp,
    -- Career SLG
    ROUND(
        CAST(
            SUM((b.h - b.doubles - b.triples - b.hr)) + 
            SUM(b.doubles * 2) + 
            SUM(b.triples * 3) + 
            SUM(b.hr * 4) AS DECIMAL
        ) / NULLIF(SUM(b.ab), 0), 
        3
    ) as career_slg
FROM batting b
JOIN people p ON b.player_id = p.player_id
WHERE b.year_id >= 1980
GROUP BY b.player_id, p.name_first, p.name_last
HAVING SUM(b.ab) >= 1000;

SELECT *
FROM career_batting_1980s
ORDER BY career_ba DESC
LIMIT 20;