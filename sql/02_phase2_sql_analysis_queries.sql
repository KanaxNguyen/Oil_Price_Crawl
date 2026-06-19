/*
    Lab 2 - Phase 2
    File 02: Cac truy van phan tich tren clean layer.

    Dieu kien truoc khi chay:
    - Da chay file 01_import_merge_crawled_files.sql.
    - Da import CSV vao staging va rebuild clean tables.

    File nay chi chua SQL analysis, khong tao table va khong import CSV.
*/

USE FuelE10Lab2;
GO

/* ============================================================
   QUERY 1. Xem 20 dong dau tien cua clean dataset
   Muc tieu: Kiem tra nhanh cau truc va du lieu sau khi merge.
   Ky thuat SQL: SELECT TOP va ORDER BY theo row_id.
   Y nghia bao cao: Cung cap mau du lieu de mo ta dataset dau vao.
   ============================================================ */
SELECT TOP (20)
    row_id,
    company,
    country,
    product,
    fuel_family,
    region,
    effective_datetime,
    price_local_per_litre,
    currency,
    source_name,
    source_file
FROM clean.fuel_prices_clean
ORDER BY row_id;
GO

/* ============================================================
   QUERY 2. Loc du lieu nhien lieu tai Viet Nam
   Muc tieu: Lay cac nhom nhien lieu chinh cua thi truong Viet Nam.
   Ky thuat SQL: WHERE ket hop IN va ORDER BY.
   Y nghia bao cao: Tao tap du lieu phuc vu phan tich E10, E5,
   RON95+ va Diesel tai Viet Nam.
   ============================================================ */
SELECT
    row_id,
    company,
    product,
    fuel_family,
    region,
    effective_datetime,
    price_local_per_litre,
    currency,
    source_name
FROM clean.fuel_prices_clean
WHERE country = N'Vietnam'
  AND fuel_family IN (N'E10', N'E5', N'RON95+', N'Diesel')
ORDER BY effective_datetime, fuel_family, product;
GO

/* ============================================================
   QUERY 3. Thong ke gia theo quoc gia va nhom nhien lieu
   Muc tieu: Dem so dong va tinh gia trung binh, nho nhat, lon nhat.
   Ky thuat SQL: GROUP BY voi COUNT, AVG, MIN va MAX.
   Y nghia bao cao: Cho thay quy mo du lieu va bien do gia cua tung
   nhom nhien lieu theo quoc gia.
   ============================================================ */
SELECT
    country,
    fuel_family,
    COUNT(*) AS n_rows,
    AVG(price_local_per_litre) AS avg_price_local_per_litre,
    MIN(price_local_per_litre) AS min_price_local_per_litre,
    MAX(price_local_per_litre) AS max_price_local_per_litre
FROM clean.fuel_prices_clean
GROUP BY
    country,
    fuel_family
ORDER BY
    country,
    fuel_family;
GO

/* ============================================================
   QUERY 4. Lay 50 muc gia cao nhat
   Muc tieu: Tim cac quan sat co gia niem yet cao nhat trong dataset.
   Ky thuat SQL: SELECT TOP, ORDER BY DESC.
   Y nghia bao cao: Ho tro kiem tra cac gia tri cao va dien giai theo
   currency, quoc gia, san pham va nguon du lieu.
   ============================================================ */
SELECT TOP (50)
    row_id,
    country,
    company,
    product,
    fuel_family,
    region,
    effective_datetime,
    price_local_per_litre,
    currency,
    source_name
FROM clean.fuel_prices_clean
ORDER BY
    price_local_per_litre DESC,
    effective_datetime DESC;
GO

/* ============================================================
   QUERY 5. Lay quoc gia co tu 100 dong du lieu tro len
   Muc tieu: Loc cac quoc gia co du quan sat de phan tich tong hop.
   Ky thuat SQL: GROUP BY, COUNT, COUNT DISTINCT va HAVING.
   Y nghia bao cao: Xac dinh pham vi quoc gia co do phu du lieu tot.
   ============================================================ */
SELECT
    country,
    COUNT(*) AS n_rows,
    COUNT(DISTINCT product) AS n_products,
    COUNT(DISTINCT source_name) AS n_sources
FROM clean.fuel_prices_clean
GROUP BY country
HAVING COUNT(*) >= 100
ORDER BY n_rows DESC;
GO

/* ============================================================
   QUERY 6. Noi fuel prices voi source catalog
   Muc tieu: Bo sung thong tin phuong phap thu thap va vai tro cua nguon.
   Ky thuat SQL: LEFT JOIN theo source_url = url.
   Y nghia bao cao: Dam bao truy vet duoc nguon cua tung quan sat gia.
   ============================================================ */
SELECT TOP (100)
    f.row_id,
    f.country,
    f.company,
    f.product,
    f.fuel_family,
    f.price_local_per_litre,
    f.currency,
    f.source_name,
    s.source_id,
    s.method AS source_method,
    s.expected_role
FROM clean.fuel_prices_clean AS f
LEFT JOIN clean.source_catalog AS s
    ON f.source_url = s.url
