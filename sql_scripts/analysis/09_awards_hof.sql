
DROP TABLE IF EXISTS awards_players CASCADE;

CREATE TABLE awards_players (
    player_id   VARCHAR(9),
    award_id    VARCHAR(75),
    year_id     INTEGER,
    lg_id       VARCHAR(10),
    tie         VARCHAR(1),
    notes       VARCHAR(100),
    FOREIGN KEY (player_id) REFERENCES people(player_id)
);

CREATE INDEX idx_awards_player ON awards_players(player_id);
CREATE INDEX idx_awards_award  ON awards_players(award_id);
CREATE INDEX idx_awards_year   ON awards_players(year_id);

COPY awards_players (player_id, award_id, year_id, lg_id, tie, notes)
FROM '/Users/tripplancaster/Desktop/Data Science Project Portfolio/Historical Performance Analysis Project/mlb-historical-performance-analysis/data/AwardsPlayers.csv'
DELIMITER ','
CSV HEADER;

SELECT COUNT(*) AS total_awards FROM awards_players;
SELECT award_id, COUNT(*) AS times_given
FROM awards_players
GROUP BY award_id
ORDER BY times_given DESC;


DROP TABLE IF EXISTS hall_of_fame CASCADE;

CREATE TABLE hall_of_fame (
    player_id   VARCHAR(9),
    year_id     INTEGER,
    voted_by    VARCHAR(64),
    ballots     INTEGER,
    needed      INTEGER,
    votes       INTEGER,
    inducted    VARCHAR(1),     -- 'Y' or 'N'
    category    VARCHAR(20),
    needed_note TEXT,    -- Expanded from 25 to 100 to prevent data truncation errors
    FOREIGN KEY (player_id) REFERENCES people(player_id)
);

CREATE INDEX idx_hof_player   ON hall_of_fame(player_id);
CREATE INDEX idx_hof_inducted ON hall_of_fame(inducted);
CREATE INDEX idx_hof_year     ON hall_of_fame(year_id);

COPY hall_of_fame (
    player_id, year_id, voted_by, ballots,
    needed, votes, inducted, category, needed_note
)
FROM '/Users/tripplancaster/Desktop/Data Science Project Portfolio/Historical Performance Analysis Project/mlb-historical-performance-analysis/data/HallOfFame.csv'
DELIMITER ','
CSV HEADER;

-- Verify
SELECT COUNT(*)                          AS total_hof_records FROM hall_of_fame;
SELECT inducted, COUNT(DISTINCT player_id) AS players
FROM hall_of_fame
GROUP BY inducted;


SELECT
    a.year_id,
    a.lg_id,
    a.award_id,
    p.name_first,
    p.name_last,
    a.notes
FROM awards_players a
JOIN people p ON a.player_id = p.player_id
WHERE a.year_id >= 1980
    AND a.award_id IN (
        'Most Valuable Player',
        'Cy Young Award',
        'Rookie of the Year',
        'Gold Glove',
        'Silver Slugger',
        'Reliever of the Year',
        'Rolaids Relief Man Award'
    )
ORDER BY a.year_id DESC, a.award_id, a.lg_id;

CREATE OR REPLACE VIEW player_award_summary AS
SELECT
    a.player_id,
    p.name_first,
    p.name_last,
    COUNT(*)                                                      AS total_awards,
    SUM(CASE WHEN a.award_id = 'Most Valuable Player'  THEN 1 ELSE 0 END) AS mvp_awards,
    SUM(CASE WHEN a.award_id = 'Cy Young Award'        THEN 1 ELSE 0 END) AS cy_young_awards,
    SUM(CASE WHEN a.award_id = 'Rookie of the Year'    THEN 1 ELSE 0 END) AS rookie_awards,
    SUM(CASE WHEN a.award_id = 'Gold Glove'            THEN 1 ELSE 0 END) AS gold_gloves,
    SUM(CASE WHEN a.award_id = 'Silver Slugger'        THEN 1 ELSE 0 END) AS silver_sluggers,
    SUM(CASE WHEN a.award_id IN (
        'Reliever of the Year', 'Rolaids Relief Man Award'
    )                                                  THEN 1 ELSE 0 END) AS reliever_awards,
    MIN(a.year_id)                                                AS first_award_year,
    MAX(a.year_id)                                                AS last_award_year
FROM awards_players a
JOIN people p ON a.player_id = p.player_id
WHERE a.year_id >= 1980
GROUP BY a.player_id, p.name_first, p.name_last;


CREATE OR REPLACE VIEW hof_inductees AS
SELECT DISTINCT
    h.player_id,
    p.name_first,
    p.name_last,
    h.year_id          AS induction_year,
    h.voted_by,
    h.votes,
    h.ballots,
    ROUND(
        CAST(h.votes AS DECIMAL) / NULLIF(h.ballots, 0) * 100, 1
    )                  AS vote_pct,
    h.category
FROM hall_of_fame h
JOIN people p ON h.player_id = p.player_id
WHERE h.inducted = 'Y'
    AND h.category = 'Player'
ORDER BY h.year_id DESC;

