# Consistency Guarantees in Distributed Systems

## The Reality of Replication Lag

Replication lag occurs in **all** types of replication methods:
- **Single-leader**
- **Multi-leader**
- **Leaderless**

This lag means:
- Simultaneous reads from different nodes may return different values.
- It takes time for writes to propagate across all nodes.

## Eventual Consistency

**Definition**:  
If writes stop, all replicas will **eventually** converge to the same values. This is also known as **convergence**.

**Characteristics**:
- A weak guarantee — no defined timeline for convergence.
- Temporary inconsistencies are expected.
- Reads during convergence may return:
  - Stale data
  - No data
  - Inconsistent results

### Challenges for Developers

Eventual consistency can break assumptions from single-threaded programming:

```python
db.write(x=5)  # May not be immediately visible
print(db.read(x))  # Could return old value
```