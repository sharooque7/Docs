# Why ZooKeeper and etcd Are More Than Just Key-Value Stores

## 1. **Why Consensus is Needed**
- Designed for **small, critical data** (cluster metadata, locks, leader election)
- Use **consensus algorithms** (Raft, Zab) for:
  - **Linearizable atomic operations** (e.g., compare-and-set)
  - **Total ordering of operations** (for fencing tokens)
  - **Fault tolerance** (handles node failures)

## 2. **Key Features**
| Feature | Description |
|---------|-------------|
| Linearizable atomic ops | Ensures atomic locks and consistency |
| Total order of ops | Monotonic IDs (e.g., `zxid`) for fencing |
| Failure detection | Ephemeral nodes (auto-delete on timeout) |
| Change notifications | Watches instead of polling |
| Membership services | Tracks active cluster nodes |

## 3. **Use Cases**
- **Leader election**: Selecting primary nodes
- **Partition assignment**: Dynamic workload distribution
- **Service discovery**: Tracking available services
- **Distributed locks**: Shared resource coordination

## 4. **Why Not a Regular Database?**
- General databases aren't optimized for:
  - Low-latency in-memory ops
  - Coordination primitives (locks, watches)
  - Consensus guarantees
- ZooKeeper uses small clusters (3-5 nodes) for consensus

## 5. **Service Discovery & Membership**
- **Service discovery**:
  - Can use DNS (doesn't require consensus)
- **Membership services**:
  - Requires consensus to prevent split-brain
  - Provides consistent view of active nodes

## 6. **Trade-offs**
- ❌ Not for high-throughput data
- ✅ Use Apache BookKeeper for runtime state
- Read-only replicas improve scalability

---

### **Summary**
ZooKeeper/etcd are **coordination services** that provide:
- Distributed locks
- Leader election
- Membership tracking
- Change notifications