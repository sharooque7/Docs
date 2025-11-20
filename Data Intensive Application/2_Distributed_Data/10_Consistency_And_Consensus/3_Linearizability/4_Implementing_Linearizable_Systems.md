# Implementing Linearizable Systems

## Replication Methods and Linearizability

| Replication Method       | Linearizable? | Key Considerations |
|--------------------------|---------------|--------------------|
| **Single-leader**        | Potentially   | Requires: <br>- Reads from leader/sync followers <br>- Accurate leader detection <br>- Synchronous replication for durability |
| **Consensus algorithms** | Yes           | Implements safe linearizable storage (e.g., ZooKeeper, etcd) |
| **Multi-leader**         | No            | Concurrent writes create conflicts <br>No single data copy |
| **Leaderless**           | Unlikely      | Challenges even with strict quorums <br>LWW and sloppy quorums break linearizability |

## Quorum Systems Analysis

### Why Quorums Aren't Automatically Linearizable
- **Figure 9-6 Scenario**:
  - Writer: w=3 (all nodes)
  - Client A (r=2): sees new value 1
  - Client B (r=2): sees old value 0
  - Violation: B reads after A but gets stale data

### Making Quorums Linearizable
1. **For Reads**:
   - Perform synchronous read repair before returning results
   - Implemented in Cassandra for quorum reads
   
2. **For Writes**:
   - Read latest state from quorum before writing
   - Significant performance penalty

### Limitations:
- **No linearizable CAS**: Requires consensus algorithm
- **Concurrent writes**: LWW resolution breaks linearizability

## Practical Recommendations
1. **For strong consistency needs**:
   - Prefer consensus-based systems (ZooKeeper, etcd)
   - Use single-leader with synchronous replication

2. **When linearizability isn't critical**:
   - Leaderless can provide better availability
   - Multi-leader enables write locality

3. **Testing**:
   - Verify linearizability claims empirically
   - Check for edge cases in quorum behaviors