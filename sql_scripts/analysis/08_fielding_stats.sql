
SELECT
    f.player_id,
    p.name_first,
    p.name_last,
    f.year_id,
    f.team_id,
    f.pos,
    f.g,
    f.gs,
    ROUND(CAST(f.inn_outs AS DECIMAL) / 3, 1)    AS innings,
    f.po,
    f.a,
    f.e,
    f.dp,

    ROUND(
        CAST(f.po + f.a AS DECIMAL) /
        NULLIF(f.po + f.a + f.e, 0),
        3
    )                                             AS fielding_pct,

    ROUND(
        CAST((f.po + f.a) AS DECIMAL) * 9 /
        NULLIF(CAST(f.inn_outs AS DECIMAL) / 3, 0),
        2
    )                                             AS range_factor,

    f.pb,
    f.sb                                          AS sb_allowed,
    f.cs                                          AS cs_by_catcher,
    CASE
        WHEN f.pos = 'C' AND (f.sb + f.cs) > 0
        THEN ROUND(
            CAST(f.cs AS DECIMAL) / (f.sb + f.cs),
            3
        )
        ELSE NULL
    END                                           AS cs_pct

FROM fielding f
JOIN people p ON f.player_id = p.player_id
WHERE f.year_id >= 1980
    AND f.g >= 20
ORDER BY f.year_id DESC, f.pos, fielding_pct DESC;



CREATE OR REPLACE VIEW career_fielding_1980s AS
SELECT
    f.player_id,
    p.name_first,
    p.name_last,
    f.pos,
    MIN(f.year_id)                                        AS first_season,
    MAX(f.year_id)                                        AS last_season,
    COUNT(DISTINCT f.year_id)                             AS seasons,
    SUM(f.g)                                              AS total_games,
    SUM(f.gs)                                             AS total_starts,
    ROUND(CAST(SUM(f.inn_outs) AS DECIMAL) / 3, 1)       AS total_innings,
    SUM(f.po)                                             AS total_po,
    SUM(f.a)                                              AS total_assists,
    SUM(f.e)                                              AS total_errors,
    SUM(f.dp)                                             AS total_dp,

    ROUND(
        CAST(SUM(f.po) + SUM(f.a) AS DECIMAL) /
        NULLIF(SUM(f.po) + SUM(f.a) + SUM(f.e), 0),
        3
    )                                                     AS career_fielding_pct,

    ROUND(
        CAST(SUM(f.po) + SUM(f.a) AS DECIMAL) * 9 /
        NULLIF(CAST(SUM(f.inn_outs) AS DECIMAL) / 3, 0),
        2
    )                                                     AS career_range_factor,

    CASE
        WHEN f.pos = 'C' AND (SUM(f.sb) + SUM(f.cs)) > 0
        THEN ROUND(
            CAST(SUM(f.cs) AS DECIMAL) / (SUM(f.sb) + SUM(f.cs)),
            3
        )
        ELSE NULL
    END                                                   AS career_cs_pct,

0    CASE WHEN f.pos = 'C' THEN SUM(f.pb) ELSE NULL END   AS total_pb

FROM fielding f
JOIN people p ON f.player_id = p.player_id
WHERE f.year_id >= 1980
GROUP BY f.player_id, p.name_first, p.name_last, f.pos
HAVING SUM(f.g) >= 200;


-- -----------------------------------------------------------------------------
-- SAMPLE QUERIES
-- -----------------------------------------------------------------------------

-- Best career fielding % by position (min 200 games)
SELECT
    pos, name_first, name_last,
    total_games, career_fielding_pct, career_range_factor,
    first_season, last_season
FROM career_fielding_1980s
ORDER BY pos, career_fielding_pct DESC;

SELECT
    pos, name_first, name_last,
    total_games, career_range_factor, career_fielding_pct
FROM career_fielding_1980s
WHERE pos NOT IN ('P', 'DH')
ORDER BY pos, career_range_factor DESC;

SELECT
    name_first, name_last,
    total_games, career_cs_pct, total_pb,
    career_fielding_pct, first_season, last_season
FROM career_fielding_1980s
WHERE pos = 'C'
    AND career_cs_pct IS NOT NULL
ORDER BY career_cs_pct DESC
LIMIT 20;

SELECT
    p.name_first, p.name_last,
    f.year_id, f.team_id, f.pos,
    f.g, f.e,
    ROUND(
        CAST(f.po + f.a AS DECIMAL) / NULLIF(f.po + f.a + f.e, 0), 3
    ) AS fielding_pct
FROM fielding f
JOIN people p ON f.player_id = p.player_id
WHERE f.year_id >= 1980
ORDER BY f.e DESC
LIMIT 20;

\SELECT
    t.year_id,
    t.name,
    t.e                                   AS team_errors,
    ROUND(t.fp, 3)                        AS team_fielding_pct,
    t.dp
FROM teams t
WHERE t.year_id >= 1980
ORDER BY t.fp DESC
LIMIT 20;