### Faults

Faults(During write)
* DB Software or Hardware fails (middle of write)
* application crash 
* interrupt in networks 
* several clients write to DB at same time overwrite
* client read partially writteten data
* Race confitions between client

### Solution 
* A transaction is usually understood as a mechanism for
grouping multiple operations on multiple objects into one unit of execution.
* Transaction for fault tolerance
* Group several read and write in one logical unit.
* All reads and writes executed as one operation. succeeds (commit) fails(abort, rollback)
* Don't need to worryu about partial failure


#### 
#### ACID Atomicity, Consistency, Isolation, Durability
#### BASE Basically Available, Soft State and Eventual Consistency
* Safety guanranteed by Transaction 
* 
### Atomicity
* cannot broken down to smaller parts
* whole Transaction should be aborted when write process fails
### Consistency
* Invariant (Data) should be validated
* application has all the control here. 
* If you write bad data then DB is not responsible
* application helps to main Consistency data with Isolation and Durability
### Isolation
* Race conditon on same data
* one Transaction per DB performance penalty
### Durability
* Durability is the promise that once a transaction has com‐
mitted successfully, any data it has written will not be forgotten, even if there is a
hardware fault or the database crashes.
* HDD or SSD. Involves WAL 
* In Replication to some nodes
* Inorder to provide a durability guarantee, a database must wait until these writes or
replications are complete before reporting a transaction as successfully committed.


### Single and multiple Object 

Single Object (read - modify - write cycle )
* Log for Atomicity
* Lock of object  

Multiple Object
* Update several objetcs in sync
* Like unread message and unread_count
* RDBMS PK, FK in different models
* Document Model (All in same model) expect denormalized

#### Handling Erros

* Transaction failed and aborted and safely retry thats the point
* ORM (Like Django) don't even retry aborts just pop a error in call stack
### Why Reasons
* Server commited and acknowledged but network issue client didnt receive commit acknowledgedment. Retry will result in duplication unless another layer is there to hanlde duplication
* error due to overload , retrying will make it worse, reduce retries
* error due to dealock Isolation, network or failure retry is pointless
* side effect like send mail every time, so don't need to retry here


### Weak Isolation Level
### Read commited
* Read only commited data
* Write only commited data

### Dirty Read
* When transaction1 is not yet commted byt transaction2 can read the data is called dirty read
* Read an data which is not yet commited transaction
* This means that even within a single transaction, different queries might see different states of the database if other transactions commit changes in the meantime. This approach prevents dirty reads but allows non-repeatable reads and phantom reads.
### Non Repeatable reads
* T1 reads data (amount: 100)
* T2 commits the data (amount: 50)
* Now T1 again reads the data (amount: 50)
* Inconsistent data when multiple read in a transaction

### Phatom read
* T1 reads and find 3 row matching a query
* T2 insert a query
* T1 again reads the query and finds out there are indifference in rows

### Dirty Writes
* Two transaction wirte same object we have no idea about the order
* Write an data which is not yet commited transaction

### Snap Shot Isolation and Repeatable Read

* To prevent phantom and non repeatable reads
* Each transaction operates on a consistent snapshot of the database, as it existed at the start of the transaction.

Long running Backups AND  Analytics

#### Visiblity 
* T1 with transaction id 
* T2 reads old data as T1 is not yet commmited
* This maintains consistent data for long eunnung transactions

### preventing Lost Updates

* Two Transaction write on object
* T1 reads the current value of a record.
* T2 reads the same value of the record.
* T1 modifies the value and writes it back to the database.
* T2, unaware of T1's update, modifies the original value and writes it back, overwriting T1's changes.
* T1 update is lost

#### Solution
#### Pessimistic Locking:
* Locking data being read
#### Optimistic Locking
* transactions proceed without locking resources but check for conflicts before committing
* When conflicts it's rollback and retries
#### Atomic Operations:
* UPDATE statements with conditions, ensures that updates occur only if the data hasn't changed since it was last read
* If the data has changed, the update fails, and the transaction can be retried.
#### Serializable Isolation Level:
* highest isolation leve
* transaction are executed in some order

### Skew and phantom
* Conditon atlest 2 doctors for shifit
* T1 -> Doctor1 feels ill
* T2 -> Doctor2 feels ill
* Both concurenlty apply for leave due to snapshap both will trigger query on snapshot.
* Both will apply leave and their leave will be approved 
* This is called skewed write

* Conconcurrent read same data
* Disjoint Write: Each transaction update different part of data
* Lack of immediate conflict: since updating different data

### Serializable 
* ensuring that the outcome of concurrent transactions is the same as if they were executed sequentially.
* prevents all potential race conditions and anomalies, such as dirty reads, non-repeatable reads, phantom reads, lost updates, and write skew.

* Two Phase Locking 
* Growing phase: A transaction acquires all the locks it needs without releasing any.
* Shrinking Phase: After acquiring all necessary locks, the transaction releases them as it completes operations
* Serializable Snapshot Isolation (SSI)
* It allows transactions to operate on a consistent snapshot of the database and checks for conflicts before committing
*  If a conflict is detected, one of the conflicting transactions is aborted to maintain serializability. 



### Actual Serial Execution

* Single Thread so only one transaction at a time limit through put
* To migitate partition and assign Thread to partition
* Multiple transaction provided access
different partition
* If transaction span accross partition then 2 phase locks or SSI is used

### Challenges

* Concurrency Control: Allowing multiple transactions to run simultaneously can lead to conflicts, such as two transactions trying to modify the same data. Managing these conflicts requires sophisticated mechanisms.
* Performance Overhead: Techniques to ensure serializability, like locking data items, can introduce delays and reduce system throughput.

