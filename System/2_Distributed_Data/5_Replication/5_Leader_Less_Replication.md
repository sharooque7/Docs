# Leaderless Replication

## Overview
Leaderless replication is an alternative to single-leader and multi-leader replication models. In this approach:
- Any replica can directly accept writes from clients
- No concept of a leader enforcing write order
- Inspired by Amazon's Dynamo system (Riak, Cassandra, Voldemort are Dynamo-style databases)

## Key Characteristics

### Write Handling
- Clients send writes to multiple replicas in parallel (or via a coordinator node)
- No enforced ordering of writes
- Writes succeed based on quorum confirmation (e.g., 2 out of 3 replicas)

### Read Handling
- Clients read from multiple replicas in parallel
- Version numbers determine which value is newer
- May require read repair for stale replicas

## Node Outage Handling
Unlike leader-based systems:
- No failover process needed
- Writes succeed if they reach enough replicas (quorum)
- Stale reads possible from recently recovered nodes

## Data Synchronization Mechanisms

### Read Repair
- Client detects stale values during parallel reads
- Writes newer value back to stale replicas
- Effective for frequently read values

### Anti-Entropy Process
- Background process that copies missing data between replicas
- No particular order of replication
- May have significant delays

## Quorum Consistency
The system uses configurable parameters:
- `n` = number of replicas
- `w` = write quorum (minimum successful write confirmations)
- `r` = read quorum (minimum nodes to read from)

**Quorum condition**: `w + r > n` ensures at least one up-to-date node is read

Common configurations:
- `n` typically odd (3 or 5)
- `w = r = (n + 1)/2` (rounded up)
- Can vary based on read/write workload needs

## Limitations
Even with `w + r > n`, edge cases can occur:
- Sloppy quorums may use non-home nodes
- Concurrent writes may conflict
- Reads concurrent with writes may be inconsistent
- Failed writes may partially succeed

## Advanced Topics

### Sloppy Quorums and Hinted Handoff
- Allows writes to non-home nodes during network partitions
- "Hinted handoff" later moves data to correct nodes
- Improves availability but may return stale reads

### Multi-Datacenter Operation
- Replicas can span multiple datacenters
- Local quorums reduce cross-datacenter latency
- Async replication between datacenters

### Conflict Resolution
**Last Write Wins (LWW)**
- Uses timestamps to order writes
- Simple but may lose data
- Recommended for immutable data

**Happens-Before Relationship**
- Determines if operations are concurrent
- Version numbers track dependencies
- Concurrent operations require merging

### Version Vectors
- Tracks version numbers per replica per key
- Enables correct conflict resolution across replicas
- Basis for Riak's causal context

## Operational Considerations
- Monitoring staleness is challenging without replication logs
- Eventual consistency is deliberately vague
- Quantifying "eventual" is important for operations

## Implementation Examples
- **Riak**: Enabled sloppy quorums by default
- **Cassandra**: Disabled sloppy quorums by default, uses LWW
- **Voldemort**: No anti-entropy process