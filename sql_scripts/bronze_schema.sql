USE ZOMATO_DB.ZOMATO_BRONZE_SCHEMA;
CREATE STAGE IF NOT EXISTS ZOMATO_RAW_DATA DIRECTORY=(ENABLE = TRUE);
PUT file:///Users/chrysocolla/repos/zomato_data_pipeline/data/zomato_master_data.csv @ZOMATO_RAW_DATA AUTO_COMPRESS=TRUE;

LIST @ZOMATO_RAW_DATA;

CREATE OR REPLACE FILE FORMAT csv_file_format
  TYPE = 'CSV'
  FIELD_DELIMITER = ','
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  TRIM_SPACE = TRUE
  EMPTY_FIELD_AS_NULL = TRUE
  SKIP_HEADER = 1;

CREATE OR REPLACE TABLE BRONZE_ZOMATO_BASE (
  amount         DECIMAL(10,2),
  payment_mode   STRING,
  order_status   STRING,
  cust_name      STRING,
  cust_email     STRING,
  cust_phone     STRING,
  cust_city      STRING,
  signup_date    DATE,
  name_rest      STRING,
  city_rest      STRING,
  cuisine        STRING,
  name_del       STRING,
  vehicle_type   STRING,
  city_del       STRING,
  phone_del      STRING
);

COPY INTO BRONZE_ZOMATO_BASE
FROM @ZOMATO_RAW_DATA
FILE_FORMAT = (
    FORMAT_NAME = csv_file_format
    DATE_FORMAT = 'DD/MM/YY'
) 
ON_ERROR='CONTINUE';

SELECT * FROM BRONZE_ZOMATO_BASE;

-- CHECK THE COLS 
DESCRIBE TABLE BRONZE_ZOMATO_BASE;