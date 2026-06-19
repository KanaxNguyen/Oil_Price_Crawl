# Fuel E10 Project

Dự án thu thập, chuẩn hóa và phân tích dữ liệu giá nhiên liệu, tập trung vào xăng sinh học E10 tại Việt Nam và dữ liệu đối chiếu quốc tế. Thư mục bao gồm dữ liệu thô, dữ liệu đã làm sạch, cơ sở dữ liệu SQLite có thể truy vấn ngay, các script SQL Server và các báo cáo tổng hợp dạng CSV.

## Mục tiêu

- Tổng hợp dữ liệu giá E10, E5, RON95, diesel và các nhóm nhiên liệu liên quan.
- Theo dõi xu hướng giá nhiên liệu tại Việt Nam theo thời gian.
- Đối chiếu dữ liệu Việt Nam với Malaysia và các nguồn quốc tế khác.
- Lưu vết nguồn, phương pháp thu thập và trạng thái xử lý dữ liệu.
- Kiểm tra dữ liệu thiếu, trùng lặp và giá trị giá không hợp lệ.

## Tổng quan dữ liệu hiện tại

| Chỉ số | Giá trị |
|---|---:|
| Số dòng trong tập dữ liệu sạch | 5.281 |
| Số cột | 23 |
| Quốc gia có dữ liệu sạch | 2 |
| Doanh nghiệp/nhà cung cấp | 3 |
| Sản phẩm | 30 |
| Nguồn xuất hiện trong dữ liệu sạch | 3 |
| Dòng E10 | 136 |
| Dòng diesel | 1.973 |
| Dòng thiếu giá | 0 |
| Dòng trùng lặp | 0 |

Phạm vi thời gian trong cơ sở dữ liệu hiện tại:

| Quốc gia | Số dòng | Khoảng năm | Đơn vị tiền tệ chính |
|---|---:|---:|---|
| Việt Nam | 3.359 | 2018–2026 | VND |
| Malaysia | 1.922 | 2017–2026 | MYR |

> Giá được giữ theo tiền tệ gốc của từng nguồn. Không so sánh trực tiếp trị số VND và MYR nếu chưa quy đổi tỷ giá.

## Cấu trúc thư mục

```text
fuel-e10-project/
├── database/
│   └── fuel_e10_lab.sqlite
├── data_clean/
│   ├── lab2_fuel_e10_dataset.csv
│   └── lab2_fuel_e10_dataset_sample_5000.csv
├── data_raw/
│   ├── *.csv
│   ├── *.html
│   ├── *.txt
│   ├── *.xlsx
│   └── *.jpg
├── figures/
├── report/
│   ├── data_dictionary.csv
│   ├── quality_summary.csv
│   ├── source_catalog.csv
│   ├── sql_country_fuel_summary.csv
│   └── sql_vietnam_fuel_trend.csv
├── sql/
│   ├── 01_import_merge_crawled_files.sql
│   ├── 02_phase2_sql_analysis_queries.sql
│   └── lab2_queries.sql
└── README.md
```

### `database/`

`fuel_e10_lab.sqlite` là cơ sở dữ liệu SQLite dựng sẵn, phù hợp để xem và truy vấn nhanh mà không cần chạy lại pipeline. Cơ sở dữ liệu gồm các bảng:

| Bảng | Số dòng | Nội dung |
|---|---:|---|
| `fuel_prices_clean` | 5.281 | Tập dữ liệu giá nhiên liệu đã chuẩn hóa |
| `policy_documents` | 4 | Nội dung văn bản chính sách E10 |
| `source_status` | 9 | Trạng thái thu thập từng nguồn |
| `source_catalog` | 6 | Danh mục và vai trò của nguồn |
| `data_dictionary` | 23 | Mô tả các cột dữ liệu |
| `quality_summary` | 14 | Chỉ số chất lượng dữ liệu |

### `data_clean/`

- `lab2_fuel_e10_dataset.csv`: tập dữ liệu sạch đầy đủ, 5.281 dòng.
- `lab2_fuel_e10_dataset_sample_5000.csv`: mẫu 5.000 dòng để xem hoặc thử nghiệm nhanh.

