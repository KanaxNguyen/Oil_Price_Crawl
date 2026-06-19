/*
    Lab 2 - Phase 2
    File 01: Tao staging tables, import CSV va gop du lieu crawl vao clean tables.

    Cach chay de xuat trong SSMS 20:
    1. Chay toan bo file lan dau de tao database, schema va staging tables.
    2. Nap 9 file CSV vao staging bang mot trong hai cach tai PHAN 4:
       - SSMS Import Flat File Wizard / Import Data Wizard; hoac
       - BULK INSERT bang cach sua @ProjectRoot va dat @RunBulkInsert = 1.
    3. Chay lai toan bo file. Cac staging tables duoc giu nguyen, clean tables
       duoc tao lai va nap lai tu staging.

    Luu y:
    - Script khong import san data_clean/lab2_fuel_e10_dataset.csv.
    - FORMAT = 'CSV' trong BULK INSERT can SQL Server 2017 tro len.
    - SQL Server service account phai co quyen doc folder CSV tren may SQL Server.
*/

/* ============================================================
   PHAN 1. Tao database FuelE10Lab2 neu chua ton tai
   ============================================================ */
USE master;
GO

IF DB_ID(N'FuelE10Lab2') IS NULL
BEGIN
    CREATE DATABASE FuelE10Lab2;
END;
GO

USE FuelE10Lab2;
GO

/* ============================================================
   PHAN 2. Tao schema staging va clean
   ============================================================ */
IF SCHEMA_ID(N'staging') IS NULL
BEGIN
    EXEC(N'CREATE SCHEMA staging AUTHORIZATION dbo;');
END;
GO

IF SCHEMA_ID(N'clean') IS NULL
BEGIN
    EXEC(N'CREATE SCHEMA clean AUTHORIZATION dbo;');
END;
GO

/* ============================================================
   PHAN 3. Tao staging tables
   Dung NVARCHAR cho du lieu CSV de tranh loi import do format,
   Unicode, gia tri NA hoac chuoi rong. Chuyen kieu o clean layer.
   ============================================================ */
IF OBJECT_ID(N'staging.stg_petrolimex_e10', N'U') IS NULL
BEGIN
    CREATE TABLE staging.stg_petrolimex_e10
    (
        company                 NVARCHAR(MAX) NULL,
        country                 NVARCHAR(MAX) NULL,
        product                 NVARCHAR(MAX) NULL,
        region                  NVARCHAR(MAX) NULL,
        effective_datetime      NVARCHAR(MAX) NULL,
        price_local_per_litre   NVARCHAR(MAX) NULL,
        currency                NVARCHAR(MAX) NULL,
        unit                    NVARCHAR(MAX) NULL,
        delta_local_per_litre   NVARCHAR(MAX) NULL,
        source_name             NVARCHAR(MAX) NULL,
        source_url              NVARCHAR(MAX) NULL,
        extraction_method       NVARCHAR(MAX) NULL
    );
END;
GO

IF OBJECT_ID(N'staging.stg_vietnam_fuel_kaggle', N'U') IS NULL
BEGIN
    CREATE TABLE staging.stg_vietnam_fuel_kaggle
    (
        company                 NVARCHAR(MAX) NULL,
        country                 NVARCHAR(MAX) NULL,
        product                 NVARCHAR(MAX) NULL,
        region                  NVARCHAR(MAX) NULL,
        effective_datetime      NVARCHAR(MAX) NULL,
        price_local_per_litre   NVARCHAR(MAX) NULL,
        currency                NVARCHAR(MAX) NULL,
        unit                    NVARCHAR(MAX) NULL,
        delta_local_per_litre   NVARCHAR(MAX) NULL,
        source_name             NVARCHAR(MAX) NULL,
        source_url              NVARCHAR(MAX) NULL,
        extraction_method       NVARCHAR(MAX) NULL
    );
END;
GO

