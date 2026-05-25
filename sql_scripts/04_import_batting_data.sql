COPY batting(
    player_id,
    year_id,
    stint,
    team_id,
    lg_id,
    g,
    ab,
    r,
    h,
    doubles,  -- Maps from '2B' header
    triples,  -- Maps from '3B' header
    hr,
    rbi,
    sb,
    cs,
    bb,
    so,
    ibb,
    hbp,
    sh,
    sf,
    gidp
)
FROM '/Users/tripplancaster/Desktop/Data Science Project Portfolio/Historical Performance Analysis Project/mlb-historical-performance-analysis/data/Batting.csv' 
DELIMITER ',' 
CSV HEADER;

SELECT COUNT(*) as total_batting_records FROM batting;