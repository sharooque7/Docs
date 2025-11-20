# Leader and Follower

## Replicas and Leader-Based Replication

Each node that stores a copy of the database is called a **replica**. When multiple replicas are used, we must ensure that **all writes are processed by all replicas** to maintain consistency.

### Leader-Based Replication

Also known as **active/passive** or **master–slave replication**, this method works as follows:

1. **Leader Node**: One replica is elected as the *leader*. Clients send all **write** requests to the leader, which writes to local storage first.
2. **Follower Nodes**: Other replicas act as *followers*. They receive data changes from the leader in a **replication log** and apply them in the same order.
3. **Reads**: Clients may read from the leader or any follower, but **writes go only to the leader**.

This is supported in:

- Relational DBs: PostgreSQL (9.0+), MySQL, Oracle Data Guard, SQL Server AlwaysOn
- NoSQL DBs: MongoDB, RethinkDB, Espresso
- Message Brokers: Kafka, RabbitMQ
- Replicated file/block storage: DRBD

---

## Synchronous vs Asynchronous Replication

Replication can be:

- **Synchronous**: Leader waits for follower confirmation before responding to client.
- **Asynchronous**: Leader does not wait for follower acknowledgment.

### Example

In a web app, a user uploads a profile image:

- Leader receives the write and sends to two followers:
  - Follower 1: synchronous — leader waits for it.
  - Follower 2: asynchronous — leader does not wait.

**Trade-offs:**

| Mode         | Pros                                                 | Cons                                                      |
|--------------|------------------------------------------------------|-----------------------------------------------------------|
| Synchronous  | Ensures data consistency across nodes                | Slower writes, availability issues if any follower fails  |
| Asynchronous| High availability, faster writes                     | Risk of data loss on leader crash                         |

Most systems use a **semi-synchronous setup**:
- One synchronous follower, others asynchronous.
- If the synchronous one fails, another asynchronous becomes synchronous.

---

## Asynchronous Replication and Durability

In fully asynchronous setups:

- Writes may be **lost** if the leader crashes before replication.
- Durability is weakened but **performance improves**.
- Common when many followers or **geo-distributed nodes** are involved.

This trade-off is acceptable in many production environments.

---

## Research on Replication

**Chain replication** is a variant of synchronous replication that:
- Is used in systems like **Microsoft Azure Storage**.
- Aims to combine **performance** and **durability**.

The problem of ensuring consistent replication is closely tied to **consensus** (discussed in Chapter 9).

---

## Setting Up New Followers

When adding new follower nodes, data must be copied consistently.

### Steps:

1. Take a **consistent snapshot** of the leader’s data (usually supported by the DB or external tools like `innobackupex` for MySQL).
2. **Copy** the snapshot to the follower.
3. Follower **connects to leader**, asks for all changes since the snapshot.
   - This is tracked using replication log positions (e.g., PostgreSQL LSN, MySQL binlog coords).
4. Follower **applies the backlog** and *catches up* with the leader.

Implementation details vary between databases—some support **automated setup**, others need **manual steps**.

---


# Handling Node Outages in Data-Intensive Applications

## Introduction

In distributed systems, nodes can go down for various reasons - unexpected faults or planned maintenance (like rebooting to install security patches). A well-designed system should continue operating despite individual node failures, minimizing the impact of outages. This document covers how to achieve high availability with leader-based replication and explores various replication implementation methods.

## High Availability with Leader-Based Replication

### Follower Failure: Catch-up Recovery

When a follower node fails and restarts, or when network issues temporarily disconnect it from the leader, recovery follows these steps:

1. The follower consults its local log to identify the last transaction processed before the failure
2. It reconnects to the leader and requests all data changes that occurred during its disconnection
3. After applying these changes, the follower "catches up" to the leader
4. Normal operation resumes with the follower receiving the regular stream of data changes

### Leader Failure: Failover

Leader failure is more complex and involves a process called "failover":

#### Failover Process

**Manual Failover**: An administrator is notified of leader failure and manually promotes a new leader

