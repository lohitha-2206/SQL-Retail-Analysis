# 🛒 SQL Retail Analytics Project

## 📌 Overview

This project demonstrates a complete **Retail Data Analysis using SQL**, covering the full pipeline:

**Schema Design → Data Generation → Data Cleaning → Analysis → Advanced SQL**

---

## 🗂️ Project Structure

```
📦 SQL-Retail-Analytics
 ┣ 📜 schema.sql     -- Table creation
 ┣ 📜 data.sql       -- Data insertion
 ┣ 📜 queries.sql    -- Analysis queries
 ┗ 📜 README.md
```

---

## 🧱 Database Schema

* **customers** → Customer details
* **stores** → Store information
* **products** → Product categories
* **sales** → Transaction data

---

## ⚙️ Features Covered

### 🔹 1. Schema Design (`schema.sql`)

* Create relational tables
* Define structure for retail data

### 🔹 2. Data Generation (`data.sql`)

* Insert sample data
* Auto-generate **1000 sales records**

### 🔹 3. Data Analysis (`queries.sql`)

#### 📊 Data Understanding

* Total transactions
* Revenue
* Customer insights

#### 🧹 Data Cleaning

* Handle NULL values (`NVL`, `COALESCE`)
* Data validation

#### 🔍 Filtering

* WHERE conditions
* Range & category filters

#### 📈 Aggregation

* GROUP BY analysis
* Store/category performance

#### 🏆 HAVING

* High-performing customers/stores

#### 🧠 CASE WHEN

* Customer segmentation
* Sales classification

#### 🔗 Joins

* Multi-table insights

#### ⚡ Window Functions

* RANK, LAG, LEAD
* Running totals
* Moving averages

#### 🎯 Segmentation

* NTILE (quartiles, marketing segments)

#### ⏱️ Date Analysis

* Monthly trends
* Growth analysis

---

## 🚀 How to Run

```sql
-- Step 1: Create tables
@schema.sql

-- Step 2: Insert data
@data.sql

-- Step 3: Run analysis
@queries.sql
```

---

## 📊 Key Insights

* 📈 Revenue trends
* 🏬 Store performance
* 🧑‍🤝‍🧑 Customer segmentation
* 🛍️ Category analysis
* 🔄 Repeat vs inactive customers

---

## 💡 Use Cases

* SQL Practice
* Data Analyst Portfolio
* Interview Preparation
* Business Insights

---

## 👩‍💻 Author

**Lohitha**
Aspiring Data Analyst

---


