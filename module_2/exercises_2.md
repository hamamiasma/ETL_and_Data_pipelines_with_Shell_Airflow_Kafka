# PostgreSQL Local Setup & Usage Guide

This guide provides basic instructions for running PostgreSQL on macOS, connecting to the server, creating a new database, and running basic SQL commands using `psql`.

---

## 1. Start PostgreSQL Server

```bash
sudo -u postgres /Library/PostgreSQL/12/bin/pg_ctl -D /Library/PostgreSQL/12/data -o "-p 5433" start
```

> ✅ Starts the PostgreSQL server on port `5433`.

---

## 2. Connect to PostgreSQL via `psql`

```bash
psql
```

> ✅ Opens the PostgreSQL interactive terminal.

---

### Inside `psql`

To list all databases:

```sql
\l
```

To connect to a specific database (e.g., `template1`):

```sql
\c template1;
```

To view contents of a table (example: `users` table):

```sql
SELECT * FROM users;
```

---

## 3. Create a New Database

Replace `my_new_db` with your desired database name:

```sql
CREATE DATABASE my_new_db;
```

---

## 4. Connect to the New Database

```sql
\c my_new_db
```

---

## 5. Additional Commands

### List All Databases

```sql
\l
```

### Show Current Connection Info

```sql
\conninfo
```

---

### Notes

- Ensure PostgreSQL is installed in `/Library/PostgreSQL/12/`.
- You may need `sudo` privileges depending on system settings.
