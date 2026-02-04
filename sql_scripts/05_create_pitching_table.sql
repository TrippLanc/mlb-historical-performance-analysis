DROP TABLE IF EXISTS pitching CASCADE;

CREATE TABLE pitching (
    player_id VARCHAR(9),
    year_id INTEGER,
    stint INTEGER,
    team_id VARCHAR(3),
    lg_id VARCHAR(10),
    w INTEGER,
    l INTEGER,
    g INTEGER,
    gs INTEGER,
    cg INTEGER,
    sho INTEGER,
    sv INTEGER,
    ipouts INTEGER,
    h INTEGER,
    er INTEGER,
    hr INTEGER,
    bb INTEGER,
    so INTEGER,
    baopp DECIMAL(5, 3),
    era DECIMAL(5, 2),
    ibb INTEGER,
    wp INTEGER,
    hbp INTEGER,
    bk INTEGER,
    bfp INTEGER,
    gf INTEGER,
    r INTEGER,
    sh INTEGER,
    sf INTEGER,
    gidp INTEGER,
    PRIMARY KEY (player_id, year_id, stint),
    FOREIGN KEY (player_id) REFERENCES people(player_id)
);

CREATE INDEX idx_pitching_player ON pitching(player_id);
CREATE INDEX idx_pitching_year ON pitching(year_id);
CREATE INDEX idx_pitching_team ON pitching(team_id);
CREATE INDEX idx_pitching_era ON pitching(era);