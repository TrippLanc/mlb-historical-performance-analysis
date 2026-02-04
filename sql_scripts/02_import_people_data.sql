
COPY people(
    id,
    player_id,
    birth_year,
    birth_month,
    birth_day,
    birth_country,
    birth_state,
    birth_city,
    death_year,
    death_month,
    death_day,
    death_country,
    death_state,
    death_city,
    name_first,
    name_last,
    name_given,
    weight,
    height,
    bats,
    throws,
    debut,
    final_game,
    retro_id,
    bbref_id
)

FROM '/Users/tripplancaster/Desktop/Data Science Project Portfolio/Historical Performance Analysis Project/mlb-historical-performance-analysis/data/People.csv' 
DELIMITER ',' 
CSV HEADER;

SELECT COUNT(*) as total_players FROM people;

SELECT player_id, name_first, name_last, debut, final_game
FROM people
LIMIT 10;