IF OBJECT_ID(N'staging.stg_malaysia_fuel', N'U') IS NULL
BEGIN
    CREATE TABLE staging.stg_malaysia_fuel
    (
        company                 NVARCHAR(MAX) NULL,
        country                 NVARCHAR(MAX) NULL,
        product                 NVARCHAR(MAX) NULL,
        region                  NVARCHAR(MAX) NULL,
        effective_datetime      NVARCHAR(MAX) NULL,
        price_local_per_litre   NVARCHAR(MAX) NULL,
        currency                NVARCHAR(MAX) NULL,
        unit                    NVARCHAR(MAX) NULL,
        delta_local_per_litre   NVARCHAR(MAX) NULL,
        source_name             NVARCHAR(MAX) NULL,
        source_url              NVARCHAR(MAX) NULL,
        extraction_method       NVARCHAR(MAX) NULL
    );
END;
GO

IF OBJECT_ID(N'staging.stg_worldbank_fuel', N'U') IS NULL
BEGIN
    CREATE TABLE staging.stg_worldbank_fuel
    (
        company                 NVARCHAR(MAX) NULL,
        country                 NVARCHAR(MAX) NULL,
        product                 NVARCHAR(MAX) NULL,
        region                  NVARCHAR(MAX) NULL,
        effective_datetime      NVARCHAR(MAX) NULL,
        price_local_per_litre   NVARCHAR(MAX) NULL,
        currency                NVARCHAR(MAX) NULL,
        unit                    NVARCHAR(MAX) NULL,
        delta_local_per_litre   NVARCHAR(MAX) NULL,
        source_name             NVARCHAR(MAX) NULL,
        source_url              NVARCHAR(MAX) NULL,
        extraction_method       NVARCHAR(MAX) NULL
    );
END;
GO

IF OBJECT_ID(N'staging.stg_germany_fuel', N'U') IS NULL
BEGIN
    CREATE TABLE staging.stg_germany_fuel
    (
        company                 NVARCHAR(MAX) NULL,
        country                 NVARCHAR(MAX) NULL,
        product                 NVARCHAR(MAX) NULL,
        region                  NVARCHAR(MAX) NULL,
        effective_datetime      NVARCHAR(MAX) NULL,
        price_local_per_litre   NVARCHAR(MAX) NULL,
        currency                NVARCHAR(MAX) NULL,
        unit                    NVARCHAR(MAX) NULL,
        delta_local_per_litre   NVARCHAR(MAX) NULL,
        source_name             NVARCHAR(MAX) NULL,
        source_url              NVARCHAR(MAX) NULL,
        extraction_method       NVARCHAR(MAX) NULL
    );
END;
GO

IF OBJECT_ID(N'staging.stg_source_status', N'U') IS NULL
BEGIN
    CREATE TABLE staging.stg_source_status
    (
        step            NVARCHAR(MAX) NULL,
        source_name     NVARCHAR(MAX) NULL,
        source_url      NVARCHAR(MAX) NULL,
        ok              NVARCHAR(MAX) NULL,
        [rows]          NVARCHAR(MAX) NULL,
        note            NVARCHAR(MAX) NULL,
        collected_at    NVARCHAR(MAX) NULL
    );
END;
GO

IF OBJECT_ID(N'staging.stg_source_catalog', N'U') IS NULL
BEGIN
    CREATE TABLE staging.stg_source_catalog
    (
        source_id       NVARCHAR(MAX) NULL,
        source_name     NVARCHAR(MAX) NULL,
        url             NVARCHAR(MAX) NULL,
        method          NVARCHAR(MAX) NULL,
        expected_role   NVARCHAR(MAX) NULL
    );
END;
GO

IF OBJECT_ID(N'staging.stg_data_dictionary', N'U') IS NULL
BEGIN
    CREATE TABLE staging.stg_data_dictionary
    (
        column_name     NVARCHAR(MAX) NULL,
        data_type       NVARCHAR(MAX) NULL,
        description     NVARCHAR(MAX) NULL
    );
END;
GO

IF OBJECT_ID(N'staging.stg_quality_summary', N'U') IS NULL
BEGIN
    CREATE TABLE staging.stg_quality_summary
    (
        metric          NVARCHAR(MAX) NULL,
        value           NVARCHAR(MAX) NULL
    );
END;
GO

