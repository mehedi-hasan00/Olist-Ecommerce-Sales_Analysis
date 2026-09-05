# Olist E-Commerce Data Analysis & Business Intelligence

An end-to-end data analytics project on the Brazilian Olist e-commerce dataset (~100K orders from Oct 2016 to Aug 2018). The workflow covers automated data cleaning, relational data warehousing in MySQL, advanced SQL business queries, inferential statistical hypothesis testing, Python visual EDA, and an interactive executive Power BI dashboard to diagnose revenue drivers, retention patterns, and delivery-related customer churn.

---

## 📌 Project Overview

Olist operates as a marketplace integrator connecting small merchants across Brazil to large e-commerce platforms. This project uncovers structural trends across orders, products, customers, sellers, logistics, payments, and reviews to answer core business questions:

- **Growth & Seasonality:** What factors drive platform revenue expansion, and what is the impact of major retail events (e.g., Black Friday)?
- **Retention & Customer Health:** What is the platform's repeat purchase rate, and what RFM segments dominate the user base?
- **Seller Performance:** How concentrated is marketplace revenue across merchant cohorts?
- **Delivery Bottlenecks & Satisfaction:** How strongly do delivery delays dictate review scores compared to variables like product price or freight cost?

---

## 🛠️ Tech Stack & Architecture

| Stage | Tools & Libraries | Primary Function |
|---|---|---|
| **Data Cleaning & Prep** | Python, Pandas, NumPy | Schema normalization, data type casting, Portuguese-to-English translation, outlier handling |
| **Data Warehousing** | MySQL, SQLAlchemy | Relational schema modeling, foreign key constraint enforcement, database ingestion |
| **Business Analytics Layer** | SQL (MySQL Workbench) | CTEs, window functions (`DENSE_RANK`, `NTILE`), RFM segmentation, aggregations |
| **Statistical Testing** | Python, SciPy, Statsmodels | Two-sample t-tests, ANOVA, Chi-Square test of independence, Pearson correlation |
| **Visual EDA** | Matplotlib, Seaborn | Exploratory data distribution analysis and trend visualization |
| **BI Reporting** | Power BI | Multi-page interactive executive reporting and KPI monitoring |

---

## 🔄 End-to-End Workflow

```
Raw CSV Files (7 Datasets)
│
▼
Data Cleaning & Feature Prep (Pandas)
│
├──► Statistical Hypothesis Testing (SciPy)
│
▼
Data Warehousing (SQLAlchemy ➔ MySQL Database: olist_db)
│
▼
Business Query Layer (MySQL Workbench: 33 Complex SQL Queries)
│
├──► Python-SQL Visual EDA (Seaborn / Matplotlib)
│
▼
Interactive BI Reporting (Power BI Dashboard)

```

1. **`Olist_data_cleaning.ipynb`**: Cleans and integrates all 7 datasets (`orders`, `products`, `customers`, `order_items`, `payments`, `reviews`, `sellers`). Converts timestamp strings to datetime objects, standardizes Brazilian zip codes, standardizes missing records, translates product categories to English, and exports normalized CSVs.
2. **`olist_statistical_analysis.ipynb`**: Evaluates business hypotheses via formal statistical testing (T-tests, ANOVA, Chi-square, correlation matrices) prior to downstream query modeling.
3. **`python_to_sql_connection.ipynb`**: Programmatically designs and ingests cleaned entities into MySQL (`olist_db`) using SQLAlchemy with configured relationship constraints.
4. **`sql_file/olist_data_analysis.sql`**: Contains 33 business analysis queries broken into 6 modules:
   - **Sales & Revenue Dynamics:** MoM revenue trajectories, average order value (AOV), category-level volume.
   - **Customer RFM Segmentation:** Recency, Frequency, and Monetary categorization into actionable customer tiers.
   - **Seller Concentration (Pareto Principle):** 80/20 revenue distribution, top seller efficiency, and fulfillment delays.
   - **Fulfillment & Logistics:** Estimated vs. actual delivery intervals, regional transit lead times, late shipment rates.
   - **Payment Economics:** Payment method adoption, installment distribution, order size correlation.
   - **Customer Sentiment Analysis:** Correlation between review ratings, transit delay days, product price, and shipping fees.
5. **`olist_data_analysis_visual.ipynb`**: Extracts aggregated SQL outputs into Pandas for visual validation using Matplotlib and Seaborn.
6. **Power BI Dashboard**: Consolidated interactive analytical views for executive reporting and operational diagnosis.

---

## 📊 Power BI Dashboard

An interactive multi-page dashboard built to monitor platform health, unit economics, fulfillment SLAs, and cohort retention.

### Page 1: Executive Overview
![Executive Overview Dashboard](images/powerbi_dashboard_page1.png)

