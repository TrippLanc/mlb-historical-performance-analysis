SELECT
    year_id,
    name,
    w,
    l,
    ROUND(CAST(w AS DECIMAL) / NULLIF(w + l, 0), 3) as win_pct,
    r as runs_scored,
    ra as runs_allowed,
    (r - ra) as run_differential,
    ws_win,
    lg_win,
    div_win
FROM teams
WHERE year_id >= 1980
ORDER BY year_id DESC, win_pct DESC;

SELECT
    name,
    COUNT(*) as season,
    SUM(w) as total_wins,
    SUM(l) as total_losses,
    ROUND(CAST(SUM(w) AS DECIMAL) / NULLIF(SUM(w) + SUM(l), 0), 3) as overall_win_pct,
    SUM(CASE WHEN ws_win = 'Y' THEN 1 ELSE 0 END) as world_series_titles,
    SUM(CASE WHEN lg_win = 'Y' THEN 1 ELSE 0 END) as pennants,
    SUM(CASE WHEN div_win = 'Y' THEN 1 ELSE 0 END) as division_titles
FROM teams
WHERE year_id >= 1980
GROUP BY name
ORDER BY total_wins DESC
LIMIT 20;