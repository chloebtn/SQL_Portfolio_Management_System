-- Separates locked-in profits from paper gains

WITH transactions_agg AS (
    SELECT
        user_id,
        stock_id,
        SUM(CASE WHEN transaction_type = 'BUY' THEN quantity ELSE 0 END) AS total_bought,
        SUM(CASE WHEN transaction_type = 'SELL' THEN quantity ELSE 0 END) AS total_sold,
        SUM(CASE WHEN transaction_type = 'BUY' THEN quantity * price ELSE 0 END) AS total_cost_buys,
        SUM(CASE WHEN transaction_type = 'SELL' THEN quantity * price ELSE 0 END) AS total_proceeds_sells
    FROM transaction_history
    GROUP BY user_id, stock_id
)

SELECT
    p.user_id,
    p.stock_id,
    ta.total_cost_buys,
    ta.total_proceeds_sells,
    (ta.total_proceeds_sells - (ta.total_cost_buys / NULLIF(ta.total_bought, 0) * ta.total_sold)) AS realized_gain,
    (p.quantity * c.stock_price - ((ta.total_cost_buys / NULLIF(ta.total_bought, 0)) * p.quantity)) AS unrealized_gain
FROM portfolio p
JOIN company c ON p.stock_id = c.stock_id
LEFT JOIN transactions_agg ta ON p.user_id = ta.user_id AND p.stock_id = ta.stock_id
;