#### approach to implement
* Actual Serial Execution: Executing transactions one at a time eliminates concurrency issues but severely limits performance, making it impractical for systems with high transaction volumes
* Two-Phase Locking (2PL): This method involves acquiring all necessary locks before a transaction proceeds and releasing them after completion. While it ensures serializability, it can lead to deadlocks and reduced performance due to waiting for locks.
* Optimistic Concurrency Control (OCC): Transactions execute without restrictions but undergo validation before committing to ensure no conflicts occurred. If a conflict is detected, the transaction is rolled back. This approach works well when conflicts are rare.
* Serializable Snapshot Isolation (SSI) : An advanced form of OCC, SSI provides a consistent snapshot of the database to each transaction and checks for conflicts during the commit phase.


### 2 Phase Locks 
* concurrency control protocol used in DB
#### Growing (Expanding) Phase: 
During this phase, a transaction may acquire locks on data items as needed but cannot release any locks.

#### Shrinking (Contracting) Phase: 
In this phase, a transaction releases its acquired locks and is prohibited from obtaining any new locks.

#### Deadlocks: 
Since transactions may block each other while waiting for locks, deadlocks can occur, requiring additional mechanisms for detection and resolution.

#### Cascading Aborts: 
If a transaction holding locks is aborted, other transactions that have depended on the modified data may also need to be aborted to maintain consistency.

### Strict Two-Phase Locking (S2PL): 
This variant requires that all exclusive (write) locks held by a transaction are released only after the transaction commits or aborts, thereby preventing other transactions from reading uncommitted data and eliminating cascading aborts.

#### Rigorous Two-Phase Locking (Rigorous 2PL or SS2PL): 
In this approach, all locks (both shared and exclusive) are held until the transaction commits or aborts, providing an even stricter protocol that simplifies recovery and ensures strict serializability.


### Implementation

* Shared Lock (read)
* Exclusive Lock (write)

* if T1 wants to read acquire shared lock. several transaction can hold shared lock but if T2 already has exclusive lock means T1 has to wait
* If T1 wants to write the it should acquire exclusive lock
other transaction should not hold(exclusive or shared lock)
* if T1 read first and then write it's may upgrade from shared to exclusive Lock
* Hold lock until commit or abort. This is two phase called first phases while excecuting lock is acquired and second phase when end of transaction lock are released


* Deadlock: transaction A is stuck
waiting for transaction B to release its lock, and vice versa 
### Performance
* Transaction throughput and response time of query are significant worse in 2 phase than under weak isolation

Reasons
* overload of acquire and releasing locks 
* reduced concurrency
* T1 has to wait to T2.
* Depending on wait latency may increase
* Deadlock 


#### Predicate Locks
Functioning of Predicate Locks:

Read Operations: When a transaction performs a read based on a certain condition, it acquires a shared-mode predicate lock on that condition. This prevents other transactions from making conflicting modifications to any records that satisfy the condition until the lock is released.

Write Operations: Before inserting, updating, or deleting a record, a transaction must check for existing predicate locks that its operation might conflict with. If such locks exist, the transaction must wait until they are released, ensuring that no conflicting operations occur concurrently.

#### Index 
* To address these performance concerns, many databases implement index-range locking, also known as next-key locking, as a more efficient approximation of predicate locking. 
* This technique involves locking a range of entries in an index that corresponds to the predicate condition. 
* For instance, if a transaction searches for bookings of room 123 between noon and 1 p.m., the database can lock the index entries for room 123 during that time range. 
* This approach ensures that other transactions cannot insert, update, or delete records within that range until the lock is released, effectively preventing phantoms without the extensive overhead of full predicate locking.

* However, index-range locking requires the presence of suitable indexes. 
* If no appropriate index exists, the database might resort to locking the entire table to maintain serializability, which can significantly impact performance

### Serializable Snapshot Isolation (SSI)
* Weak Isolation (lost updates, write skew, phantoms)
* 2PL (performance, scaling issue)

* serializability while allowing transactions to execute under Snapshot Isolation 

#### Implementation
* Snapshot Isolation (SI) Basics
    1. Transactions operate on a snapshot of the database.
    2. They do not see changes from concurrent transactions until commit.
    3. This prevents read phenomena like dirty reads and non-repeatable reads.

* SI Anomalies
    1. SI can lead to anomalies such as write skew, where two concurrent transactions read old data and make conflicting updates that should have been serialized.

* Detecting & Preventing Anomalies
    1. SI dynamically detects conflicts caused by anti-dependencies (i.e., when a transaction reads an old version of a value and another transaction updates it).
    2. Instead of blocking transactions like traditional locking mechanisms, SSI detects dangerous conflicts and aborts one of the transactions to maintain serializability.

#### Key Mechanism
* Tracking Reads & Writes:
    1. The system tracks which transactions read which versions of data.

* Conflict Detection (Anti-Dependencies):
    1. If a transaction reads data that a concurrent transaction later modifies, it creates an anti-dependency.
    2. If a transaction that wrote the newer version also committed, the reading transaction may be aborted.
*   Abort & Retry Strategy:
    1. Instead of blocking, SSI aborts conflicting transactions, forcing them to retry, ensuring serializability without locking.

#### Cons

✅ Provides true serializability without locking overhead.
✅ Retains performance benefits of SI by allowing concurrent reads.
✅ Avoids deadlocks and blocking waits.

#### Challenges
Increased abort rates under high contention.
⚠️ Overhead in tracking anti-dependencies.
⚠️ May require application-level retry logic.