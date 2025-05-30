# Summary of Data Transformation Techniques

## 1. Introduction
Data transformation refers to modifying the format or type of data to make it suitable for the target application or system.

---

## 2. Types of Data Transformation

| Type                          | Description                                             | Example                                      |
|-------------------------------|---------------------------------------------------------|----------------------------------------------|
| **Data typing**               | Converting data to appropriate types (e.g., number, text) | Converting `"100.5"` from a string to a decimal number |
| **Data structuring**          | Changing the data format (e.g., JSON → Table)           | Converting JSON to a database table          |
| **Anonymizing/encrypting**    | Hiding or encrypting data for privacy protection         | Masking customer names or encrypting credit cards |
| **Cleaning**                  | Removing duplicates or filling missing values            | Deleting duplicate customer records          |
| **Normalizing**               | Standardizing units or formats                          | Converting multiple currencies into one      |
| **Filtering/Sorting/Aggregating/Binning** | Filtering, ordering, grouping, or bucketing data     | Sorting products by price                    |
| **Joining/Merging**           | Combining data from different sources                   | Merging sales data with customer data        |

---

## 3. Schema-on-Write vs Schema-on-Read

| Aspect                         | Schema-on-Write                           | Schema-on-Read                          |
|--------------------------------|-------------------------------------------|-----------------------------------------|
| **When is transformation done?** | Before storage                            | At the time of reading                  |
| **Flexibility**                 | Less flexible                             | More flexible                           |
| **Query speed**                | Faster                                     | Slower                                  |
| **Handling changes**           | Difficult (requires schema updates)       | Easier (supports multiple schema views) |
| **Data type**                  | Structured and consistent data            | Raw and diverse data                    |
| **Real-world example**         | Traditional databases (e.g., MySQL)       | Data lakes                              |

---

## 4. How Information Loss Occurs During Transformation

- **Lossy compression**: Reduces data precision (e.g., converting decimal to integer).
- **Filtering**: Deletes data based on conditions (e.g., removing irrelevant records).
- **Aggregation**: Combines data, removing detailed information (e.g., showing annual instead of daily sales).
- **Edge computing**: Devices process data at the source, possibly losing details (e.g., cameras sending only alerts).

---

## 5. Practical Example: Sales Data Management

### Schema-on-Write (ETL)
- Data is cleaned and transformed before storage in the database.
- Fast querying, but less flexible.
- Requires schema updates when new data types appear.

### Schema-on-Read (ELT)
- Data is stored in raw form and transformed at query time.
- More flexible and supports diverse analytics.
- Queries are slower due to on-the-fly transformation.
