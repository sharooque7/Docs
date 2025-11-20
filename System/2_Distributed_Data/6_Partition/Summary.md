**Partitioning - Comprehensive Notes**

## 1. Introduction to Partitioning
Partitioning, also known as sharding, is the process of breaking large datasets into smaller, more manageable pieces (partitions) to improve scalability and performance. Each partition acts as a small, independent database.

### **Why Partitioning?**
- **Scalability**: Distributes data across multiple nodes, allowing horizontal scaling.
- **Performance**: Enables parallel query execution, reducing response times.
- **Fault Tolerance**: Works with replication to enhance data availability.
- **Load Distribution**: Prevents single-node bottlenecks by spreading the load.
- **Maintainability**: Allows efficient data pruning and retention policies.

## 2. Partitioning vs. Replication
- **Replication**: Keeps multiple copies of the same data for fault tolerance.
- **Partitioning**: Distributes different subsets of data across multiple nodes.
- **Hybrid Approach**: Many modern systems use both techniques together for scalability and fault tolerance.

## 3. Partitioning Strategies

### **3.1 Partitioning of Key-Value Data**
Each data record is assigned to exactly one partition. The goal is to distribute data and query load evenly.

**Challenges:**
- **Skewed Partitioning**: Uneven data distribution causes hotspots.
- **Hotspots**: Some partitions may receive disproportionately high queries, overloading specific nodes.
- **Resharding Complexity**: Moving partitions when data grows is difficult.

### **3.2 Partitioning by Key Range**
- Data is divided into continuous key ranges (e.g., A–F, G–L, M–R, S–Z).
- Used in **Bigtable, HBase, MongoDB (before v2.4), RethinkDB**.
- **Advantage**: Supports efficient range queries.
- **Disadvantage**: Risk of hotspots (e.g., time-based keys may overload the latest partition).

**Mitigation**: 
- Instead of using a timestamp as the key, prefix it with another attribute (e.g., sensor name + timestamp) to distribute writes more evenly.

### **3.3 Partitioning by Hash of Key**
- A hash function is applied to the key, and data is assigned based on the hash output.
- Used in **Cassandra, DynamoDB, Couchbase, Elasticsearch**.
- **Advantage**: Distributes data evenly and prevents hotspots.
- **Disadvantage**: Loses the ability to efficiently query ranges of data.

### **3.4 Directory-Based Partitioning**
- Uses a **lookup table** that maps keys to partitions.
- **Advantage**: Highly flexible (allows custom partitioning logic).
- **Disadvantage**: Lookup table can become a bottleneck at scale.

### **3.5 Sub-Partitioning (Multi-Level Partitioning)**
- Data is partitioned using one method (e.g., range partitioning), and then further partitioned using another method (e.g., hash partitioning).
- Used in **PostgreSQL, Oracle, MySQL**.

### **3.6 Virtual Partitions**
- Instead of using physical partitions, logical partitions are mapped dynamically to nodes.
- Used in **DynamoDB, Apache Kafka (partition leadership movement)**.

## 4. Partitioning and Indexing
- **Local Indexes**: Each partition maintains its own index (faster for local queries but slow for cross-partition queries).
- **Global Indexes**: A single index spans multiple partitions (faster for cross-partition queries but requires additional coordination).

## 5. Rebalancing Partitions
As data grows or shrinks, partitions may need to be redistributed.

### **5.1 Manual Rebalancing**
- Admin defines new partition boundaries and moves data.

### **5.2 Automatic Rebalancing**
- Some systems dynamically adjust partition boundaries based on data load.
- Common in **HBase, Bigtable, DynamoDB**.

## 6. Query Execution in Partitioned Systems

### **6.1 Direct Partition Querying**
- If the partitioning scheme is known, queries can be sent directly to the correct node.
- Used in **Cassandra, DynamoDB**.

### **6.2 Query Broadcasting**
- When the partition location is unknown, queries are sent to all nodes.
- Inefficient for large datasets but sometimes necessary.

### **6.3 Coordinator-Based Query Execution**
- A query coordinator determines the relevant partitions and aggregates the results.
- Used in **Google Spanner, Amazon Aurora**.

### **6.4 Partition-Aware Query Optimizations**
- Query engines in distributed databases optimize queries to minimize cross-partition reads.
- Used in **ClickHouse, Presto, Trino**.

## 7. Combining Partitioning and Replication
- **Leader-Follower Model**: Each partition has a leader (handles writes) and multiple followers (handle reads).
- **Multi-Leader Model**: Writes are distributed across multiple nodes to reduce bottlenecks.
- **Leaderless Replication**: No designated leader; all replicas can accept writes.

## 8. Trade-offs & Limitations
- **Consistency vs. Availability**: In distributed databases, strong consistency often requires cross-partition coordination.
- **Cross-Partition Queries**: Can be slow and complex to execute efficiently.
- **Partition Migrations**: Moving partitions is expensive and can temporarily degrade performance.
- **Storage Overhead**: Some partitioning techniques require additional metadata and indexing.

## 9. Real-World Implementations
| Database  | Partitioning Method |
|-----------|--------------------|
| MySQL | Range, List, Hash |
| PostgreSQL | Range, List, Hash, Sub-Partitioning |
| Cassandra | Hash-based (Consistent Hashing) |
| Kafka | Topic-based Partitioning |
| MongoDB | Sharding (Range or Hash) |
| DynamoDB | Hash Partitioning with Auto-Rebalancing |
| Bigtable | Range Partitioning with Auto-Rebalancing |

## 10. Best Practices for Partitioning
- **Avoid Hotspots**: Ensure even distribution of data and queries.
- **Choose the Right Strategy**: Hash partitioning for uniform distribution; range partitioning for efficient range queries.
- **Plan for Rebalancing**: Systems should handle growing datasets without manual intervention.
- **Monitor Query Performance**: Check if some partitions experience more load than others.
- **Use Partition-Aware Indexing**: Design queries and indexes to minimize cross-partition overhead.

## 11. Case Study: Apache Kafka Partitioning
- **Topic-based partitioning**: Each topic is divided into partitions.
- **Leader Election**: Each partition has a leader broker responsible for writes.
- **Consumer Scaling**: Consumers in a consumer group consume from multiple partitions in parallel.

## 12. Conclusion
Partitioning is essential for scaling large databases efficiently. The choice of partitioning strategy depends on the use case: 
- **Key-range partitioning** for range queries.
- **Hash partitioning** for uniform distribution.
- **Directory-based partitioning** for custom logic.
- **Sub-partitioning** for hierarchical data partitioning.

Understanding and implementing the right partitioning strategy ensures optimal performance, scalability, and fault tolerance.

