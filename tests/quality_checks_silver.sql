/*
================================================================================
Quality Checks
================================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' schema. It includes checks for:

    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
================================================================================
*/


-- ============================================================================
-- Checking 'silver.crm_cust_info'
-- ============================================================================

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results

SELECT
    cst_id,
    COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;


-- Check for Unwanted Spaces
-- Expectation: No Results

SELECT
    cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);


SELECT
    cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);


SELECT
    cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);


-- Check Data Standardization & Consistency
-- Expectation: Only 'Single', 'Married', or 'n/a'

SELECT DISTINCT
    cst_marital_status
FROM silver.crm_cust_info;


-- Check Gender Standardization
-- Expectation: Only 'Male', 'Female', or 'n/a'

SELECT DISTINCT
    cst_gndr
FROM silver.crm_cust_info;


-- ============================================================================
-- Checking 'silver.crm_prd_info'
-- ============================================================================

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results

SELECT
    prd_id,
    COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;


-- Check for Unwanted Spaces
-- Expectation: No Results

SELECT
    prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);


-- Check for NULL Product Cost
-- Expectation: No Results

SELECT
    prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL;


-- Check Data Standardization & Consistency
-- Expectation: Only valid product lines

SELECT DISTINCT
    prd_line
FROM silver.crm_prd_info;


-- Check Invalid Date Order
-- Expectation: No Results

SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;


-- ============================================================================
-- Checking 'silver.crm_sales_details'
-- ============================================================================

-- Check for NULLs in Customer/Product Keys
-- Expectation: No Results

SELECT *
FROM silver.crm_sales_details
WHERE sls_cust_id IS NULL
   OR sls_prd_key IS NULL;


-- Check Invalid Order Dates
-- Expectation: No Results

SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt IS NULL;


-- Check Invalid Date Order
-- Expectation: No Results

SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;


-- Check Sales Calculation
-- Expectation: No Results

SELECT *
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * ABS(sls_price);


-- Check for Invalid Quantity
-- Expectation: No Results

SELECT *
FROM silver.crm_sales_details
WHERE sls_quantity <= 0;


-- Check for Invalid Price
-- Expectation: No Results

SELECT *
FROM silver.crm_sales_details
WHERE sls_price <= 0;


-- ============================================================================
-- Checking 'silver.erp_cust_az12'
-- ============================================================================

-- Check for NULL Customer IDs
-- Expectation: No Results

SELECT *
FROM silver.erp_cust_az12
WHERE cid IS NULL;


-- Identify Out-of-Range Dates
-- Expectation: Birthdates between 1924-01-01 and Today

SELECT DISTINCT
    bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01'
   OR bdate > GETDATE();


-- Data Standardization & Consistency
-- Expectation: Only 'Male', 'Female', or 'n/a'

SELECT DISTINCT
    gen
FROM silver.erp_cust_az12;


-- ============================================================================
-- Checking 'silver.erp_loc_a101'
-- ============================================================================

-- Data Standardization & Consistency

SELECT DISTINCT
    cntry
FROM silver.erp_loc_a101
ORDER BY cntry;


-- Check for Unwanted Spaces
-- Expectation: No Results

SELECT *
FROM silver.erp_loc_a101
WHERE cntry != TRIM(cntry);


-- ============================================================================
-- Checking 'silver.erp_px_cat_g1v2'
-- ============================================================================

-- Check for Unwanted Spaces
-- Expectation: No Results

SELECT *
FROM silver.erp_px_cat_g1v2
WHERE id != TRIM(id)
   OR ct != TRIM(ct)
   OR subcat != TRIM(subcat)
   OR maintenance != TRIM(maintenance);


-- Data Standardization & Consistency

SELECT DISTINCT
    ct,
    subcat,
    maintenance
FROM silver.erp_px_cat_g1v2
ORDER BY ct, subcat;


-- ============================================================================
-- End of Quality Checks
-- ============================================================================
