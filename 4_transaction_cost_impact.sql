-- Quantifies how trading commissions impact overall returns

SELECT
    user_id,
    SUM(commission) as total_commissions,
    ROUND(SUM(commission) / SUM(ABS(quantity * price)) *100, 6) as cost_percentage
FROM transaction_history
GROUP BY user_id
ORDER BY user_id
;


