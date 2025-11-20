# The Cost of Linearizability

## Key Trade-offs

### Availability vs. Consistency
| Scenario | Linearizable System | Non-linearizable System |
|----------|----------------------|--------------------------|
| Network partition | Becomes unavailable (CP) | Remains available (AP) |
| Normal operation | Lower performance | Higher performance |
| Multi-datacenter | Requires synchronous coordination | Can operate asynchronously |

### Performance Implications
- **Always slower**: Even without network faults
- **Fundamental limit**: Response time ≥ network delay uncertainty
- **Hardware analogy**: CPU caches sacrifice linearizability for speed

## The CAP Theorem Revisited

### Original Formulation
- **C**onsistency (Linearizability)
- **A**vailability (All nodes can process requests)
- **P**artition tolerance (Works despite network splits)

### Key Insights
1. **Misleading "pick 2" interpretation**: Partitions are inevitable
2. **Better phrasing**: "Consistent **or** Available when Partitioned"
3. **Narrow scope**: Only considers linearizability and network partitions

### Modern Perspective
- CAP is oversimplified and often misunderstood
- More precise frameworks now exist
- Still useful historically for shifting design thinking

## Practical Considerations

### When to Choose Linearizability
- **Required for**: 
  - Leader election
  - Distributed locks
  - Uniqueness constraints
- **Acceptable when**:
  - Lower performance is tolerable
  - Network is reliable

### When to Avoid Linearizability
- **Preferred for**:
  - Multi-datacenter deployments
  - High-availability requirements
  - Latency-sensitive applications
- **Alternatives**:
  - Eventual consistency
  - Conflict resolution
  - Application-level sequencing

## Implementation Challenges
- **Single-leader systems**: Risk of unavailability during partitions
- **Quorum systems**: Can't guarantee linearizability without sync repair
- **Hardware parallels**: CPU memory models show similar trade-offs

### Key features:

Clear comparison tables showing trade-offs

Balanced view of CAP theorem's value and limitations

Practical guidance on when to choose/avoid linearizability

Connects distributed concepts to hardware parallels

Maintains technical precision while being accessible

Focuses on actionable insights rather than just theory