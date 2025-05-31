# ETL: Load Web Server Access Log into PostgreSQL

This guide explains how to extract, transform, and load data from a remote access log file into a PostgreSQL table using a Bash script.

---

## Prerequisites

- PostgreSQL server running locally
- `psql` command-line tool available
- Bash shell and standard Linux tools (`wget`, `gunzip`, `cut`, `tr`)

---

## 📦 Step-by-Step Instructions

### 1. Connect to `template1` Database

Open PostgreSQL CLI:

```bash
psql
```

At the prompt:

```sql
\c template1;
```

---

### 2. Create Table in PostgreSQL

```sql
CREATE TABLE access_log(
  timestamp TIMESTAMP,
  latitude FLOAT,
  longitude FLOAT,
  visitor_id CHAR(37)
);
```

---

### 3. Create the ETL Bash Script

Create and open the file:

```bash
touch cp-access-log.sh
nano cp-access-log.sh
```

Paste the following content:

```bash
# cp-access-log.sh
# This script downloads the file 'web-server-access-log.txt.gz'
# and performs ETL operations before loading data into PostgreSQL.

# Download the access log file
wget "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0250EN-SkillsNetwork/labs/Bash%20Scripting/ETL%20using%20shell%20scripting/web-server-access-log.txt.gz"

# Unzip the file to extract the .txt file.
gunzip -f web-server-access-log.txt.gz

# Extract phase
echo "Extracting data"
cut -d"#" -f1-4 web-server-access-log.txt > extracted-data.txt

# Transform phase
echo "Transforming data"
tr "#" "," < extracted-data.txt > transformed-data.csv

# Load phase
echo "Loading data"
echo "\c template1;\COPY access_log FROM '$(pwd)/transformed-data.csv' DELIMITERS ',' CSV HEADER;" | psql --username=postgres --host=localhost
```

---

### 4. Run the Script

```bash
bash cp-access-log.sh
```

---

### 5. Verify Data in PostgreSQL

Inside PostgreSQL CLI:

```sql
SELECT * FROM access_log;
```

You should see the extracted records loaded into the `access_log` table.

---

## ✅ Outcome

A complete ETL pipeline using Bash and PostgreSQL for ingesting access log data.
