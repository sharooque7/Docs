# Write Skew and Phantoms in Database Transactions

## Understanding Write Skew

Write skew is a subtle race condition that can occur between concurrent writes, distinct from dirty writes and lost updates. It happens when multiple transactions read the same objects but update different objects, with each update affecting the validity of the other transaction's preconditions.

### The On-Call Doctors Example

Consider a hospital scheduling system where:
- At least one doctor must always be on call
- Currently two doctors (Alice and Bob) are on call
- Both doctors request leave simultaneously

**Sequence of events:**
1. Alice's transaction reads: 2 doctors on call
2. Bob's transaction reads: 2 doctors on call
3. Alice updates her record to go off call
4. Bob updates his record to go off call
5. Both transactions commit
6. Result: No doctors on call - requirement violated!

## Characteristics of Write Skew

- Not a dirty write or lost update, as different objects are being modified
- A generalization of the lost update problem
- Occurs when transactions read the same data but update different objects
- Especially problematic under snapshot isolation

## Prevention Options for Write Skew

| Approach | Effectiveness |
|----------|--------------|
| Atomic single-object operations | Ineffective (multiple objects involved) |
| Automatic detection | Not available in most databases' snapshot isolation |
| Database constraints | Limited by database support for multi-object constraints |
| Explicit row locking | Effective but requires careful implementation |
| Serializable isolation | Most effective solution |

### Example of Explicit Locking Solution:

```sql
BEGIN TRANSACTION;
SELECT * FROM doctors
 WHERE on_call = true
 AND shift_id = 1234 FOR UPDATE;
UPDATE doctors
 SET on_call = false
 WHERE name = 'Alice'
 AND shift_id = 1234;
COMMIT;
```

## Common Write Skew Scenarios

1. **Meeting Room Booking System**
   - Preventing double-booking of rooms
   - Two users might simultaneously book overlapping time slots

2. **Multiplayer Games**
   - Ensuring game rules are followed
   - Players might make concurrent moves that together violate rules

3. **Username Registration**
   - Ensuring username uniqueness
   - Two users might attempt to register the same username simultaneously
   - (Note: Unique constraints can solve this specific case)

4. **Financial Systems**
   - Preventing overdrafts
   - Multiple simultaneous purchases might together exceed available funds

## Phantoms and Write Skew

Most write skew scenarios follow this pattern:

1. **Query Phase**: A SELECT checks if a requirement is satisfied
2. **Decision Phase**: Application decides to proceed based on query results
3. **Write Phase**: An INSERT, UPDATE, or DELETE modifies the database
4. **Result**: The write invalidates the precondition that was checked in step 1

The write in step 3 changes what would be returned by the query in step 1 - this effect is called a **phantom**.

## Handling Phantoms

The challenge with phantoms is that there may be no existing rows to lock with `SELECT FOR UPDATE` when checking for absence of conflicting data.

### Materializing Conflicts

A last-resort technique involves creating artificial lock objects:

1. Create a table representing all possible conflict states (e.g., room/time slot combinations)
2. Lock relevant rows using `SELECT FOR UPDATE` before checking for conflicts
3. Proceed with the actual operation if no conflicts exist

**Drawbacks**:
- Difficult to implement correctly
- Leaks concurrency control into the data model
- Error-prone and inelegant

## Conclusion

Write skew and phantom problems represent subtle but significant concurrency issues that can compromise application integrity. While techniques like explicit locking and materializing conflicts can help, a truly serializable isolation level is generally the most robust solution for preventing these anomalies.