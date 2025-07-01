USE master;


DROP DATABASE IF EXISTS Portfolio_Management;

CREATE DATABASE Portfolio_Management;
USE Portfolio_Management;

-- user details table 
CREATE TABLE user_details (
    user_id VARCHAR(12) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    dob DATE NOT NULL, 
    pan VARCHAR(10) NOT NULL UNIQUE, 
    email VARCHAR(255) NOT NULL UNIQUE
);

-- user phone numbers
CREATE TABLE phone_numbers (
    user_id VARCHAR(12),
    phone_number VARCHAR(10) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user_details(user_id)
);

-- company/stock information
CREATE TABLE company (
    stock_id VARCHAR(4) PRIMARY KEY,
    stock_name VARCHAR(255) NOT NULL,
    stock_price DECIMAL(10, 2) NOT NULL
);

-- user watchlist for stocks
CREATE TABLE watchlist (
    user_id VARCHAR(12) NOT NULL,
    stock_id VARCHAR(4),
    stock_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user_details(user_id),
    FOREIGN KEY (stock_id) REFERENCES company(stock_id)
);

-- portfolio holdings
CREATE TABLE portfolio (
    user_id VARCHAR(12) NOT NULL,
    buy_price DECIMAL(10, 2),
    stock_id VARCHAR(4) NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (stock_id) REFERENCES company(stock_id),
    FOREIGN KEY (user_id) REFERENCES user_details(user_id)
);

-- buy/sell transaction history
CREATE TABLE transaction_history (
    transaction_id UNIQUEIDENTIFIER PRIMARY KEY,
    user_id VARCHAR(12) NOT NULL,
    stock_id VARCHAR(4) NOT NULL,
    transaction_type VARCHAR(4) NOT NULL CHECK (transaction_type IN ('BUY', 'SELL')),
    transaction_date DATETIME NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    commission DECIMAL(10, 2),
    FOREIGN KEY (user_id) REFERENCES user_details(user_id),
    FOREIGN KEY (stock_id) REFERENCES company(stock_id)
);

-- historical stock prices
CREATE TABLE stock_price_history (
    id INT IDENTITY(1,1) PRIMARY KEY,
    stock_id VARCHAR(4) NOT NULL,
    trade_date DATE NOT NULL,
    open_price DECIMAL(10, 2) NOT NULL,
    close_price DECIMAL(10, 2) NOT NULL,
    low_price DECIMAL(10, 2) NOT NULL,
    high_price DECIMAL(10, 2) NOT NULL,
    volume BIGINT,
    FOREIGN KEY (stock_id) REFERENCES company(stock_id)
);

BULK INSERT user_details
FROM 'C:\SQL Projects\user_details.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

BULK INSERT phone_numbers
FROM 'C:\SQL Projects\phone_numbers.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

BULK INSERT company
FROM 'C:\SQL Projects\company.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

BULK INSERT watchlist
FROM 'C:\SQL Projects\watchlist.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

BULK INSERT portfolio
FROM 'C:\SQL Projects\portfolio.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

BULK INSERT transaction_history
FROM 'C:\SQL Projects\transaction_history.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

CREATE TABLE stock_price_history_staging (
    stock_id VARCHAR(4) NOT NULL,
    trade_date DATE NOT NULL,
    open_price DECIMAL(10, 2) NOT NULL,
    close_price DECIMAL(10, 2) NOT NULL,
    low_price DECIMAL(10, 2) NOT NULL,
    high_price DECIMAL(10, 2) NOT NULL,
    volume BIGINT
);

BULK INSERT stock_price_history_staging
FROM 'C:\SQL Projects\stock_prices.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

INSERT INTO stock_price_history (stock_id, trade_date, open_price, close_price, low_price, high_price, volume)
SELECT stock_id, trade_date, open_price, close_price, low_price, high_price, volume
FROM stock_price_history_staging;
