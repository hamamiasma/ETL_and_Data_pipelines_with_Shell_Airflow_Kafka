# Summary of Data Loading Strategies & Techniques

## 1. Data Loading Strategies

### Full Loading
- Used when initializing a new data warehouse or loading historical data for the first time.
- **Example:** Starting a new system by loading all company sales data from day one.

### Incremental Loading
- Used to load only new or changed data since the last load without deleting old data.
- **Example:** Adding only today’s sales to the existing historical sales data.

---

## 2. Data Loading Techniques

### Stream Loading
- Real-time and continuous data loading based on incoming data flow.
- **Example:** Temperature sensors or security cameras sending data directly to the system as it’s generated.

### Batch Loading
- Data is loaded in scheduled batches (daily, weekly, monthly).
- **Example:** Loading daily sales updates every night at midnight.

---

## 3. Push vs Pull Methodologies

### Push
- The data source sends data directly to the data warehouse.
- **Example:** A sensor pushes its data directly to the storage system.

### Pull
- The data warehouse requests data from the source either on-demand or on a schedule.
- **Example:** A system pulls sales data from a database every day at 2 AM.

---

## 4. Serial vs Parallel Loading

### Serial Loading
- Data is loaded step-by-step, one after the other.
- **Example:** Uploading files one by one in sequence.

### Parallel Loading
- Data is loaded simultaneously from multiple sources or by splitting a large file to speed up the process.
- **Example:** Loading sales data from 3 different branches at the same time, or dividing a large file into 5 parts and loading them in parallel.

---

## Quick Summary

| Concept               | Description                                | Example                                     |
|------------------------|--------------------------------------------|---------------------------------------------|
| **Full Loading**       | Load all data from the beginning           | Load all company sales from day one         |
| **Incremental Loading**| Load only new data                         | Add only today’s sales                      |
| **Stream Loading**     | Immediate and continuous data loading      | Temperature sensor data sent instantly      |
| **Batch Loading**      | Data loaded in scheduled batches           | Daily sales update at midnight              |
| **Push**               | Source pushes data to the system           | Sensor pushes its readings automatically    |
| **Pull**               | System pulls data from source              | System fetches sales data every day         |
| **Serial Loading**     | Load data sequentially                     | Load one file at a time                     |
| **Parallel Loading**   | Load data in parallel to speed up process  | Load data from multiple branches at once    |

---

## Note on IoT Data Extraction

When extracting data from Internet of Things (IoT) devices, the data volume is often large and includes redundancy or irrelevant values.  
To reduce the data size, **Edge Computing** is typically used to process data near its source (i.e., on or close to the device). It extracts only the important features from the raw data before sending it to centralized storage or analysis systems.

### Why not the other options?

- **SQL Languages:** Used for querying databases, not for reducing data at the device level.
- **APIs:** Allow communication between systems, but they don't reduce data volume by themselves.
- **Biometric Sensors:** These are data sources (like heart rate monitors) and don’t process or minimize data internally.
