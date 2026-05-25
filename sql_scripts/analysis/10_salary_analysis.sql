
DROP TABLE IF EXISTS salaries CASCADE;

CREATE TABLE salaries (
    year_id     INTEGER,
    team_id     VARCHAR(3),
    lg_id       VARCHAR(10),
    player_id   VARCHAR(9),
    salary      INTEGER,
    PRIMARY KEY (year_id, team_id, player_id),
    FOREIGN KEY (player_id) REFERENCES people(player_id)
);

CREATE INDEX idx_salaries_player ON salaries(player_id);
CREATE INDEX idx_salaries_year   ON salaries(year_id);
CREATE INDEX idx_salaries_team   ON salaries(team_id);

COPY salaries (year_id, team_id, lg_id, player_id, salary)
FROM '/Users/tripplancaster/Desktop/Data Science Project Portfolio/Historical Performance Analysis Project/mlb-historical-performance-analysis/data/Salaries.csv'
DELIMITER ','
CSV HEADER;

SELECT COUNT(*)           AS total_salary_records FROM salaries;
SELECT MIN(year_id), MAX(year_id) FROM salaries;


SELECT
    year_id,
    COUNT(DISTINCT player_id)                         AS players_with_salary,
    COUNT(DISTINCT team_id)                           AS teams,
    SUM(salary)                                       AS total_payroll,
    ROUND(AVG(salary), 0)                             AS avg_salary,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) AS median_salary,
    MIN(salary)                                       AS min_salary,
    MAX(salary)                                       AS max_salary
FROM salaries
GROUP BY year_id
ORDER BY year_id;



SELECT
    s.year_id,
    t.name,
    s.lg_id,
    COUNT(DISTINCT s.player_id)                       AS roster_size,
    SUM(s.salary)                                     AS total_payroll,
    ROUND(AVG(s.salary), 0)                           AS avg_player_salary,
    MAX(s.salary)                                     AS highest_salary,
    t.w,
    t.l,
    ROUND(CAST(t.w AS DECIMAL) / NULLIF(t.w + t.l, 0), 3) AS win_pct,
    t.ws_win
FROM salaries s
JOIN teams t ON s.year_id = t.year_id AND s.team_id = t.team_id
GROUP BY s.year_id, t.name, s.lg_id, t.w, t.l, t.ws_win
ORDER BY s.year_id DESC, total_payroll DESC;


SELECT
    s.year_id,
    t.name,
    SUM(s.salary)                                          AS total_payroll,
    t.w                                                    AS wins,
    ROUND(CAST(t.w AS DECIMAL) / NULLIF(t.w + t.l, 0), 3) AS win_pct,
    t.ws_win,
    t.lg_win,
    t.div_win,
    RANK() OVER (
        PARTITION BY s.year_id
        ORDER BY SUM(s.salary) DESC
    )                                                      AS payroll_rank
FROM salaries s
JOIN teams t ON s.year_id = t.year_id AND s.team_id = t.team_id
GROUP BY s.year_id, t.name, t.w, t.l, t.ws_win, t.lg_win, t.div_win
ORDER BY s.year_id DESC, total_payroll DESC;


SELECT
    s.year_id,
    p.name_first,
    p.name_last,
    t.name                                            AS team,
    s.lg_id,
    s.salary,
    ROUND(
        CAST(s.salary AS DECIMAL) /
        NULLIF(avg_by_year.avg_salary, 0),
        2
    )                                                 AS salary_vs_league_avg
FROM salaries s
JOIN people p ON s.player_id = p.player_id
JOIN teams t  ON s.year_id = t.year_id AND s.team_id = t.team_id
JOIN (
    SELECT year_id, ROUND(AVG(salary), 0) AS avg_salary
    FROM salaries
    GROUP BY year_id
) avg_by_year ON s.year_id = avg_by_year.year_id
ORDER BY s.salary DESC
LIMIT 30;


CREATE OR REPLACE VIEW career_earnings AS
SELECT
    s.player_id,
    p.name_first,
    p.name_last,
    MIN(s.year_id)                                    AS first_paid_season,
    MAX(s.year_id)                                    AS last_paid_season,
    COUNT(DISTINCT s.year_id)                         AS paid_seasons,
    SUM(s.salary)                                     AS career_earnings,
    ROUND(AVG(s.salary), 0)                           AS avg_annual_salary,
    MAX(s.salary)                                     AS peak_salary,
    MIN(s.salary)                                     AS rookie_salary
FROM salaries s
JOIN people p ON s.player_id = p.player_id
GROUP BY s.player_id, p.name_first, p.name_last;

SELECT *
FROM career_earnings
ORDER BY career_earnings DESC
LIMIT 30;


SELECT
    cb.name_first,
    cb.name_last,
    cb.first_season,
    cb.last_season,
    cb.total_ab,
    cb.total_hr,
    cb.total_rbi,
    cb.career_ba,
    cb.career_obp,
    cb.career_slg,
    ROUND(cb.career_obp + cb.career_slg, 3)           AS career_ops,
    ce.career_earnings,
    ce.avg_annual_salary,
    ROUND(
        (cb.career_obp + cb.career_slg) /
        NULLIF(ce.avg_annual_salary / 1000000.0, 0),
        4
    )                                                 AS ops_per_million
FROM career_batting_1980s cb
JOIN career_earnings ce ON cb.player_id = ce.player_id
WHERE cb.total_ab >= 2000
    AND ce.career_earnings > 0
ORDER BY ops_per_million DESC
LIMIT 30;


SELECT
    cpf.name_first,
    cpf.name_last,
    cpf.first_season,
    cpf.last_season,
    cpf.career_ip,
    cpf.total_wins,
    cpf.career_era,
    cpf.career_era_plus,
    cpf.career_fip,
    cpf.career_k_per_9,
    ce.career_earnings,
    ce.avg_annual_salary,
    ROUND(
        cpf.career_era_plus /
        NULLIF(ce.avg_annual_salary / 1000000.0, 0),
        2
    )                                                 AS era_plus_per_million
FROM career_pitching_era_plus_fip cpf
JOIN career_pitching_1980s cp  ON cpf.player_id = cp.player_id
JOIN career_earnings ce        ON cpf.player_id = ce.player_id
WHERE cpf.career_ip >= 500
    AND ce.career_earnings > 0
ORDER BY era_plus_per_million DESC
LIMIT 30;



SELECT
    s.year_id,
    t.name,
    SUM(s.salary)                                          AS total_payroll,
    t.w                                                    AS wins,
    ROUND(CAST(t.w AS DECIMAL) / NULLIF(t.w + t.l, 0), 3) AS win_pct,
    t.ws_win,
    ROUND(
        SUM(s.salary) / NULLIF(t.w, 0),
        0
    )                                                      AS cost_per_win,
    RANK() OVER (
        PARTITION BY s.year_id
        ORDER BY SUM(s.salary) ASC
    )                                                      AS payroll_rank_low_to_high
FROM salaries s
JOIN teams t ON s.year_id = t.year_id AND s.team_id = t.team_id
GROUP BY s.year_id, t.name, t.w, t.l, t.ws_win
ORDER BY cost_per_win ASC
LIMIT 30;