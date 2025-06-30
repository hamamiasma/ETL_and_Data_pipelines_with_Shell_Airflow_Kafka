# CSV to PostgreSQL Loader

This project contains a shell script (`csv2db.sh`) that performs the following tasks:

1. **Data Extraction:**

   * Extracts the `username`, `userid`, and `home directory path` of each user account from the `/etc/passwd` file.

2. **Data Transformation:**

   * Converts the extracted data from `:` delimiter format to CSV format (comma-separated values) and saves it in `transformed-data.csv`.

3. **Data Loading:**

   * Loads the transformed CSV data into a PostgreSQL database table named `users`.

4. **Data Verification:**

   * Executes a query to display the contents of the `users` table after the load operation.

---

## Prerequisites

Before running the script, make sure the following are installed:

* PostgreSQL (`psql` command-line tool)
* Bash shell

Additionally, ensure you have:

* Access to the `/etc/passwd` file
* Proper PostgreSQL credentials and permissions

---

## Database Setup

1. Start the PostgreSQL shell:

   ```sh
   psql
   ```

2. Create the database if it doesn't exist:

   ```sql
   CREATE DATABASE template1;
   \c template1;
   ```

3. Create the `users` table:

   ```sql
   CREATE TABLE users (
       username VARCHAR(50),
       userid INT,
       homedirectory VARCHAR(100)
   );
   ```

4. Verify the table is created:

   ```sql
   \d users
   ```

---

## Script Usage

1. Give execution permission to the script:

   ```sh
   touch csv2db.sh
   chmod +x csv2db.sh
   nano csv2db.sh   
   ```
   

2. Run the script:

   ```sh
   bash csv2db.sh
   ```

---

## Script Logic - Step by Step Explanation

1. **Data Extraction:**

   ```sh
   cut -d":" -f1,3,6 /etc/passwd | grep -v "^#" | grep -v "^$" > extracted-data.txt
   ```

   * `cut -d":" -f1,3,6`: Extracts the first, third, and sixth fields (`username`, `userid`, `home directory`) from `/etc/passwd`.
   * `grep -v "^#"`: Removes lines that are commented out.
   * `grep -v "^$"`: Removes empty lines.
   * `> extracted-data.txt`: Writes the output to `extracted-data.txt`.

2. **Data Transformation:**

   ```sh
   tr ":" "," < extracted-data.txt > transformed-data.csv
   ```

   * `tr ":" ","`: Replaces all colons (`:`) with commas (`,`).
   * `< extracted-data.txt`: Reads data from `extracted-data.txt`.
   * `> transformed-data.csv`: Saves the transformed data to `transformed-data.csv`.

3. **File Validation:**

   ```sh
   if [ ! -s transformed-data.csv ]; then
       echo "Fehler: transformed-data.csv enthält keine gültigen Daten."
       exit 1
   fi
   ```

   * ! -s : Checks if the CSV file is empty or invalid.
   * If it is, the script exits with an error message.

4. **Data Loading:**

   ```sh
   export PGPASSWORD='dein_passwort'
   echo "\c template1; \COPY users FROM '$(pwd)/transformed-data.csv' DELIMITERS ',' CSV;" | psql --username=asmaahamami
   ```

   * `export PGPASSWORD='dein_passwort'`: Sets the password for PostgreSQL authentication.
   * `echo ... | psql`: Connects to the database and executes the `COPY` command.
   * `\COPY users FROM ...`: Imports the data from the CSV file into the `users` table.

5. **Data Verification:**

   At the end of the script, we add the following line to immediately display the contents of the `users` table after loading:

   ```sh
   echo "SELECT * FROM users;" | psql --username=asmaahamami --host=localhost template1
   ```

   * This command runs a `SELECT` query to view all the rows in the `users` table.
   * It helps to quickly confirm that the ETL process worked as expected.

---

## Verification

After running the script, the contents of the `users` table are automatically displayed:

```
 username   | userid | homedirectory     
------------+--------+-------------------
 root       | 0      | /root
 daemon     | 1      | /usr/sbin
 bin        | 2      | /bin
 sys        | 3      | /dev
 ...
```

---

## Troubleshooting

* **Permission Denied:** Ensure you have the right permissions to read `/etc/passwd` and write the CSV files.
* **Database Connection Errors:** Verify your PostgreSQL credentials and database name are correct.
* **Empty CSV File:** If `transformed-data.csv` is empty, check the `/etc/passwd` file for proper formatting.

