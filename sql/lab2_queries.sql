
-- ============================================================
-- Lab 2 SQL Queries
-- Dataset: fuel_prices_clean
-- ============================================================

-- 1. SELECT
SELECT row_id, company, country, product, price_local_per_litre, currency
FROM fuel_prices_clean
LIMIT 20;

-- 2. WHERE
SELECT *
FROM fuel_prices_clean
WHERE country = 'Vietnam'
  AND fuel_family IN ('E10', 'E5', 'RON95+');

-- 3. GROUP BY + Aggregate Functions
SELECT country,
       fuel_family,
       COUNT(*) AS n_rows,
       AVG(price_local_per_litre) AS avg_price,
       MIN(price_local_per_litre) AS min_price,
       MAX(price_local_per_litre) AS max_price
FROM fuel_prices_clean
GROUP BY country, fuel_family;

-- 4. ORDER BY
SELECT country, company, product, effective_datetime, price_local_per_litre, currency
FROM fuel_prices_clean
ORDER BY price_local_per_litre DESC
LIMIT 50;

-- 5. HAVING
SELECT country,
       COUNT(*) AS n_rows,
       COUNT(DISTINCT product) AS n_products
FROM fuel_prices_clean
GROUP BY country
HAVING COUNT(*) >= 100;

-- 6. JOIN
SELECT f.row_id,
       f.company,
       f.country,
       f.product,
       f.price_local_per_litre,
       f.source_name,
       s.method,
       s.expected_role
FROM fuel_prices_clean f
LEFT JOIN source_catalog s
  ON f.source_url = s.url
LIMIT 50;

-- 7. Vietnam E10/E5/RON95 trend
SELECT year,
       month,
       fuel_family,
       COUNT(*) AS n_rows,
       AVG(price_local_per_litre) AS avg_vnd_price
FROM fuel_prices_clean
WHERE country = 'Vietnam'
GROUP BY year, month, fuel_family
ORDER BY year, month, fuel_family;

-- 8. Source status check
SELECT source_name, ok, rows, note, collected_at
FROM source_status
ORDER BY collected_at;

