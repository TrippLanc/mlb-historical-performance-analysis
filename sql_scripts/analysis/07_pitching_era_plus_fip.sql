
CREATE OR REPLACE VIEW league_pitching_averages AS
SELECT
    year_id,
    lg_id,
    ROUND(CAST(SUM(ipouts) AS DECIMAL) / 3, 1)          AS lg_ip,
    SUM(er)                                               AS lg_er,
    SUM(hra)                                              AS lg_hr,  
    SUM(bba)                                              AS lg_bb,  
    SUM(soa)                                              AS lg_so,  
    ROUND(
        (CAST(SUM(er) AS DECIMAL) * 9) /
        NULLIF(CAST(SUM(ipouts) AS DECIMAL) / 3, 0),
        2
    )                                                     AS lg_era,
    ROUND(AVG(bpf), 1)                                   AS avg_park_factor
FROM teams
WHERE year_id >= 1980
GROUP BY year_id, lg_id;


CREATE OR REPLACE VIEW fip_constants AS
SELECT
    year_id,
    lg_id,
    lg_era,
    lg_ip,
    ROUND(
        lg_era -
        (
            (13.0 * lg_hr + 3.0 * lg_bb - 2.0 * lg_so) /
            NULLIF(lg_ip, 0)
        ),
        2
    ) AS fip_constant
FROM league_pitching_averages;

SELECT
    pi.player_id,
    p.name_first,
    p.name_last,
    pi.year_id,
    pi.team_id,
    pi.lg_id,
    pi.w,
    pi.l,
    pi.g,
    pi.gs,
    pi.sv,
    ROUND(CAST(pi.ipouts AS DECIMAL) / 3, 1)             AS ip,
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
    )                                                     AS whip,


    ROUND(
        100.0 * (
            lpa.lg_era * (100.0 / NULLIF(lpa.avg_park_factor, 0))
        ) / NULLIF(pi.era, 0),
        0
    )                                                     AS era_plus,

    ROUND(
        (
            (13.0 * pi.hr) +
            (3.0  * pi.bb) -
            (2.0  * pi.so)
        ) /
        NULLIF(CAST(pi.ipouts AS DECIMAL) / 3, 0)
        + fc.fip_constant,
        2
    )                                                     AS fip,

    ROUND(
        100.0 *
        (
            (13.0 * pi.hr + 3.0 * pi.bb - 2.0 * pi.so) /
            NULLIF(CAST(pi.ipouts AS DECIMAL) / 3, 0)
            + fc.fip_constant
        ) / NULLIF(lpa.lg_era, 0),
        0
    )                                                     AS fip_minus,

    ROUND(
        (CAST(pi.so AS DECIMAL) * 9) /
        NULLIF(CAST(pi.ipouts AS DECIMAL) / 3, 0),
        2
    )                                                     AS k_per_9,

    ROUND(
        (CAST(pi.bb AS DECIMAL) * 9) /
        NULLIF(CAST(pi.ipouts AS DECIMAL) / 3, 0),
        2
    )                                                     AS bb_per_9,

    ROUND(
        (CAST(pi.hr AS DECIMAL) * 9) /
        NULLIF(CAST(pi.ipouts AS DECIMAL) / 3, 0),
        2
    )                                                     AS hr_per_9,

    ROUND(
        CAST(pi.so AS DECIMAL) / NULLIF(pi.bb, 0),
        2
    )                                                     AS k_bb_ratio,

    ROUND(
        (CAST(pi.h AS DECIMAL) * 9) /
        NULLIF(CAST(pi.ipouts AS DECIMAL) / 3, 0),
        2
    )                                                     AS h_per_9,

    lpa.lg_era,
    fc.fip_constant

FROM pitching pi
JOIN people p
    ON pi.player_id = p.player_id
JOIN league_pitching_averages lpa
    ON pi.year_id = lpa.year_id
    AND pi.lg_id  = lpa.lg_id
JOIN fip_constants fc
    ON pi.year_id = fc.year_id
    AND pi.lg_id  = fc.lg_id
WHERE pi.year_id >= 1980
    AND pi.ipouts >= 150        
    AND pi.era    IS NOT NULL
ORDER BY pi.year_id DESC, era_plus DESC;

