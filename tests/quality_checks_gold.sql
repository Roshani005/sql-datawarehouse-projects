
/*
===============================================================================
Quality Checks: Gold Layer
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity,
    consistency, and accuracy of the Gold layer.

    These checks validate:
        - Uniqueness of surrogate keys in dimension views.
        - Referential integrity between fact and dimension views.
        - Validity of relationships in the data model.

Objects Tested:
    - gold.dim_customers
    - gold.dim_products
    - gold.fact_sales

Usage Notes:
    - Run these checks after loading the Silver layer and creating Gold views.
    - Investigate and resolve any discrepancies found.
    - Expected results are documented for each check.
===============================================================================
*/


/*
===============================================================================
1. Checking gold.dim_customers
===============================================================================
Check:
    Verify uniqueness of customer_key.

Expectation:
    No results.
===============================================================================
*/

SELECT
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;
GO


/*
===============================================================================
2. Checking gold.dim_products
===============================================================================
Check:
    Verify uniqueness of product_key.

Expectation:
    No results.
===============================================================================
*/

SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;
GO


/*
===============================================================================
3. Checking gold.fact_sales
===============================================================================
Check:
    Validate relationships between fact_sales and its dimensions.

Expectation:
    No results for unmatched customer or product keys.
===============================================================================
*/

SELECT
    f.order_number,
    f.customer_key,
    f.product_key
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
    ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products AS p
    ON p.product_key = f.product_key
WHERE
    (f.customer_key IS NOT NULL AND c.customer_key IS NULL)
    OR
    (f.product_key IS NOT NULL AND p.product_key IS NULL);
GO


/*
===============================================================================
4. Checking Missing Dimension Keys in gold.fact_sales
===============================================================================
Check:
    Identify sales records without a matching customer or product.

Expectation:
    Review any returned rows. Missing keys may indicate unmatched source data.
===============================================================================
*/

SELECT
    order_number,
    customer_key,
    product_key
FROM gold.fact_sales
WHERE
    customer_key IS NULL
    OR product_key IS NULL;
GO


/*
===============================================================================
5. Checking NULL Customer Keys in gold.dim_customers
===============================================================================
Check:
    Identify customer dimension records with missing surrogate keys.

Expectation:
    No results.
===============================================================================
*/

SELECT *
FROM gold.dim_customers
WHERE customer_key IS NULL;
GO


/*
===============================================================================
6. Checking NULL Product Keys in gold.dim_products
===============================================================================
Check:
    Identify product dimension records with missing surrogate keys.

Expectation:
    No results.
===============================================================================
*/

SELECT *
FROM gold.dim_products
WHERE product_key IS NULL;
GO


/*
===============================================================================
7. Checking NULL Sales Measures in gold.fact_sales
===============================================================================
Check:
    Identify sales records with missing sales amounts or quantities.

Expectation:
    Investigate any returned rows according to business rules.
===============================================================================
*/

SELECT
    order_number,
    sales_amount,
    quantity,
    price
FROM gold.fact_sales
WHERE
    sales_amount IS NULL
    OR quantity IS NULL
    OR price IS NULL;
GO


/*
===============================================================================
8. Checking Invalid Sales Values in gold.fact_sales
===============================================================================
Check:
    Identify negative quantities or prices.

Expectation:
    Review returned rows. Negative values may represent returns or corrections.
===============================================================================
*/

SELECT
    order_number,
    sales_amount,
    quantity,
    price
FROM gold.fact_sales
WHERE
    quantity < 0
    OR price < 0
    OR sales_amount < 0;
GO


/*
===============================================================================
9. Checking Invalid Product Costs in gold.dim_products
===============================================================================
Check:
    Identify negative product costs.

Expectation:
    No results unless negative costs are valid under business rules.
===============================================================================
*/

SELECT
    product_id,
    product_number,
    product_name,
    cost
FROM gold.dim_products
WHERE cost < 0;
GO


/*
===============================================================================
10. Checking Duplicate Customer Business IDs
===============================================================================
Check:
    Verify that each customer_id appears only once in the customer dimension.

Expectation:
    No results if customer_id is intended to be unique.
===============================================================================
*/

SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
GO


/*
===============================================================================
11. Checking Duplicate Product Business IDs
===============================================================================
Check:
    Verify that each product_number appears only once in the product dimension.

Expectation:
    No results if product_number is intended to be unique.
===============================================================================
*/

SELECT
    product_number,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_number
HAVING COUNT(*) > 1;
GO


/*
===============================================================================
End of Gold Layer Quality Checks
===============================================================================
*/
