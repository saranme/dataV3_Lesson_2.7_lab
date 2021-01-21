-- Activity 2.08. 1
# 1
USE bank;
SELECT RANK() OVER (ORDER BY A4 desc) as 'Rank_hab', A4, 
	   RANK() OVER (ORDER BY A9 desc) as 'Rank_cit',A9, 
       RANK() OVER (ORDER BY A10 desc) as 'Rank_cit',A10,
       RANK() OVER (ORDER BY A11 desc) as 'Rank_cit',A11, 
       RANK() OVER (ORDER BY A12 desc) as 'Rank_cit',A12
FROM district;

# 2
SELECT RANK() OVER (PARTITION BY A3 ORDER BY A4 desc) as 'Rank_hab',A4,
		RANK() OVER (PARTITION BY A3 ORDER BY A9 desc) as 'Rank_hab',A9,
        RANK() OVER (PARTITION BY A3 ORDER BY A10 desc) as 'Rank_hab',A10,
        RANK() OVER (PARTITION BY A3 ORDER BY A11 desc) as 'Rank_hab',A11,
        RANK() OVER (PARTITION BY A3 ORDER BY A12 desc) as 'Rank_hab',A12
FROM district;
-- Activity 2
/* 
Use the transactions table in the bank database to find the Top 20 account_ids based on the balances.
Illustrate the difference between Rank() and Dense_Rank().
*/
# 1
SELECT DISTINCT account_id, balance
FROM trans
ORDER BY balance DESC
LIMIT 20;
# 2
SELECT account_id, balance, RANK() OVER (ORDER BY balance DESC) ranking
FROM trans
LIMIT 20;

SELECT account_id, balance, DENSE_RANK() OVER (ORDER BY balance DESC) ranking
FROM trans
LIMIT 20;

-- Activity 3
/*
Get a rank of districts ordered by the number of customers.
Get a rank of regions ordered by the number of customers.
Get the total amount borrowed by the district together with the average loan in that district.
Get the number of accounts opened by district and year.
*/
# 1
SELECT d.A1 AS district_code, d.A2 AS district_name, COUNT(c.client_id) n_clients, DENSE_RANK() OVER (ORDER BY COUNT(c.client_id)) rank_n_clients_x_district
FROM district AS d
JOIN client AS c
ON d.A1 = c.district_id
GROUP BY A1, A2;

# 2 Get a rank of regions ordered by the number of customers.
SELECT d.A3 AS region, COUNT(c.client_id) n_clients, DENSE_RANK() OVER (ORDER BY COUNT(c.client_id)) rank_n_clients_x_region
FROM district AS d
JOIN client AS c
ON d.A1 = c.district_id
GROUP BY A3;

# 3 Get the total amount borrowed by the district together with the average loan in that district.
SELECT d.A1 AS district_code, d.A2 AS district_name, AVG(l.amount - l.payments) AS loan_debt, SUM(l.amount - l.payments) total_amount
FROM loan l
JOIN account a
ON l.account_id = a.account_id
JOIN district d
ON d.A1 = a.district_id
GROUP BY d.A1, d.A2
ORDER BY loan_debt DESC, d.A1 ASC;

# 4 Get the number of accounts opened by district and year.
SELECT COUNT(a.account_id) n_accounts, d.A1, a.date
FROM account a
JOIN district d
ON d.A1 = a.district_id
GROUP BY d.A1, a.date
ORDER BY n_accounts

