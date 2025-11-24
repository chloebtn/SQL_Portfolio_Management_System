## Portfolio Management System
This project documents a stock portfolio management system built using SQL queries with fictional data.\
The project demonstrates my ability to manage client databases, investment data, calculate key financial metrics, and generate actionable insights for portfolio analysis and risk management.


#### Project Objectives:
Track portfolio value and daily changes\
Analyze daily returns and volatility\
Identify diversification issues\
Quantify the impact of trading commissions\
Generate trading signals based on moving averages\
Separate realized and unrealized gains\

[0_database.sql](0_database.sql) contains the query used to create the database Portfolio_Management.\
Each table is then created individualy, that includes tables: user_details, phone_numbers, company, watchlist, portfolio, transaction_history, stock_price_history.\
Data is then uploaded from csv files that can be found in the directory named raw_data.\

<img width="1582" height="1157" alt="image" src="https://github.com/user-attachments/assets/0e39e11f-bc4f-420e-b030-66e6f88dd38b" />

In [0_views.sql](0_views.sql) two views, valuation_over_time and daily_returns, are set up for future use joining tables together and performing calculations which will be needed later, like portfolio_value, daily_change or daily returns.

[1_valuation_over_time.sql](1_valuation_over_time.sql) tracks portfolios value and profit and loss over time. The query starts with a Common Table Expression (CTE) for total daily valuation for all portfolios combined. Where then added columns for total daily changes in values and in percentages, and cumulative returns.

[1_valuation_per_user.sql](1_valuation_per_user.sql) adds the "per user" dimension thanks to "PARTITION BY user_id" on the total daily valuation.

[2_risk_metrics.sql](2_risk_metrics.sql) uses simple queries to calculate standard deviations, drawdowns (using CTEs to first calculate running maximums), and value at risk 95 (using a subquery). For value at risk, row number where added to select only one row per user with "WHERE rn = 1" and avoid duplicates in the output.

[3_concentration_risk.sql](3_concentration_risk.sql) identifies stocks exceeding 10% of portfolio value to highlight diversification issues. Two tables were joined together, portfolio and company (to get each stock_id's name), and a join had to be performed on a new table created out of joining the same two original tables to divide by the total values of each portfolio. Note: I could have used a view created earlier or a CTE, but the goal here was to demonstrate different querying techniques.

[4_transaction_cost_impact.sql](4_transaction_cost_impact.sql) quatifies how trading commissions impact overall returns with simple quering techniques.

[5_moving_average.sql](5_moving_average.sql) generates trading signals based on 10-day/30-day moving average crossovers using a CTE to calculate the moving averages, and then used it in a CASE statement to generate 'BUY', 'SELL' and 'HOLD' orders.

[6_gains.sql](6_gains.sql) uses a CTE, the transaction types and a CASE statement to calculate separetly the quantity bought and sold, as well as the total costs from buying and proceeds from sells, which are then used in the final analysis.

Sample of the results can be found in the [SampleResults](SampleResults) directory.