SELECT
    hof.name_first,
    hof.name_last,
    hof.induction_year,
    hof.voted_by,
    hof.vote_pct,
    cb.first_season,
    cb.last_season,
    cb.total_ab,
    cb.total_hits,
    cb.total_hr,
    cb.total_rbi,
    cb.career_ba,
    cb.career_obp,
    cb.career_slg,
    ROUND(cb.career_obp + cb.career_slg, 3) AS career_ops
FROM hof_inductees hof
JOIN career_batting_1980s cb ON hof.player_id = cb.player_id
ORDER BY hof.induction_year DESC;

SELECT
    hof.name_first,
    hof.name_last,
    hof.induction_year,
    hof.voted_by,
    hof.vote_pct,
    cp.first_season,
    cp.last_season,
    cp.total_wins,
    cp.total_losses,
    cp.total_strikeouts,
    cp.career_era,
    cp.career_whip,
    cp.career_k_per_9,
    cpf.career_era_plus,
    cpf.career_fip
FROM hof_inductees hof
JOIN career_pitching_1980s cp  ON hof.player_id = cp.player_id
JOIN career_pitching_era_plus_fip cpf ON hof.player_id = cpf.player_id
ORDER BY hof.induction_year DESC;


SELECT
    pa.name_first,
    pa.name_last,
    pa.total_awards,
    pa.mvp_awards,
    pa.cy_young_awards,
    pa.gold_gloves,
    pa.silver_sluggers,
    pa.rookie_awards,
    pa.first_award_year,
    pa.last_award_year,
    CASE WHEN hof.player_id IS NOT NULL THEN 'Yes' ELSE 'No' END AS in_hall_of_fame,
    hof.induction_year
FROM player_award_summary pa
LEFT JOIN hof_inductees hof ON pa.player_id = hof.player_id
ORDER BY pa.total_awards DESC
LIMIT 30;

SELECT
    a.year_id,
    a.lg_id,
    p.name_first,
    p.name_last,
    pi.w,
    pi.l,
    ROUND(CAST(pi.ipouts AS DECIMAL) / 3, 1)   AS ip,
    pi.era,
    ROUND(CAST(pi.bb + pi.h AS DECIMAL) /
        NULLIF(CAST(pi.ipouts AS DECIMAL) / 3, 0), 2) AS whip,
    ROUND((CAST(pi.so AS DECIMAL) * 9) /
        NULLIF(CAST(pi.ipouts AS DECIMAL) / 3, 0), 2) AS k_per_9,
    pi.so                                       AS strikeouts
FROM awards_players a
JOIN people p ON a.player_id = p.player_id

JOIN (
    SELECT player_id, year_id,
        SUM(w) AS w, SUM(l) AS l,
        SUM(ipouts) AS ipouts, SUM(h) AS h,
        SUM(er) AS er, SUM(bb) AS bb, SUM(so) AS so,
        ROUND((CAST(SUM(er) AS DECIMAL) * 9) /
            NULLIF(CAST(SUM(ipouts) AS DECIMAL) / 3, 0), 2) AS era
    FROM pitching
    WHERE year_id >= 1980
    GROUP BY player_id, year_id
) pi ON a.player_id = pi.player_id AND a.year_id = pi.year_id
WHERE a.award_id = 'Cy Young Award'
    AND a.year_id >= 1980
ORDER BY a.year_id DESC, a.lg_id;


SELECT
    a.year_id,
    a.lg_id,
    p.name_first,
    p.name_last,
    b.g,
    b.ab,
    b.h,
    b.hr,
    b.rbi,
    b.sb,
    ROUND(CAST(b.h AS DECIMAL) / NULLIF(b.ab, 0), 3) AS ba,
    ROUND(
        CAST(b.h + b.bb + COALESCE(b.hbp, 0) AS DECIMAL) /
        NULLIF(b.ab + b.bb + COALESCE(b.hbp, 0) + COALESCE(b.sf, 0), 0),
        3
    ) AS obp,
    ROUND(
        CAST(
            (b.h - b.doubles - b.triples - b.hr) +
            (b.doubles * 2) + (b.triples * 3) + (b.hr * 4)
        AS DECIMAL) / NULLIF(b.ab, 0),
        3
    ) AS slg
FROM awards_players a
JOIN people p ON a.player_id = p.player_id

JOIN (
    SELECT player_id, year_id,
        SUM(g) AS g, SUM(ab) AS ab, SUM(h) AS h,
        SUM(doubles) AS doubles, SUM(triples) AS triples,
        SUM(hr) AS hr, SUM(rbi) AS rbi, SUM(bb) AS bb,
        SUM(sb) AS sb,
        SUM(COALESCE(hbp, 0)) AS hbp,
        SUM(COALESCE(sf, 0)) AS sf
    FROM batting
    WHERE year_id >= 1980
    GROUP BY player_id, year_id
) b ON a.player_id = b.player_id AND a.year_id = b.year_id
WHERE a.award_id = 'Most Valuable Player'
    AND a.year_id >= 1980
ORDER BY a.year_id DESC, a.lg_id;