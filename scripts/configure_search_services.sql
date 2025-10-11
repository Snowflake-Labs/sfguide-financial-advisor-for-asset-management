-- =====================================================
-- Run this script after setup.sql and uploading the PDFs to the stage
-- =====================================================

USE ROLE ACCOUNTADMIN;
USE DATABASE FINANCIAL_ADVISOR_DEMO_DB;
USE SCHEMA ANALYTICS;
USE WAREHOUSE FINANCIAL_ADVISOR_DEMO_WH;

-- =====================================================
-- Cortex Search Setup
-- =====================================================

  -- Equity Research Reports Table
CREATE OR REPLACE TABLE EQUITY_RESEARCH_DOCUMENTS (
    file_name STRING,
    company_ticker STRING,
    report_date STRING,
    content VARIANT
);

-- Fed Documents Table  
CREATE OR REPLACE TABLE FED_DOCUMENTS (
    file_name STRING,
    document_type STRING,
    content VARIANT
);

-- 10-K Excerpts Table
CREATE OR REPLACE TABLE TENK_EXCERPTS_DOCUMENTS (
    file_name STRING,
    company_ticker STRING,
    filing_year STRING,
    content VARIANT
);

-- Market Commentary Table
CREATE OR REPLACE TABLE MARKET_COMMENTARY_DOCUMENTS (
    file_name STRING,
    publication_date STRING,
    content VARIANT
);

-- =====================================================
-- RESIZE WAREHOUSE FOR UNSTRUCTURED DATA PROCESSING
-- =====================================================

-- Resize warehouse to Large for faster processing of unstructured data
ALTER WAREHOUSE FINANCIAL_ADVISOR_DEMO_WH SET WAREHOUSE_SIZE = '2X-LARGE';

-- =====================================================
-- PARSE PDF DOCUMENTS FROM UNSTRUCTURED PDF STAGE
-- =====================================================

-- Extract Equity Research Reports
INSERT INTO EQUITY_RESEARCH_DOCUMENTS (file_name, company_ticker, report_date, content)
SELECT 
    relative_path AS file_name,
    SPLIT_PART(SPLIT_PART(relative_path, '_', 3), '.', 1) AS company_ticker,
    SPLIT_PART(SPLIT_PART(relative_path, '_', 4), '.', 1) AS report_date,
    SNOWFLAKE.CORTEX.PARSE_DOCUMENT('@FINANCIAL_ADVISOR_STAGE', relative_path, {'mode': 'LAYOUT'}) AS content
FROM DIRECTORY('@FINANCIAL_ADVISOR_STAGE')
WHERE relative_path LIKE 'equity_research_%';

-- Extract Fed Documents
INSERT INTO FED_DOCUMENTS (file_name, document_type, content)
SELECT 
    relative_path AS file_name,
    'FOMC_Minutes' AS document_type,
    SNOWFLAKE.CORTEX.PARSE_DOCUMENT('@FINANCIAL_ADVISOR_STAGE', relative_path, {'mode': 'LAYOUT'}) AS content
FROM DIRECTORY('@FINANCIAL_ADVISOR_STAGE')
WHERE relative_path LIKE 'Fed_%';

-- Extract 10-K Excerpts
INSERT INTO TENK_EXCERPTS_DOCUMENTS (file_name, company_ticker, filing_year, content)
SELECT 
    relative_path AS file_name,
    SPLIT_PART(relative_path, '_', 1) AS company_ticker,
    SPLIT_PART(SPLIT_PART(relative_path, '_', 3), '.', 1) AS filing_year,
    SNOWFLAKE.CORTEX.PARSE_DOCUMENT('@FINANCIAL_ADVISOR_STAGE', relative_path, {'mode': 'LAYOUT'}) AS content
FROM DIRECTORY('@FINANCIAL_ADVISOR_STAGE')
WHERE relative_path LIKE '%_10K_excerpts_%';

