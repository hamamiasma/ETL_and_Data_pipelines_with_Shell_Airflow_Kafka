#!/bin/bash
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
echo "\\c template1;\\COPY access_log FROM '$(pwd)/transformed-data.csv' DELIMITERS ',' CSV HEADER;" | psql --username=asmaahamami --host=localhost
