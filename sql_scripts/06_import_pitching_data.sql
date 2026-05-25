COPY pitching(
    player_id,
    year_id,
    stint,
    team_id,
    lg_id,
    w,
    l,
    g,
    gs,
    cg,
    sho,
    sv,
    ipouts, -- Maps from 'IPouts' header
    h,
    er,
    hr,
    bb,
    so,
    baopp,  -- Maps from 'BAOpp' header
    era,
    ibb,
    wp,
    hbp,
    bk,
    bfp,
    gf,
    r,
    sh,
    sf,
    gidp
)
FROM '/Users/tripplancaster/Desktop/Data Science Project Portfolio/Historical Performance Analysis Project/mlb-historical-performance-analysis/data/Pitching.csv' 
DELIMITER ',' 
CSV HEADER;

-- Verification queries remain below
SELECT COUNT(*) as total_pitching_records FROM pitching;