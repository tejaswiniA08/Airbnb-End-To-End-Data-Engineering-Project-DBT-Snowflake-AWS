# Airbnb-End-To-End-Data-Engineering-Project-DBT-Snowflake-AWS

**Snowflake • dbt • AWS • Medallion Architecture**

## 📌 Project Overview

This project demonstrates a **production-grade, end-to-end data engineering pipeline** built using **Snowflake, dbt, and AWS**, following modern analytics engineering best practices.

The pipeline ingests Airbnb **listings, bookings, and hosts** data and processes it through a **Bronze → Silver → Gold medallion architecture** using a **metadata-driven transformation approach**. Business logic, schema management, and transformations are abstracted through dbt configurations, macros, and Jinja templating to ensure scalability, consistency, and maintainability.

The Gold layer delivers **analytics-ready star schema models**, including well-defined **fact and dimension tables**, optimized for BI and reporting use cases. Key features include **incremental loading**, **Slowly Changing Dimensions (SCD Type 2)** for historical tracking, and **automated data quality validation** to ensure accuracy and reliability.



---

## 🏗️ Architecture

### Data Flow

```
CSV Source Data
      ↓
AWS S3
      ↓
Snowflake (Staging)
      ↓
Bronze Layer (Raw)
      ↓
Silver Layer (Cleaned & Standardized)
      ↓
Gold Layer
```
<img width="561" height="342" alt="Screenshot 2026-01-19 at 7 34 42 PM" src="https://github.com/user-attachments/assets/5dd50d9a-e64e-4db4-a5e1-e017dc6c7fe7" />

### Technology Stack

* **Cloud Data Warehouse:** Snowflake
* **Transformation Framework:** dbt (Data Build Tool)
* **Cloud Storage:** AWS S3
* **Language:** SQL, Python (3.12+)
* **Version Control:** Git & GitHub

### Key dbt Capabilities Used

* Incremental models
* Snapshots (Slowly Changing Dimensions – Type 2)
* Custom macros & Jinja templating
* Source freshness & data quality tests
* Auto-generated documentation & lineage

---

## 📊 Data Modeling Approach

### S3 bucket and IAM:
<img width="500" height="371" alt="Screenshot 2026-01-19 at 7 27 19 PM" src="https://github.com/user-attachments/assets/48edd32f-e8d8-43db-86a1-95886499eea4" />

<img width="500" height="341" alt="Screenshot 2026-01-19 at 7 26 32 PM" src="https://github.com/user-attachments/assets/1a94a51e-bc8f-43a8-9f3c-42616016a032" />


### Medallion Architecture

#### 🥉 Bronze Layer (Raw)

* Schema-aligned ingestion from staging tables
* Preserves raw source fidelity

**Models**

* `bronze_bookings`
* `bronze_hosts`
* `bronze_listings`

<img width="700" height="310" alt="Screenshot 2026-01-19 at 7 31 23 PM" src="https://github.com/user-attachments/assets/a0c20d23-0ff7-44c8-98c5-17251ee19d2e" />

---

#### 🥈 Silver Layer (Cleaned & Conformed)

* Data validation and standardization
* Business rule enforcement
* Type casting and deduplication

**Models**

* `silver_bookings`
* `silver_hosts`
* `silver_listings`

<img width="700" height="378" alt="Screenshot 2026-01-19 at 7 30 24 PM" src="https://github.com/user-attachments/assets/4fdb2dd6-992f-450d-9ca0-0085024e817e" />

---

#### 🥇 Gold Layer (Analytics-Ready)

* Optimized for BI and downstream analytics
* Denormalized and dimensional models

**Models**

* `fact` – Star-schema compatible fact table
* `obt` – One Big Table for ad-hoc analytics
* Ephemeral models for efficient intermediate joins

<img width="700" height="378" alt="Screenshot 2026-01-19 at 7 28 25 PM" src="https://github.com/user-attachments/assets/4ad5cd32-091b-4415-9665-a3d270a80038" />

---

## 🕒 Slowly Changing Dimensions (SCD Type 2)

Historical changes are tracked using **dbt snapshots**, enabling **point-in-time analysis**.


Each snapshot automatically manages:

* `valid_from` and `valid_to` timestamps
* Full change history without overwriting data

---

## 📁 Project Structure

```
Airbnb_Snowflake_DBT_Data_Engineer_Project/
│
├── SourceData/                # Raw CSV inputs
│   ├── bookings.csv
│   ├── hosts.csv
│   └── listings.csv
│
├── DDL/                       # Snowflake schema definitions
│   ├── ddl.sql
│   └── resources.sql
│
├── aws_dbt_snowflake_project/
│   ├── dbt_project.yml
│   ├── models/
│   │   ├── sources/
│   │   ├── bronze/
│   │   ├── silver/
│   │   └── gold/
│   ├── snapshots/
│   ├── macros/
│   ├── tests/
│   └── analyses/
│
├── main.py                    # Pipeline orchestration
├── pyproject.toml             # Python dependencies
└── README.md
```

---


### Installation

```bash
git clone <repository-url>
cd Airbnb_Snowflake_DBT_Data_Engineer_Project
```

Create virtual environment:

```bash
python -m venv .venv
source .venv/bin/activate  # Mac/Linux
```

Install dependencies:

```bash
pip install -e .
```

---

### Configure dbt Profile

Create `~/.dbt/profiles.yml`:

```yaml
aws_dbt_snowflake_project:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <account>
      user: <username>
      password: <password>
      role: ACCOUNTADMIN
      database: AIRBNB
      warehouse: COMPUTE_WH
      schema: dbt_schema
      threads: 4
```

---

## 🔧 Running the Pipeline

```bash
cd aws_dbt_snowflake_project
dbt debug
dbt deps
dbt run
dbt test
dbt snapshot
dbt docs generate
dbt docs serve
```

Run full build:

```bash
dbt build
```

---

## ⚙️ Key Engineering Features

### Incremental Loading

Efficient processing of new and updated records only:

```sql
{% if is_incremental() %}
WHERE created_at > (SELECT COALESCE(MAX(created_at), '1900-01-01') FROM {{ this }})
{% endif %}
```

---

### Custom Macros

Reusable business logic implemented via dbt macros:

* Price categorization (`low`, `medium`, `high`)
* String normalization
* Dynamic schema generation

---

### Data Quality & Testing

* Source freshness checks
* `not_null` and `unique` constraints
* Referential integrity tests
* Business rule validations

---

### Performance Optimization

* Incremental materializations
* Ephemeral models for lightweight joins
* Snowflake-optimized transformations...singular test
