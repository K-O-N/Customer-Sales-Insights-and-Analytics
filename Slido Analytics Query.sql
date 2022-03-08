WITH new AS
(
  SELECT SUBSTR(SUBSTR(email, INSTR(email, '@'), INSTR(email, '.')), 2) As domain_name, users, 
         PLAN, price, event_id, joined_participants, active_participants, 
         AVG(joined_participants) AS avg_join, AVG(active_participants) AS avg_active,
         date_signup, subscriptions.date_subscription, date
  FROM accounts
  INNER JOIN subscriptions
  ON accounts.account_id = subscriptions.account_id
  INNER JOIN events
  ON accounts.account_id = events.account_id
  GROUP BY event_id
  )
  SELECT SUM(price) AS Total_monetary_value,
         (SELECT 100 * COUNT(DISTINCT domain_name) FROM new 
          WHERE date BETWEEN date_signup AND DATE(date_signup, '+1 month')) / 
          COUNT (DISTINCT domain_name) AS activation_30,
          (SELECT 100 * COUNT(DISTINCT domain_name) FROM new 
          WHERE date BETWEEN date_signup AND DATE(date_signup, '+3 month')) / 
          COUNT (DISTINCT domain_name) AS activation_90
  FROM new;