-- Extract Market Commentary
INSERT INTO MARKET_COMMENTARY_DOCUMENTS (file_name, publication_date, content)
SELECT 
    relative_path AS file_name,
    SPLIT_PART(SPLIT_PART(relative_path, '_', 3), '.', 1) AS publication_date,
    SNOWFLAKE.CORTEX.PARSE_DOCUMENT('@FINANCIAL_ADVISOR_STAGE', relative_path, {'mode': 'LAYOUT'}) AS content
FROM DIRECTORY('@FINANCIAL_ADVISOR_STAGE')
WHERE relative_path LIKE 'market_commentary_%';


-- =====================================================
-- CHUNKING OPERATIONS FOR CORTEX SEARCH SERVICES
-- =====================================================

-- Create Equity Research Chunks Table
CREATE OR REPLACE TABLE EQUITY_RESEARCH_CHUNKS (
    original_file_name STRING,
    company_ticker STRING,
    report_date STRING,
    chunk_id INTEGER,
    chunk_text STRING
);

-- Chunk Equity Research Documents
INSERT INTO EQUITY_RESEARCH_CHUNKS (original_file_name, company_ticker, report_date, chunk_id, chunk_text)
SELECT 
    e.file_name,
    e.company_ticker,
    e.report_date,
    ROW_NUMBER() OVER (PARTITION BY e.file_name ORDER BY chunks.index) AS chunk_id,
    chunks.value::STRING AS chunk_text
FROM EQUITY_RESEARCH_DOCUMENTS e,
LATERAL FLATTEN(
    SNOWFLAKE.CORTEX.SPLIT_TEXT_RECURSIVE_CHARACTER(
        e.content:content::STRING,
        'none',
        1500,
        200
    )
) AS chunks;

-- Create Fed Documents Chunks Table
CREATE OR REPLACE TABLE FED_DOCUMENTS_CHUNKS (
    original_file_name STRING,
    document_type STRING,
    chunk_id INTEGER,
    chunk_text STRING
);

-- Chunk Fed Documents
INSERT INTO FED_DOCUMENTS_CHUNKS (original_file_name, document_type, chunk_id, chunk_text)
SELECT 
    f.file_name,
    f.document_type,
    ROW_NUMBER() OVER (PARTITION BY f.file_name ORDER BY chunks.index) AS chunk_id,
    chunks.value::STRING AS chunk_text
FROM FED_DOCUMENTS f,
LATERAL FLATTEN(
    SNOWFLAKE.CORTEX.SPLIT_TEXT_RECURSIVE_CHARACTER(
        f.content:content::STRING,
        'none',
        1500,
        200
    )
) AS chunks;

-- Create 10-K Excerpts Chunks Table
CREATE OR REPLACE TABLE TENK_EXCERPTS_CHUNKS (
    original_file_name STRING,
    company_ticker STRING,
    filing_year STRING,
    chunk_id INTEGER,
    chunk_text STRING
);

-- Chunk 10-K Excerpts Documents
INSERT INTO TENK_EXCERPTS_CHUNKS (original_file_name, company_ticker, filing_year, chunk_id, chunk_text)
SELECT 
    t.file_name,
    t.company_ticker,
    t.filing_year,
    ROW_NUMBER() OVER (PARTITION BY t.file_name ORDER BY chunks.index) AS chunk_id,
    chunks.value::STRING AS chunk_text
FROM TENK_EXCERPTS_DOCUMENTS t,
LATERAL FLATTEN(
    SNOWFLAKE.CORTEX.SPLIT_TEXT_RECURSIVE_CHARACTER(
        t.content:content::STRING,
        'none',
        1500,
        200
    )
) AS chunks;

-- Create Market Commentary Chunks Table
CREATE OR REPLACE TABLE MARKET_COMMENTARY_CHUNKS (
    original_file_name STRING,
    publication_date STRING,
    chunk_id INTEGER,
    chunk_text STRING
);

-- Chunk Market Commentary Documents
INSERT INTO MARKET_COMMENTARY_CHUNKS (original_file_name, publication_date, chunk_id, chunk_text)
SELECT 
    m.file_name,
    m.publication_date,
    ROW_NUMBER() OVER (PARTITION BY m.file_name ORDER BY chunks.index) AS chunk_id,
    chunks.value::STRING AS chunk_text
