# Single-Object vs Multi-Object Transactions

## Core Principles

### Atomicity Guarantees
- **All-or-nothing** execution
- Implemented via:
  - Write-ahead logging (WAL)
  - Undo/rollback capabilities
- Critical for maintaining data integrity

### Isolation Levels
| Level | Dirty Reads | Lost Updates | Phantoms | Performance |
|-------|-------------|--------------|----------|-------------|
| Read Uncommitted | ✓ | ✓ | ✓ | Best |
| Read Committed | ✗ | ✓ | ✓ | Good | 
| Repeatable Read | ✗ | ✗ | ✓ | Moderate |
| Serializable | ✗ | ✗ | ✗ | Lowest |

## Implementation Patterns

### Multi-Object Transactions
**Relational Example**:
```sql
BEGIN TRANSACTION;
  -- Transfer $100 between accounts
  UPDATE accounts SET balance = balance - 100 WHERE id = 1;
  UPDATE accounts SET balance = balance + 100 WHERE id = 2;
  
  -- Record transaction
  INSERT INTO transfers (from_acct, to_acct, amount) 
  VALUES (1, 2, 100);
COMMIT;

```

### Document DB Example:
-- MongoDB multi-document transaction
```
session.startTransaction();
  orders.insertOne({orderId: 123, items: [...]}, {session});
  inventory.updateMany(
    {itemId: {$in: [...]}},
    {$inc: {qty: -1}},
    {session}
  );
session.commitTransaction();
```

## Single-Object Operations

### Atomic Primitives:
1. Atomic increment:
```
INCR user:session:count
```
2. Compare-and-set:
```
UPDATE user_profiles 
SET last_login = '2023-07-20' 
WHERE user_id = 101 
IF last_login = '2023-07-19'
```

## Error Handling
### Transaction Retry Logic
```
def execute_transaction(max_retries=3):
    retries = 0
    while retries < max_retries:
        try:
            # Transaction logic
            return commit_transaction()
        except TransientError as e:
            retries += 1
            sleep(2 ** retries)  # Exponential backoff
    raise PermanentError("Max retries exceeded")
```

### Retry Considerations
1.
```
INSERT INTO payments (idempotency_key, ...)
VALUES ('a1b2c3d4', ...)
ON CONFLICT DO NOTHING;
```
2.Side Effect Management:
* Queue external actions for post-commit
* Implement compensating transactions

## Best Practices
When to Use Multi-Object
1. Financial transactions
2. Order processing systems
3. Inventory management
4. Anywhere referential integrity is critical

### Alternatives
1. Denormalization
```
// Order with embedded items
{
  "orderId": "123",
  "items": [...],
  "total": 99.99
}
```
2. Saga 
```
[Order Service] → [Payment Service] → [Inventory Service]
      ↑               ↓                     ↓
      └── Compensation Flow ←──────────────┘
```
3. Eventual Consistency:
* Accept temporary inconsistency
* Use version stamps for conflict resolution

## Monitoring
### Key Metrics

1. Transaction duration (p95, p99)
2. Rollback rate
3. Deadlock frequency
4. Retry attempts

### Alerting Rules
rules:
- alert: HighRollbackRate
  expr: rate(transactions_aborted[5m]) / rate(transactions_started[5m]) > 0.1
  for: 10m