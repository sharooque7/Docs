## 📌 Replication – Introduction

### ✅ **What is Replication?**
Replication = Keeping copies of the same data on **multiple machines** connected via a network.

### 🌟 **Why Replicate Data?**
- 🗜️ **Geographic Proximity** → Reduce latency by keeping data close to users.
- 🔀 **Fault Tolerance** → Ensures system can continue working during partial failures.
- 📈 **Read Scalability** → Increases read throughput by distributing read load across replicas.

### 🧠 **Assumption for This Chapter**
- Dataset is small enough that **each machine can store the entire dataset**.

> ⚠️ **Partitioning** (sharding) for large datasets is discussed in **Chapter 6**.

### ⚡️ **What Makes Replication Hard?**
- **Static data** → Easy to replicate (copy once).
- **Dynamic (changing) data** → Complex, due to need to **synchronize updates** across replicas.

---

## 🧪 Types of Replication Algorithms (to be discussed)
1. **Single-Leader Replication**
2. **Multi-Leader Replication**
3. **Leaderless Replication**

> All distributed databases use one of these. Each has trade-offs.

---

### ⚙️ **Additional Considerations**
- **Hot/Warm/Cold Standbys**  
  > E.g., PostgreSQL:
  - *Hot standby* → Accepts read queries.
  - *Warm standby* → Applies changes, doesn’t serve reads.

- **Synchronous vs. Asynchronous replication**
- **Handling failed replicas**
- **Eventual consistency, read-your-writes, and monotonic reads**  
  > These are impacted by replication lag.

---

### 📚 Historical Note
- Replication concepts date back to the **1970s**.
- Despite this, **distributed databases** became mainstream much later.
- Many developers are still learning this area → Common misunderstandings around concepts like *eventual consistency*.

