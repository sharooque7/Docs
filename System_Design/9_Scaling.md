Here’s a well-organized **markdown summary** of the **Database Scaling** topic you just shared:

---

## 📊 Database Scaling

There are **two broad approaches** to scale databases:

---

### ✅ Vertical Scaling (Scaling Up)

**Definition:**  
Increasing the resources (CPU, RAM, Disk) of a **single server**.

**Pros:**
- Simple to implement.
- No changes in application logic.

**Cons:**
- Hardware limitations (e.g., max CPU/RAM).
- Single point of failure.
- Very expensive for powerful hardware.

**Example:**  
Amazon RDS offers DB servers with up to 24 TB RAM. StackOverflow in 2013 ran on a single master DB.

---

### 🚀 Horizontal Scaling (Scaling Out / Sharding)

**Definition:**  
Adding **more servers** to handle the data load.

#### 🔹 Sharding
Splitting the database into smaller, manageable chunks called **shards**.

- Each shard has the **same schema** but holds different data.
- A **hash function** routes data to appropriate shard (e.g., `user_id % 4`).
- **Sharding Key (Partition Key):** 
  - Determines how data is split.
  - Must ensure **even data distribution** for efficiency.

#### 🧩 Real-world Challenges

1. **Resharding:**
   - Needed when a shard grows too large or data isn’t distributed evenly.
   - Requires data migration and changes in sharding logic.
   - **Consistent hashing** is often used to reduce impact.

2. **Celebrity/Hotspot Problem:**
   - Popular users (e.g., Katy Perry, Justin Bieber) might overload a shard.
   - Solution: dedicate separate shards or even sub-partitions for such cases.

3. **Joins and De-normalization:**
   - Cross-shard joins are difficult.
   - **De-normalization** is a common workaround.

4. **NoSQL Integration:**
   - Offload some functionality to **NoSQL** to reduce relational DB load.
   - NoSQL is great for high-speed reads/writes, schema flexibility, and distributed architecture.

---

### 🖼 Diagram References (from original content)

- **Figure 1-20:** Vertical vs Horizontal Scaling
- **Figure 1-21:** Shard Routing Using Hash Function
- **Figure 1-22:** Sharded User Table
- **Figure 1-23:** Scaling with NoSQL Support

---

Let me know if you'd like to go over these with examples, diagrams, or prepare interview Q&A based on this topic. Ready for the next one whenever you are!