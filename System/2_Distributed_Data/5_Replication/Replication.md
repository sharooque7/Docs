
### Partiton

* Keep copy of same data on multiple machines
* Reduce latency
* Increase Availability
* scale out 

### Note
* Replication is easy if data not changes 

### Single Leader
### Multi Leader
### LeaderLess

### Trade Off
* Asycn vs Sync replicas
* Failer replicas

### Single Leader
* Active/Passive or master-slave replicas
* Master(Leader) - wrtie , store , pass info through logs
* Slave(follower) - Read, update the data from replication log or change stream

### Synchronous vs Async
### Sync
* leader waits for ack from follower
### Cons
* If follower fails , or network issue due to system max capacity the leader will be blocked
### Pros
* Atleast 2 nodes will have latest data
### Async
* Leader will not wait for ack
### Cons:
* If nodes are down then data will not be replicated
* Leader fails and it's data not passed down to nodes 
* Write to leader is not guarantee to be 

#### Setting Up New Follower

* Take Leader Snapshot
* Update the Node with the data
* Follower connect to node and request for data changes that have append since snapshot. Postion is log sequence number or binlog coordinates
* Caught up with the leader

### Handling Node Outages
* Maitenance
* Software Update
* Power Issue
* Netowrk Isseu
* Bugs in DB


### Follower Failure: Catch-up recovery
* On disk each node maintains log of data changes
* If node goes down and comes up 
* It will request the change in data for that time 
* When applied the changes it will caught up with leader

### Leader Failure: Failover

* Follower promoted to leader
* Client need to send writed to new leader
* Followers starts to consume data changes from new leader

### FailOver
* Manual (Admin picks new Leader after failure)
* Automatic 
* Fails - power issue, network , crash or many
* timeouts -  nodes sends messages to each other if lets say no response for more than 30 sec it failed

* Election to choose leader(elected by replicas or control node)
* Node with latest data is choosen as leader
* When leader comes back it shoudl step down

### Failover is fraught with things that can go wrong:
* In async replication new leader may not received all the data changes
* If old leader comes back and it contains the changes should we discard it
* So here we may have inconsisten data between a leader and old leader
* Two nodes are leaders split brain both accept writes data corruption happes
* What should be considerable timeout. It should not be large or small

### Issue
* Unreliable network
* Node failure
* Trade - offs 
* Durability, availability, latency are fundamental problem in Distributed system 

### Implementation of Replication Logs

### Statement Based Replication

* Every statement (sql) leader writes and send to followert
* NOW() or RAND() - nondeterministic function
* These generate differen value on replicas
* Auto Incremet or Update shoudl excecute in order on each replicaes. If not data may be misleading
* Statemt have side effects(trigger,SP, user defined functions) may result data

### Write Ahead Log (WAL)

* LSM - Log for storage (Segment are compacted and GC in BG)
* B-Tree(over-write individual disk blocks)
* Modification is Written to WAL so restore when crashed

* Either Case it is append only sequence of  bytes contains wites to DB.
* Use exact log to build replicas on other nodes. Not only leader writes on disk but send over network
* This Log strucuture data very low level. WAL contains details of bytes which were changes in Disk Blocks
* Replication tiedly coupled to Storage engine
* It's DB chnages or version changes it not possibtle to run. So different version is loeader and node is not possible

* If we want to upgrade without downtime then it's not possible



### Logical(row-based) log replication:
* Different Log for replication and storage engine
* RDBMS - sequence of record describing writes to DB
* Inserted row - > logs contians new values of all column
* Deleted row -> id of row
* updated - > enough info to uniquley identify updated row and new values of columns
* Transcation -> sevral logs with commited statement

* Logical Logs is easier to parse for external application.
send contens of Db to external sysetm like warehouse, 
* building custom index or cachaees
* This is called change data capture

### Trigger Based Replication
* So far replication implemented by DB system
* Some time you need replication moved to application layer
* replicate subset of data,  from one DB to another, conflic resolution
* Triggers and SP
* SP and Triggers capture changes and can apply logic to changes and store in seperate DB

### Problems with Replication

* Replication
    1. Node Failure
    2. Scalability
    3. Latency(geographical nodes)

### Eventual Consistency
* When you read leader and follower at same time the data may be different
* As the replicas sync would not have happened
* Eventualy the sync will happend , how far the replica may fall behind is not controllable. Maybe mins depends

### Reading Your Own Writes
* write and view data. Write using leader but read using follower.
* With async replication the sync would not have completed
* Read after write consistency or Read your write consistency. This guarantee that user can see updated values but other users may not see it yet 

### How can we implement read-after-write consistency in a system with leader-based replication? There are various possible techniques. To mention a few
* Read from Leader
* Read User profile table always from Leader
* Most of things are editable. This wont work as read always from Leader so scaling issue
* Timestamp 
* cross-device mobile and web browser

### Monotonic Reads:
* Multiple queries 
1. q1 - updated 
2. q2 not updated data
So user may witness old data after seeing a new data due to multiple query which queried from different replicas
In this case monotonic read. Read from same replica using a hash of user_id.

### Consisten Prefix Read

* violation of causality
* Guarantees consisten prefix reads. gurantees sequence of writes happens in certain order then anyone reading those writes see them appear in the same order
* If DB writes in same order this is not happen. But due to replication the writes order is not consistent


### Solution to replication Lags

* If Lags if not problem then the go with it
* If problem then stronger guarantee fo read-after-write. Prententing application is Synchronous when infact its async
* Using applicatio code read from leader
* These thing should be taken care by DB using transactions
* Single node transaction available. But Distributed abondoned it due to (performancre anf availability)
* Assernting Eventual Consistency is inevitable for scalable system


 



