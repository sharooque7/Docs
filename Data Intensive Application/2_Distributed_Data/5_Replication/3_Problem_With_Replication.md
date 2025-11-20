# Replication Lag in Data-Intensive Applications - Interview Notes

## 🔑 Key Concepts

- **Replication Benefits**: Fault tolerance, scalability, reduced latency
- **Read-Scaling Architecture**: Many followers handle read requests, leader handles writes
- **Eventual Consistency**: Followers eventually catch up with the leader, but lag creates temporary inconsistencies
- **Replication Lag**: Delay between write on leader and update on follower
  - Normally milliseconds, but can increase to seconds/minutes under load

## Problems Caused by Replication Lag

### 1. Reading Your Own Writes Problem

**Scenario**: User submits data to leader but reads from follower before replication completes
- User sees their own data "disappear"
- Frustrating user experience

**Solution**: Read-after-write consistency (read-your-writes consistency)
- Guarantees users always see their own updates

**Implementation Techniques**:
1. **User-modified data from leader**: Read potentially user-modified data from leader, other data from followers
   - Example: Read user's own profile from leader, other profiles from followers
   
2. **Time-based approach**:
   - Read from leader for X minutes after user's last update
   - Monitor replication lag and avoid followers that are too behind
   
3. **Timestamp tracking**:
   - Client remembers timestamp of most recent write
   - System ensures replica serving reads reflects updates up to that timestamp
   - Can use logical timestamps (sequence numbers) or system clocks

4. **Cross-device considerations**:
   - Centralize timestamp metadata when users access from multiple devices
   - Route requests from all user devices to same datacenter if using leader reads

### 2. Monotonic Reads Problem

**Scenario**: User reads from one replica, then another with greater lag
- Time appears to go backward
- Data appears, then disappears

**Example**:
- User reads comment from up-to-date follower
- Next request routes to lagging follower that hasn't received the comment
- Comment seemingly disappears

**Solution**: Monotonic reads guarantee
- If a user makes several reads in sequence, they will not see time go backward
- Stronger than eventual consistency, weaker than strong consistency

**Implementation**:
- Route each user's reads to the same replica consistently (e.g., hash of user ID)
- If that replica fails, reroute to another replica

### 3. Consistent Prefix Reads Problem

**Scenario**: Causally related writes arrive in different order to different replicas
- Observers see effects before causes
- Violates causality

**Example**:
- Two-message conversation where answer arrives before question
- Different replication lag for different partitions/shards causes apparent time travel

**Solution**: Consistent prefix reads guarantee
- If writes happen in a certain order, all readers see them appear in the same order

**Implementation Challenges**:
- Particularly difficult in partitioned/sharded databases
- One approach: Keep causally related writes on same partition
- Alternative: Explicitly track causal dependencies

## Solutions for Replication Lag

1. **Design for lag**: Consider application behavior if lag increases to minutes/hours
2. **Provide stronger guarantees**: Implement read-after-write consistency where needed
3. **Use transactions**: Let database handle complex guarantees rather than application code
   - Many distributed systems abandoned transactions for performance
   - This tradeoff is more nuanced than simply "transactions vs. scalability"

## Interview Tips

- **Know the terminology**: Eventual consistency, read-after-write consistency, monotonic reads, consistent prefix reads
- **Understand tradeoffs**: Consistency vs availability vs performance
- **Remember**: Consistency problems get worse as scale increases
- **Be ready to discuss**: How you'd handle each type of problem in real applications
- **Emphasize**: Anticipating these issues during system design is better than fixing them after deployment

## Example Interview Questions

1. "How would you design a social media system where users need to see their own posts immediately?"
2. "What consistency guarantees would you implement for a collaborative document editing system?"
3. "How would you ensure users don't experience data 'disappearing' in a distributed system?"
4. "Explain how you'd handle causality violations in a distributed message system."