#!/bin/bash
# This script downloads the file 'web-server-access-log.txt.gz'
# and performs ETL operations before loading data into PostgreSQL.

# Download the access log file
echo "Downloading access log file..."
wget "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0250EN-SkillsNetwork/labs/Bash%20Scripting/ETL%20using%20shell%20scripting/web-server-access-log.txt.gz"

# Unzip the file to extract the .txt file.
echo "Extracting compressed file..."
gunzip -f web-server-access-log.txt.gz

# Extract phase - get timestamp, visitorid, latitude, longitude (columns 1,3,4,5)
echo "Extracting data"
cut -d"#" -f1-4 web-server-access-log.txt > extracted-data.txt

# Transform phase
echo "Transforming data"
tr "#" "," < extracted-data.txt > transformed-data.csv

# Load data using postgres user (has all permissions)
echo "Loading data"

# Use postgres user instead of asmaahamami
psql -U postgres template1 << EOF
-- Create table if not exists
CREATE TABLE IF NOT EXISTS access_log (
    timestamp TIMESTAMP,
    visitorid CHAR(37),
    latitude FLOAT,
    longitude FLOAT
);

-- Clear existing data
TRUNCATE TABLE access_log;

-- Load data
\\COPY access_log FROM '$(pwd)/transformed-data.csv' DELIMITERS ',' CSV HEADER;

-- Give permissions to asmaahamami for future use
GRANT ALL PRIVILEGES ON TABLE access_log TO asmaahamami;

-- Show results
SELECT COUNT(*) as total_records FROM access_log;
SELECT 'Erste 5 Datensätze:' as info;
SELECT * FROM access_log LIMIT 5;
EOF

if [ $? -eq 0 ]; then
    echo "Daten erfolgreich in die Datenbank geladen."
else
    echo "Fehler beim Laden der Daten."
fi