/* ============================================================
   PHAN 4. Huong dan import 9 file CSV vao staging

   LUA CHON A - GUI trong SSMS:
   - Neu dung "Tasks > Import Flat File...", chon tung CSV va dat ten bang
     theo danh sach staging o PHAN 3. Trong man hinh Modify Columns, dat cac
     cot thanh NVARCHAR. Wizard phu hop nhat khi staging table chua ton tai.
   - Neu da chay PHAN 3, co the dung "Tasks > Import Data..." de map CSV vao
     staging table da co san.
   - Kiem tra "Column names in the first data row" de bo qua header.

   Mapping file -> staging table:
   data_raw/petrolimex_e10_raw.csv
       -> staging.stg_petrolimex_e10
   data_raw/vietnam_fuel_prices_kaggle_standardized.csv
       -> staging.stg_vietnam_fuel_kaggle
   data_raw/malaysia_fuelprice_standardized.csv
       -> staging.stg_malaysia_fuel
   data_raw/worldbank_global_fuel_prices_standardized.csv
       -> staging.stg_worldbank_fuel
   data_raw/germany_petrol_station_prices_standardized.csv
       -> staging.stg_germany_fuel
   data_raw/source_status.csv
       -> staging.stg_source_status
   report/source_catalog.csv
       -> staging.stg_source_catalog
   report/data_dictionary.csv
       -> staging.stg_data_dictionary
   report/quality_summary.csv
       -> staging.stg_quality_summary

   LUA CHON B - BULK INSERT:
   - Copy folder project vao may SQL Server hoac mot UNC share ma SQL Server
     service account doc duoc.
   - Sua @ProjectRoot va dat @RunBulkInsert = 1.
   - Khi @RunBulkInsert = 1, script TRUNCATE staging truoc khi nap lai de
     tranh duplicate do chay BULK INSERT nhieu lan.
   ============================================================ */
DECLARE @RunBulkInsert BIT = 0; -- Doi thanh 1 neu muon nap CSV bang BULK INSERT.
DECLARE @ProjectRoot NVARCHAR(4000) = N'C:\sql-import\fuel-e10-project';

