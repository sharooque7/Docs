# Request Routing in Partitioned Systems

## Overview
When data is partitioned across nodes, clients need a way to determine which node hosts the data they're requesting. This is a **service discovery** problem with three common approaches:

![Request Routing Methods](figures/request-routing-methods.png)  
*(Figure 6-7: Three routing strategies)*

---

## Routing Strategies

### 1. Client → Random Node (Forwarding)
**How It Works**:
- Clients connect to any node (e.g., via load balancer).
- If the node doesn't own the requested partition, it **forwards** the request to the correct node.

**Pros**:
✅ Simple client implementation  
✅ No single point of failure  

**Cons**:
⚠️ Extra hop latency for forwarded requests  
⚠️ Nodes must maintain routing metadata  

**Used By**: Cassandra, Riak (gossip protocol)  

---

### 2. Client → Routing Tier (Proxy)
**How It Works**:
- Dedicated **partition-aware load balancer** (e.g., `mongos`, `moxi`).
- Maintains authoritative partition-node mappings.

**Pros**:
✅ Clients are unaware of partitioning  
✅ Centralized routing logic  

**Cons**:
⚠️ Potential bottleneck at scale  
⚠️ Adds infrastructure complexity  

**Used By**: 
- MongoDB (`mongos` + config servers)  
- Couchbase (`moxi`)  
- HBase, Kafka (with ZooKeeper)  

---

### 3. Client → Direct (Partition-Aware)
**How It Works**:
- Clients **cache partition assignments** and connect directly to the correct node.

**Pros**:
✅ Lowest latency (no hops/proxies)  

**Cons**:
⚠️ Clients must handle rebalancing  
⚠️ Complex client implementations  

**Used By**: Some custom in-house systems  

---

## Metadata Management
**Key Challenge**: Keeping routing information up-to-date during rebalancing.

### Coordination Services
| System           | Approach                      |
|------------------|-------------------------------|
| **ZooKeeper**    | Centralized truth (HBase, Kafka) |
| **Gossip**       | Peer-to-peer sync (Cassandra) |
| **Custom**       | MongoDB config servers        |

*(Figure 6-8: ZooKeeper maintaining partition assignments)*

---

## Implementation Examples

### MongoDB
1. `mongos` routers query **config servers**  
2. Clients connect to `mongos` (Strategy 2)  

### Cassandra
1. Nodes gossip cluster state  
2. Any node can forward requests (Strategy 1)  

### Couchbase
1. `moxi` routers learn routes from nodes  
2. Minimal rebalancing simplifies design  

---

## Parallel Query Execution (MPP)
**Analytics Workloads**:
- Complex queries (joins, aggregations) split into **parallel stages**.
- Scans distributed across partitions.

**Key Tech**:
- **Query planners** optimize execution graphs  
- **Columnar storage** for efficient scans  

*(Covered in depth in Chapter 10)*  

---

## Comparison Summary
| Strategy          | Latency   | Complexity     | Failure Resilience |
|-------------------|-----------|----------------|--------------------|
| **Random Forward**| Medium    | Moderate (nodes)| High              |
| **Routing Tier**  | Low-Medium| High (infra)   | Medium (proxy SPOF)|
| **Direct Client** | Lowest    | High (clients) | High              |

**Trade-off**: Choose based on client capabilities vs. operational overhead.# Request Routing in Partitioned Systems

## Overview
When data is partitioned across nodes, clients need a way to determine which node hosts the data they're requesting. This is a **service discovery** problem with three common approaches:

![Request Routing Methods](figures/request-routing-methods.png)  
*(Figure 6-7: Three routing strategies)*

---

## Routing Strategies

### 1. Client → Random Node (Forwarding)
**How It Works**:
- Clients connect to any node (e.g., via load balancer).
- If the node doesn't own the requested partition, it **forwards** the request to the correct node.

**Pros**:
✅ Simple client implementation  
✅ No single point of failure  

**Cons**:
⚠️ Extra hop latency for forwarded requests  
⚠️ Nodes must maintain routing metadata  

**Used By**: Cassandra, Riak (gossip protocol)  

---

### 2. Client → Routing Tier (Proxy)
**How It Works**:
- Dedicated **partition-aware load balancer** (e.g., `mongos`, `moxi`).
- Maintains authoritative partition-node mappings.

**Pros**:
✅ Clients are unaware of partitioning  
✅ Centralized routing logic  

**Cons**:
⚠️ Potential bottleneck at scale  
⚠️ Adds infrastructure complexity  

**Used By**: 
- MongoDB (`mongos` + config servers)  
- Couchbase (`moxi`)  
- HBase, Kafka (with ZooKeeper)  

---

### 3. Client → Direct (Partition-Aware)
**How It Works**:
- Clients **cache partition assignments** and connect directly to the correct node.

**Pros**:
✅ Lowest latency (no hops/proxies)  

**Cons**:
⚠️ Clients must handle rebalancing  
⚠️ Complex client implementations  

**Used By**: Some custom in-house systems  

---

## Metadata Management
**Key Challenge**: Keeping routing information up-to-date during rebalancing.

### Coordination Services
| System           | Approach                      |
|------------------|-------------------------------|
| **ZooKeeper**    | Centralized truth (HBase, Kafka) |
| **Gossip**       | Peer-to-peer sync (Cassandra) |
| **Custom**       | MongoDB config servers        |

*(Figure 6-8: ZooKeeper maintaining partition assignments)*

---

## Implementation Examples

### MongoDB
1. `mongos` routers query **config servers**  
2. Clients connect to `mongos` (Strategy 2)  

### Cassandra
1. Nodes gossip cluster state  
2. Any node can forward requests (Strategy 1)  

### Couchbase
1. `moxi` routers learn routes from nodes  
2. Minimal rebalancing simplifies design  

---

## Parallel Query Execution (MPP)
**Analytics Workloads**:
- Complex queries (joins, aggregations) split into **parallel stages**.
- Scans distributed across partitions.

**Key Tech**:
- **Query planners** optimize execution graphs  
- **Columnar storage** for efficient scans  

*(Covered in depth in Chapter 10)*  

---

## Comparison Summary
| Strategy          | Latency   | Complexity     | Failure Resilience |
|-------------------|-----------|----------------|--------------------|
| **Random Forward**| Medium    | Moderate (nodes)| High              |
| **Routing Tier**  | Low-Medium| High (infra)   | Medium (proxy SPOF)|
| **Direct Client** | Lowest    | High (clients) | High              |

**Trade-off**: Choose based on client capabilities vs. operational overhead.

```
1. Forwarding Flow:
Client → Node3 (random)  
Node3 → Checks partition map → Forwards to Node1 (owner)  
Node1 → Returns result → Node3 → Client

2. ZooKeeper Coordination:
[ZooKeeper]
  │
  ├─ Partition 1 → NodeA  
  ├─ Partition 2 → NodeB  
  └─ (Updates propagate to routers/clients)

3. MPP Query Execution:
Query: SELECT SUM(sales) GROUP BY region  
Plan:
  Node1: Scan west_region → Local SUM  
  Node2: Scan east_region → Local SUM  
  Coordinator: Merge results
```