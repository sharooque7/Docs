# System Models and Distributed Algorithm Correctness

## System Models Overview

### Timing Models
| Model            | Assumptions | Realism |
|------------------|-------------|---------|
| **Synchronous**  | Bounded network delay, process pauses, clock error | Unrealistic for most systems |
| **Partially Synchronous** | Usually behaves synchronously, but may exceed bounds occasionally | Most practical systems |
| **Asynchronous** | No timing assumptions, no clocks | Extremely restrictive |

### Node Failure Models
1. **Crash-stop**: 
   - Node fails by crashing permanently
   - Never recovers

2. **Crash-recovery**: 
   - Nodes may crash and recover
   - Stable storage persists
   - Memory state lost

3. **Byzantine**:
   - Nodes may behave arbitrarily
   - Includes malicious behavior

> **Most practical model**: Partially synchronous with crash-recovery faults

## Algorithm Correctness

### Defining Correctness
Expressed through required properties:

**Example (Fencing Tokens):**
1. **Uniqueness**: No duplicate tokens
2. **Monotonic Sequence**: Tokens always increase
3. **Availability**: Non-crashed nodes eventually get responses

### Safety vs. Liveness Properties

| Property Type | Definition | Examples | Violation Characteristics |
|--------------|------------|----------|---------------------------|
| **Safety** | "Nothing bad happens" | Uniqueness, Monotonic sequence | Violation is permanent and identifiable |
| **Liveness** | "Something good eventually happens" | Availability, Eventual consistency | May not hold temporarily but can recover |

**Key Differences:**
- Safety must **always** hold in all system model scenarios
- Liveness may have caveats (e.g., "if majority nodes survive")

## Reality vs. Theoretical Models

### Practical Challenges
1. **Storage assumptions**:
   - Theoretical: Stable storage always survives crashes
   - Reality: Disk corruption, hardware failures, misconfigurations

2. **Quorum systems**:
   - Depend on nodes remembering stored data
   - "Amnesia" breaks correctness guarantees

3. **Edge cases**:
   - Must handle theoretically "impossible" scenarios
   - Often requires human intervention

### Value of Theoretical Models
- Essential for systematic problem solving
- Enable formal proofs of correctness
- Surface hidden timing/coordination issues
- **But**: Must be complemented with empirical testing

> "The difference between computer science and software engineering" - Handling cases the model assumes can't happen

## Implementation Considerations
```python
def handle_impossible_case():
    # What to do when theoretical assumptions fail
    log_error("Impossible condition occurred!")
    alert_operator()
    emergency_shutdown()
```

### Key Takeaways:

* System models are necessary abstractions but imperfect
* Safety properties are absolute; liveness may have conditions
* Real implementations must handle "impossible" cases
* Theory and practice must work together