CREATE OR REPLACE VIEW career_pitching_era_plus_fip AS
WITH season_metrics AS (
    SELECT
        pi.player_id,
        pi.year_id,
        pi.lg_id,
        pi.ipouts,
        pi.er,
        pi.hr,
        pi.bb,
        pi.so,
        pi.era,
        lpa.lg_era,
        lpa.avg_park_factor,
        fc.fip_constant
    FROM pitching pi
    JOIN league_pitching_averages lpa
        ON pi.year_id = lpa.year_id
        AND pi.lg_id  = lpa.lg_id
    JOIN fip_constants fc
        ON pi.year_id = fc.year_id
        AND pi.lg_id  = fc.lg_id
    WHERE pi.year_id >= 1980
        AND pi.ipouts  > 0
        AND pi.era    IS NOT NULL
)
SELECT
    sm.player_id,
    p.name_first,
    p.name_last,
    MIN(sm.year_id)                                           AS first_season,
    MAX(sm.year_id)                                           AS last_season,
    COUNT(DISTINCT sm.year_id)                                AS seasons,
    ROUND(CAST(SUM(sm.ipouts) AS DECIMAL) / 3, 1)            AS career_ip,
    SUM(sm.er)                                                AS career_er,
    SUM(sm.hr)                                                AS career_hr_allowed,
    SUM(sm.bb)                                                AS career_bb,
    SUM(sm.so)                                                AS career_so,

    ROUND(
        (CAST(SUM(sm.er) AS DECIMAL) * 9) /
        NULLIF(CAST(SUM(sm.ipouts) AS DECIMAL) / 3, 0),
        2
    )                                                         AS career_era,

    
    ROUND(
        100.0 *
        (
            SUM(sm.lg_era * sm.ipouts) / NULLIF(SUM(sm.ipouts), 0)
            * (100.0 / NULLIF(AVG(sm.avg_park_factor), 0))
        ) /
        NULLIF(
            (CAST(SUM(sm.er) AS DECIMAL) * 9) /
            NULLIF(CAST(SUM(sm.ipouts) AS DECIMAL) / 3, 0),
            0
        ),
        0
    )                                                         AS career_era_plus,

    ROUND(
        (
            13.0 * SUM(sm.hr) +
            3.0  * SUM(sm.bb) -
            2.0  * SUM(sm.so)
        ) /
        NULLIF(CAST(SUM(sm.ipouts) AS DECIMAL) / 3, 0)
        + AVG(sm.fip_constant),
        2
    )                                                         AS career_fip,

    ROUND(
        (CAST(SUM(sm.so) AS DECIMAL) * 9) /
        NULLIF(CAST(SUM(sm.ipouts) AS DECIMAL) / 3, 0),
        2
    )                                                         AS career_k_per_9,

    ROUND(
        (CAST(SUM(sm.bb) AS DECIMAL) * 9) /
        NULLIF(CAST(SUM(sm.ipouts) AS DECIMAL) / 3, 0),
        2
    )                                                         AS career_bb_per_9,

    ROUND(
        (CAST(SUM(sm.hr) AS DECIMAL) * 9) /
        NULLIF(CAST(SUM(sm.ipouts) AS DECIMAL) / 3, 0),
        2
    )                                                         AS career_hr_per_9,

    ROUND(
        CAST(SUM(sm.so) AS DECIMAL) / NULLIF(SUM(sm.bb), 0),
        2
    )                                                         AS career_k_bb_ratio

FROM season_metrics sm
JOIN people p ON sm.player_id = p.player_id
GROUP BY sm.player_id, p.name_first, p.name_last
HAVING ROUND(CAST(SUM(sm.ipouts) AS DECIMAL) / 3, 1) >= 500;


-- -----------------------------------------------------------------------------
-- SAMPLE QUERIES
-- -----------------------------------------------------------------------------

-- Top 20 single seasons by ERA+ (min 150 ipouts ~50 IP)
SELECT
    name_first, name_last, year_id, team_id,
    ip, era, era_plus, fip, whip, k_per_9
FROM (
    SELECT
        p.name_first, p.name_last, pi.year_id, pi.team_id,
        ROUND(CAST(pi.ipouts AS DECIMAL) / 3, 1) AS ip,
        pi.era,
        ROUND(
            100.0 * (lpa.lg_era * (100.0 / NULLIF(lpa.avg_park_factor, 0)))
            / NULLIF(pi.era, 0), 0
        ) AS era_plus,
        ROUND(
            (13.0 * pi.hr + 3.0 * pi.bb - 2.0 * pi.so) /
            NULLIF(CAST(pi.ipouts AS DECIMAL) / 3, 0)
            + fc.fip_constant, 2
        ) AS fip,
        ROUND(CAST(pi.bb + pi.h AS DECIMAL) / NULLIF(CAST(pi.ipouts AS DECIMAL) / 3, 0), 2) AS whip,
        ROUND((CAST(pi.so AS DECIMAL) * 9) / NULLIF(CAST(pi.ipouts AS DECIMAL) / 3, 0), 2) AS k_per_9
    FROM pitching pi
    JOIN people p ON pi.player_id = p.player_id
    JOIN league_pitching_averages lpa ON pi.year_id = lpa.year_id AND pi.lg_id = lpa.lg_id
    JOIN fip_constants fc ON pi.year_id = fc.year_id AND pi.lg_id = fc.lg_id
    WHERE pi.year_id >= 1980 AND pi.ipouts >= 150 AND pi.era IS NOT NULL AND pi.era > 0
) sub
ORDER BY era_plus DESC
LIMIT 20;

-- Top 20 career ERA+ (min 500 IP)
SELECT
    name_first, name_last, first_season, last_season,
    career_ip, career_era, career_era_plus, career_fip,
    career_k_per_9, career_bb_per_9, career_k_bb_ratio
FROM career_pitching_era_plus_fip
ORDER BY career_era_plus DESC
LIMIT 20;

SELECT
    name_first, name_last, first_season, last_season,
    career_ip, career_era, career_fip,
    ROUND(career_era - career_fip, 2) AS era_minus_fip,
    career_era_plus
FROM career_pitching_era_plus_fip
WHERE career_ip >= 1000
ORDER BY era_minus_fip ASC   
LIMIT 20;