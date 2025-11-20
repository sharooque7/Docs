# Rebalancing Partitions

## Overview
Rebalancing redistributes data and query load across nodes when:
- **Adding/removing nodes** (scale-out/in)  
- **Node failures** (fault recovery)  
- **Data growth** (adjust partition sizes)  

**Requirements**:
- Preserve **fair load distribution**  
- Minimize **data movement**  
- Maintain **availability** during rebalancing  

---

## Rebalancing Strategies

### 1. Fixed Number of Partitions
**How It Works**:
- Pre-create **more partitions (e.g., 1,000) than nodes (e.g., 10)**.  
- Assign multiple partitions per node (~100/node initially).  
- On rebalance, **shift entire partitions** between nodes (Figure 6-6).  

**Pros**:
✅ Minimal data movement (partition boundaries unchanged)  
✅ Simple implementation  

**Cons**:
⚠️ Must **pre-size partitions** for future growth  
⚠️ Partition count limits max nodes  

**Used By**: Riak, Elasticsearch, Couchbase, Voldemort  

**Key Consideration**:  
Choose partition count carefully—too high (overhead), too low (limits scaling).  

---

### 2. Dynamic Partitioning
**How It Works**:
- Partitions **split** when exceeding size threshold (e.g., 10GB).  
- Partitions **merge** when too small.  
- Enables **adaptive partition counts**.  

**Pros**:
✅ Automatic scaling with data growth  
✅ No manual pre-sizing  

**Cons**:
⚠️ **Hotspots** possible initially (single partition until split)  
⚠️ Split/merge overhead  

**Used By**: HBase, RethinkDB, MongoDB  

**Mitigation**:  
- **Pre-splitting** for known key distributions (e.g., HBase regions).  

---

### 3. Partition Proportionally to Nodes
**How It Works**:
- Fixed partitions **per node** (e.g., Cassandra: 256/node).  
- New nodes **split random partitions**, claiming half.  

**Pros**:
✅ Stable partition sizes (grow with data, shrink with nodes)  
✅ Fair load distribution (via randomization)  

**Cons**:
⚠️ Requires **hash partitioning**  
⚠️ Potential temporary imbalance  

**Used By**: Cassandra, Ketama  

**Optimization**:  
Cassandra 3.0+ uses **improved algorithms** to avoid unfair splits.  

---

## Automation Trade-offs
| Approach           | Pros                          | Cons                          |
|--------------------|-------------------------------|-------------------------------|
| **Fully Automatic**| Low operational overhead      | Risk of cascading failures    |
| **Semi-Automatic**| Safety checks (human review)  | Slower response               |
| **Manual**        | Maximum control              | High operational cost         |

**Examples**:  
- **Automatic**: MongoDB, Elasticsearch  
- **Semi-Auto**: Couchbase, Riak (admin approval required)  

---

## Key Challenges
1. **Network Overload**: Moving large partitions consumes bandwidth.  
2. **Concurrent Requests**: Balancing reads/writes during rebalance.  
3. **Failure Handling**: Distinguishing slow nodes from dead nodes.  

**Best Practices**:  
- **Throttle** rebalance traffic.  
- **Prioritize** critical operations.  
- **Monitor** for hotspots post-rebalance.  

---

## Comparison Summary
| Strategy               | Partition Count | Data Movement | Use Case              |
|------------------------|------------------|---------------|-----------------------|
| **Fixed Partitions**   | Static           | Low           | Predictable workloads |
| **Dynamic**           | Adaptive         | Moderate      | Variable data size    |
| **Per-Node**          | Node-dependent   | High          | Elastic clusters      |


```
1. Fixed Partitions Rebalancing:
Initial: Node1 [P1-P100], Node2 [P101-P200]  
Add Node3: Steal P50 from Node1, P150 from Node2 → Node3 [P50, P150]  

2. Dynamic Partition Splitting:
Partition A (15GB) → Split → A1 (7GB) + A2 (8GB)  
Move A2 to new node.  

3. Per-Node Partitions:
Cluster: 3 nodes × 256 partitions = 768 total  
Add Node4: Split 256 random partitions → 128 moved to Node4  
```