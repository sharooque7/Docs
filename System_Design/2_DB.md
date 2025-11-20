# 📦 Database Replication

> *"Database replication can be used in many database management systems, usually with a master/slave relationship between the original (master) and the copies (slaves)."* — Wikipedia

---

## 🧠 Core Concept

- **Master-Slave Model**:
  - **Master DB** handles **write operations**: `INSERT`, `UPDATE`, `DELETE`
  - **Slave DBs** handle **read operations**: `SELECT`
  - Slaves replicate data from the master in near real-time

---

## 🧮 Why Replicate?

### ✅ Better Performance
- **Read-heavy applications** benefit most
- **Parallel query processing** by offloading reads to multiple slaves

### ✅ Reliability
- Data is **replicated across regions or availability zones**
- **Disaster resilience**: e.g., earthquakes, fires, etc.

### ✅ High Availability
- System continues to function even if:
  - A **slave** is down → route to other slaves or temporarily to the master
  - The **master** is down → **promote a slave to master** (with care)

---

## ⚙️ Failure Scenarios

### 🔁 Slave Fails
- Redirect reads to another healthy slave or to the master temporarily
- Replace the failed slave with a new one

### 🔁 Master Fails
- **Promote a slave to master**
- Run **data recovery scripts** to fill missing data (if any lag)
- Add a new slave to maintain replication setup

⚠️ Promoting a new master is **not trivial** — replication lag and data consistency must be carefully handled.

---

## 👨‍💻 Practical Flow with Web + DB Tier

1. User gets Load Balancer IP via DNS
2. User sends HTTP request to the Load Balancer
3. Request goes to Web Server (e.g., Server 1 or Server 2)
4. Web Server:
   - Reads from **Slave DB**
   - Writes to **Master DB**

---

## 🗃️ Notes

- This setup improves:
  - System **throughput**
  - **Fault tolerance**
  - **Scalability**
- Read/Write traffic is cleanly separated

---

## 📍 Next Step: Improving Latency
To reduce **load/response time**, we can:
- Add a **Cache Layer**
- Use a **Content Delivery Network (CDN)** for static files (JS, CSS, images, videos)