IF @RunBulkInsert = 1
BEGIN
    TRUNCATE TABLE staging.stg_petrolimex_e10;
    TRUNCATE TABLE staging.stg_vietnam_fuel_kaggle;
    TRUNCATE TABLE staging.stg_malaysia_fuel;
    TRUNCATE TABLE staging.stg_worldbank_fuel;
    TRUNCATE TABLE staging.stg_germany_fuel;
    TRUNCATE TABLE staging.stg_source_status;
    TRUNCATE TABLE staging.stg_source_catalog;
    TRUNCATE TABLE staging.stg_data_dictionary;
    TRUNCATE TABLE staging.stg_quality_summary;

    DECLARE @BulkOptions NVARCHAR(MAX) =
        N' WITH
        (
            FORMAT = ''CSV'',
            FIRSTROW = 2,
            FIELDQUOTE = ''"'',
            CODEPAGE = ''65001'',
            ROWTERMINATOR = ''0x0a'',
            TABLOCK
        );';

    DECLARE @BulkSql NVARCHAR(MAX) =
        N'BULK INSERT staging.stg_petrolimex_e10 FROM '
        + QUOTENAME(@ProjectRoot + N'\data_raw\petrolimex_e10_raw.csv', N'''')
        + @BulkOptions
        + N'BULK INSERT staging.stg_vietnam_fuel_kaggle FROM '
        + QUOTENAME(@ProjectRoot + N'\data_raw\vietnam_fuel_prices_kaggle_standardized.csv', N'''')
        + @BulkOptions
        + N'BULK INSERT staging.stg_malaysia_fuel FROM '
        + QUOTENAME(@ProjectRoot + N'\data_raw\malaysia_fuelprice_standardized.csv', N'''')
        + @BulkOptions
        + N'BULK INSERT staging.stg_worldbank_fuel FROM '
        + QUOTENAME(@ProjectRoot + N'\data_raw\worldbank_global_fuel_prices_standardized.csv', N'''')
        + @BulkOptions
        + N'BULK INSERT staging.stg_germany_fuel FROM '
        + QUOTENAME(@ProjectRoot + N'\data_raw\germany_petrol_station_prices_standardized.csv', N'''')
        + @BulkOptions
        + N'BULK INSERT staging.stg_source_status FROM '
        + QUOTENAME(@ProjectRoot + N'\data_raw\source_status.csv', N'''')
        + @BulkOptions
        + N'BULK INSERT staging.stg_source_catalog FROM '
        + QUOTENAME(@ProjectRoot + N'\report\source_catalog.csv', N'''')
        + @BulkOptions
        + N'BULK INSERT staging.stg_data_dictionary FROM '
        + QUOTENAME(@ProjectRoot + N'\report\data_dictionary.csv', N'''')
        + @BulkOptions
        + N'BULK INSERT staging.stg_quality_summary FROM '
        + QUOTENAME(@ProjectRoot + N'\report\quality_summary.csv', N'''')
        + @BulkOptions;

    EXEC sys.sp_executesql @BulkSql;
END;
GO

/* ============================================================
   PHAN 5. Tao lai clean tables
   Clean layer duoc rebuild moi lan chay de ket qua co tinh lap lai.
   Staging layer khong bi xoa neu @RunBulkInsert = 0.
   ============================================================ */
DROP TABLE IF EXISTS clean.fuel_prices_clean;
DROP TABLE IF EXISTS clean.source_status;
DROP TABLE IF EXISTS clean.source_catalog;
DROP TABLE IF EXISTS clean.data_dictionary;
DROP TABLE IF EXISTS clean.quality_summary;
GO

CREATE TABLE clean.fuel_prices_clean
(
    row_id                      INT             NOT NULL,
    company                     NVARCHAR(255)   NULL,
    country                     NVARCHAR(255)   NOT NULL,
    product                     NVARCHAR(500)   NOT NULL,
    product_normalized          NVARCHAR(500)   NOT NULL,
    fuel_family                 NVARCHAR(50)    NOT NULL,
    region                      NVARCHAR(255)   NULL,
    effective_datetime          DATETIME2(0)    NULL,
    [year]                      INT             NULL,
    [month]                     INT             NULL,
    [day]                       INT             NULL,
    price_local_per_litre       DECIMAL(18, 4)  NOT NULL,
    currency                    NVARCHAR(50)    NULL,
    unit                        NVARCHAR(100)   NULL,
    delta_local_per_litre       DECIMAL(18, 4)  NULL,
    has_delta                   BIT             NOT NULL,
    is_e10                      BIT             NOT NULL,
    is_e5                       BIT             NOT NULL,
    is_diesel                   BIT             NOT NULL,
    price_band                  NVARCHAR(50)    NOT NULL,
    source_name                 NVARCHAR(500)   NULL,
    source_url                  NVARCHAR(2048)  NULL,
    extraction_method           NVARCHAR(500)   NULL,
    source_file                 NVARCHAR(260)   NOT NULL,
    CONSTRAINT PK_fuel_prices_clean PRIMARY KEY CLUSTERED (row_id)
);
GO

CREATE TABLE clean.source_status
(
    step            NVARCHAR(255)   NULL,
    source_name     NVARCHAR(500)   NULL,
    source_url      NVARCHAR(2048)  NULL,
    ok              BIT             NULL,
    row_count       INT             NULL,
    note            NVARCHAR(MAX)   NULL,
    collected_at    DATETIME2(6)    NULL
);
GO

CREATE TABLE clean.source_catalog
(
    source_id       NVARCHAR(255)   NULL,
    source_name     NVARCHAR(500)   NULL,
    url             NVARCHAR(2048)  NULL,
    method          NVARCHAR(500)   NULL,
    expected_role   NVARCHAR(1000)  NULL
);
GO

CREATE TABLE clean.data_dictionary
(
    column_name     NVARCHAR(255)   NULL,
    data_type       NVARCHAR(255)   NULL,
    description     NVARCHAR(2000)  NULL
);
GO

CREATE TABLE clean.quality_summary
(
    metric          NVARCHAR(255)   NULL,
    value           NVARCHAR(4000)  NULL
);
GO

/* ============================================================
   PHAN 6. Gop 5 staging tables gia nhien lieu bang UNION ALL

   Quy tac clean chinh:
   - TRY_CONVERT de chuyen kieu an toan.
   - Loai dong co price NULL, price <= 0, product rong, country rong.
   - ROW_NUMBER theo business key de giu mot dong cho moi duplicate group.
   - Tao row_id INT sau khi loai duplicate.
   ============================================================ */
;WITH raw_union AS
(
    SELECT N'data_raw/petrolimex_e10_raw.csv' AS source_file, *
    FROM staging.stg_petrolimex_e10

    UNION ALL

    SELECT N'data_raw/vietnam_fuel_prices_kaggle_standardized.csv' AS source_file, *
    FROM staging.stg_vietnam_fuel_kaggle

    UNION ALL

    SELECT N'data_raw/malaysia_fuelprice_standardized.csv' AS source_file, *
    FROM staging.stg_malaysia_fuel

    UNION ALL

    SELECT N'data_raw/worldbank_global_fuel_prices_standardized.csv' AS source_file, *
    FROM staging.stg_worldbank_fuel

    UNION ALL

    SELECT N'data_raw/germany_petrol_station_prices_standardized.csv' AS source_file, *
    FROM staging.stg_germany_fuel
),
trimmed AS
(
    SELECT
        source_file,
        NULLIF(LTRIM(RTRIM(REPLACE(company, NCHAR(13), N''))), N'') AS company,
        NULLIF(LTRIM(RTRIM(REPLACE(country, NCHAR(13), N''))), N'') AS country,
        NULLIF(LTRIM(RTRIM(REPLACE(product, NCHAR(13), N''))), N'') AS product,
        NULLIF(LTRIM(RTRIM(REPLACE(region, NCHAR(13), N''))), N'') AS region,
        NULLIF(LTRIM(RTRIM(REPLACE(effective_datetime, NCHAR(13), N''))), N'') AS effective_datetime_text,
        NULLIF(LTRIM(RTRIM(REPLACE(price_local_per_litre, NCHAR(13), N''))), N'') AS price_text,
        NULLIF(LTRIM(RTRIM(REPLACE(currency, NCHAR(13), N''))), N'') AS currency,
        NULLIF(LTRIM(RTRIM(REPLACE(unit, NCHAR(13), N''))), N'') AS unit,
        NULLIF(LTRIM(RTRIM(REPLACE(delta_local_per_litre, NCHAR(13), N''))), N'') AS delta_text,
        NULLIF(LTRIM(RTRIM(REPLACE(source_name, NCHAR(13), N''))), N'') AS source_name,
        NULLIF(LTRIM(RTRIM(REPLACE(source_url, NCHAR(13), N''))), N'') AS source_url,
        NULLIF(LTRIM(RTRIM(REPLACE(extraction_method, NCHAR(13), N''))), N'') AS extraction_method
    FROM raw_union
),
typed_base AS
(
    SELECT
        source_file,
        company,
        country,
        product,
        LOWER(product) AS product_normalized,
        region,
        COALESCE
        (
            TRY_CONVERT(DATETIME2(0), effective_datetime_text, 127),
            TRY_CONVERT(DATETIME2(0), TRY_CONVERT(DATETIMEOFFSET(0), effective_datetime_text, 127))
        ) AS effective_datetime,
        TRY_CONVERT(DECIMAL(18, 4), price_text) AS price_local_per_litre,
        currency,
        unit,
        TRY_CONVERT(DECIMAL(18, 4), NULLIF(delta_text, N'NA')) AS delta_local_per_litre,
        source_name,
        source_url,
        extraction_method
    FROM trimmed
),
enriched AS
(
    SELECT
        *,
        CASE
            WHEN UPPER(product) LIKE N'%E10%' THEN N'E10'
            WHEN UPPER(product) LIKE N'%E5%' THEN N'E5'
            WHEN UPPER(product) LIKE N'%DIESEL%'
                 OR LOWER(product) LIKE N'dau do %'
                 OR LOWER(product) LIKE N'do %' THEN N'Diesel'
            WHEN LOWER(product) LIKE N'dau hoa %' THEN N'Kerosene'
            WHEN REPLACE(UPPER(product), N' ', N'') LIKE N'%RON97%' THEN N'RON97'
            WHEN REPLACE(UPPER(product), N' ', N'') LIKE N'%RON95%' THEN N'RON95+'
            ELSE N'Other'
        END AS fuel_family
    FROM typed_base
),
typed_enriched AS
(
    SELECT
        source_file,
        company,
        country,
        product,
        product_normalized,
        fuel_family,
        region,
        effective_datetime,
        TRY_CONVERT(INT, DATEPART(YEAR, effective_datetime)) AS [year],
        TRY_CONVERT(INT, DATEPART(MONTH, effective_datetime)) AS [month],
        TRY_CONVERT(INT, DATEPART(DAY, effective_datetime)) AS [day],
        price_local_per_litre,
        currency,
        unit,
        delta_local_per_litre,
        TRY_CONVERT(BIT, CASE WHEN delta_local_per_litre IS NULL THEN N'0' ELSE N'1' END) AS has_delta,
        TRY_CONVERT(BIT, CASE WHEN fuel_family = N'E10' THEN N'1' ELSE N'0' END) AS is_e10,
        TRY_CONVERT(BIT, CASE WHEN fuel_family = N'E5' THEN N'1' ELSE N'0' END) AS is_e5,
        TRY_CONVERT(BIT, CASE WHEN fuel_family = N'Diesel' THEN N'1' ELSE N'0' END) AS is_diesel,
        CASE
            WHEN currency <> N'VND' OR currency IS NULL THEN N'international'
            WHEN price_local_per_litre < 23000 THEN N'low_vnd'
            WHEN price_local_per_litre < 26000 THEN N'medium_vnd'
            ELSE N'high_vnd'
        END AS price_band,
        source_name,
        source_url,
        extraction_method
    FROM enriched
),
deduplicated AS
(
    SELECT
        *,
        ROW_NUMBER() OVER
        (
            PARTITION BY
                company,
                country,
                product,
                region,
                effective_datetime,
                price_local_per_litre,
                source_name
            ORDER BY source_file, source_url, extraction_method
        ) AS duplicate_rank
    FROM typed_enriched
    WHERE price_local_per_litre IS NOT NULL
      AND price_local_per_litre > 0
      AND product IS NOT NULL
      AND country IS NOT NULL
),
numbered AS
(
    SELECT
        TRY_CONVERT
        (
            INT,
            ROW_NUMBER() OVER
            (
                ORDER BY
                    country,
                    company,
                    product,
                    region,
                    effective_datetime,
                    price_local_per_litre,
                    source_name,
                    source_file
            )
        ) AS row_id,
        company,
        country,
        product,
        product_normalized,
        fuel_family,
        region,
        effective_datetime,
        [year],
        [month],
        [day],
        price_local_per_litre,
        currency,
        unit,
        delta_local_per_litre,
        has_delta,
        is_e10,
        is_e5,
        is_diesel,
        price_band,
        source_name,
        source_url,
        extraction_method,
        source_file
    FROM deduplicated
    WHERE duplicate_rank = 1
)
INSERT INTO clean.fuel_prices_clean
(
    row_id,
    company,
    country,
    product,
    product_normalized,
    fuel_family,
    region,
    effective_datetime,
    [year],
    [month],
    [day],
    price_local_per_litre,
    currency,
    unit,
    delta_local_per_litre,
    has_delta,
    is_e10,
    is_e5,
    is_diesel,
    price_band,
    source_name,
    source_url,
    extraction_method,
    source_file
)
SELECT
    row_id,
    company,
    country,
    product,
    product_normalized,
    fuel_family,
    region,
    effective_datetime,
    [year],
    [month],
    [day],
    price_local_per_litre,
    currency,
    unit,
    delta_local_per_litre,
    has_delta,
    is_e10,
    is_e5,
    is_diesel,
    price_band,
    source_name,
    source_url,
    extraction_method,
    source_file
FROM numbered;
GO

/* ============================================================
   PHAN 7. Tao clean metadata tables tu staging
   TRY_CONVERT tiep tuc duoc dung cho BIT, INT va DATETIME2.
   ============================================================ */
INSERT INTO clean.source_status
(
    step,
    source_name,
    source_url,
    ok,
    row_count,
    note,
    collected_at
)
SELECT DISTINCT
    NULLIF(LTRIM(RTRIM(REPLACE(step, NCHAR(13), N''))), N''),
    NULLIF(LTRIM(RTRIM(REPLACE(source_name, NCHAR(13), N''))), N''),
    NULLIF(LTRIM(RTRIM(REPLACE(source_url, NCHAR(13), N''))), N''),
    TRY_CONVERT
    (
        BIT,
        CASE UPPER(NULLIF(LTRIM(RTRIM(REPLACE(ok, NCHAR(13), N''))), N''))
            WHEN N'TRUE' THEN N'1'
            WHEN N'FALSE' THEN N'0'
            ELSE NULLIF(LTRIM(RTRIM(REPLACE(ok, NCHAR(13), N''))), N'')
        END
    ),
    TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(REPLACE([rows], NCHAR(13), N''))), N'')),
    NULLIF(LTRIM(RTRIM(REPLACE(note, NCHAR(13), N''))), N''),
    TRY_CONVERT(DATETIME2(6), NULLIF(LTRIM(RTRIM(REPLACE(collected_at, NCHAR(13), N''))), N''))
FROM staging.stg_source_status;
GO

INSERT INTO clean.source_catalog
(
    source_id,
    source_name,
    url,
    method,
    expected_role
)
SELECT DISTINCT
    NULLIF(LTRIM(RTRIM(REPLACE(source_id, NCHAR(13), N''))), N''),
    NULLIF(LTRIM(RTRIM(REPLACE(source_name, NCHAR(13), N''))), N''),
    NULLIF(LTRIM(RTRIM(REPLACE(url, NCHAR(13), N''))), N''),
    NULLIF(LTRIM(RTRIM(REPLACE(method, NCHAR(13), N''))), N''),
    NULLIF(LTRIM(RTRIM(REPLACE(expected_role, NCHAR(13), N''))), N'')
FROM staging.stg_source_catalog;
GO

INSERT INTO clean.data_dictionary
(
    column_name,
    data_type,
    description
)
SELECT DISTINCT
    NULLIF(LTRIM(RTRIM(REPLACE(column_name, NCHAR(13), N''))), N''),
    NULLIF(LTRIM(RTRIM(REPLACE(data_type, NCHAR(13), N''))), N''),
    NULLIF(LTRIM(RTRIM(REPLACE(description, NCHAR(13), N''))), N'')
FROM staging.stg_data_dictionary;
GO

INSERT INTO clean.quality_summary
(
    metric,
    value
)
SELECT DISTINCT
    NULLIF(LTRIM(RTRIM(REPLACE(metric, NCHAR(13), N''))), N''),
    NULLIF(LTRIM(RTRIM(REPLACE(value, NCHAR(13), N''))), N'')
FROM staging.stg_quality_summary;
GO

/* ============================================================
   PHAN 8. Tao index phuc vu analysis
   ============================================================ */
CREATE NONCLUSTERED INDEX IX_fuel_prices_clean_country
    ON clean.fuel_prices_clean (country);
GO

CREATE NONCLUSTERED INDEX IX_fuel_prices_clean_fuel_family
    ON clean.fuel_prices_clean (fuel_family);
GO

CREATE NONCLUSTERED INDEX IX_fuel_prices_clean_effective_datetime
    ON clean.fuel_prices_clean (effective_datetime);
GO

CREATE NONCLUSTERED INDEX IX_fuel_prices_clean_source_name
    ON clean.fuel_prices_clean (source_name);
GO

CREATE NONCLUSTERED INDEX IX_fuel_prices_clean_country_family_year_month
    ON clean.fuel_prices_clean (country, fuel_family, [year], [month]);
GO

/* ============================================================
   PHAN 9. Kiem tra nhanh sau khi import va merge
   Neu clean_rows = 0, hay nap staging CSV o PHAN 4 va chay lai file.
   ============================================================ */
SELECT N'staging.stg_petrolimex_e10' AS table_name, COUNT(*) AS row_count
FROM staging.stg_petrolimex_e10
UNION ALL
SELECT N'staging.stg_vietnam_fuel_kaggle', COUNT(*)
FROM staging.stg_vietnam_fuel_kaggle
UNION ALL
SELECT N'staging.stg_malaysia_fuel', COUNT(*)
FROM staging.stg_malaysia_fuel
UNION ALL
SELECT N'staging.stg_worldbank_fuel', COUNT(*)
FROM staging.stg_worldbank_fuel
UNION ALL
SELECT N'staging.stg_germany_fuel', COUNT(*)
FROM staging.stg_germany_fuel
UNION ALL
SELECT N'clean.fuel_prices_clean', COUNT(*)
FROM clean.fuel_prices_clean;
GO