**Automatic Failover**:
1. **Detecting leader failure**: Usually done through timeouts (if a node doesn't respond within a set period, e.g., 30 seconds, it's presumed dead)
2. **Choosing a new leader**: Can be through election (majority vote) or appointment by a controller node
   - The best candidate is typically the replica with the most up-to-date data
   - Achieving consensus on the new leader is a complex problem (covered in Chapter 9)
3. **Reconfiguring the system**: Clients must send write requests to the new leader
   - If the old leader returns, it must be made to recognize the new leadership hierarchy

#### Potential Failover Problems

1. **Data loss with asynchronous replication**: 
   - The new leader may not have received all writes from the old leader
   - Unreplicated writes from the old leader are often discarded, potentially violating durability expectations

2. **Coordination issues with external systems**:
   - Example: GitHub incident where an out-of-date MySQL follower was promoted
   - Autoincrementing primary keys were reused, causing inconsistency with Redis
   - This led to private data being disclosed to incorrect users

3. **Split brain scenarios**:
   - Two nodes both believe they are the leader
   - Without conflict resolution, data corruption likely occurs
   - Some systems implement shutdown mechanisms for dual-leader detection
   - These mechanisms require careful design to avoid complete system shutdown

4. **Timeout configuration challenges**:
   - Too long: Slower recovery after leader failure
   - Too short: Unnecessary failovers during temporary issues (load spikes, network glitches)
   - Unnecessary failovers may worsen existing system problems

These challenges lead some operations teams to prefer manual failovers despite the availability of automatic options.

## Implementation of Replication Logs

### Statement-Based Replication

The leader logs every write request (SQL statement) and forwards it to followers who execute it as if received from a client.

**Limitations**:
- **Nondeterministic functions**: Functions like `NOW()` or `RAND()` generate different values on each replica
- **Order dependency**: Statements with autoincrementing columns or that depend on existing data must execute in the exact same order on all replicas
- **Side effects**: Triggers, stored procedures, and user-defined functions may produce different effects on each replica

**Workarounds exist** (e.g., replacing nondeterministic calls with fixed values), but many edge cases remain.

**Usage**: Used in MySQL before v5.1; MySQL now defaults to row-based replication when nondeterminism is detected. VoltDB uses this approach but requires deterministic transactions.

### Write-Ahead Log (WAL) Shipping

This method leverages the storage engine's append-only log:
- For log-structured storage engines, this is the primary storage medium
- For B-trees, it's used for crash recovery

The approach:
1. The leader sends its write-ahead log across the network to followers
2. Followers process the log to build identical data structures

**Usage**: Implemented in PostgreSQL and Oracle

**Main disadvantage**: Tight coupling to storage engine internals
- The log contains low-level details about byte changes in disk blocks
- Version mismatches between leader and follower software typically not supported
- Makes zero-downtime upgrades difficult, as software version must match across nodes

### Logical (Row-Based) Log Replication

Uses a different log format for replication than for storage, decoupling replication from storage engine internals.

**Logical log format**:
- For inserts: Contains new values for all columns
- For deletes: Contains information to uniquely identify the deleted row (typically primary key)
- For updates: Contains row identification information plus new values for all columns (or at least changed columns)

**Benefits**:
- Better backward compatibility, allowing different versions of database software on leader and followers
- Easier to parse by external applications (useful for data warehousing, custom indexes, caches)
- Enables change data capture techniques

**Usage**: MySQL's binlog (when configured for row-based replication)

### Trigger-Based Replication

Moves replication logic to the application layer for greater flexibility.

**Implementation**:
1. Database triggers execute upon data changes
2. Triggers log changes to a separate table
3. External processes read from this table and apply application logic
4. Changes are replicated to other systems

**Use cases**:
- Replicating only a subset of data
- Replicating between different database types
- Implementing custom conflict resolution logic

**Examples**: Oracle GoldenGate, Databus for Oracle, Bucardo for Postgres

**Drawbacks**:
- Higher overhead than other replication methods
- More prone to bugs and limitations than built-in database replication