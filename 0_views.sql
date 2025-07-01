
CREATE OR ALTER VIEW valuation_over_time AS
SELECT p.user_id,
        sph.trade_date,
        SUM(p.quantity * sph.close_price) as portfolio_value,
        ROUND(SUM(p.quantity * sph.close_price) - LAG(SUM(p.quantity * sph.close_price)) OVER (PARTITION BY p.user_id ORDER BY sph.trade_date), 2) as daily_change
    FROM portfolio as p
    JOIN stock_price_history as sph ON p.stock_id = sph.stock_id
    GROUP BY p.user_id, sph.trade_date
GO




CREATE OR ALTER VIEW daily_returns AS 
    SELECT
        trade_date,
        user_id,
        ROUND((portfolio_value - LAG(portfolio_value) OVER (PARTITION BY user_id ORDER BY trade_date))
        / NULLIF(LAG(portfolio_value) OVER (PARTITION BY user_id ORDER BY trade_date), 0), 2) as daily_return
    FROM valuation_over_time
GO
