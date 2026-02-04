DROP TABLE IF EXISTS batting CASCADE;

CREATE TABLE batting (
    player_id VARCHAR(9),
    year_id INTEGER,
    stint INTEGER,
    team_id VARCHAR(3),
    lg_id VARCHAR(10),
    g INTEGER,
    ab INTEGER,
    r INTEGER,
    h INTEGER,
    doubles INTEGER,  -- "2B" renamed to doubles
    triples INTEGER,  -- "3B" renamed to triples
    hr INTEGER,
    rbi INTEGER,
    sb INTEGER,
    cs INTEGER,
    bb INTEGER,
    so INTEGER,
    ibb INTEGER,
    hbp INTEGER,
    sh INTEGER,
    sf INTEGER,
    gidp INTEGER,
    PRIMARY KEY (player_id, year_id, stint),
    FOREIGN KEY (player_id) REFERENCES people(player_id)
);

-- Create indexes for common queries
CREATE INDEX idx_batting_player ON batting(player_id);
CREATE INDEX idx_batting_year ON batting(year_id);
CREATE INDEX idx_batting_team ON batting(team_id);