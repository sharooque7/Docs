**Notes on Data Models and Query Languages**

### 1. **Data Models**
   - **Relational Model**: Uses tables (relations) with predefined schema.
   - **Document Model**: Stores semi-structured data as JSON or BSON.
   - **Graph Model**: Uses nodes and edges to represent relationships.
   - **Key-Value Stores**: Simple lookups based on keys.
   - **Column-Family Stores**: Optimized for read-heavy workloads, similar to relational databases but with flexible schema.

### 2. **Schema Design**
   - **Normalization**: Reduces redundancy, improves consistency.
   - **Denormalization**: Optimizes for read-heavy applications by duplicating data.
   - **Indexing**: Speeds up queries but affects write performance.
   - **Partitioning & Sharding**: Distributes data across multiple nodes for scalability.

### 3. **Query Languages**
   - **SQL (Structured Query Language)**: Used in relational databases.
   - **NoSQL Query Languages**:
     - MongoDB: Uses JSON-like queries.
     - Cassandra: Uses CQL (Cassandra Query Language).
     - Neo4j: Uses Cypher for graph-based queries.
   - **Query Optimization**: Database engines use execution plans and indexing to improve performance.

### 4. **Transactions & Concurrency Control**
   - **ACID (Atomicity, Consistency, Isolation, Durability)**: Ensures reliable transactions.
   - **BASE (Basically Available, Soft state, Eventually consistent)**: Used in distributed databases for availability.
   - **Isolation Levels**:
     - Read Uncommitted
     - Read Committed
     - Repeatable Read
     - Serializable
   - **Optimistic vs. Pessimistic Locking**:
     - Optimistic: Assumes minimal conflicts; retries on failure.
     - Pessimistic: Locks data to prevent conflicts.

### 5. **Replication & Distribution**
   - **Leader-Follower Replication**: Writes go to the leader, followers replicate.
   - **Multi-Leader Replication**: Allows writes on multiple nodes.
   - **Eventual Consistency**: Guarantees that data will eventually sync across nodes.

### 6. **Data Storage Internals**
   - **B-Trees & LSM Trees**: Used for indexing.
   - **Write-Ahead Logging (WAL)**: Ensures durability.
   - **Compaction & Garbage Collection**: Optimizes storage by merging or deleting old records.

### 7. **Distributed Systems Considerations**
   - **CAP Theorem**: Trade-off between Consistency, Availability, and Partition Tolerance.
   - **Consensus Protocols**:
     - Raft: Simpler leader election and consensus.
     - Paxos: Complex but widely used in distributed databases.

### 8. **Use Cases & Trade-offs**
   - **OLTP (Online Transaction Processing)**: Requires ACID properties, relational databases.
   - **OLAP (Online Analytical Processing)**: Requires high read performance, columnar storage.
   - **Event-Driven Systems**: Use log-based storage (Kafka, Pulsar).

---
These notes capture the key takeaways for a quick refresh. Let me know if you want to dive deeper into any topic! 🚀

