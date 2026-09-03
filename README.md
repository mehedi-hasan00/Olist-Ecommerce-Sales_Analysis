# Olist E-Commerce Data Analysis

End-to-end data analysis of the Brazilian Olist e-commerce dataset — covering data cleaning, SQL-based business analysis, visual EDA, and statistical hypothesis testing to uncover revenue drivers, customer behavior, and the root causes of delivery-related dissatisfaction.

## 📌 Project Overview

Olist connects small Brazilian merchants to major marketplaces and manages the full order lifecycle. This project analyzes ~100K orders (Oct 2016 – Aug 2018) across orders, products, customers, sellers, payments, and reviews to answer key business questions:

- What drives revenue growth, and how seasonal is demand?
- How healthy is customer retention, and who are the highest-value customers?
- How concentrated is seller performance, and where are the delivery bottlenecks?
- What actually moves customer satisfaction — price, payment method, or delivery speed?

## 🛠️ Tech Stack

| Stage | Tools |
|---|---|
| Data Cleaning | Python, Pandas |
| Data Warehousing | MySQL, SQLAlchemy |
| Business Query Layer | SQL (CTEs, window functions) |
| Exploratory & Visual Analysis | Python, Pandas, Matplotlib/Seaborn |
| Statistical Testing | Python, SciPy (Chi-Square, ANOVA, T-Test, Correlation) |

## 🔄 Workflow

```
Raw CSVs → Clean & Merge Datasets (Pandas) → Statistical Analysis (SciPy)
        → Load to MySQL (SQLAlchemy) → SQL Analysis in Workbench (CTEs/Window Fns)
        → Pull Results Back to Python → Visual EDA → Insights
```

1. **`Olist_data_cleaning.ipynb`** — Cleans and merges all 7 raw datasets (orders, products, customers, order items, payments, reviews, sellers): fixes data types (string → datetime), translates product categories from Portuguese to English, validates dates, fixes zip codes, checks price/logic consistency, and exports clean CSVs.
2. **`olist_statistical_analysis.ipynb`** — Runs formal hypothesis tests on the cleaned data (Chi-Square, ANOVA, T-Test, correlation analysis) to validate business patterns before deeper SQL exploration.
3. **`python_to_sql_connection.ipynb`** — Loads the cleaned datasets into a MySQL database (`olist_db`) via SQLAlchemy, enabling SQL analysis in MySQL Workbench.
4. **`olist_data_analysis.sql`** — Core business analysis run in MySQL Workbench, organized into 6 sections with 29 queries total:
   - **Revenue & Sales Trends** — Monthly revenue, AOV, revenue by category, MoM growth
   - **Customer Analysis** — RFM (Recency, Frequency, Monetary), RFM segmentation, new vs. repeat customers, top spenders
   - **Seller Analysis** — Top sellers by revenue, seller review performance, delivery performance, Pareto (80/20) revenue concentration
   - **Order & Delivery Performance** — Order status breakdown, avg delivery time, late delivery %, delivery time vs. review score
   - **Payment Analysis** — Payment type distribution, installment behavior, payment value distribution
   - **Product Analysis** — Best-selling categories, average price by category, freight cost vs. price, top revenue products
   - **Review/Satisfaction Analysis** — Review scores by category, score distribution, delivery delay vs. score, price vs. score
5. **`olist_data_analysis_visual.ipynb`** — Pulls the SQL query results back into Python and visualizes them as charts covering revenue trends, customer retention, seller Pareto curves, delivery timeliness, payment preferences, and review breakdowns.

## 🔑 Key Insights

**Revenue & Growth**
- Revenue grew consistently from early 2017, with a sharp spike in November 2017 driven by Black Friday and holiday demand.

**Customer Retention**
- Over 97% of buyers are one-time customers — repeat purchase rate sits at just 2–3%, and a large share of customers fall into "Churned" or "At Risk" RFM segments, signaling a strong need for re-engagement campaigns.

**Seller Concentration**
- Roughly 20% of sellers generate close to 80% of total platform revenue (Pareto principle), highlighting concentration risk alongside the need to grow the long tail of sellers.

**Delivery & Satisfaction**
- 8–10% of orders arrive later than the estimated delivery date; bulky categories (furniture, large appliances) see the longest delivery times (20–30+ days).
- Late deliveries are the single strongest driver of poor reviews — a two-sample t-test found delayed orders average a **2.55** review score vs. **4.21** for on-time orders (p < 0.0001).
- Price, freight cost, and product photo count show **no meaningful correlation** with review score — satisfaction is driven by delivery reliability, not price or presentation.

**Payments**
- Credit card is the dominant payment method (70%+ of transactions), with payment method significantly associated with both review score (p = 0.0002) and payment value (ANOVA, p < 0.0001) — installments correlate with higher-value orders.
- Payment preference varies strongly by region (p ≈ 4.25 × 10⁻⁸⁰), pointing to a need for region-specific checkout and marketing strategies.

**Shipping Cost Drivers**
- Freight cost correlates moderately-to-strongly with product weight (r = 0.61), more than with price (r = 0.41) — shipping cost is driven primarily by weight, not item value.

## 📂 Repository Structure

```
├── Olist_data_cleaning.ipynb          # Raw data cleaning & merging
├── olist_statistical_analysis.ipynb   # Hypothesis testing & correlation
├── python_to_sql_connection.ipynb     # Load clean data into MySQL
├── olist_data_analysis_visual.ipynb   # Pull SQL results back & visualize
├── sql_file/
│   └── olist_data_analysis.sql        # 29 business analysis SQL queries
└── README.md
```

## ▶️ How to Reproduce

1. Download the [Olist Brazilian E-Commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) from Kaggle.
2. Run `Olist_data_cleaning.ipynb` to clean and merge the raw CSVs.
3. Run `olist_statistical_analysis.ipynb` for hypothesis testing on the cleaned data.
4. Update the MySQL connection string in `python_to_sql_connection.ipynb` and run it to load the cleaned data into your database.
5. Run the queries in `sql_file/olist_data_analysis.sql` in MySQL Workbench.
6. Run `olist_data_analysis_visual.ipynb` to pull the SQL results back into Python and visualize them.

## 👤 Author

**Mehedi Hasan**
Data Analyst | [Portfolio](https://mehedi-hasan00.github.io)

[![LinkedIn](https://img.shields.io/badge/LinkedIn-blue?style=flat&logo=linkedin)](https://www.linkedin.com/in/mehedi-hasan-094855388/)
[![GitHub](https://img.shields.io/badge/GitHub-black?style=flat&logo=github)](https://github.com/mehedi-hasan00)
[![Tableau](https://img.shields.io/badge/Tableau-orange?style=flat&logo=tableau)](https://public.tableau.com/app/profile/mehedi.hasan2176)
[![Kaggle](https://img.shields.io/badge/Kaggle-blue?style=flat&logo=kaggle)](https://www.kaggle.com/mehedi71)
