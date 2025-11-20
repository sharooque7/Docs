### Leader Less Replication

* writes to multiple replicas
* or writes to coordinator which does this writing
* coordinator does not enforce ordering


### Writing to DB when node is down

* Consider 3 replicas with one down
* 2 out of 3 writes are ok
* multiple reads in parallel. using version of data we can identify which is stale(old) or new one

### Read repair and anti entropy
* Replication should be all data should be copied to replicas
* Catching up 

### Read Repair
* client reads from multiple replicas it gets stale and new records
* Here the new record will be updated
### Anti-Entropy process
* BG process that constanly looks for difference in data between replicas and
* copies any missing data

### Quoroms for reading and Writing
* N replicas(Odd number)
* w = r = (N + 1) / 2 (rounded u[p])
* Write must be confirmed by w nodes to be successfull
* Read must be confirmed by r nodes to be successfull
* w + r > n we get up to date value
* 3 replicas 2 must confirm writes and 2 must confirm reads
* By this atleast our data is in 2 replicas and we get new value
* 2 + 2 > 3
* This is Quoroms reads and writes.
* w r how many nodes we wait for response. to tolerate node failure
* If fewer than the required w or r nodes are available, writes or reads return an error

### Limitation of Quoroms Consistency\
* Sloppy Quoroms
* Writes may end up in different nodes and read may happenn from difference nodes. so stale records
* Concurrent writes means not clear which one will be first so merging is safe solution
* writes and read Concurrently. read may return stale
* writes in nodes but does not meet w response then it's not rolled back but DB return error

### Monitoring staleness

* SLR and MLR . subtracting current writes  between leader and follower gives the lag
* other metrics are available and fed to Monitoring sysstem
* In LeaderLess it's not as writes happenn is not ordered.

### Sloppy Quoroms and Hinted Handoff
* Writes must satisfy w nodes, But what if nodes are down < wait
* Write happenn at some nodes even though the Quoroms didn't reach w nodes response(ok)
* When the nodes are up and greater than w nodes the data are send to update other node
* Hinted Handoff is that  writes that one node temporarily accepted on behalf of another node are sent to the appropriate “home” nodes
* During this time the read may return stale data
* Increase durablity to writes
* No guarantee on reads until Hinted Handoff

### Multi-datacenter operation
* Number of nodes irrespective of datacenter
* Quoroms w and r from local data center for acknolegdement

### Detetcing Concurrent Writes

### Late write wins
* Order of replicas issue. 
* using timestamp. Higer ts wins 
* Concurrent writes only one will survive and other are discarded
* cassandra uuid for each write

### The “happens-before” relationship and concurrency
* B causally depnds on A 
* Two operation on same key