FROM MARKET_COMMENTARY_DOCUMENTS m,
LATERAL FLATTEN(
    SNOWFLAKE.CORTEX.SPLIT_TEXT_RECURSIVE_CHARACTER(
        m.content:content::STRING,
        'none',
        1500,
        200
    )
) AS chunks;

-- Resize warehouse back to X-Small to optimize costs after processing
ALTER WAREHOUSE FINANCIAL_ADVISOR_DEMO_WH SET WAREHOUSE_SIZE = 'X-SMALL';

-- =====================================================
-- CREATE CORTEX SEARCH SERVICES
-- =====================================================

-- Equity Research Search Service
-- Equity Research Search Service
CREATE OR REPLACE CORTEX SEARCH SERVICE EQUITY_RESEARCH_SEARCH_SERVICE
    ON CHUNK_TEXT
    ATTRIBUTES COMPANY_TICKER, REPORT_DATE, ORIGINAL_FILE_NAME, CHUNK_ID
    WAREHOUSE = FINANCIAL_ADVISOR_DEMO_WH
    TARGET_LAG = '1 hour'
    AS (
        SELECT CHUNK_TEXT, COMPANY_TICKER, REPORT_DATE, ORIGINAL_FILE_NAME, CHUNK_ID
        FROM EQUITY_RESEARCH_CHUNKS
    );

-- Client Transcripts Search Service
CREATE OR REPLACE CORTEX SEARCH SERVICE CLIENT_TRANSCRIPTS_SEARCH_SERVICE
    ON TRANSCRIPT_TEXT
    ATTRIBUTES CLIENT_ID, CALL_DURATION, CALL_DATE
    WAREHOUSE = FINANCIAL_ADVISOR_DEMO_WH
    TARGET_LAG = '1 hour'
    AS (
        SELECT TRANSCRIPT_TEXT, CLIENT_ID, CALL_DURATION, CALL_DATE
        FROM CLIENT_CALL_TRANSCRIPTS_UNSTRUCTURED
    );

-- Federal Reserve Documents Search Service
CREATE OR REPLACE CORTEX SEARCH SERVICE FED_DOCUMENTS_SEARCH_SERVICE
    ON CHUNK_TEXT
    ATTRIBUTES DOCUMENT_TYPE, ORIGINAL_FILE_NAME, CHUNK_ID
    WAREHOUSE = FINANCIAL_ADVISOR_DEMO_WH
    TARGET_LAG = '1 hour'
    AS (
        SELECT CHUNK_TEXT, DOCUMENT_TYPE, ORIGINAL_FILE_NAME, CHUNK_ID
        FROM FED_DOCUMENTS_CHUNKS
    );

-- Market Commentary Search Service
CREATE OR REPLACE CORTEX SEARCH SERVICE MARKET_COMMENTARY_SEARCH_SERVICE
    ON CHUNK_TEXT
    ATTRIBUTES PUBLICATION_DATE, ORIGINAL_FILE_NAME, CHUNK_ID
    WAREHOUSE = FINANCIAL_ADVISOR_DEMO_WH
    TARGET_LAG = '1 hour'
    AS (
        SELECT CHUNK_TEXT, PUBLICATION_DATE, ORIGINAL_FILE_NAME, CHUNK_ID
        FROM MARKET_COMMENTARY_CHUNKS
    );

-- 10-K Excerpts Search Service
CREATE OR REPLACE CORTEX SEARCH SERVICE TENK_EXCERPTS_SEARCH_SERVICE
    ON CHUNK_TEXT
    ATTRIBUTES COMPANY_TICKER, FILING_YEAR, ORIGINAL_FILE_NAME, CHUNK_ID
    WAREHOUSE = FINANCIAL_ADVISOR_DEMO_WH
    TARGET_LAG = '1 hour'
    AS (
        SELECT CHUNK_TEXT, COMPANY_TICKER, FILING_YEAR, ORIGINAL_FILE_NAME, CHUNK_ID
        FROM TENK_EXCERPTS_CHUNKS
    );
