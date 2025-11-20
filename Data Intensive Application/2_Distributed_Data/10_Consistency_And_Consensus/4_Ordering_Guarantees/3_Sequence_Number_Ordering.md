# Sequence Number Ordering and Causality

## The Challenge of Tracking Causality
- Explicitly tracking all causal dependencies is impractical
- Need efficient ways to order events while preserving causality

## Sequence Number Approaches

### Single-Leader Systems
- Natural total order from replication log
- Leader increments counter for each operation
- Preserves causality automatically

### Multi-Leader/Leaderless Systems
| Method | Description | Problem |
|--------|-------------|---------|
| **Node-specific ranges** | Odd/even or block allocation | No causal consistency |
| **Physical timestamps** | Using clock time | Clock skew violations |
| **Lamport timestamps** | (counter, nodeID) pairs | Preserves causality |

## Lamport Timestamps Deep Dive

### How They Work
1. Each node maintains:
   - Unique node ID
   - Local counter
2. Timestamp format: `(counter, nodeID)`
3. Protocol rules:
   - Include max seen counter in all messages
   - Update local counter when receiving higher value

### Properties
- **Total ordering**: Comparable timestamps
- **Causal consistency**: If A → B, then ts(A) < ts(B)
- **Compact**: Only need (counter, nodeID) per op

### Limitations
- Can't distinguish concurrent vs causal ops
- Doesn't solve real-time decision problems
  - e.g., unique username allocation

## The Finality Problem
- Total order only emerges after collecting all ops
- Can't make immediate decisions without consensus
- Leads to the need for **total order broadcast**

> "Lamport timestamps provide ordering but not coordination - for that you need consensus."

## Visualizing Lamport Timestamps
Client A Node 1 (counter=1) Node 2 (counter=5)
| | |
|---------->| (counter=1) |
| | (updates to 5) |
|<----------| (counter=6) |
|----------------------------->| (counter=5)
|<-----------------------------| (counter=6)


Key takeaways:
1. Lamport timestamps efficiently capture causality
2. Different approaches needed for immediate decisions
3. Final ordering requires collecting all operations
4. Consensus needed for real-time coordination