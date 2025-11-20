# Transactions: Reliability in the Face of Failures

## The Harsh Reality of Data Systems
**Common failure modes**:
- 🖥️ **Node failures**: Hardware/software crashes mid-operation
- 💥 **Application crashes**: Partial writes before completion
- 🌐 **Network issues**: Partitions, dropped packets, timeouts
- 🔄 **Concurrency anomalies**: Race conditions, dirty reads, lost updates
- 🧩 **Partial failures**: Some operations succeed while others fail

## Why Transactions Matter
**Core purpose**: Simplify application logic by grouping operations into atomic units.

### Key Guarantees (ACID Properties)
| Property      | Description                                                                 |
|---------------|-----------------------------------------------------------------------------|
| **Atomicity** | "All or nothing" - either all operations complete or none do                |
| **Consistency** | Database remains in valid state (invariants preserved) after transaction  |
| **Isolation** | Concurrent transactions don't interfere (illusion of serial execution)      |
| **Durability** | Committed writes survive failures                                         |

## Transaction Failure Modes & Solutions

### 1. Partial Failure Protection
**Scenario**: Application crashes after writing 3/5 records  
**Solution**:  
```sql
BEGIN TRANSACTION;
  INSERT INTO orders ...;  -- 1
  UPDATE inventory ...;    -- 2
  INSERT INTO logs ...;    -- 3
COMMIT;  -- All or nothing