### `data_raw/`

Thư mục chứa dữ liệu tải về và kết quả chuẩn hóa trung gian:

| Nhóm tệp | Nội dung |
|---|---|
| `petrolimex_e10_raw.csv` | 2 mức giá E10 RON95-V từ thông báo chính thức Petrolimex |
| `raw_petrolimex_oilprice.csv` | Dữ liệu giá lịch sử Petrolimex ở định dạng nguồn |
| `raw_pvoil_oilprice.csv` | Dữ liệu giá lịch sử PVOIL ở định dạng nguồn |
| `vietnam_fuel_prices_kaggle_standardized.csv` | 3.357 dòng dữ liệu Việt Nam đã chuẩn hóa |
| `malaysia_fuelprice.csv` | Dữ liệu gốc từ Malaysia Open Data |
| `malaysia_fuelprice_standardized.csv` | 1.922 dòng dữ liệu Malaysia đã chuẩn hóa |
| `Global_Fuel_Prices_Database.xlsx` | Tệp Excel gốc của World Bank |
| `worldbank_global_fuel_prices_raw.csv` | Dữ liệu World Bank sau khi đọc từ workbook |
| `germany_petrol_station_prices_raw_sample.csv` | Mẫu 100.000 dòng từ dữ liệu trạm xăng Đức |
| `*_standardized.csv` | Các tệp có schema chung để nhập vào tầng staging |
| `*_article.html`, `*.txt` | Trang gốc và văn bản trích xuất về chính sách E10 |
| `petrolimex_e10_ron95v_official_image.jpg` | Ảnh dùng làm nguồn dự phòng cho mức giá chính thức |
| `source_status.csv` | Nhật ký kết quả thu thập dữ liệu |

Hai tệp sau hiện chỉ có header, chưa có dòng dữ liệu chuẩn hóa:

- `worldbank_global_fuel_prices_standardized.csv`
- `germany_petrol_station_prices_standardized.csv`

Vì vậy, tập dữ liệu sạch hiện chỉ chứa quan sát từ Việt Nam và Malaysia. Dữ liệu World Bank và Đức vẫn được giữ ở tầng raw để tiếp tục xử lý.

### `report/`

- `data_dictionary.csv`: mô tả 23 trường dữ liệu.
- `quality_summary.csv`: các chỉ số kiểm tra chất lượng.
- `source_catalog.csv`: URL, phương pháp thu thập và vai trò của từng nguồn.
- `sql_country_fuel_summary.csv`: thống kê theo quốc gia và nhóm nhiên liệu.
- `sql_vietnam_fuel_trend.csv`: xu hướng giá Việt Nam theo năm, tháng và nhóm nhiên liệu.

### `sql/`

- `lab2_queries.sql`: 8 truy vấn dùng cú pháp SQLite (`LIMIT`, tên bảng không có schema).
- `01_import_merge_crawled_files.sql`: tạo database, staging/clean schema, nhập CSV, làm sạch, gộp dữ liệu và tạo index trên SQL Server.
- `02_phase2_sql_analysis_queries.sql`: 12 truy vấn phân tích và kiểm tra chất lượng trên SQL Server.

### `figures/`

Thư mục dành cho biểu đồ hoặc hình ảnh đầu ra; hiện chưa có tệp.

## Nguồn dữ liệu

| Nguồn | Vai trò |
|---|---|
| Petrolimex | Giá E10 chính thức tại Việt Nam |
| Kaggle – Weekly Fuel Prices in Vietnam | Lịch sử giá Petrolimex và PVOIL |
| Bộ Công Thương Việt Nam | Văn bản và giải thích chính sách E10 |
| Báo Chính phủ | Thông tin triển khai E10 toàn quốc |
| World Bank Global Fuel Prices Database | Nguồn so sánh quốc tế |
| Malaysia Open Data | Dữ liệu so sánh khu vực |
| German Petrol Station Data (Kaggle) | Nguồn E10 quốc tế tùy chọn |

