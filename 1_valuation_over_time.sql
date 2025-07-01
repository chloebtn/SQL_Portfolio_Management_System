WITH daily_totals AS (
SELECT 
    trade_date,
    SUM(portfolio_value) as total_valuation
FROM valuation_over_time
GROUP BY trade_date
)

SELECT
    trade_date,
    total_valuation,
    ROUND(total_valuation - LAG(total_valuation) OVER (ORDER BY trade_date), 2) as total_daily_change_value,
    ROUND((total_valuation - LAG(total_valuation) OVER (ORDER BY trade_date))
        / NULLIF(LAG(total_valuation) OVER (ORDER BY trade_date), 0) * 100, 2) as total_daily_change_percent,
    ROUND((total_valuation - FIRST_VALUE(total_valuation) OVER (ORDER BY trade_date))
        / NULLIF(FIRST_VALUE(total_valuation) OVER (ORDER BY trade_date), 0) * 100, 2) as cumulative_return
FROM daily_totals
ORDER BY trade_date DESC
;