# zepto-inventory-SQL-analysis
SQL project analyzing retail inventory data to generate insights on pricing, discounts, stock availability, and revenue optimization.

# 🛒 Zepto Inventory Analysis using SQL

## 📌 Project Overview
This project analyzes a retail inventory dataset inspired by Zepto to extract business insights related to pricing, discounts, stock availability, and revenue.

##  Objectives
* Analyze product pricing and discounts
* Identify best-value products
* Detect dead stock and inventory issues
* Calculate category-wise revenue

##  Tools & Technologies
* SQL (MySQL)
* Data Cleaning
* Data Analysis

## 📂 Dataset Details

The dataset contains:

* Product name
* Category
* MRP (Maximum Retail Price)
* Discount percentage
* Available quantity
* Weight
* Stock availability

## 🧹 Data Cleaning Steps
* Removed products with MRP = 0
* Checked and handled NULL values
* Converted price from paisa to rupees

 --- 

## 📊 Key SQL Analysis

### 🔹 Top 10 Best Value Products
SELECT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

---

### 🔹 Revenue by Category
SELECT category,
SUM(discountedSellingPrice * quantity) AS revenue
FROM zepto
GROUP BY category
ORDER BY revenue DESC;

---

### 🔹 Dead Stock Detection
SELECT name, availableQuantity
FROM zepto
WHERE availableQuantity < 10
AND discountPercent = 0;

---

### 🔹 Product Ranking
SELECT name, category,
RANK() OVER (PARTITION BY category ORDER BY mrp DESC) AS rank
FROM zepto;

---

### 💡 Key Insights

* Some categories offer higher discounts
* High MRP products are often out of stock
* Dead stock exists (low quantity, no discount)
* Pricing inconsistencies detected

---

## 🚀 Conclusion

This project demonstrates how SQL can be used to clean data and generate business insights for better decision-making.
