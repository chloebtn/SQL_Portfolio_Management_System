-- Standard deviation

SELECT
    user_id,
    ROUND(STDEV(daily_return), 4) as volatility
FROM daily_returns
WHERE daily_return IS NOT NULL
GROUP BY user_id
GO

-- Drawdowns

WITH running_max AS (
    SELECT
        user_id,
        trade_date,
        portfolio_value,
        MAX(portfolio_value) OVER (PARTITION BY user_id ORDER BY trade_date) as max_to_date
    FROM valuation_over_time
)
,

drawdowns AS (
    SELECT 
        user_id,
        trade_date,
        portfolio_value,
        max_to_date,
        ROUND((portfolio_value - max_to_date) / NULLIF(max_to_date, 0) * 100, 2) as drawdown_percent
    FROM running_max
)

SELECT
    user_id,
    MIN(drawdown_percent) as max_drawdown
FROM drawdowns
GROUP BY user_id
GO


-- Value at risk

SELECT
    user_id,
    var_95
FROM (
    SELECT
        user_id,
        PERCENTILE_CONT(0.05) WITHIN GROUP (ORDER BY daily_return) OVER (PARTITION BY user_id) AS var_95,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY trade_date) AS rn
    FROM daily_returns
    WHERE daily_return IS NOT NULL
) ranked
WHERE rn = 1
;


