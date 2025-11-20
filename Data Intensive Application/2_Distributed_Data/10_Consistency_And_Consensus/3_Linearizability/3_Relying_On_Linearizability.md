# When Linearizability is Essential

## Critical Use Cases

### 1. Distributed Coordination
- **Leader election**: Must have exactly one leader (no split brain)
- **Distributed locks**: All nodes must agree on lock ownership
- **Implementation**: 
  - ZooKeeper/etcd provide linearizable primitives
  - Requires consensus algorithms (Paxos/Raft)

### 2. Uniqueness Constraints
- **Examples**:
  - Usernames/emails in databases
  - File paths in storage systems
  - Seat reservations
- **Mechanism**: 
  - Equivalent to atomic compare-and-set
  - First writer wins semantics

### 3. Cross-Channel Consistency
- **Problem**: Race conditions when:
  - Multiple communication paths exist (storage + queue)
  - No guaranteed operation ordering
- **Example**: 
  - Photo upload + resize workflow
  - Risk of processing stale versions

## When Linearizability Can Be Relaxed
| Scenario | Alternative Approach |
|----------|----------------------|
| Soft constraints (overbooking) | Eventual consistency + compensation |
| Read-after-write consistency | Version vectors/client tracking |
| Non-critical metadata | Conflict resolution |

## Implementation Considerations
- **Performance cost**: Requires coordination
- **Alternatives**: 
  - Application-level conflict resolution
  - Two-phase commit protocols
  - Client-side sequence numbers