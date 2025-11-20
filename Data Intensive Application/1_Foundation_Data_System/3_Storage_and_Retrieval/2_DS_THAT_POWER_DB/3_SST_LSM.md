# SSTables and LSM-Trees

## Core Concepts
- **SSTable (Sorted String Table)**: 
  - Key-value pairs sorted by key
  - Each key appears only once per segment
  - Basis for high-performance storage engines

- **LSM-Tree (Log-Structured Merge-Tree)**:
  - Algorithm for maintaining SSTables
  - Combines in-memory and on-disk structures
  - Used by LevelDB, RocksDB, Cassandra, HBase

## Key Advantages of SSTables

1. **Efficient Merges**:
   - Merges use merge-sort algorithm
   - Only keep latest version of each key
   - Can merge files larger than memory

2. **Sparse Indexing**:
   - In-memory index can be sparse (1 entry per few KB)
   - Locate key via binary search between indexed points

3. **Compression**:
   - Sorted nature enables block compression
   - Reduces I/O bandwidth and storage requirements

## LSM-Tree Architecture

### Write Path
1. Write arrives → stored in **memtable** (in-memory sorted tree)
2. Memtable fills → flushed to disk as SSTable
3. Background threads merge/compact SSTables

### Read Path
1. Check memtable (most recent data)
2. Check most recent SSTable
3. Progressively check older SSTables

### Crash Recovery
- Write-ahead log (WAL) preserves memtable contents
- WAL can be replayed after crash
- Discarded after memtable flushed to SSTable

## Performance Optimizations

| Technique | Benefit |
|-----------|---------|
| **Bloom filters** | Faster "key not found" checks |
| **Size-tiered compaction** | Better for write-heavy loads |
| **Leveled compaction** | Better read performance, less space |
| **Block compression** | Reduced I/O and storage |

## Real-World Implementations

**Databases using LSM-Trees**:
- LevelDB
- RocksDB
- Cassandra
- HBase
- Bigtable (Google)

**Full-text search**:
- Lucene (Elasticsearch/Solr)
- Uses similar SSTable-like structures

## Comparison to Hash Indexes

| Feature | Hash Index | LSM-Tree |
|---------|------------|----------|
| **Memory needs** | All keys in RAM | Sparse index |
| **Range queries** | Not supported | Efficient |
| **Write throughput** | High | Very high |
| **Read performance** | O(1) | O(log n) |
| **Disk space use** | Higher (no compression) | Lower |

> "LSM-trees combine the write performance of log-structured storage with the read efficiency of sorted data."

## Tradeoffs
- **Write amplification**: Multiple writes per update
- **Compaction overhead**: Background CPU/disk usage
- **Tuning complexity**: Many configuration parameters

Key takeaways:

SSTables provide efficient sorted storage through merging

LSM-trees combine memtables and SSTables for high performance

Different compaction strategies optimize for different workloads

Used widely in modern distributed databases

Fundamental tradeoff between write amplification and read performance