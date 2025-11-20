# Linearizability: The Single-Copy Consistency Model

## Core Principles
- **Illusion**: System behaves as if there's only **one copy** of the data
- **Atomicity**: Operations appear instantaneous between invocation and response
- **Recency**: All clients see the most recent value after write completion

## Operation Semantics
| Operation | Description | Linearizability Requirement |
|-----------|-------------|-----------------------------|
| `read(x) ⇒ v` | Read value of x | Must return most recent written value |
| `write(x,v) ⇒ r` | Set x to v | Change must become visible atomically |
| `cas(x,vold,vnew) ⇒ r` | Conditional write | Must succeed only if current value = vold |

## Key Constraints
1. **Value Transition Atomicity**:
   - Writes flip values at one instant (no partial visibility)
   - No "flipping back and forth" during writes

2. **Read-Write Ordering**:
   - If read R1 sees write W1, subsequent reads must see W1 or later writes
   - Illustrated by Figure 9-3's timing dependency

3. **Real-Time Recency**:
   - Operations after a completed write must see its effect
   - Even if requests were sent before write completed

## Practical Examples

### Figure 9-2 Scenario
- **Concurrent reads during write** may return old or new value
- **Non-concurrent reads**:
  - Before write: must return old value
  - After write: must return new value

### Figure 9-4 Complex Case
- **Valid sequence**: Database may reorder concurrent operations
- **Invalid case**: B's shaded read returns stale value after A saw newer value
- **CAS operations**: Demonstrate linearizable conditional writes

## Linearizability vs. Serializability
| Property        | Linearizability | Serializability |
|-----------------|-----------------|-----------------|
| **Scope**       | Single operation | Transaction group |
| **Time aspect** | Real-time order | Logical order |
| **Prevents**    | Stale reads | Write skew |
| **Combination** | Strict serializability when both apply |

## Implementation Challenges
- Requires precise operation ordering
- Must track causal dependencies
- Performance impact due to coordination
- Testing requires analyzing request/response timelines

Key features:

Clear comparison with serializability

Operation semantics table

Visual timeline references to figures

Core constraints as bullet points

Practical case breakdowns

Implementation considerations