URL cụ thể và phương pháp thu thập được lưu trong `report/source_catalog.csv` và `data_raw/source_status.csv`.

## Schema dữ liệu sạch

| Cột | Kiểu logic | Mô tả |
|---|---|---|
| `row_id` | integer | Mã dòng duy nhất |
| `company` | text | Doanh nghiệp hoặc nhà cung cấp dữ liệu |
| `country` | text | Quốc gia của quan sát |
| `product` | text | Tên sản phẩm nhiên liệu |
| `product_normalized` | text | Tên sản phẩm đã chuyển về chữ thường |
| `fuel_family` | text | Nhóm E10, E5, RON95+, RON97, Diesel, Kerosene hoặc Other |
| `region` | text | Khu vực hoặc vùng giá |
| `effective_datetime` | datetime | Thời điểm mức giá có hiệu lực |
| `year`, `month`, `day` | integer | Thành phần thời gian được tách ra |
| `price_local_per_litre` | numeric | Giá theo tiền tệ địa phương trên lít hoặc đơn vị nguồn công bố |
| `currency` | text | Mã tiền tệ |
| `unit` | text | Đơn vị đo |
| `delta_local_per_litre` | numeric | Mức thay đổi so với kỳ trước, nếu có |
| `has_delta` | boolean | Có dữ liệu thay đổi giá hay không |
| `is_e10`, `is_e5`, `is_diesel` | boolean | Cờ nhận dạng nhóm nhiên liệu |
| `price_band` | text | Phân khúc giá đơn giản |
| `source_name` | text | Tên nguồn |
| `source_url` | text | URL nguồn |
| `extraction_method` | text | Phương pháp trích xuất |

Trong file SQLite, `effective_datetime` được lưu dưới dạng Unix timestamp theo giây. Có thể chuyển thành ngày giờ bằng hàm `datetime(effective_datetime, 'unixepoch')`.

## Bắt đầu nhanh với SQLite

Yêu cầu: cài SQLite CLI, DBeaver, DB Browser for SQLite hoặc một công cụ tương đương.

Từ thư mục gốc của dự án:

```powershell
sqlite3 .\database\fuel_e10_lab.sqlite
```

Trong SQLite shell:

```sql
.tables
.headers on
.mode column

SELECT
    country,
    fuel_family,
    COUNT(*) AS n_rows,
    ROUND(AVG(price_local_per_litre), 2) AS avg_price
FROM fuel_prices_clean
GROUP BY country, fuel_family
ORDER BY country, fuel_family;
```

Để chạy toàn bộ truy vấn Lab 2:

```powershell
sqlite3 -header -column .\database\fuel_e10_lab.sqlite ".read sql/lab2_queries.sql"
```

Ví dụ xem xu hướng E10 tại Việt Nam:

```sql
SELECT
    year,
    month,
    COUNT(*) AS n_rows,
    ROUND(AVG(price_local_per_litre), 2) AS avg_vnd_price
FROM fuel_prices_clean
WHERE country = 'Vietnam' AND fuel_family = 'E10'
GROUP BY year, month
ORDER BY year, month;
```

## Chạy với SQL Server và SSMS

### Yêu cầu

- Microsoft SQL Server 2017 trở lên nếu dùng `BULK INSERT ... FORMAT = 'CSV'`.
- SQL Server Management Studio (SSMS).
- Tài khoản dịch vụ SQL Server có quyền đọc thư mục dự án nếu dùng `BULK INSERT`.

### Quy trình

1. Mở `sql/01_import_merge_crawled_files.sql` trong SSMS và chạy lần đầu để tạo database `FuelE10Lab2`, schema `staging`, schema `clean` và các staging table.
2. Nhập 9 tệp CSV vào staging bằng SSMS Import Data/Import Flat File Wizard, hoặc sửa hai biến trong script:

   ```sql
   DECLARE @RunBulkInsert BIT = 1;
   DECLARE @ProjectRoot NVARCHAR(4000) = N'D:\duong-dan\fuel-e10-project';
   ```

