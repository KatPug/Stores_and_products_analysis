### End-to-End ELT Pipeline with Python, SQL, dbt, and Google BigQuery
This repository showcases an end-to-end ELT (Extract, Load, Transform) pipeline built using Python 3, SQL, dbt, and Google BigQuery. The project demonstrates how to transform raw data into insightful analytics using best practices in modern data engineering.

### Project Overview
The objective of this project was to to showcase an end to end ELT pipeline from a data source to any data warehouse using Python, SQL and DBT and data models to answer the following questions
● Top 10 stores per transacted amount
● Top 10 products sold
● Average transacted amount per store typology and country
● Percentage of transactions per device type
● Average time for a store to perform its 5 first transactions

The goal was to process and analyze data from three interconnected tables, cleaning and preparing the data in a staging layer, applying business logic in an intermediate layer, and delivering insights through data marts.

This repositary contains data model and SQL scripts to answer the above-mentioned questions.

### Tools and Technologies
Python 3: For environment setup and database integration.
SQL: Core language for data transformation and analysis.
dbt (Data Build Tool): For modular and version-controlled data transformations.
Google BigQuery: A serverless, highly scalable data warehouse used for storing and processing data.

### Setup and Implementation
1. BigQuery Setup
Created a new project in Google BigQuery and populated it with sample data.
The data included three tables:
Transaction: Contains details about payments, including transaction IDs, products, amounts, timestamps, and sensitive information (e.g., card number, CVV).
Device: Tracks the hardware used for transactions, including device types and their associated stores.
Store: Holds information about physical locations, such as addresses, typology, and customer associations.
2. Python and dbt Setup
Configured a Python 3 virtual environment.
Installed dbt using Visual Studio Code.
Authenticated Google BigQuery credentials to connect dbt to the project.
Configured the profiles.yml file (excluded from this repository for security purposes) to define the connection between dbt and BigQuery.

### Data Architecture
1. Staging Layer
Objective: Clean and prepare raw data for downstream transformations.
Implementation:
Cleaned fields, standardized date formats, and normalized textual data (e.g., converting names to lowercase).
Masked sensitive data, such as card_number and cvv, to ensure privacy.
Improved query performance for high-query fields like store_id, device_id, or transaction_day by partitioning by date.
Added derived columns like transaction_day and transaction_month for easier aggregation.
Stored all staging models in the models/staging folder.
Configured YAML files to define column-level tests, ensuring data integrity:
- not_null constraints for key fields (e.g., id, device_id, created_at).
- unique constraints for primary keys.
- accepted_values tests for categorical fields (e.g., status).
- relationships: Ensures that the store_id column in the stg_device table corresponds to the id column in the stg_store table.

2. Intermediate Layer
Objective: Join and enrich data for specific analyses.
Implementation:
- Joined the three tables (transaction, device, store) to create a unified dataset.
- Applied ranking logic to transactions to calculate the time between specific transactions for each store.
- Stored all intermediate models in the models/intermediate folder.
- Configured YAML files with tests to validate join integrity and ensure field consistency.

3. Data Marts
Objective: Deliver actionable insights for business questions.
Implementation:
Created two datamarts:
- Stores: Identifies the top-performing stores based on transaction amounts. Only transactions with a status of 'accepted' were considered to count successful transactions.
Also the time difference between store creation date and 5th transaction is calculated in this stage.
- Products: Highlights the most popular products based on transaction volume, filtering for transactions with a status of 'accepted'.
- Applied business rules to ensure only valid transactions were included in the analysis, improving the accuracy of insights.
- Stored data models in the models/marts folder.
Repository Structure
.
├── models/
│   ├── staging/
│   │   ├── stg_transaction.sql
│   │   ├── stg_device.sql
│   │   └── stg_store.sql
│   ├── intermediate/
│   │   └── int_transactions.sql
│   ├── marts/
│       ├── mart_stores.sql
│       ├── mart_products.sql
├── dbt_project.yml
├── README.md
├── answers.sql
└── profiles.yml (not included)

### Future Improvements
Automate pipeline execution using tools like Airflow.
Add more granular metrics, such as customer segmentation and device efficiency.
Integrate with a visualization tool like Tableau or Looker for dynamic dashboards.