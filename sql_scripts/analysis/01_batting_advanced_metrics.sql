SELECT 
    b.player_id,
    p.name_first,
    p.name_last,
    b.year_id,
    b.team_id,
    b.ab,
    b.h,
    b.doubles,
    b.triples,
    b.hr,
    b.bb,
    b.hbp,
    b.sf,
    ROUND(CAST(b.h AS DECIMAL) / NULLIF(b.ab, 0), 3) as ba,
    ROUND(
        CAST(b.h + b.bb + COALESCE(b.hbp, 0) AS DECIMAL) / 
        NULLIF(b.ab + b.bb + COALESCE(b.hbp, 0) + COALESCE(b.sf, 0), 0), 
        3
    ) as obp,
    ROUND(
        CAST((b.h - b.doubles - b.triples - b.hr) + (b.doubles * 2) + (b.triples * 3) + (b.hr * 4) AS DECIMAL) / 
        NULLIF(b.ab, 0), 
        3
    ) as slg,
    ROUND(
        (CAST(b.h + b.bb + COALESCE(b.hbp, 0) AS DECIMAL) / 
        NULLIF(b.ab + b.bb + COALESCE(b.hbp, 0) + COALESCE(b.sf, 0), 0)) +
        (CAST((b.h - b.doubles - b.triples - b.hr) + (b.doubles * 2) + (b.triples * 3) + (b.hr * 4) AS DECIMAL) / 
        NULLIF(b.ab, 0)),
        3
    ) as ops
FROM batting b
JOIN people p ON b.player_id = p.player_id
WHERE b.year_id >= 1980 
    AND b.ab >= 100
ORDER BY b.year_id DESC, ops DESC;