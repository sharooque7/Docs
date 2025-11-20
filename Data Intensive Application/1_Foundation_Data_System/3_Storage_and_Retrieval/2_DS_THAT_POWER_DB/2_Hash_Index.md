# Hash Indexes in Database Storage

## Core Concept
- **In-memory hash map** that maps keys to byte offsets in an append-only data file
- Enables fast O(1) lookups by key
- Example implementation: Bitcask (used in Riak)

## How It Works
1. **Write Path**:
   - Append new key-value pair to log file
   - Update in-memory hash map with new key → offset mapping

2. **Read Path**:
   - Lookup key in hash map to get file offset
   - Seek to offset in file and read value

## Advantages
✔ **Fast writes**: Appending is sequential I/O  
✔ **Fast reads**: Single disk seek per lookup (O(1))  
✔ **Simple crash recovery**: Can rebuild index by scanning log  
✔ **Concurrency friendly**: Immutable segments enable easy multi-threaded reads  

## Implementation Challenges

### Segment Files
- Break log into fixed-size segments
- Older segments get compacted (remove duplicate keys)
- Merging combines multiple segments while compacting

### Key Considerations
| Challenge | Solution |
|-----------|----------|
| **Disk space** | Segment compaction |
| **Deletions** | Tombstone records |
| **Crash recovery** | Periodic index snapshots |
| **Partial writes** | Checksums for corruption detection |
| **Concurrency** | Single writer thread, multiple readers |

## Limitations
- **Memory-bound**: All keys must fit in RAM
- **No efficient range queries**: Can't scan key ranges
- **Write amplification**: Compaction rewrites data
- **Not optimal for write-heavy with many unique keys**

## When to Use
- **Good for**: 
  - High write throughput
  - Frequent updates to existing keys
  - Simple key-value access patterns
- **Not ideal for**:
  - Very large key spaces
  - Range/prefix queries
  - Memory-constrained environments

## Performance Characteristics
| Operation | Complexity | Notes |
|-----------|------------|-------|
| Write | O(1) | Append-only |
| Read | O(1) | Hash lookup |
| Range query | O(n) | Full scan required |
| Compaction | O(n) | Background process |

> "Hash indexes trade memory usage for fast point lookups, while sacrificing range query capability."


Key takeaways:

Hash indexes provide excellent point lookup performance

Append-only design simplifies concurrency and recovery

Segment compaction is crucial for managing disk space

Memory requirements limit scalability for large key spaces

Fundamentally different tradeoffs than tree-based indexes