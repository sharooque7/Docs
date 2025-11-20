# B-Trees vs LSM-Trees Comparison

## Performance Characteristics
| Feature | B-Trees | LSM-Trees |
|---------|---------|-----------|
| **Write Performance** | Slower (page overwrites) | Faster (sequential writes) |
| **Read Performance** | Generally faster | Slower (multiple SSTables) |
| **Write Amplification** | Higher (WAL + page writes) | Can be lower (depends on configuration) |
| **Storage Efficiency** | Less efficient (fragmentation) | Better compression, less fragmentation |
| **Predictability** | More predictable latencies | Higher latency at high percentiles |

## Advantages of LSM-Trees
- **Higher write throughput** due to sequential writes to SSTables
- **Better compression** and smaller disk footprint
- **Lower write amplification** in many workloads
- **Particularly effective on magnetic drives** where sequential writes are much faster
- **Reduced fragmentation** through periodic compaction

## Disadvantages of LSM-Trees
- **Compaction process** can interfere with ongoing operations
- **High percentile latencies** can be worse than B-trees
- **Compaction may not keep up** with high write throughput
- **Requires careful monitoring** to prevent running out of disk space
- **Multiple copies of keys** exist across different segments

## B-Tree Strengths
- **Mature implementations** with predictable performance
- **Each key exists exactly once** in the index
- **Better for transactional semantics** with key-range locks
- **More predictable latency** across all percentiles
- **Deeply ingrained** in traditional database architectures

## Considerations for Choice
- No quick rule for determining the better option
- **Workload dependent** - must test empirically
- **Write-heavy applications** may benefit from LSM-trees
- **Read-heavy applications** with strong transactional needs may prefer B-trees
- **SSD vs HDD** affects the significance of sequential vs random writes

> "In write-heavy applications, the performance bottleneck might be the rate at which the database can write to disk."

## Implementation Notes
- B-trees write data at least twice (WAL + tree page)
- LSM-trees manage compaction in the background
- SSD firmware often uses log-structured algorithms internally
- Database size affects compaction requirements
- Performance benchmarks are often inconclusive and workload-sensitive