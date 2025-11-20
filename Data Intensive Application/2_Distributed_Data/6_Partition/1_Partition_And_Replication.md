# Partitioning (Sharding)

## Overview
Partitioning (or sharding) splits large datasets into smaller subsets (partitions) distributed across multiple nodes. It enables:
- **Horizontal scaling** of data storage and query throughput  
- **Parallel processing** across nodes  
- **Fault isolation** (issues in one partition don't affect others)

**Terminology Variations**:
| System       | Term for Partition |
|--------------|--------------------|
| MongoDB      | Shard              |
| Elasticsearch| Shard              |
| HBase        | Region             |
| Bigtable     | Tablet             |
| Cassandra    | vnode              |
| Couchbase    | vBucket            |

## Key Characteristics
- **Data Ownership**: Each record belongs to exactly one partition.
- **Shared-Nothing Architecture**: Partitions live on independent nodes.
- **Combined with Replication**: Partitions are replicated for fault tolerance (see Figure 6-1).
