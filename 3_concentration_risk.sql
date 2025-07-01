-- Identifies stocks exceeding 10% of portfolio value to highlight diversification issues

SELECT 
    p.user_id,
    c.stock_name,
    ROUND((SUM(p.quantity * c.stock_price) / user_totals.total_value) * 100, 2) AS portfolio_percentage
FROM portfolio p
JOIN company c ON p.stock_id = c.stock_id
JOIN (
    SELECT 
        user_id, 
        SUM(p2.quantity * c2.stock_price) AS total_value
    FROM portfolio p2
    JOIN company c2 ON p2.stock_id = c2.stock_id
    GROUP BY user_id
) AS user_totals ON p.user_id = user_totals.user_id
GROUP BY p.user_id, c.stock_name, user_totals.total_value
HAVING ROUND((SUM(p.quantity * c.stock_price) / user_totals.total_value) * 100, 2) > 10
;
