-- Tracks portfolio value and P&L over time PER USER


WITH daily_totals AS (
SELECT 
    user_id,
    trade_date,
    SUM(portfolio_value) as total_valuation
FROM valuation_over_time
GROUP BY user_id, trade_date
)

SELECT
    user_id,
    trade_date,
    total_valuation,
    ROUND(total_valuation - LAG(total_valuation) OVER (PARTITION BY user_id ORDER BY trade_date), 2) as daily_change_value,
    ROUND((total_valuation - LAG(total_valuation) OVER (PARTITION BY user_id ORDER BY trade_date))
        / NULLIF(LAG(total_valuation) OVER (PARTITION BY user_id ORDER BY trade_date), 0) * 100, 2) as daily_change_percent,
    ROUND((total_valuation - FIRST_VALUE(total_valuation) OVER (PARTITION BY user_id ORDER BY trade_date))
        / NULLIF(FIRST_VALUE(total_valuation) OVER (PARTITION BY user_id ORDER BY trade_date), 0) * 100, 2) as cumulative_return
FROM daily_totals
ORDER BY user_id, trade_date DESC
;