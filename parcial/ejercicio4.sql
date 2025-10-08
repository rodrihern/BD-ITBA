-- 4.1

SELECT prodID
FROM detailedOrder d JOIN purchaseOrder p
ON d.orderID = p.orderID
GROUP BY d.prodID
HAVING COUNT(DISTINCT channel) = 2
ORDER BY prodID;
-- 4.2

WITH last_sale AS (
  SELECT
    d.prodID,
    MAX(date_trunc('month', p.date)) AS last_month
  FROM DetailedOrder d
  JOIN PurchaseOrder p 
  ON d.orderID = p.orderID
  GROUP BY d.prodID
)
SELECT
  pr.prodID,
  COALESCE(to_char(ls.last_month, 'YYYY-MM'), 'No vendido') AS last_month
FROM Product pr
LEFT JOIN last_sale ls
ON pr.prodID = ls.prodID
ORDER BY ls.last_month, pr.prodID;

-- 4.3

WITH all_months AS (
    SELECT COUNT(DISTINCT TO_CHAR(date, 'YYYY-MM')) AS tot
    FROM PurchaseOrder
)
SELECT dtor.prodid,
       COUNT(DISTINCT TO_CHAR(po.date, 'YYYY-MM')) AS qty_month
FROM DetailedOrder dtor JOIN PurchaseOrder po 
ON po.orderID = dtor.orderID
GROUP BY dtor.prodid
HAVING COUNT(DISTINCT TO_CHAR(po.date, 'YYYY-MM')) < (SELECT tot FROM all_months)
ORDER BY qty_month, dtor.prodid;