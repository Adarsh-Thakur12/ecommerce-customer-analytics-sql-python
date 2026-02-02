# 🛒 E-Commerce Sales & Customer Analytics  
**Using SQL & Python**

## 📌 Project Overview
This project performs **end-to-end e-commerce sales and customer analytics** using **SQL and Python** on a real-world transactional dataset.  
The objective is to analyze **revenue trends, customer churn, and customer segmentation** to extract meaningful business insights that can support data-driven decision making.

The project follows an **industry-style analytics workflow**, where SQL is used for structured data analysis and Python is used for exploration and visualization.

---

## 🎯 Objectives
- Analyze overall and time-based sales performance  
- Understand customer purchasing behavior  
- Identify churned and active customers using inactivity logic  
- Segment customers based on order frequency and revenue contribution  
- Translate data findings into actionable business insights  

---

## 📂 Dataset
The project uses the **Sample – Superstore** dataset, a widely used e-commerce dataset containing:
- Order and shipping details  
- Customer information  
- Sales, profit, and quantity data  
- Product categories and regions  

The dataset represents real transactional data suitable for business analytics.

---

## 🧰 Tools & Technologies
- **SQL** – aggregations, CTEs, filtering, business logic  
- **Python** – Pandas, NumPy  
- **Visualization** – Matplotlib, Seaborn  
- **Jupyter Notebook** – analysis and reporting  

---

## 🧠 Analysis Workflow

### 1️⃣ Data Preparation
- Loaded raw CSV data into the analysis environment  
- Handled missing values and corrected data types  
- Converted date fields for time-series analysis  

---

### 2️⃣ Revenue Analysis (SQL)
Revenue analysis focuses on:
- Total and monthly revenue trends  
- Average order value  
- Top customers by revenue contribution  
- Revenue distribution by category and region  

SQL queries are stored separately for clarity and reusability.

---

### 3️⃣ Customer Churn Analysis (SQL)
Churn is defined using an inactivity-based approach:

> **A customer is considered churned if they have not placed any order in the last 90 days from the most recent order date in the dataset.**

Churn analysis includes:
- Identification of churned vs active customers  
- Churn rate calculation  
- Segment-wise and region-wise churn distribution  
- Estimated revenue impact due to churn  

---

### 4️⃣ Customer Segmentation (SQL)
Customers are segmented based on:
- Number of orders placed  
- Total revenue contribution  

Segments include:
- **High-Value Loyal**  
- **Potential Loyalist**  
- **Regular**  
- **One-Time Buyer**  

This segmentation helps identify retention and growth opportunities.

---

### 5️⃣ Python Analysis & Visualization
- SQL query outputs are analyzed using Pandas  
- Visualizations are created to highlight trends and patterns  
- Insights are interpreted with a business perspective  

---

## 📊 Key Insights
- A small group of customers contributes a large share of total revenue  
- Repeat customers generate higher long-term value than one-time buyers  
- Customer churn increases significantly after prolonged inactivity  
- Targeting potential loyalists can improve retention and revenue  

---

## 💡 Business Recommendations
- Introduce loyalty programs for high-value customers  
- Run re-engagement campaigns for inactive users  
- Focus marketing efforts on converting regular customers into loyal ones  
- Monitor churn-prone segments proactively  

---

## 📁 Project Structure

E Commerce Sales Analysis/
├── data/
│   └── Sample - Superstore.csv
├── notebooks/
│   └── ecommerce-customer-analytics.ipynb
├── sql/
│   ├── revenue_analysis.sql
│   ├── churn_analysis.sql
│   └── customer_segmentation.sql
├── README.md

---

## 🚀 Conclusion
This project demonstrates how **SQL and Python can be combined for real-world e-commerce analytics**, covering the complete pipeline from raw data to business insights.  

---
