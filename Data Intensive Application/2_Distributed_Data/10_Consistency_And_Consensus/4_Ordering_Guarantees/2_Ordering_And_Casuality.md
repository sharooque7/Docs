# Ordering and Causality in Distributed Systems

## The Importance of Causality
Causality defines the fundamental "happened-before" relationships in a system:
- **Examples**:
  - Question must precede its answer
  - Database row must be created before being updated
  - Message must be sent before being received

## Causal Consistency vs. Linearizability

### Key Differences
| Property          | Causal Consistency | Linearizability |
|-------------------|--------------------|-----------------|
| **Order Type**    | Partial order      | Total order     |
| **Concurrency**   | Allows concurrent ops | No concurrency |
| **Performance**   | More efficient     | Higher latency  |
| **Availability**  | Maintained during partitions | May be lost |

### Relationship
- **Linearizability ⇒ Causality**: Any linearizable system preserves causality
- **Causality ⇏ Linearizability**: Causal systems can be more available

## Implementation Approaches

### Tracking Causal Dependencies
1. **Version Vectors**:
   - Generalized across entire database
   - Tracks "knowledge" of each node

2. **Read Tracking**:
   - Database records which versions were read by transactions
   - Enables conflict detection (like in SSI)

3. **Operation Logs**:
   - Explicitly track causal relationships between operations
   - Similar to Git's version history

### Handling Concurrent Operations
- Concurrent ops can be processed in any order
- Causal dependencies must be processed in order
- Missing dependencies trigger waits

## Practical Implications

### When Causal Consistency Suffices
- Most applications only truly need causality
- Avoids linearizability's performance costs
- Maintains availability during partitions

### Current Research Directions
- New databases exploring causal consistency
- Potential for better performance than linearizable systems
- Challenges in efficient implementation

> "Causality provides the strongest possible consistency that remains available during network failures."

## Visualizing Ordering
- **Total order (Linearizability)**: Single timeline of operations
- **Partial order (Causality)**: Branched timeline with merges (like Git history)
- **Concurrent ops**: Incomparable branches in the partial order