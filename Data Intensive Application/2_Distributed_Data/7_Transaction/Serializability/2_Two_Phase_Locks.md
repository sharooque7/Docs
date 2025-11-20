# Two-Phase Locking (2PL)

## Overview
- **Historical significance**: Dominant serializability algorithm for ~30 years
- **Key characteristic**: Stronger locking requirements than basic dirty write prevention
- **Comparison**: 
  - Not to be confused with Two-Phase Commit (2PC)
  - Provides true serializability (unlike snapshot isolation)

## Locking Mechanism

### Lock Modes
| Lock Type | Shared Mode | Exclusive Mode |
|-----------|-------------|---------------|
| **Readers** | Multiple allowed | Blocked |
| **Writers** | Blocked | Single allowed |

### Locking Rules
1. **Reading**: Must acquire shared lock first
   - Blocked if exclusive lock exists
2. **Writing**: Must acquire exclusive lock first
   - Blocked if any lock exists (shared or exclusive)
3. **Upgrade**: Shared → Exclusive possible for read-modify-write
4. **Two Phases**:
   - **Phase 1 (Growing)**: Acquire all locks
   - **Phase 2 (Shrinking)**: Release all locks (only at transaction end)

## Implementation Characteristics

### Database Support
- MySQL (InnoDB) - Serializable isolation
- SQL Server - Serializable isolation  
- DB2 - Repeatable Read isolation

### Phantom Prevention
| Technique | Precision | Performance | Implementation |
|-----------|----------|------------|---------------|
| **Predicate Locks** | Exact matches | Poor | Checks all active locks |
| **Index-Range Locks** | Approximate | Good | Leverages existing indexes |
| **Table Locks** | Entire table | Worst | Fallback when no index |

## Performance Considerations

### Advantages
✔ Guarantees serializable isolation  
✔ Prevents all race conditions including:
  - Lost updates
  - Write skew
  - Phantom reads

### Disadvantages
✖ **Reduced concurrency**: Readers block writers and vice versa  
✖ **Deadlocks**: More frequent than weaker isolation levels  
✖ **Unpredictable latency**: Queueing effects at high contention  
✖ **Throughput impact**: Lock management overhead  

### Operational Challenges
- **Unbounded waits**: No timeout for lock acquisition
- **Deadlock handling**:
  - Automatic detection
  - Requires application retry logic
- **Performance instability**:
  - One slow transaction can stall system
  - High-percentile latency spikes

## Index-Range Locking (Next-Key Locking)

### Implementation Approach
1. **Index-based**: Attaches locks to index entries/ranges
2. **Approximation**: Locks broader range than strictly necessary
3. **Fallback**: Whole table lock if no suitable index exists

### Example Scenario
```sql
SELECT * FROM bookings 
WHERE room_id = 123 
  AND end_time > '12:00' 
  AND start_time < '13:00';
```

## Locking options:

1. Room ID index entry for 123 (coarse)
2. Time range in time-based index (medium)
3. Entire bookings table (last resort)

### Tradeoffs
* Precision vs Performance:
    * More precise → More expensive to check
    * Less precise → Reduced concurrency