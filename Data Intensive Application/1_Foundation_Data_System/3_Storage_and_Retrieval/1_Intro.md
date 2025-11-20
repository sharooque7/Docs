# Database Storage and Retrieval Fundamentals

## Core Responsibilities
At its essence, a database must:
1. **Store data** reliably when given information
2. **Retrieve data** efficiently when requested

## Storage Engine Perspectives

### Application Developer View
- **Data Models**: How data is structured (Ch. 2)
- **Query Languages**: How to request data (Ch. 2)

### Database Implementation View
- **Storage**: How data is physically stored
- **Retrieval**: How data is efficiently located

## Why Storage Internals Matter
1. **Engine Selection**: Choose optimal storage for workload
2. **Performance Tuning**: Understand optimization opportunities
3. **Troubleshooting**: Diagnose performance bottlenecks

## Storage Engine Architectures

### Log-Structured Engines
**Characteristics**:
- Append-only data files
- Immutable data segments
- Periodic compaction
- Hash indexes for quick lookup

**Advantages**:
- High write throughput
- Simple crash recovery
- Avoids random writes

**Use Cases**:
- Write-intensive workloads
- Time-series data
- Blockchain implementations

### Page-Oriented Engines (B-trees)
**Characteristics**:
- Fixed-size pages/blocks (typically 4KB)
- Balanced tree structure
- In-place updates
- Write-ahead log (WAL) for durability

**Advantages**:
- Predictable query performance
- Efficient range queries
- Mature implementations

**Use Cases**:
- Traditional RDBMS
- Mixed read/write workloads
- Systems requiring ACID transactions

## Workload Optimization

### Transaction Processing (OLTP)
- Many concurrent users
- Short, atomic operations
- Random access by key
- Example: e-commerce order processing

### Analytics Processing (OLAP)
- Few complex queries
- Large data scans
- Aggregation-focused
- Example: business reporting

## Performance Considerations

| Factor | Log-Structured | Page-Oriented |
|--------|---------------|--------------|
| **Write Speed** | Excellent | Good |
| **Read Speed** | Good (with index) | Excellent |
| **Update Cost** | Append-only | In-place |
| **Disk Usage** | Higher (compaction) | More efficient |
| **Concurrency** | Simple locking | Complex locking |

## Modern Trends
1. **LSM-Trees**: Hybrid log-structured approach (RocksDB, Cassandra)
2. **Column Stores**: Optimized for analytics (Redshift, BigQuery)
3. **Multi-Model**: Supporting multiple storage engines
4. **Cloud-Native**: Separation of compute and storage

> "The choice between storage engines ultimately depends on your read/write ratio, access patterns, and consistency requirements."

## Implementation Examples
```python
# Simplified log-structured storage example
class LogStorage:
    def __init__(self):
        self.log = []
        self.index = {}
    
    def write(self, key, value):
        self.log.append((key, value))
        self.index[key] = len(self.log) - 1
    
    def read(self, key):
        position = self.index.get(key)
        if position is not None:
            return self.log[position][1]
        return None
```

Key Tradeoffs
Read vs Write Optimization: Can't maximize both simultaneously

Latency vs Throughput: Optimizing for one often impacts the other

Durability vs Performance: More durability guarantees reduce speed