ORDER BY f.row_id;
GO

/* ============================================================
   QUERY 7. Trend gia nhien lieu Viet Nam theo thang
   Muc tieu: Theo doi bien dong gia trung binh theo nam, thang va fuel family.
   Ky thuat SQL: WHERE, GROUP BY, COUNT, AVG va ORDER BY theo thoi gian.
   Y nghia bao cao: Tao bang trend de dua vao phan phan tich thi truong Viet Nam.
   ============================================================ */
SELECT
    [year],
    [month],
    fuel_family,
    COUNT(*) AS n_rows,
    AVG(price_local_per_litre) AS avg_vnd_price,
    MIN(price_local_per_litre) AS min_vnd_price,
    MAX(price_local_per_litre) AS max_vnd_price
FROM clean.fuel_prices_clean
WHERE country = N'Vietnam'
GROUP BY
    [year],
    [month],
    fuel_family
ORDER BY
    [year],
    [month],
    fuel_family;
GO

/* ============================================================
   QUERY 8. So sanh Viet Nam va quoc te
   Muc tieu: Tong hop gia theo scope, country, fuel family va currency.
   Ky thuat SQL: CASE, GROUP BY, COUNT, AVG, MIN va MAX.
   Y nghia bao cao: So sanh theo currency goc de tranh dien giai sai khi
   chua quy doi ty gia giua VND va ngoai te.
   ============================================================ */
SELECT
    CASE
        WHEN country = N'Vietnam' THEN N'Vietnam'
        ELSE N'International'
    END AS comparison_scope,
    country,
    fuel_family,
    currency,
    COUNT(*) AS n_rows,
    AVG(price_local_per_litre) AS avg_price_local_per_litre,
    MIN(price_local_per_litre) AS min_price_local_per_litre,
    MAX(price_local_per_litre) AS max_price_local_per_litre
FROM clean.fuel_prices_clean
GROUP BY
    CASE
        WHEN country = N'Vietnam' THEN N'Vietnam'
        ELSE N'International'
    END,
    country,
    fuel_family,
    currency
ORDER BY
    comparison_scope DESC,
    country,
    fuel_family,
    currency;
GO

/* ============================================================
   QUERY 9. Data quality check cho cot bat buoc
   Muc tieu: Tim dong bi thieu price, product hoac country.
   Ky thuat SQL: WHERE voi IS NULL, LTRIM, RTRIM va OR.
   Y nghia bao cao: Clean layer du kien tra ve 0 dong vi file import
   da loai cac dong loi nay.
   ============================================================ */
SELECT
    row_id,
    country,
    product,
    price_local_per_litre,
    source_name,
    source_file
FROM clean.fuel_prices_clean
WHERE price_local_per_litre IS NULL
   OR NULLIF(LTRIM(RTRIM(product)), N'') IS NULL
   OR NULLIF(LTRIM(RTRIM(country)), N'') IS NULL;
GO

/* ============================================================
   QUERY 10. Kiem tra duplicate theo business key
   Muc tieu: Tim duplicate con sot lai sau buoc ROW_NUMBER dedup.
   Ky thuat SQL: GROUP BY business key va HAVING COUNT(*) > 1.
   Y nghia bao cao: Clean layer du kien tra ve 0 dong, chung minh moi
   quan sat business chi duoc giu mot lan.
   ============================================================ */
SELECT
    company,
    country,
    product,
    region,
    effective_datetime,
    price_local_per_litre,
    source_name,
    COUNT(*) AS duplicate_count
FROM clean.fuel_prices_clean
GROUP BY
    company,
    country,
    product,
    region,
    effective_datetime,
    price_local_per_litre,
    source_name
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
GO

/* ============================================================
   QUERY 11. Kiem tra outlier gia khong hop le
   Muc tieu: Tim gia NULL hoac gia nho hon hay bang 0.
   Ky thuat SQL: WHERE voi IS NULL va phep so sanh <=.
   Y nghia bao cao: Clean layer du kien tra ve 0 dong vi cac gia khong
   hop le da bi loai truoc khi insert.
   ============================================================ */
SELECT
    row_id,
    country,
    product,
    effective_datetime,
    price_local_per_litre,
    currency,
    source_name,
    source_file
FROM clean.fuel_prices_clean
WHERE price_local_per_litre IS NULL
   OR price_local_per_litre <= 0;
GO

/* ============================================================
   QUERY 12. Tong hop quy mo dataset
   Muc tieu: Dem tong dong va so luong country, product, source, company.
   Ky thuat SQL: COUNT va COUNT DISTINCT.
   Y nghia bao cao: Cung cap cac chi so tong quan de dua vao phan mo ta dataset.
   ============================================================ */
SELECT
    COUNT(*) AS n_rows,
    COUNT(DISTINCT country) AS n_countries,
    COUNT(DISTINCT product) AS n_products,
    COUNT(DISTINCT source_name) AS n_sources,
    COUNT(DISTINCT company) AS n_companies
FROM clean.fuel_prices_clean;
GO

