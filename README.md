# Big Data & Data Engineering Course

## **Introduction**

This course is designed for enthusiasts in the field of **Big Data Analysis**, **Data Engineering**, **Machine Learning Engineers**, **Data Warehouse Specialists**, and **Developers**.
Throughout this course, you will learn how to build **Data Pipelines** using open-source tools such as:

* `Shell Scripting` for task automation.
* `Apache Airflow` for managing and tracking complex workflows.
* `Apache Kafka` for handling stream processing.

---

## 📂 **Course Contents**

The course is divided into the following modules:

### **Module 1:** Data Processing Techniques

In this module, you will learn:

* **What is ETL?**
  ETL stands for **Extract, Transform, Load**—a process of extracting data from different sources, processing it, and loading it into data warehouses.

  **Example:**

  * Sales data in Excel files, customer data in MySQL, and logistics data in CSV files.
  * The ETL process collects, cleans, and loads them into a unified data warehouse.

* **What is ELT?**
  ELT is the reverse of ETL, where data is first **Loaded** into the warehouse and then **Transformed**.

  **Example:**

  * With modern tools like **BigQuery** or **Snowflake**, data can be loaded and processed directly using SQL queries.

* **Batch Loading vs. Stream Loading:**

  * **Batch Loading:** Data is loaded in bulk at scheduled intervals (e.g., once per day).
  * **Stream Loading:** Data is continuously loaded as events happen in real-time.

  **Example:**

  * Daily sales data can be handled using Batch Loading, while real-time sensor data requires Stream Loading.

---

### **Module 2:** ETL Tools and Data Pipelines

In this module, you will learn:

* **Shell Scripting in ETL Pipelines:**
  Using `Bash Scripting`, you can automate data collection, cleaning, and loading.

  **Example:**

  ```bash
  # Simple script to read and clean CSV files
  for file in /data/*.csv; do
      awk -F, '$3 != ""' $file > cleaned_$file
  done
  ```

* **Data Flow Bottleneck Solutions:**
  Tools like **Apache Kafka** can speed up the transfer of data between systems.

* **Batch vs. Streaming Pipelines:**

  * `Batch Pipelines:` Process data in chunks.
  * `Streaming Pipelines:` Process data continuously without interruption.

---

### **Module 3:** Building Data Pipelines with Apache Airflow

In this module, you will learn:

* **Apache Airflow Fundamentals:**
  A framework for managing ETL operations using **DAGs (Directed Acyclic Graphs)**, which represent the sequence of tasks.

* **Defining a DAG in Python:**
  Below is a basic example of a DAG in Airflow:

  ```python
  from airflow import DAG
  from airflow.operators.bash import BashOperator
  from datetime import datetime

  with DAG('simple_etl',
           start_date=datetime(2023, 5, 15),
           schedule_interval='@daily') as dag:

      extract = BashOperator(
          task_id='extract_data',
          bash_command='python3 extract.py'
      )

      transform = BashOperator(
          task_id='transform_data',
          bash_command='python3 transform.py'
      )

      load = BashOperator(
          task_id='load_data',
          bash_command='python3 load.py'
      )

      extract >> transform >> load
  ```

---

### **Module 4:** Building Streaming Pipelines with Apache Kafka

In this module, you will learn:

* **Apache Kafka Components:**

  * `Producer:` Sends messages to Kafka Topics.
  * `Consumer:` Reads messages from Kafka Topics.
  * `Broker:` Acts as a storage and mediator for messages.

* **Real-Time Data Flow:**
  **Example:** An electronic payment system sending updates for each transaction in real-time through Kafka.

---

### **Module 5:** Final Project

At the end of the course, you will build:

* **ETL Pipeline with Apache Airflow:**
  Define tasks through DAGs for integrated data processing.

* **Streaming ETL Pipeline with Kafka:**
  Build a real-time data processing system from source to storage.

---

##  **Conclusion**

This course equips you with the technical and practical knowledge to build efficient Data Pipelines using powerful open-source tools. You will learn how to transform, move, and automate data processes to build advanced data-driven systems.