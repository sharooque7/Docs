# Partitioning and Secondary Indexes

## Overview
Secondary indexes complicate partitioning because they don't map cleanly to partitions like primary keys do. Two main strategies exist:
1. **Document-Partitioned Indexes (Local Indexes)**  
2. **Term-Partitioned Indexes (Global Indexes)**  

---

## 1. Document-Partitioned Indexes (Local Indexes)
**How It Works**:
- Each partition maintains its **own secondary indexes** (e.g., `color:red`, `make:honda`) **only for documents it stores**.
- Example: Used car database partitioned by `document_id` (Figure 6-4).

**Write Behavior**:
- Writes only affect the partition where the document lives.  
- Index updates are automatic (e.g., adding a red car updates `color:red` in its partition).  

**Read Behavior**:
- Queries must **scatter/gather** across all partitions (e.g., "find all red cars" queries every node).  
- Combines results client-side.  

**Pros & Cons**:
| ✅ Pros                          | ⚠️ Cons                          |
|----------------------------------|----------------------------------|
| Simple writes (no cross-partition ops) | Expensive reads (tail latency risk) |
| No single point of failure       | No partition isolation for queries |

**Used By**: MongoDB, Riak, Cassandra, Elasticsearch, SolrCloud, VoltDB.  

**Optimization Tip**:  
Design partitioning to align secondary index queries with single partitions (hard for multi-index queries).  

---

## 2. Term-Partitioned Indexes (Global Indexes)
**How It Works**:
- Secondary indexes are **partitioned separately from data** (e.g., `color:red` entries live together, regardless of document location).  
- Example: Car color index split alphabetically (`a-r` in Partition 0, `s-z` in Partition 1) (Figure 6-5).  

**Partitioning Strategies**:
- **By Term**: Supports range queries (e.g., numeric ranges).  
- **By Term Hash**: Evenly distributes load.  

**Write Behavior**:
- Single-document writes may update **multiple index partitions** (e.g., a red Honda updates `color:red` and `make:honda`).  
- Often **asynchronous** (no distributed transactions).  

**Read Behavior**:
- Directly query the relevant index partition (no scatter/gather).  

**Pros & Cons**:
| ✅ Pros                          | ⚠️ Cons                          |
|----------------------------------|----------------------------------|
| Efficient reads (single-partition) | Complex writes (cross-partition) |
| Flexible querying                | Potential inconsistency (async updates) |

**Used By**:  
- DynamoDB (global secondary indexes, ~1s propagation delay).  
- Riak Search, Oracle Data Warehouse.  

---

## Key Trade-offs
| Factor                  | Document-Partitioned          | Term-Partitioned            |
|-------------------------|-------------------------------|-----------------------------|
| **Write Scalability**   | High (local only)             | Lower (global coordination) |
| **Read Scalability**    | Low (scatter/gather)          | High (targeted queries)     |
| **Consistency**         | Strong (immediate)            | Eventual (async)            |
| **Implementation**      | Simpler                       | Complex                     |

---

## Real-World Examples
### DynamoDB Global Secondary Indexes
- Async updates with "seconds" latency.  
- Queries routed to index partitions.  

### MongoDB Sharded Collections
- Secondary indexes are local to each shard.  
- Queries fan out to all shards unless filtered by shard key.  

### Elasticsearch/Solr
- Term-partitioned inverted indexes for full-text search.  

---

## Implementation Notes
- **Document-Partitioned**: Preferred for **write-heavy** workloads.  
- **Term-Partitioned**: Preferred for **read-heavy** analytics/search.  
- Hybrid approaches exist (e.g., **partition-aware caching** to mitigate scatter/gather costs).  

```
1. Document-Partitioned Indexes:
Partition 0: [doc1 (color:red), doc2 (color:blue)] → Index: {color:red: [doc1], color:blue: [doc2]}  
Partition 1: [doc3 (color:red)] → Index: {color:red: [doc3]}  
Query "red cars": Ask Partition 0 + Partition 1 → Merge [doc1, doc3]  

2. Term-Partitioned Indexes:
Index Partition 0: {color:red: [doc1 (Partition 0), doc3 (Partition 1)]}  
Index Partition 1: {color:blue: [doc2 (Partition 0)]}  
Query "red cars": Ask Index Partition 0 → Get [doc1, doc3] directly  
```