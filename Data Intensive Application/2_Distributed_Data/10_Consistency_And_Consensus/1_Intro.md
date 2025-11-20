# Building Fault-Tolerant Distributed Systems

## Approaches to Handling Faults

1. **Simplest Approach**:
   - Entire service fails on errors
   - Shows user error message
   - Often unacceptable for critical systems

2. **Fault Tolerance**:
   - System continues functioning despite component failures
   - Requires specialized algorithms and protocols

## Assumed Failure Modes
All Chapter 8 problems may occur:
- Network issues: lost/delayed/duplicate/reordered packets
- Time issues: unreliable clocks
- Node issues: GC pauses, crashes at any time

## Key Strategy: Reliable Abstractions

**Transaction Analogy** (from Chapter 7):
- Hides:
  - Crashes (atomicity)
  - Concurrency (isolation) 
  - Storage failures (durability)
  
**Distributed Systems Approach**:
- Build similar abstractions for distributed problems
- Let applications rely on these guarantees

## The Consensus Problem

### Definition
Getting all nodes to agree on something despite:
- Network faults
- Process failures

### Critical Use Case: Leader Election
- Single-leader replication systems
- Prevents split brain (multiple leaders)
- Ensures all nodes agree on leader identity

> **Split brain consequence**: Often leads to data loss

## Fundamental Limits

### What We'll Explore:
1. Possible guarantees in distributed systems
2. Boundaries of what can/cannot be achieved
3. Theoretical and practical limitations

### Characteristics:
- Decades of research behind these concepts
- Formal models and proofs exist (not covered in depth here)
- Focus on practical intuitions rather than formalisms

## Chapter Structure Preview

1. **First**: Explore guarantees and abstractions
   - Understand capabilities and limits

2. **Later**: Consensus algorithms ("Distributed Transactions and Consensus" p.352)
   - Practical implementations
   - Related problems

> **Key Insight**: Some faults are recoverable, others aren't - knowing the difference is crucial