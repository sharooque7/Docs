## Partitioning Strategies

### 1. Partitioning by Key Range
**How It Works**:
- Assigns continuous key ranges to partitions (e.g., `A-D`, `E-H`).
- Keys within a partition are stored in sorted order.

**Pros**:
✅ Efficient **range queries** (e.g., timestamp ranges)  
✅ Supports **multi-column indexes**  

**Cons**:
⚠️ Risk of **hot spots** if keys are skewed (e.g., all writes to "today's" timestamp partition)  

**Examples**: 
- HBase, Bigtable, MongoDB (pre-2.4)

**Hot Spot Mitigation**:
- Use compound keys (e.g., `sensor_id-timestamp` instead of just `timestamp`).

---

### 2. Partitioning by Hash of Key
**How It Works**:
- Applies a hash function (e.g., MD5, Fowler–Noll–Vo) to keys.
- Assigns keys to partitions based on hash value ranges.

**Pros**:
✅ Evenly **distributes load** (avoids skew)  
✅ No hot spots from sequential keys  

**Cons**:
⚠️ **Loses range query capability** (adjacent keys are scattered)  

**Examples**: 
- Cassandra, MongoDB (hash-based sharding), Voldemort  

**Hybrid Approach (Cassandra)**:
- Compound primary keys:  
  - **Partition key**: Hashed (1st column)  
  - **Clustering columns**: Sorted (for range scans within a partition)  
  - Example: `(user_id, update_timestamp)` enables user-specific time-range queries.

---

### 3. Consistent Hashing (Misnomer Alert!)
**Note**: Despite the name, this is rarely used in databases due to rebalancing challenges. Prefer the term **hash partitioning**.

## Handling Hot Spots
**Problem**: Skewed workloads (e.g., celebrity user IDs).  
**Solutions**:
1. **Key Salting**: Append a random number to hot keys (e.g., `user_id_42` → `user_id_42_01`, `user_id_42_02`).  
   - Trade-off: Reads must combine data from all salted keys.  
2. **Manual Tracking**: Only apply salting to known hot keys.  

## Partitioning + Replication
- Each partition has multiple replicas across nodes (see Figure 6-1).  
- A node can be a **leader for some partitions** and a **follower for others**.  

## Trade-offs Summary
| Strategy         | Data Distribution | Range Queries | Hot Spot Risk |
|------------------|-------------------|---------------|---------------|
| **Key Range**    | Uneven            | ✅ Supported   | High          |
| **Hash of Key**  | Even              | ❌ Not supported | Low         |
| **Hybrid**       | Even              | ✅ Within partitions | Moderate |

## Use Cases
- **Key-Range**: Time-series data, logs, alphabetical ranges.  
- **Hash**: Uniformly accessed key-value data (e.g., user sessions).  
- **Hybrid**: Social media feeds (`user_id-timestamp`).


```
1. Key-Range Partitioning:
Partition 1: [A-D]  
Partition 2: [E-H]  
Partition 3: [I-Z]  

2. Hash Partitioning:
Hash(key) → Partition 1/2/3 (even distribution)

3. Hot Spot Mitigation:
Original Key: "celebrity_user" → Hot spot  
Salted Keys: "celebrity_user_01", "celebrity_user_02" → Distributed

```