* **Core Platform KPIs**: Tracks Net Product Revenue (**$13.59M** across 96K delivered orders), Average Order Value (**$140.91**), and Platform Average Review Score (**4.09 / 5.00**).
* **Revenue Trend Analysis**: Captures growth acceleration through 2017, highlighting the Black Friday demand surge in November 2017 ($0.99M+).
* **Payment Method Distribution**: Highlights Credit Card dominance (**78.34%**, $12.54M), followed by Boleto (**17.92%**, $2.87M), Vouchers (**2.37%**), and Debit Cards.
* **Category Contribution**: Identifies top product categories driving product revenue (`watches_gifts`, `sports_leisure`, `toys`).

---

### Page 2: Delivery & Satisfaction
*(Dashboard screenshot to be added)*

<!-- 
![Delivery & Satisfaction Dashboard](images/powerbi_dashboard_page2.png) 
-->

---

### Page 3: Customer & Seller Insights
*(Dashboard screenshot to be added)*

<!-- 
![Customer & Seller Insights Dashboard](images/powerbi_dashboard_page3.png) 
-->

---

## 🔑 Key Empirical Insights

**Revenue Dynamics & Seasonality**
- Platform product revenue totaled $13.59M across the analyzed period, showing sustained MoM growth with peak gross volume during Q4 2017 (Black Friday).

**Customer Retention & RFM Health**
- More than 97% of transacting customers are one-time buyers; the repeat purchase rate is constrained between 2% and 3%.
- RFM segmentation demonstrates that a substantial proportion of historical customers reside in "At Risk" or "Hibernating" cohorts, demonstrating the need for structured lifecycle re-engagement workflows.

**Seller Concentration (Pareto Principle)**
- Approximately 20% of active merchants generate roughly 80% of platform sales volume, confirming heavy revenue concentration among top-tier sellers.

**Logistics Reliability vs. Customer Satisfaction**
- Between 8% and 10% of shipments exceed the estimated delivery SLA. Bulky goods (furniture, large domestic appliances) experience the highest transit variance (20–30+ days).
- Transit delay is the primary statistical driver of low review scores: delayed deliveries register a mean review score of **2.55**, whereas on-time deliveries average **4.21** (Two-sample t-test: $p < 0.0001$).
- Item price, shipping fee, and product image count show **no statistically significant correlation** with customer satisfaction scores. Reliability of fulfillment is the primary lever of customer sentiment.

**Payment Mechanics & Regional Behaviors**
- Credit cards account for >78% of monetary volume. Payment method selection correlates significantly with order transaction value (ANOVA: $p < 0.0001$), with installment options unlocking higher basket sizes.
- Regional payment patterns vary significantly across Brazilian states (Chi-Square: $p \approx 4.25 \times 10^{-80}$).

**Freight Cost Dynamics**
- Freight charges correlate strongly with physical product weight ($r = 0.61$), whereas item price exhibits lower correlation ($r = 0.41$), indicating shipping costs are determined by package dimensions rather than product valuation.

---

## 📂 Repository Structure

```
├── Olist_data_cleaning.ipynb          # Raw dataset cleaning, translation & preparation
├── olist_statistical_analysis.ipynb   # Hypothesis validation (T-Test, ANOVA, Chi-Square)
├── python_to_sql_connection.ipynb     # Automated MySQL database creation & loading
├── olist_data_analysis_visual.ipynb   # SQL extraction & Seaborn/Matplotlib visualization
├── sql_file/
│   └── olist_data_analysis.sql        # 33 production SQL queries (CTEs, Window functions)
├── images/
│   ├── dashboard_1.png    # Executive Overview Dashboard screenshot
│   ├── dashboard_2.png    # Delivery & Satisfaction Dashboard (In progress)
│   └── dashboard_3.png    # Customer & Seller Insights Dashboard (In progress)
└── README.md
```

---

## ▶️ How to Reproduce

1. **Obtain Data:** Download the [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) from Kaggle into your root data directory.
2. **Data Cleaning:** Run `Olist_data_cleaning.ipynb` to clean raw records, translate categories, and export normalized datasets.
3. **Statistical Testing:** Run `olist_statistical_analysis.ipynb` to execute inferential tests and review correlation metrics.
4. **Database Configuration:** Configure your MySQL connection parameters in `python_to_sql_connection.ipynb` and execute the notebook to instantiate `olist_db`.
5. **Business SQL Queries:** Open MySQL Workbench, load `sql_file/olist_data_analysis.sql`, and execute queries across business analysis sections.
6. **Exploratory Visuals:** Execute `olist_data_analysis_visual.ipynb` to pull database aggregations into Python charting environments.
7. **Power BI Report:** Open the Power BI `.pbix` file, configure your MySQL or clean CSV data source credentials, and refresh visuals.

---

## 👤 Author

**Mehedi Hasan**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-blue?style=flat&logo=linkedin)](https://www.linkedin.com/in/mehedi-hasan-094855388/)
[![GitHub](https://img.shields.io/badge/GitHub-black?style=flat&logo=github)](https://github.com/mehedi-hasan00)
[![Tableau](https://img.shields.io/badge/Tableau-orange?style=flat&logo=tableau)](https://public.tableau.com/app/profile/mehedi.hasan2176)
[![Kaggle](https://img.shields.io/badge/Kaggle-blue?style=flat&logo=kaggle)](https://www.kaggle.com/mehedi71)