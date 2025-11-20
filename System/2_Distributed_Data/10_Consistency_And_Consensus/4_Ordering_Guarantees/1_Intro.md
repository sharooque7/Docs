# Ordering Guarantees in Distributed Systems

## The Fundamental Role of Ordering
- **Linearizability**: Implies a total order of operations
- **Key insight**: Ordering enables consistency guarantees
- **Analogy**: Single copy of data requires ordered operations

## Manifestations of Ordering

### 1. Replication (Chapter 5)
| Replication Type | Ordering Mechanism |
|------------------|--------------------|
| Single-leader | Leader sequences writes in log |
| Multi-leader | Conflict resolution needed |
| Leaderless | Casual dependencies emerge |

### 2. Transactions (Chapter 7)
- **Serializability**: Transactions appear to execute sequentially
- Implementation approaches:
  - Actual serial execution
  - Locking/aborting to prevent conflicts

### 3. Time & Clocks (Chapter 8)
- **Challenge**: Establishing global order without coordination
- **Solutions**:
  - Logical clocks (Lamport timestamps)
  - Hybrid clocks (combining physical and logical)
  - Version vectors

## Deep Connections
1. **Ordering → Consistency**: Determines what state is visible when
2. **Linearizability**: Special case of total ordering
3. **Consensus**: Fundamentally about agreeing on order

## Implications
- **Performance cost**: Stronger ordering requires more coordination
- **Trade-off**: Weaker ordering models improve availability
- **Fundamental limit**: Cannot have both unrestricted availability and total ordering (CAP)

> "Ordering is the foundation upon which distributed consistency is built."