USE amazon_sales_2025;
SELECT * FROM amazon;

SELECT
    ROUND(SUM(TotalAmount), 2) AS total_revenue
FROM amazon;

SELECT
    COUNT(DISTINCT CustomerID) AS total_customer
FROM amazon;

SELECT
    COUNT(DISTINCT SellerID) AS total_sellers
FROM amazon;

SELECT
    COUNT(DISTINCT OrderID) AS total_orders
FROM amazon;

-- Products average discount, average shipping cost, total orders, total units sold 
SELECT 
    ProductID,
    ProductName,
    ROUND(AVG(Discount) * 100, 2) AS avg_discount_pct,
    ROUND(AVG(ShippingCost), 2) AS avg_shipping_cost,
    COUNT(DISTINCT OrderID) AS total_orders,
    SUM(Quantity) AS total_units_sold
FROM amazon
GROUP BY ProductID, ProductName
ORDER BY total_units_sold DESC;

-- Brand's Total Orders and Total Revenue
SELECT 
    Brand,
    COUNT(DISTINCT OrderID) AS total_orders,
    SUM(TotalAmount) AS total_revenue
FROM 
    amazon
GROUP BY 
    Brand;

-- Category Revenue
WITH all_category_revenue AS(
    SELECT 
        Category,
        COUNT(DISTINCT OrderID) AS total_orders,
        SUM(TotalAmount) AS category_revenue
    FROM amazon 
    GROUP BY Category
) 
SELECT
	Category,
    total_orders,
    ROUND(category_revenue, 2) AS total_revenue,
    DENSE_RANK() OVER(ORDER BY category_revenue DESC) AS revenue_rank
FROM 
    all_category_revenue
ORDER BY 
    revenue_rank;
    
-- Country 

SELECT
    Country,
    COUNT(DISTINCT CustomerID) AS total_customers,
    COUNT(DISTINCT OrderID) AS total_orders,
    SUM(Quantity) AS total_quantity_sold,
    COUNT(DISTINCT SellerID) AS total_sellers,
    SUM(Tax) AS tax_amount_paid,
    SUM(TotalAmount) AS total_revenue
FROM amazon
GROUP BY Country
ORDER BY total_revenue;
    
-- State
SELECT
    State,
    ROUND(AVG(ShippingCost), 2) AS avg_shipping_cost,
    ROUND(AVG(Tax), 2) AS avg_tax,
    ROUND(SUM(TotalAmount), 2) AS total_revenue
FROM amazon
GROUP BY State
ORDER BY total_revenue DESC;

SELECT
    YEAR(OrderDate) AS order_year,
    MONTH(OrderDate) AS order_month,
    COUNT(DISTINCT OrderID) AS total_orders,
    SUM(Quantity) AS total_units_sold,
    SUM(TotalAmount) AS total_revenue
FROM amazon
GROUP BY order_year, order_month
ORDER BY order_year, order_month;

-- Yearly Review
SELECT
    YEAR(OrderDate) AS order_year,
    SUM(TotalAmount) AS total_revenue,
    DENSE_RANK() OVER(ORDER BY SUM(TotalAmount) DESC) AS revenue_ranking
FROM amazon
GROUP BY order_year
ORDER BY order_year DESC;

-- Sellers
SELECT
    SellerID,
    COUNT(DISTINCT OrderID) AS total_orders,
    SUM(Quantity) AS total_units_sold,
    ROUND(SUM(TotalAmount), 2) AS total_revenue
FROM amazon
GROUP BY SellerID
ORDER BY total_revenue DESC;

-- Payment Method
SELECT
    PaymentMethod,
    COUNT(DISTINCT CustomerID) AS total_customer_count,
    COUNT(DISTINCT OrderID) AS total_orders,
    ROUND(AVG(TotalAmount), 2) AS avg_amount,
    ROUND(SUM(TotalAmount), 2) AS total_amount
FROM amazon
GROUP BY PaymentMethod
ORDER BY total_orders;

-- Order Status
SELECT
    OrderStatus,
    COUNT(DISTINCT OrderID) AS total_orders,
    SUM(TotalAmount) AS revenue
FROM amazon
GROUP BY OrderStatus
ORDER BY total_orders DESC;

SELECT
    CASE 
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount < 0.10 THEN 'Low (0–10%)'
        WHEN Discount < 0.30 THEN 'Medium (10–30%)'
        ELSE 'High (30%+)'
    END AS discount_band,
    COUNT(DISTINCT OrderID) AS total_orders,
    SUM(TotalAmount) AS revenue
FROM amazon
GROUP BY discount_band
ORDER BY revenue DESC;

SELECT
    Category,
    ROUND(SUM(ShippingCost) / SUM(TotalAmount) * 100, 2) AS shipping_to_revenue_pct
FROM amazon
GROUP BY Category
ORDER BY shipping_to_revenue_pct DESC;

SELECT
    SellerID,
    SUM(TotalAmount) AS revenue,
    ROUND(
        SUM(TotalAmount) / 
        (SELECT SUM(TotalAmount) FROM amazon) * 100, 
        2
    ) AS revenue_contribution_pct
FROM amazon
GROUP BY SellerID
ORDER BY revenue DESC;

SELECT
    YEAR(OrderDate) AS order_year,
    SUM(TotalAmount) AS revenue,
    ROUND(
        (SUM(TotalAmount) - 
         LAG(SUM(TotalAmount)) OVER (ORDER BY YEAR(OrderDate)))
        /
        LAG(SUM(TotalAmount)) OVER (ORDER BY YEAR(OrderDate)) * 100,
        2
    ) AS yoy_growth_pct
FROM amazon
GROUP BY YEAR(OrderDate)
ORDER BY order_year;

-- Note: Customer-level repeat behavior could not be analyzed as the dataset
-- represents single-order customers only. Analysis focuses on revenue,
-- pricing, cost, seller, and category performance.





    
    


    

    







    