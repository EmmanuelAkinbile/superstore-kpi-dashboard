# Superstore KPI Dashboard  
**Data Analytics | SQL | Power BI | Data Visualization**

---

## Overview  

This project analyzes sales performance, profit margins, and key business trends using the **Superstore dataset**.  
The objective is to design a **KPI dashboard** that highlights performance across regions, product categories, and customer segments, enabling data-driven decision-making.  

This project demonstrates my ability to:  
- Clean, transform, and model raw data using **SQL Server**  
- Build and calculate KPIs (Revenue, Profit Margin, Growth Rate, etc.)  
- Visualize business insights interactively using **Power BI**  
- Communicate actionable findings clearly and effectively  

---

## Business Problem  

A retail company wants to better understand its sales performance across regions, products, and customers.  
They need an analytics solution that can answer:  

- Which regions or product categories drive the most profit?  
- How have monthly sales and profit margins changed over time?  
- Which customer segments contribute most to revenue growth?  
- How effective are discounts in improving overall profitability?  

---

## Dataset  

**Source:** [Kaggle – Superstore Dataset (Vivek468)](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)  
**Rows:** ~9,995  
**Columns:** 21  

**Key Fields:**  
- `Order Date`, `Region`, `Category`, `Sub-Category`, `Sales`, `Profit`, `Discount`, `Quantity`  
- `Customer ID`, `Segment`, `State`, `City`  

**Data Location:**  
data/raw/superstore_sales_raw.csv

---

## Process  

### 1. Data Cleaning & Preparation  
- Imported raw data into SQL Server  
- Cleaned and standardized date, category, and region fields  
- Removed nulls and invalid values  
- Created calculated fields such as:  
  - `Profit_Margin = Profit / Sales`  
  - `Sales_After_Discount = Sales * (1 - Discount)`  
- Validated totals and ensured data consistency  

### 2. KPI Development  
Defined key metrics for business monitoring:  
| KPI | Formula | Description |
|------|----------|-------------|
| **Total Sales** | `SUM(Sales)` | Total revenue generated |
| **Total Profit** | `SUM(Profit)` | Overall profitability |
| **Profit Margin %** | `Profit / Sales` | Profit efficiency |
| **Monthly Growth Rate** | `(Current – Previous) / Previous` | Trend strength |
| **Customer Retention Rate** | `Returning Customers / Total Customers` | Loyalty indicator |

### 3. Data Modeling & Visualization  
- Connected SQL Server to Power BI  
- Built data relationships and measures using DAX  
- Designed interactive visuals (cards, trend lines, category breakdowns, region maps)  
- Created a unified dashboard summarizing KPIs and trends  

---

## Dashboard Preview *(to be added)*  


---

## Insights (to be added)  

Key findings will be summarized here after dashboard completion — focusing on trends, outliers, and strategic recommendations.

---

## Tools & Technologies  

| Tool | Purpose |
|------|----------|
| **SQL Server** | Data cleaning, transformation, and KPI calculations |
| **Power BI** | Dashboard visualization and DAX metrics |
| **Excel** | Exploratory analysis and validation |
| **GitHub** | Version control and project documentation |

---

## Repository Structure  

``` plaintext

superstore-kpi-dashboard/
│
├── data/
│ ├── raw/ # Untouched Kaggle dataset
│ └── cleaned/ # Cleaned and transformed data
│
├── sql/ # SQL scripts
│ ├── clean_superstore.sql
│ └── summary_kpis.sql
│
├── powerbi/ # Power BI files and visuals
│ ├── superstore_dashboard.pbix
│ └── visuals/
│
├── docs/ # Additional documentation
│ ├── Project_Report.pdf
│ └── README_DATA.md
│
└── README.md # Main project overview
```
---

## Contact  

**Emmanuel Akinbile**  
Niagara Falls, ON  
[emmanuelakinbile@gmail.com](mailto:emmanuelakinbile@gmail.com)  
[LinkedIn](https://www.linkedin.com/in/emmanuel-akinbile) | [GitHub](https://github.com/EmmanuelAkinbile)

---

> *This repository is part of my data analytics portfolio showcasing skills in SQL, Power BI, and KPI dashboard design.*

