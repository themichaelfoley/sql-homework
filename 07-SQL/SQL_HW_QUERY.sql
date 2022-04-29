---SQL HW 07 QUERIES - PART 1

---Some fraudsters hack a credit card by making several small transactions (generally less than $2.00), which are typically ignored by cardholders.
---Create a view for each of your queries.

---Count the transactions that are less than $2.00 per cardholder.
DROP VIEW IF EXISTS small_transactions;
CREATE VIEW small_transactions AS
SELECT * FROM public."Transactions"
WHERE transaction_amount < 2;

---Close enough for government work answer - How can you isolate (or group) the transactions of each cardholder?
DROP VIEW IF EXISTS group_transactions;
CREATE VIEW group_transactions AS
SELECT card_number, count (*) as small_transaction_count FROM public."Transactions"
WHERE transaction_amount < 2
GROUP BY card_number
ORDER BY small_transaction_count DESC;

---Dan's higher standards answer 1.1 - How can you isolate (or group) the transactions of each cardholder? - CARDHOLDER ID
SELECT card_holder_id, count (*) as small_transaction_count FROM public."Transactions" t
INNER JOIN "Credit_Card" cc
ON cc.card_number = t.card_number
WHERE transaction_amount < 2
GROUP BY card_holder_id
ORDER BY small_transaction_count DESC; 

---Dan's higher standards answer 1.2 - How can you isolate (or group) the transactions of each cardholder? - CUSTOMER NAME
SELECT c.customer_name, count (*) as small_transaction_count FROM public."Transactions" t
INNER JOIN "Credit_Card" cc
ON cc.card_number = t.card_number
INNER JOIN "Card_Holder" c
ON cc.card_holder_id = c.card_holder_id
WHERE transaction_amount < 2
GROUP BY cc.card_holder_id, c.customer_name
ORDER BY small_transaction_count DESC; 

---Dan's higher standards answer 1.3 - How can you isolate (or group) the transactions of each cardholder? - WEEKLY
SELECT c.customer_name, date_trunc('week',tranaction_date) , count (*) as small_transaction_count FROM public."Transactions" t
INNER JOIN "Credit_Card" cc
ON cc.card_number = t.card_number
INNER JOIN "Card_Holder" c
ON cc.card_holder_id = c.card_holder_id
WHERE transaction_amount < 2
GROUP BY cc.card_holder_id, c.customer_name, date_trunc('week',tranaction_date)
ORDER BY small_transaction_count DESC; 

---Is there any evidence to suggest that a credit card has been hacked? Explain your rationale.
---Answer: It does not appear that 3 credit card transactions in one week would suggest the credit card has been hacked.

---Take your investigation a step futher by considering the time period in which potentially fraudulent transactions are made.
---What are the top 100 highest transactions made between 7:00 am and 9:00 am?
---Answer: 319
DROP VIEW IF EXISTS morning_transactions;
CREATE VIEW morning_transactions AS
SELECT * FROM "Transactions"
WHERE date_part('hour', tranaction_date) BETWEEN 7 AND 9
ORDER BY transaction_amount DESC;

SELECT COUNT (*) FROM morning_transactions
------
DROP VIEW IF EXISTS outside_morning_transactions;
CREATE VIEW outside_morning_transactions AS
SELECT * FROM "Transactions"
WHERE date_part('hour', tranaction_date) NOT BETWEEN 7 AND 9
ORDER BY transaction_amount DESC;

SELECT COUNT (*) FROM outside_morning_transactions

---Do you see any anomalous transactions that could be fraudulent?
---Answer: No

---Is there a higher number of fraudulent transactions made during this time frame versus the rest of the day?
---Answer: It does not appear that way. If anything there are more transactions made throughout the rest of the day.


---What are the top 5 merchants prone to being hacked using small transactions?
---Answer: ??
