# Linearizability: The Single-System Illusion

## Core Concept
- **Also called**: atomic consistency, strong consistency, immediate consistency, external consistency
- **Key guarantee**: System appears to have only **one copy of data** with atomic operations
- **Effect**: Clients always see most recent write, never stale data

## How It Differs from Eventual Consistency
| Property          | Eventual Consistency | Linearizability |
|-------------------|----------------------|-----------------|
| Read your writes  | ❌ Not guaranteed    | ✅ Guaranteed   |
| Stale reads       | ✅ Possible          | ❌ Impossible   |
| Write visibility  | Delayed propagation  | Immediate       |

## Practical Example (Figure 9-1)
**Scenario**: 
1. Alice reads final World Cup score (write complete)
2. Bob reads immediately after Alice but gets stale data

**Why this violates linearizability**:
- Bob's read occurred **after** Alice's successful read
- Should have seen Alice's updated value
- Replica lag caused violation

## Technical Requirements
1. **Recency guarantee**: Reads reflect all prior writes
2. **Order preservation**: All clients see operations in consistent order
3. **No divergence**: Never two different "current" values

## Implementation Challenges
- Requires coordination between replicas
- Performance tradeoff vs. eventual consistency
- Network partitions can cause availability issues


### Key advantages of this format:

1. Clear comparison table showing differences
2. Concrete example explaining the concept
3. Bullet-pointed technical requirements
4. Highlights practical implications
5. Maintains all key information from original text
6. More scannable than paragraph form