3. Nếu dùng wizard, ánh xạ các tệp như sau:

   | Tệp | Bảng staging |
   |---|---|
   | `data_raw/petrolimex_e10_raw.csv` | `staging.stg_petrolimex_e10` |
   | `data_raw/vietnam_fuel_prices_kaggle_standardized.csv` | `staging.stg_vietnam_fuel_kaggle` |
   | `data_raw/malaysia_fuelprice_standardized.csv` | `staging.stg_malaysia_fuel` |
   | `data_raw/worldbank_global_fuel_prices_standardized.csv` | `staging.stg_worldbank_fuel` |
   | `data_raw/germany_petrol_station_prices_standardized.csv` | `staging.stg_germany_fuel` |
   | `data_raw/source_status.csv` | `staging.stg_source_status` |
   | `report/source_catalog.csv` | `staging.stg_source_catalog` |
   | `report/data_dictionary.csv` | `staging.stg_data_dictionary` |
   | `report/quality_summary.csv` | `staging.stg_quality_summary` |

4. Chạy lại toàn bộ `01_import_merge_crawled_files.sql`. Script sẽ dựng lại các bảng clean, chuyển kiểu an toàn, loại giá rỗng/không dương, loại dòng thiếu `country` hoặc `product`, khử trùng lặp và tạo index.
5. Chạy `sql/02_phase2_sql_analysis_queries.sql` để thực hiện phân tích và kiểm tra chất lượng.

> Khi `@RunBulkInsert = 1`, script sẽ `TRUNCATE` các staging table trước khi nhập lại nhằm tránh nhân đôi dữ liệu. Khi bằng `0`, dữ liệu staging được giữ nguyên nhưng clean layer vẫn được dựng lại.

## Quy tắc làm sạch chính

1. Hợp nhất năm nguồn giá chuẩn hóa bằng `UNION ALL`.
2. Xóa khoảng trắng và chuyển chuỗi rỗng thành `NULL`.
3. Chuyển kiểu ngày, giá và mức thay đổi bằng `TRY_CONVERT`.
4. Nhận dạng `fuel_family` từ tên sản phẩm.
5. Loại dòng có giá rỗng, giá không dương, thiếu quốc gia hoặc thiếu sản phẩm.
6. Khử trùng lặp theo doanh nghiệp, quốc gia, sản phẩm, vùng, thời điểm, giá và nguồn.
7. Sinh lại `row_id` và các cờ `is_e10`, `is_e5`, `is_diesel`.
8. Tạo index theo quốc gia, nhóm nhiên liệu, thời gian và nguồn.

## Kiểm tra kết quả

Với SQLite:

```sql
SELECT COUNT(*) AS n_rows FROM fuel_prices_clean;

SELECT COUNT(*) AS invalid_prices
FROM fuel_prices_clean
WHERE price_local_per_litre IS NULL
   OR price_local_per_litre <= 0;

SELECT country, COUNT(*) AS n_rows
FROM fuel_prices_clean
GROUP BY country;
```

Kết quả kỳ vọng theo snapshot hiện tại:

- `n_rows = 5281`
- `invalid_prices = 0`
- Việt Nam: 3.359 dòng
- Malaysia: 1.922 dòng

## Lưu ý

- Repository hiện cung cấp dữ liệu và SQL; không có script thu thập/chuyển đổi nguồn để tái tạo toàn bộ pipeline từ đầu.
- `lab2_queries.sql` dành cho SQLite, còn hai file có tiền tố `01_` và `02_` dùng T-SQL cho SQL Server.
- Dữ liệu giá dùng nhiều tiền tệ; các báo cáo so sánh cần nhóm theo `currency` hoặc quy đổi về cùng một đồng tiền.
- Tệp raw có thể lớn và có schema phức tạp; nên ưu tiên `data_clean/lab2_fuel_e10_dataset.csv` hoặc database SQLite cho phân tích.
- Thống kê trong tài liệu phản ánh các tệp đang có trong thư mục tại thời điểm README được tạo.
