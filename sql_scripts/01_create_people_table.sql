DROP TABLE IF EXISTS people CASCADE;

CREATE TABLE people (
    id INTEGER,
    player_id VARCHAR(9) PRIMARY KEY,
    birth_year INTEGER,
    birth_month INTEGER,
    birth_day INTEGER,
    birth_country VARCHAR(50),
    birth_state VARCHAR(50),
    birth_city VARCHAR(50),
    death_year INTEGER,
    death_month INTEGER,
    death_day INTEGER,
    death_country VARCHAR(50),
    death_state VARCHAR(50),
    death_city VARCHAR(50),
    name_first VARCHAR(50),
    name_last VARCHAR(50),
    name_given VARCHAR(100),
    weight INTEGER,
    height INTEGER,
    bats VARCHAR(1),
    throws VARCHAR(1),
    debut DATE,
    final_game DATE,
    retro_id VARCHAR(9),
    bbref_id VARCHAR(9)
);

CREATE INDEX idx_people_name_last ON people(name_last, name_first);
