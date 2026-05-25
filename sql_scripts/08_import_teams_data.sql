COPY teams(
    year_id,
    lg_id,
    team_id,
    franch_id,
    div_id,
    rank,
    g,
    ghome,
    w,
    l,
    div_win,
    wc_win,
    lg_win,
    ws_win,
    r,
    ab,
    h,
    doubles, -- Maps from '2B' header
    triples, -- Maps from '3B' header
    hr,
    bb,
    so,
    sb,
    cs,
    hbp,
    sf,
    ra,
    er,
    era,
    cg,
    sho,
    sv,
    ipouts,
    ha,
    hra,
    bba,
    soa,
    e,
    dp,
    fp,
    name,
    park,
    attendance,
    bpf,
    ppf,
    team_id_br,       -- Maps from 'teamIDBR'
    team_id_lahman45, -- Maps from 'teamIDlahman45'
    team_id_retro     -- Maps from 'teamIDretro'
)
FROM '/Users/tripplancaster/Desktop/Data Science Project Portfolio/Historical Performance Analysis Project/mlb-historical-performance-analysis/data/Teams.csv' 
DELIMITER ',' 
CSV HEADER;

SELECT COUNT(*) as total_team_seasons FROM teams;