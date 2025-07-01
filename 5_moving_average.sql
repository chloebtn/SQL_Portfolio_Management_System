-- Generates trading signals based on 10-day/30-day moving average crossovers

WITH moving_averages as (
    SELECT
        stock_id,
        trade_date,
        close_price,
        AVG(close_price) OVER (PARTITION BY stock_id ORDER BY trade_date ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) as mav_10,
        AVG(close_price) OVER (PARTITION BY stock_id ORDER BY trade_date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) as mav_30
    FROM stock_price_history
)

SELECT 
    stock_id,
    trade_date,
    close_price,
    CASE
        WHEN mav_10 > mav_30 
            AND LAG(mav_10) OVER (PARTITION BY stock_id ORDER BY trade_date) <= LAG(mav_30) OVER (PARTITION BY stock_id ORDER BY trade_date)
            THEN 'BUY'
        WHEN mav_10 < mav_30 
            AND LAG(mav_10) OVER (PARTITION BY stock_id ORDER BY trade_date) >= LAG(mav_30) OVER (PARTITION BY stock_id ORDER BY trade_date)
            THEN 'SELL'
        ELSE 'HOLD'
    END AS signal
FROM moving_averages
;