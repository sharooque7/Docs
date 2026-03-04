# Complete Redis Guide - The Ultimate Interview Reference 🚀

_Your comprehensive go-to reference for all Redis concepts with explanations, Java examples, and interview-focused insights_

---

## **📋 TABLE OF CONTENTS**

1. [What is Redis?](#1-what-is-redis)
2. [Redis vs Traditional Databases](#2-redis-vs-traditional-databases)
3. [Redis Architecture & Core Concepts](#3-redis-architecture--core-concepts)
4. [Redis Data Types](#4-redis-data-types)
5. [Persistence in Redis](#5-persistence-in-redis)
6. [Redis Replication](#6-redis-replication)
7. [Redis Sentinel (High Availability)](#7-redis-sentinel-high-availability)
8. [Redis Cluster (Scaling)](#8-redis-cluster-scaling)
9. [Redis Cache Strategies](#9-redis-cache-strategies)
10. [Pub/Sub & Messaging](#10-pubsub--messaging)
11. [Redis Transactions & Lua Scripting](#11-redis-transactions--lua-scripting)
12. [Redis as a Database vs Cache](#12-redis-as-a-database-vs-cache)
13. [Java Client: Jedis vs Lettuce](#13-java-client-jedis-vs-lettuce)
14. [Spring Boot with Redis](#14-spring-boot-with-redis)
15. [Common Use Cases](#15-common-use-cases)
16. [Performance & Memory Optimization](#16-performance--memory-optimization)
17. [Security Best Practices](#17-security-best-practices)
18. [Monitoring & Troubleshooting](#18-monitoring--troubleshooting)
19. [Common Interview Questions](#19-common-interview-questions)
20. [Quick Reference Cheat Sheet](#20-quick-reference-cheat-sheet)

---

## **1. WHAT IS REDIS?**

> **Concept:** Redis (Remote Dictionary Server) is an open-source, in-memory data structure store used as a database, cache, message broker, and streaming engine. It supports various data structures such as strings, hashes, lists, sets, sorted sets, and more .

```java
// Redis operates primarily in memory, delivering microsecond latency
// Data is optionally persisted to disk for durability
```

### **Core Characteristics**

| Characteristic        | Description                                      |
| --------------------- | ------------------------------------------------ |
| **In-Memory**         | All data primarily stored in RAM for fast access |
| **Persistence**       | Optional disk persistence for durability         |
| **Data Structures**   | Rich set of native data structures               |
| **Single-Threaded**   | Operations are atomic and sequential             |
| **Replication**       | Master-slave replication for read scaling        |
| **High Availability** | Sentinel for automatic failover                  |
| **Clustering**        | Horizontal partitioning across nodes             |

### **Redis vs Traditional Databases**

| Feature             | Redis                               | Traditional RDBMS | Memcached       |
| ------------------- | ----------------------------------- | ----------------- | --------------- |
| **Primary Storage** | RAM                                 | Disk              | RAM             |
| **Data Model**      | Key-Value + Structures              | Relational        | Key-Value       |
| **Persistence**     | Optional (RDB/AOF)                  | Required          | None            |
| **Read Latency**    | Sub-millisecond                     | Milliseconds      | Sub-millisecond |
| **Write Latency**   | Sub-millisecond                     | Milliseconds      | Sub-millisecond |
| **Query Language**  | Commands                            | SQL               | Commands        |
| **Data Types**      | Rich (strings, hashes, lists, sets) | Primitive         | Strings only    |

---

## **2. REDIS ARCHITECTURE & CORE CONCEPTS**

> **Concept:** Redis follows a simple yet powerful architecture centered around in-memory operations .

### **Single-Threaded Architecture**

Redis uses a single-threaded event loop, which simplifies concurrency and ensures atomicity without locks .

```
Client 1 → Command → Event Loop → Execute → Response
Client 2 → Command → Event Loop → (queue) → Execute → Response
Client 3 → Command → Event Loop → (queue) → Execute → Response
```

#### **Why Single-Threaded?**

| Reason             | Explanation                                        |
| ------------------ | -------------------------------------------------- |
| **Simplicity**     | No concurrency bugs, race conditions, or deadlocks |
| **Atomicity**      | Each command executes fully before next starts     |
| **Performance**    | RAM access is fast enough; CPU rarely bottleneck   |
| **Predictability** | Consistent performance under load                  |

#### **What if CPU is the bottleneck?**

For CPU-bound workloads, Redis Cluster provides horizontal scaling.

### **Redis Database Structure**

```
Redis Instance
├── Database 0 (default)
│   ├── Key "user:1000" → Value (hash)
│   ├── Key "session:abc123" → Value (string)
│   └── Key "leaderboard" → Value (sorted set)
├── Database 1
│   ├── Key "cache:products" → Value (string)
│   └── ...
└── Database 2
    └── ...
```

- **16 logical databases** (0-15) by default
- Databases are isolated with no commands to move data between them
- Use separate Redis instances for complete isolation

### **Key Naming Conventions**

```
# Common patterns
user:1000:profile
user:1000:orders
session:abc123
product:inventory
leaderboard:daily
```

---

## **3. REDIS DATA TYPES**

> **Concept:** Redis supports multiple data structures, each optimized for specific use cases .

### **3.1 Strings**

The simplest Redis type, maps a key to a string value (binary-safe, up to 512MB).

```java
// Java with Jedis
Jedis jedis = new Jedis("localhost", 6379);

// Set and get
jedis.set("user:1000:name", "John Doe");
String name = jedis.get("user:1000:name");

// Set with expiration (in seconds)
jedis.setex("session:abc123", 3600, "user-data");

// Set only if not exists (distributed lock)
Long result = jedis.setnx("lock:resource", "locked");

// Increment/Decrement
jedis.incr("counter:pageviews");
jedis.incrBy("counter:score", 10);
jedis.decr("counter:remaining");
jedis.decrBy("counter:points", 5);

// Get multiple
List<String> values = jedis.mget("key1", "key2", "key3");
```

#### **Use Cases**

| Use Case              | Example                            |
| --------------------- | ---------------------------------- |
| **Caching**           | Store serialized objects (JSON)    |
| **Counters**          | Page views, likes, API rate limits |
| **Distributed Locks** | SETNX for critical sections        |
| **Session Storage**   | User session data with TTL         |

### **3.2 Hashes**

Maps between string fields and string values, perfect for representing objects.

```java
// Store user object as hash
jedis.hset("user:1000", "name", "John Doe");
jedis.hset("user:1000", "email", "john@example.com");
jedis.hset("user:1000", "age", "30");

// Get all fields
Map<String, String> user = jedis.hgetAll("user:1000");

// Get single field
String name = jedis.hget("user:1000", "name");

// Get multiple fields
List<String> values = jedis.hmget("user:1000", "name", "email");

// Increment field
jedis.hincrBy("user:1000", "loginCount", 1);

// Check if field exists
Boolean exists = jedis.hexists("user:1000", "email");

// Get all fields or values
Set<String> fields = jedis.hkeys("user:1000");
List<String> allValues = jedis.hvals("user:1000");

// Field count
Long size = jedis.hlen("user:1000");
```

#### **Use Cases**

| Use Case              | Benefit                                                         |
| --------------------- | --------------------------------------------------------------- |
| **User Profiles**     | Store/retrieve individual fields without fetching entire object |
| **Product Inventory** | Track quantities, prices, descriptions                          |
| **Configuration**     | Application settings that can be updated at runtime             |

### **3.3 Lists**

Ordered collections of strings, implemented as linked lists.

```java
// Push to left/right
jedis.lpush("notifications:1000", "New message");
jedis.rpush("notifications:1000", "Friend request");

// Pop from left/right
String message = jedis.lpop("notifications:1000");  // First
String last = jedis.rpop("notifications:1000");     // Last

// Range queries
List<String> recent = jedis.lrange("notifications:1000", 0, 10);

// Trim (keep only latest 100)
jedis.ltrim("notifications:1000", 0, 99);

// Length
Long len = jedis.llen("notifications:1000");

// Blocking pop (wait for item)
List<String> result = jedis.brpop(5, "queue:tasks"); // Wait 5 seconds
```

#### **Use Cases**

| Use Case           | Description                         |
| ------------------ | ----------------------------------- |
| **Message Queues** | Simple FIFO queues with LPUSH/RPOP  |
| **Activity Feeds** | Store recent user activities        |
| **Timelines**      | Latest posts or notifications       |
| **Work Queues**    | Task distribution with blocking pop |

### **3.4 Sets**

Unordered collections of unique strings.

```java
// Add members
jedis.sadd("user:1000:following", "2000", "3000", "4000");

// Remove members
jedis.srem("user:1000:following", "2000");

// Check membership
Boolean isFollowing = jedis.sismember("user:1000:following", "3000");

// Get all members
Set<String> following = jedis.smembers("user:1000:following");

// Cardinality
Long count = jedis.scard("user:1000:following");

// Random member
String random = jedis.srandmember("user:1000:following");

// Pop random member
String popped = jedis.spop("user:1000:following");

// Set operations
Set<String> mutual = jedis.sinter("user:1000:following", "user:2000:following");
Set<String> union = jedis.sunion("user:1000:following", "user:2000:following");
Set<String> diff = jedis.sdiff("user:1000:following", "user:2000:following");

// Store results
jedis.sinterstore("mutual:1000:2000", "user:1000:following", "user:2000:following");
```

#### **Use Cases**

| Use Case            | Description                      |
| ------------------- | -------------------------------- |
| **Tags/Labels**     | Product tags, article categories |
| **Relationships**   | Followers/following, friends     |
| **Uniqueness**      | Track unique visitors (IPs)      |
| **Random Sampling** | Random giveaways, A/B testing    |

### **3.5 Sorted Sets (ZSETs)**

Like sets, but each member has an associated score for ordering.

```java
// Add members with scores
jedis.zadd("leaderboard:daily", 150, "user:1000");
jedis.zadd("leaderboard:daily", 200, "user:2000");
jedis.zadd("leaderboard:daily", 175, "user:3000");

// Range by rank (0-based, lowest rank = highest score)
Set<String> top10 = jedis.zrevrange("leaderboard:daily", 0, 9);
Set<String> bottom10 = jedis.zrange("leaderboard:daily", 0, 9);

// Range with scores
Set<Tuple> topWithScores = jedis.zrevrangeWithScores("leaderboard:daily", 0, 9);

// Increment score
jedis.zincrby("leaderboard:daily", 25, "user:1000");

// Get rank
Long rank = jedis.zrevrank("leaderboard:daily", "user:1000"); // 0 = first

// Get score
Double score = jedis.zscore("leaderboard:daily", "user:1000");

// Count members in score range
Long count = jedis.zcount("leaderboard:daily", 100, 200);

// Remove
jedis.zrem("leaderboard:daily", "user:3000");

// Range by score
Set<String> inRange = jedis.zrangeByScore("leaderboard:daily", 150, 200);

// Get cardinality
Long size = jedis.zcard("leaderboard:daily");
```

#### **Use Cases**

| Use Case            | Description                                 |
| ------------------- | ------------------------------------------- |
| **Leaderboards**    | Game scores, top products, trending items   |
| **Rate Limiting**   | Track request counts with time-based scores |
| **Priority Queues** | Process items by priority score             |
| **Time Series**     | Store events with timestamp as score        |
| **Autocomplete**    | Weighted suggestions based on frequency     |

### **3.6 Bitmaps**

Bit-level operations on strings.

```java
// Set bit at offset (0 or 1)
jedis.setbit("user:active:2024-01-01", 1000, true);

// Get bit
Boolean active = jedis.getbit("user:active:2024-01-01", 1000);

// Count bits set
Long activeCount = jedis.bitcount("user:active:2024-01-01");

// Bit operations
jedis.bitop(BitOP.AND, "active:both", "user:active:2024-01-01", "user:active:2024-01-02");
```

#### **Use Cases**

| Use Case               | Description                          |
| ---------------------- | ------------------------------------ |
| **Daily Active Users** | Track user activity (1 user per bit) |
| **Feature Flags**      | Toggle features per user             |
| **Boolean Analytics**  | Any yes/no tracking                  |

### **3.7 HyperLogLog**

Probabilistic data structure for cardinality estimation with minimal memory.

```java
// Add elements
jedis.pfadd("unique:visitors:2024-01-01", "ip1", "ip2", "ip3");

// Count approximate unique elements
Long approx = jedis.pfcount("unique:visitors:2024-01-01");

// Merge multiple HLLs
jedis.pfmerge("unique:visitors:week", "unique:visitors:2024-01-01",
              "unique:visitors:2024-01-02");
```

#### **Use Cases**

| Use Case            | Description                                           |
| ------------------- | ----------------------------------------------------- |
| **Unique Visitors** | Count distinct IPs with minimal memory (12KB per HLL) |
| **Search Terms**    | Count unique searches without storing all terms       |
| **Item Views**      | Track unique product views                            |

### **3.8 Streams**

Append-only log structure for event streaming (introduced in Redis 5.0).

```java
// Add entry to stream
Map<String, String> event = new HashMap<>();
event.put("user", "1000");
event.put("action", "purchase");
event.put("amount", "99.99");

String entryId = jedis.xadd("events:user:1000", StreamEntryID.NEW_ENTRY, event);

// Read from stream
List<Map.Entry<String, List<Map.Entry<String, String>>>> entries =
    jedis.xrange("events:user:1000", (StreamEntryID) null, (StreamEntryID) null, 10);

// Create consumer group
jedis.xgroupCreate("events", "processors", StreamEntryID.LAST, true);

// Read as consumer
List<Map.Entry<String, List<Map.Entry<String, String>>>> pending =
    jedis.xreadGroup("processors", "worker-1", 1, 10000, true,
                     new XReadGroupItem("events", StreamEntryID.UNRECEIVED_ENTRY));
```

#### **Use Cases**

| Use Case           | Description                             |
| ------------------ | --------------------------------------- |
| **Event Sourcing** | Store user activity events              |
| **Message Queues** | Reliable messaging with consumer groups |
| **Audit Logs**     | Append-only logs for compliance         |
| **IoT Data**       | Sensor readings with timestamps         |

---

## **4. PERSISTENCE IN REDIS**

> **Concept:** Redis can persist data to disk through two mechanisms: RDB snapshots and AOF logs .

### **4.1 RDB (Redis Database File)**

Point-in-time snapshots of the dataset.

```java
// Trigger manual save (blocking)
jedis.save();

// Trigger background save (non-blocking)
jedis.bgsave();
```

#### **Configuration**

```properties
# redis.conf
save 900 1          # Save after 900 seconds if at least 1 key changed
save 300 10         # Save after 300 seconds if at least 10 keys changed
save 60 10000       # Save after 60 seconds if at least 10000 keys changed

dbfilename dump.rdb
dir /var/lib/redis
```

#### **Pros & Cons**

| ✅ Advantages                   | ❌ Disadvantages                               |
| ------------------------------- | ---------------------------------------------- |
| Compact single file for backups | Potential data loss between snapshots          |
| Fast recovery                   | BGSAVE can be CPU-intensive for large datasets |
| Perfect for disaster recovery   | Not suitable if you need durability            |
| Good for cold backups           |                                                |

### **4.2 AOF (Append Only File)**

Logs every write operation, replayed on startup.

```properties
# redis.conf
appendonly yes
appendfilename "appendonly.aof"

# fsync policies
appendfsync always      # Every write (slowest, safest)
appendfsync everysec    # Every second (default)
appendfsync no          # Let OS decide (fastest, least safe)

# AOF rewrite (compaction)
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
```

#### **AOF Rewrite**

- Creates new AOF with minimal commands needed to rebuild current dataset
- Prevents AOF from growing indefinitely
- Triggered automatically based on size, or manually with `BGREWRITEAOF`

#### **Pros & Cons**

| ✅ Advantages                          | ❌ Disadvantages                 |
| -------------------------------------- | -------------------------------- |
| Minimal data loss (fsync configurable) | Larger files than RDB            |
| Append-only, no corruption             | Slower than RDB (fsync overhead) |
| Human-readable                         | Recovery can be slow             |
| Easy to understand                     |                                  |

### **4.3 No Persistence**

Pure cache use case.

```properties
# redis.conf
save ""
appendonly no
```

### **4.4 RDB + AOF (Best of Both)**

Run both for maximum safety.

```properties
# redis.conf
save 900 1
save 300 10
appendonly yes
appendfsync everysec
```

#### **Recovery Order**

When both enabled, Redis recovers from AOF first (more complete).

### **4.5 Choosing the Right Strategy**

| Use Case              | Recommended Persistence      |
| --------------------- | ---------------------------- |
| **Cache only**        | No persistence               |
| **Session store**     | RDB (can tolerate some loss) |
| **Primary database**  | AOF + RDB (fsync everysec)   |
| **Financial data**    | AOF with `always` fsync      |
| **Analytics/Logging** | RDB snapshots periodically   |

---

## **5. REDIS REPLICATION**

> **Concept:** Master-slave replication for read scaling and data redundancy .

### **Replication Topology**

```
┌──────────┐
│  Master  │
└────┬─────┘
     │
     ├──────────────────┐
     │                  │
     ▼                  ▼
┌──────────┐     ┌──────────┐
│  Slave 1 │     │  Slave 2 │
└──────────┘     └──────────┘
     │
     ▼
┌──────────┐
│  Slave 3 │
└──────────┘
```

### **How Replication Works**

1. **Full sync**: Slave connects to master, master generates RDB, sends to slave
2. **Partial sync**: For reconnections, master buffers writes, sends only missed commands
3. **Command propagation**: After sync, master sends every write to slaves

### **Configuration**

```properties
# Master (redis.conf)
bind 0.0.0.0
protected-mode no

# Slave (redis.conf)
replicaof master-ip 6379
masterauth master-password   # if master has password
replica-read-only yes        # prevent writes to slave
```

```java
// Java: Check replication info
Jedis jedis = new Jedis("localhost", 6379);
String info = jedis.info("replication");
System.out.println(info);
```

### **Replication Features**

| Feature                         | Description                                    |
| ------------------------------- | ---------------------------------------------- |
| **Asynchronous**                | Master continues without waiting for slave ACK |
| **One master, multiple slaves** | Fan-out for read scaling                       |
| **Replica chaining**            | Slaves can replicate from other slaves         |
| **Read-only slaves**            | Prevent accidental writes                      |
| **Partial resynchronization**   | Efficient reconnection handling                |

### **Use Cases**

| Use Case              | Benefit                                       |
| --------------------- | --------------------------------------------- |
| **Read scaling**      | Distribute read queries across slaves         |
| **High availability** | Promote slave if master fails (with Sentinel) |
| **Backups**           | Run BGSAVE on slave without impacting master  |
| **Analytics**         | Run heavy queries on replica                  |

---

## **6. REDIS SENTINEL (HIGH AVAILABILITY)**

> **Concept:** Sentinel provides automatic failover, monitoring, and notifications for Redis deployments .

### **Sentinel Architecture**

```
┌──────────┐
│  Sentinel│ 1. Monitor
│ Cluster  │ 2. Notify
└───┬──────┘ 3. Failover
    │
    ├──────────────────┐
    │                  │
    ▼                  ▼
┌──────────┐     ┌──────────┐
│ Master   │◄────│ Sentinel │
│ Redis    │     │ Quorum   │
└────┬─────┘     └──────────┘
     │
     ├──────────────────┐
     │                  │
     ▼                  ▼
┌──────────┐     ┌──────────┐
│ Slave 1  │     │ Slave 2  │
└──────────┘     └──────────┘
```

### **Sentinel Functions**

| Function                   | Description                         |
| -------------------------- | ----------------------------------- |
| **Monitoring**             | Checks if master/slaves are working |
| **Notification**           | Alerts system administrators        |
| **Automatic Failover**     | Promotes slave if master fails      |
| **Configuration Provider** | Clients discover current master     |

### **Sentinel Configuration**

```properties
# sentinel.conf
port 26379
sentinel monitor mymaster 127.0.0.1 6379 2
sentinel auth-pass mymaster yourpassword
sentinel down-after-milliseconds mymaster 30000
sentinel parallel-syncs mymaster 1
sentinel failover-timeout mymaster 180000
```

#### **Explanation of Key Settings**

| Setting                     | Description                                                   |
| --------------------------- | ------------------------------------------------------------- |
| **monitor mymaster ... 2**  | Master name, IP, port, quorum (2 sentinels agree master down) |
| **down-after-milliseconds** | Time after which master considered down                       |
| **parallel-syncs**          | Number of slaves reconfiguring simultaneously                 |
| **failover-timeout**        | Timeout for failover procedure                                |

### **Sentinel Quorum**

> **Concept:** Quorum is the number of sentinels that must agree that master is down to trigger failover .

- 3 sentinel nodes with quorum 2 can tolerate 1 node failure
- 5 sentinel nodes with quorum 3 can tolerate 2 node failures

### **Java Client with Sentinel**

```java
import redis.clients.jedis.JedisSentinelPool;
import java.util.HashSet;
import java.util.Set;

public class SentinelExample {
    public static void main(String[] args) {
        Set<String> sentinels = new HashSet<>();
        sentinels.add("sentinel1:26379");
        sentinels.add("sentinel2:26379");
        sentinels.add("sentinel3:26379");

        // Create sentinel pool
        JedisSentinelPool pool = new JedisSentinelPool("mymaster", sentinels);

        // Get connection to current master
        try (Jedis jedis = pool.getResource()) {
            jedis.set("key", "value");
            String value = jedis.get("key");
            System.out.println(value);
        }

        pool.close();
    }
}
```

---

## **7. REDIS CLUSTER (SCALING)**

> **Concept:** Redis Cluster provides automatic sharding and high availability across multiple nodes .

### **Cluster Architecture**

```
┌─────────────────────────────────────────────────┐
│              REDIS CLUSTER                        │
├─────────────────────────────────────────────────┤
│  ┌──────────┐    ┌──────────┐    ┌──────────┐  │
│  │ Master A │    │ Master B │    │ Master C │  │
│  │ 0-5500   │    │ 5501-11000│   │11001-16383│  │
│  └────┬─────┘    └────┬─────┘    └────┬─────┘  │
│       │               │               │        │
│  ┌────▼─────┐    ┌────▼─────┐    ┌────▼─────┐  │
│  │ Slave A1 │    │ Slave B1 │    │ Slave C1 │  │
│  └──────────┘    └──────────┘    └──────────┘  │
└─────────────────────────────────────────────────┘
```

### **Key Concepts**

| Concept          | Description                                      |
| ---------------- | ------------------------------------------------ |
| **Sharding**     | Data distributed across nodes (16384 hash slots) |
| **Hash Slot**    | Key mapped to slot using CRC16(key) % 16384      |
| **Master Node**  | Owns subset of hash slots                        |
| **Replica Node** | Copies data from master for failover             |
| **Cluster Bus**  | Communication between nodes (port +10000)        |

### **Slot Allocation**

```
Hash Slot Range: 0-16383

Node A: 0-5500     (5501 slots)
Node B: 5501-11000 (5500 slots)
Node C: 11001-16383(5500 slots)
```

### **Cluster Configuration**

```properties
# redis.conf for cluster node
port 7000
cluster-enabled yes
cluster-config-file nodes-7000.conf
cluster-node-timeout 5000
appendonly yes
```

### **Creating a Cluster**

```bash
# Start 6 Redis instances (3 masters, 3 slaves)
redis-server redis-7000.conf
redis-server redis-7001.conf
redis-server redis-7002.conf
redis-server redis-7003.conf
redis-server redis-7004.conf
redis-server redis-7005.conf

# Create cluster with redis-cli
redis-cli --cluster create 127.0.0.1:7000 127.0.0.1:7001 \
    127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 \
    --cluster-replicas 1
```

### **Java Client with Redis Cluster**

```java
import redis.clients.jedis.JedisCluster;
import redis.clients.jedis.HostAndPort;
import java.util.HashSet;
import java.util.Set;

public class ClusterExample {
    public static void main(String[] args) {
        Set<HostAndPort> clusterNodes = new HashSet<>();
        clusterNodes.add(new HostAndPort("127.0.0.1", 7000));
        clusterNodes.add(new HostAndPort("127.0.0.1", 7001));
        clusterNodes.add(new HostAndPort("127.0.0.1", 7002));

        // Create cluster client
        JedisCluster jedisCluster = new JedisCluster(clusterNodes);

        // Use as normal (automatic routing)
        jedisCluster.set("key", "value");
        String value = jedisCluster.get("key");
        System.out.println(value);

        // Works with any key (routed to correct node)
        for (int i = 0; i < 100; i++) {
            jedisCluster.set("key:" + i, "value:" + i);
        }

        jedisCluster.close();
    }
}
```

### **Cluster Limitations**

| Limitation               | Explanation                                                              |
| ------------------------ | ------------------------------------------------------------------------ |
| **Multi-key operations** | Only if keys share same hash slot (use hash tags `{user1000}.following`) |
| **Transactions**         | Only on single node                                                      |
| **Lua scripts**          | Must operate on keys in same slot                                        |
| **Database selection**   | Only DB 0 available                                                      |
| **Pipeline**             | Only on single node                                                      |

### **Hash Tags**

Force keys to be in same slot: `{user1000}.profile` and `{user1000}.orders` hash to same slot.

---

## **8. REDIS CACHE STRATEGIES**

> **Concept:** Redis is commonly used as a cache to reduce database load and improve application performance .

### **8.1 Cache-Aside (Lazy Loading)**

Application checks cache first, then database.

```java
public class CacheAsideStrategy {
    private Jedis jedis;
    private Database db;

    public String getUserData(String userId) {
        // 1. Check cache
        String cached = jedis.get("user:" + userId);

        if (cached != null) {
            return cached; // Cache hit
        }

        // 2. Cache miss - load from database
        String userData = db.findUserById(userId);

        // 3. Store in cache with TTL
        jedis.setex("user:" + userId, 3600, userData);

        return userData;
    }

    public void updateUser(String userId, String userData) {
        // Update database
        db.updateUser(userId, userData);

        // Invalidate cache
        jedis.del("user:" + userId);
    }
}
```

| ✅ Advantages            | ❌ Disadvantages        |
| ------------------------ | ----------------------- |
| Simple to implement      | Cache miss penalty      |
| Handles all data types   | Stale data possible     |
| Efficient for read-heavy | Invalidation complexity |

### **8.2 Write-Through**

Write to cache and database simultaneously.

```java
public class WriteThroughStrategy {
    private Jedis jedis;
    private Database db;

    public void saveUser(String userId, String userData) {
        // Write to database first
        db.saveUser(userId, userData);

        // Then write to cache
        jedis.setex("user:" + userId, 3600, userData);
    }

    public String getUser(String userId) {
        // Always from cache (if present)
        return jedis.get("user:" + userId);
    }
}
```

| ✅ Advantages           | ❌ Disadvantages               |
| ----------------------- | ------------------------------ |
| Cache always consistent | Write latency (two writes)     |
| No cache miss penalty   | Wasted cache for unused data   |
| Simple read path        | Database still must be updated |

### **8.3 Write-Behind (Write-Back)**

Write to cache first, asynchronously write to database.

```java
public class WriteBehindStrategy {
    private Jedis jedis;
    private Queue<String> writeQueue; // Could be Kafka, SQS

    public void saveUser(String userId, String userData) {
        // Write to cache immediately
        jedis.setex("user:" + userId, 3600, userData);

        // Queue for database write
        writeQueue.offer(userId + ":" + userData);
    }

    // Background processor
    public void processWrites() {
        while (true) {
            String item = writeQueue.poll();
            if (item != null) {
                String[] parts = item.split(":", 2);
                db.saveUser(parts[0], parts[1]);
            }
        }
    }
}
```

| ✅ Advantages         | ❌ Disadvantages              |
| --------------------- | ----------------------------- |
| Fast writes           | Data loss risk if cache fails |
| Batch database writes | Consistency challenges        |
| Offloads database     | Complex implementation        |

### **8.4 Cache Invalidation Strategies**

| Strategy               | Method                | When to Use                  |
| ---------------------- | --------------------- | ---------------------------- |
| **TTL (Time-to-Live)** | `EXPIRE key seconds`  | Data changes predictably     |
| **Write Invalidate**   | Delete on update      | Write-heavy, read-heavy mix  |
| **Write Update**       | Update cache on write | Read-heavy, can accept stale |
| **Versioning**         | Use version keys      | Complex data relationships   |

```java
// TTL example
jedis.setex("leaderboard", 300, leaderboardJson);

// Write invalidate
public void updateProduct(String productId, Product product) {
    db.updateProduct(productId, product);
    jedis.del("product:" + productId); // Invalidate cache
}

// Versioning
public String getUserWithVersion(String userId) {
    String version = jedis.get("user:" + userId + ":version");
    String cached = jedis.get("user:" + userId + ":v" + version);

    if (cached == null) {
        // Load from DB, increment version
    }
    return cached;
}
```

---

## **9. PUB/SUB & MESSAGING**

> **Concept:** Redis provides lightweight publish/subscribe messaging with channel-based routing .

### **Pub/Sub Architecture**

```
Publisher
    │
    ▼
┌─────────────────────────────────────┐
│            Redis Channel             │
│  "news.sports"  "news.tech"         │
└──────────────┬───────────────┬──────┘
               │               │
               ▼               ▼
          Subscriber 1     Subscriber 2
          (sports)         (tech)
```

### **Publisher Example**

```java
import redis.clients.jedis.Jedis;

public class PublisherExample {
    public static void main(String[] args) {
        try (Jedis jedis = new Jedis("localhost", 6379)) {
            // Publish to channel
            jedis.publish("news.sports", "Team A wins the championship!");
            jedis.publish("news.tech", "New Java version released");

            // Publish to multiple channels
            String[] channels = {"news.sports", "news.tech"};
            for (String channel : channels) {
                jedis.publish(channel, "Update at " + System.currentTimeMillis());
            }
        }
    }
}
```

### **Subscriber Example**

```java
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPubSub;

public class SubscriberExample {
    public static void main(String[] args) {
        try (Jedis jedis = new Jedis("localhost", 6379)) {
            // Create subscriber
            JedisPubSub subscriber = new JedisPubSub() {
                @Override
                public void onMessage(String channel, String message) {
                    System.out.println("Channel " + channel + ": " + message);
                }

                @Override
                public void onSubscribe(String channel, int subscribedChannels) {
                    System.out.println("Subscribed to " + channel);
                }

                @Override
                public void onUnsubscribe(String channel, int subscribedChannels) {
                    System.out.println("Unsubscribed from " + channel);
                }
            };

            // Subscribe to channels (blocking)
            jedis.subscribe(subscriber, "news.sports", "news.tech");

            // Subscribe to pattern
            // jedis.psubscribe(subscriber, "news.*");
        }
    }
}
```

### **Pub/Sub Features & Limitations**

| Feature                | Description                             |
| ---------------------- | --------------------------------------- |
| **Fire-and-forget**    | Publishers don't know about subscribers |
| **No persistence**     | Messages lost if no subscriber          |
| **No acknowledgments** | Subscribers must process as received    |
| **Pattern matching**   | Subscribe to patterns like `news.*`     |
| **High throughput**    | Very fast, minimal overhead             |

### **Pub/Sub vs Streams vs Lists**

| Feature             | Pub/Sub                 | Streams        | Lists              |
| ------------------- | ----------------------- | -------------- | ------------------ |
| **Persistence**     | No                      | Yes (AOF/RDB)  | Yes                |
| **Consumer Groups** | No                      | Yes            | No                 |
| **Acknowledgments** | No                      | Yes            | No (via RPOPLPUSH) |
| **Message Replay**  | No                      | Yes            | No                 |
| **Use Case**        | Real-time notifications | Event sourcing | Task queues        |

---

## **10. REDIS TRANSACTIONS & LUA SCRIPTING**

> **Concept:** Redis transactions and Lua scripts provide atomicity for multiple operations .

### **10.1 Transactions with MULTI/EXEC**

```java
import redis.clients.jedis.Transaction;
import redis.clients.jedis.Response;

public class TransactionExample {
    public static void main(String[] args) {
        try (Jedis jedis = new Jedis("localhost", 6379)) {
            // Start transaction
            Transaction t = jedis.multi();

            // Queue commands
            t.set("key1", "value1");
            t.set("key2", "value2");
            t.incr("counter");
            Response<String> result = t.get("key1");

            // Execute transaction
            List<Object> results = t.exec();

            // Get result from queued response
            System.out.println("Result: " + result.get());
        }
    }
}
```

#### **Optimistic Locking with WATCH**

```java
public class OptimisticLockingExample {
    public boolean transferFunds(String from, String to, int amount) {
        try (Jedis jedis = new Jedis("localhost", 6379)) {
            while (true) {
                // Watch keys for changes
                jedis.watch(from, to);

                // Get current balances
                int fromBalance = Integer.parseInt(jedis.get(from));
                int toBalance = Integer.parseInt(jedis.get(to));

                if (fromBalance < amount) {
                    jedis.unwatch();
                    return false;
                }

                // Start transaction
                Transaction t = jedis.multi();
                t.set(from, String.valueOf(fromBalance - amount));
                t.set(to, String.valueOf(toBalance + amount));

                // Execute transaction (fails if watched keys changed)
                List<Object> results = t.exec();

                if (results != null) {
                    return true; // Success
                }

                // Retry if transaction failed
            }
        }
    }
}
```

### **10.2 Lua Scripting**

Redis Lua scripts execute atomically and can combine multiple commands.

```lua
-- transfer.lua
local from = KEYS[1]
local to = KEYS[2]
local amount = tonumber(ARGV[1])

local fromBalance = tonumber(redis.call('get', from) or 0)
if fromBalance < amount then
    return redis.error_reply('Insufficient funds')
end

redis.call('decrby', from, amount)
redis.call('incrby', to, amount)

return 'OK'
```

```java
public class LuaScriptExample {
    public static void main(String[] args) {
        try (Jedis jedis = new Jedis("localhost", 6379)) {
            // Load script
            String script = "local from = KEYS[1]\n" +
                           "local to = KEYS[2]\n" +
                           "local amount = tonumber(ARGV[1])\n" +
                           "\n" +
                           "local fromBalance = tonumber(redis.call('get', from) or 0)\n" +
                           "if fromBalance < amount then\n" +
                           "    return redis.error_reply('Insufficient funds')\n" +
                           "end\n" +
                           "\n" +
                           "redis.call('decrby', from, amount)\n" +
                           "redis.call('incrby', to, amount)\n" +
                           "\n" +
                           "return 'OK'";

            // Load script once
            String sha = jedis.scriptLoad(script);

            // Execute with keys and arguments
            List<String> keys = Arrays.asList("account:1000", "account:2000");
            List<String> args = Arrays.asList("50");

            Object result = jedis.evalsha(sha, keys, args);
            System.out.println("Result: " + result);

            // Execute without pre-loading
            // Object result2 = jedis.eval(script, keys, args);
        }
    }
}
```

#### **Lua Script Advantages**

| Advantage              | Description                                 |
| ---------------------- | ------------------------------------------- |
| **Atomicity**          | Entire script executes without interruption |
| **Complex operations** | Combine multiple Redis commands             |
| **Network efficiency** | Send logic once, execute many times         |
| **Server-side logic**  | Reduce client-server round trips            |

#### **Lua Script Best Practices**

- Keep scripts short (Redis is single-threaded)
- Use KEYS array for all keys (for cluster compatibility)
- Return error with `redis.error_reply()`
- Pre-load scripts with `SCRIPT LOAD`

---

## **11. REDIS AS A DATABASE VS CACHE**

> **Concept:** Redis can serve both as a primary database and as a cache, with different considerations for each .

### **Redis as Primary Database**

Use Redis as your main data store when:

```java
// Example: Session store
public class SessionStore {
    private Jedis jedis;

    public void createSession(String sessionId, UserSession session) {
        // Persist with AOF enabled
        String json = serialize(session);
        jedis.setex("session:" + sessionId, 3600, json);
    }

    public UserSession getSession(String sessionId) {
        String json = jedis.get("session:" + sessionId);
        return deserialize(json);
    }
}
```

| ✅ Advantages           | ❌ Disadvantages                |
| ----------------------- | ------------------------------- |
| **Extreme performance** | Limited by RAM capacity         |
| **Rich data types**     | No complex query language       |
| **Atomic operations**   | Data size limited by memory     |
| **Built-in HA**         | Need careful persistence config |

### **Redis as Cache**

Use Redis as a cache in front of another database:

```java
// Example: Database cache
public class UserService {
    private Jedis jedis;
    private Database db;

    public User getUser(String userId) {
        // Try cache first
        String cached = jedis.get("user:" + userId);
        if (cached != null) {
            return deserialize(cached);
        }

        // Cache miss - get from DB
        User user = db.findUser(userId);

        // Store in cache with TTL
        jedis.setex("user:" + userId, 300, serialize(user));

        return user;
    }
}
```

| ✅ Advantages              | ❌ Disadvantages              |
| -------------------------- | ----------------------------- |
| **Reduces DB load**        | Cache invalidation complexity |
| **Faster responses**       | Additional infrastructure     |
| **Handles traffic spikes** | Consistency challenges        |
| **Cost-effective**         | TTL management needed         |

### **Choosing Your Approach**

| Factor              | Use as Database                           | Use as Cache                    |
| ------------------- | ----------------------------------------- | ------------------------------- |
| **Data size**       | Fits in RAM                               | Any size                        |
| **Durability**      | Required                                  | Optional                        |
| **Complex queries** | Simple key access                         | Complex in primary DB           |
| **Consistency**     | Real-time                                 | Eventually consistent           |
| **Use cases**       | Session, real-time counters, leaderboards | API responses, database offload |

---

## **12. JAVA CLIENTS: JEDIS VS LETTUCE**

> **Concept:** Two popular Java Redis clients with different characteristics .

### **12.1 Jedis**

Simple, straightforward, blocking client.

```xml
<dependency>
    <groupId>redis.clients</groupId>
    <artifactId>jedis</artifactId>
    <version>4.3.0</version>
</dependency>
```

```java
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

public class JedisExample {
    public static void main(String[] args) {
        // Connection pool
        JedisPoolConfig poolConfig = new JedisPoolConfig();
        poolConfig.setMaxTotal(10);
        poolConfig.setMaxIdle(5);
        poolConfig.setMinIdle(1);

        JedisPool pool = new JedisPool(poolConfig, "localhost", 6379);

        // Use pool
        try (Jedis jedis = pool.getResource()) {
            jedis.set("key", "value");
            String value = jedis.get("key");
        }

        pool.close();
    }
}
```

#### **Jedis Features**

| Feature                   | Support                           |
| ------------------------- | --------------------------------- |
| **Thread Safety**         | Pool recommended, not thread-safe |
| **Connection Management** | Connection pool                   |
| **Pipelining**            | Yes                               |
| **Transactions**          | Yes                               |
| **Pub/Sub**               | Yes                               |
| **Cluster**               | Yes (JedisCluster)                |
| **Sentinel**              | Yes (JedisSentinelPool)           |
| **Performance**           | Good, blocking I/O                |

### **12.2 Lettuce**

Advanced, reactive, non-blocking client.

```xml
<dependency>
    <groupId>io.lettuce</groupId>
    <artifactId>lettuce-core</artifactId>
    <version>6.2.0</version>
</dependency>
```

```java
import io.lettuce.core.RedisClient;
import io.lettuce.core.api.StatefulRedisConnection;
import io.lettuce.core.api.sync.RedisCommands;

public class LettuceExample {
    public static void main(String[] args) {
        // Create client
        RedisClient redisClient = RedisClient.create("redis://localhost:6379");

        // Get connection
        StatefulRedisConnection<String, String> connection =
            redisClient.connect();

        // Sync API
        RedisCommands<String, String> sync = connection.sync();
        sync.set("key", "value");
        String value = sync.get("key");

        // Async API
        RedisAsyncCommands<String, String> async = connection.async();
        async.set("key", "async-value").thenAccept(result -> {
            System.out.println("Set result: " + result);
        });

        // Reactive API
        RedisReactiveCommands<String, String> reactive = connection.reactive();
        reactive.set("key", "reactive-value").subscribe();

        // Cleanup
        connection.close();
        redisClient.shutdown();
    }
}
```

#### **Lettuce Features**

| Feature                   | Support                            |
| ------------------------- | ---------------------------------- |
| **Thread Safety**         | Yes, single connection thread-safe |
| **Connection Management** | Built-in, multiplexing             |
| **Pipelining**            | Yes                                |
| **Transactions**          | Yes                                |
| **Pub/Sub**               | Yes                                |
| **Cluster**               | Yes                                |
| **Sentinel**              | Yes                                |
| **Performance**           | Excellent, non-blocking I/O        |
| **Reactive APIs**         | Yes (Project Reactor, RxJava)      |

### **Jedis vs Lettuce Comparison**

| Aspect                 | Jedis                           | Lettuce                        |
| ---------------------- | ------------------------------- | ------------------------------ |
| **API Style**          | Synchronous                     | Sync, Async, Reactive          |
| **Connection Model**   | Blocking I/O                    | Non-blocking, Netty            |
| **Thread Safety**      | Not thread-safe (use pool)      | Thread-safe (share connection) |
| **Performance**        | Good                            | Excellent, higher concurrency  |
| **Learning Curve**     | Simple                          | Moderate                       |
| **Memory Usage**       | Lower                           | Higher                         |
| **Community**          | Larger, mature                  | Growing, modern                |
| **Spring Integration** | Spring Data Redis supports both | Same                           |

### **Choosing a Client**

| Scenario                | Recommended                     |
| ----------------------- | ------------------------------- |
| **Simple applications** | Jedis (simpler)                 |
| **High concurrency**    | Lettuce (better performance)    |
| **Reactive stack**      | Lettuce (reactive support)      |
| **Spring Boot default** | Lettuce (since Spring Boot 2.x) |
| **Legacy applications** | Jedis (widespread)              |

---

## **13. SPRING BOOT WITH REDIS**

> **Concept:** Spring Data Redis provides easy integration with Redis using familiar Spring patterns .

### **13.1 Dependencies**

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>

<!-- Optional: Use Jedis instead of Lettuce -->
<dependency>
    <groupId>redis.clients</groupId>
    <artifactId>jedis</artifactId>
</dependency>
```

### **13.2 Configuration**

```yaml
# application.yml
spring:
  redis:
    host: localhost
    port: 6379
    password:
    database: 0
    timeout: 2000ms
    lettuce:
      pool:
        max-active: 8
        max-idle: 8
        min-idle: 0
```

```java
@Configuration
@EnableCaching
public class RedisConfig {

    @Bean
    public RedisTemplate<String, Object> redisTemplate(
            RedisConnectionFactory connectionFactory) {

        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(connectionFactory);

        // Key serializer
        template.setKeySerializer(new StringRedisSerializer());

        // Value serializer (JSON)
        template.setValueSerializer(new GenericJackson2JsonRedisSerializer());

        // Hash key serializer
        template.setHashKeySerializer(new StringRedisSerializer());

        // Hash value serializer
        template.setHashValueSerializer(new GenericJackson2JsonRedisSerializer());

        return template;
    }

    @Bean
    public CacheManager cacheManager(RedisConnectionFactory connectionFactory) {
        RedisCacheConfiguration config = RedisCacheConfiguration.defaultCacheConfig()
            .entryTtl(Duration.ofMinutes(10))
            .disableCachingNullValues()
            .serializeKeysWith(
                RedisSerializationContext.SerializationPair.fromSerializer(
                    new StringRedisSerializer()))
            .serializeValuesWith(
                RedisSerializationContext.SerializationPair.fromSerializer(
                    new GenericJackson2JsonRedisSerializer()));

        return RedisCacheManager.builder(connectionFactory)
            .cacheDefaults(config)
            .build();
    }
}
```

### **13.3 Using RedisTemplate**

```java
@Service
public class UserService {

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    private static final String USER_KEY_PREFIX = "user:";

    public void saveUser(User user) {
        String key = USER_KEY_PREFIX + user.getId();
        redisTemplate.opsForValue().set(key, user, 1, TimeUnit.HOURS);
    }

    public User getUser(String userId) {
        String key = USER_KEY_PREFIX + userId;
        return (User) redisTemplate.opsForValue().get(key);
    }

    public void deleteUser(String userId) {
        String key = USER_KEY_PREFIX + userId;
        redisTemplate.delete(key);
    }

    public void addToLeaderboard(String userId, int score) {
        redisTemplate.opsForZSet().add("leaderboard", userId, score);
    }

    public Set<Object> getTopPlayers(int count) {
        return redisTemplate.opsForZSet().reverseRange("leaderboard", 0, count - 1);
    }
}
```

### **13.4 Repository Pattern**

```java
@RedisHash("users")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {

    @Id
    private String id;
    private String name;
    private String email;
    private Integer age;

    @Indexed
    private String city;

    @Reference
    private List<Order> orders;
}

@Repository
public interface UserRepository extends CrudRepository<User, String> {

    List<User> findByCity(String city);

    List<User> findByName(String name);
}

// Usage
@Service
public class UserRepositoryService {

    @Autowired
    private UserRepository userRepository;

    public User createUser(User user) {
        return userRepository.save(user);
    }

    public Optional<User> getUser(String id) {
        return userRepository.findById(id);
    }

    public List<User> getUsersByCity(String city) {
        return userRepository.findByCity(city);
    }

    public void deleteUser(String id) {
        userRepository.deleteById(id);
    }
}
```

### **13.5 Caching Annotations**

```java
@Service
public class ProductService {

    @Autowired
    private ProductRepository productRepository;

    @Cacheable(value = "products", key = "#id")
    public Product getProduct(Long id) {
        // Expensive database call
        return productRepository.findById(id).orElse(null);
    }

    @CachePut(value = "products", key = "#product.id")
    public Product updateProduct(Product product) {
        return productRepository.save(product);
    }

    @CacheEvict(value = "products", key = "#id")
    public void deleteProduct(Long id) {
        productRepository.deleteById(id);
    }

    @Cacheable(value = "products", unless = "#result.size() < 10")
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }
}
```

---

## **14. COMMON USE CASES**

> **Concept:** Redis excels in specific scenarios where its in-memory speed and data structures shine .

### **14.1 Session Store**

```java
@Component
public class SessionManager {

    private final Jedis jedis;
    private static final int SESSION_TTL = 3600; // 1 hour

    public SessionManager(Jedis jedis) {
        this.jedis = jedis;
    }

    public void createSession(String sessionId, Map<String, String> sessionData) {
        String key = "session:" + sessionId;
        jedis.hset(key, sessionData);
        jedis.expire(key, SESSION_TTL);
    }

    public Map<String, String> getSession(String sessionId) {
        return jedis.hgetAll("session:" + sessionId);
    }

    public void updateSession(String sessionId, String field, String value) {
        jedis.hset("session:" + sessionId, field, value);
    }

    public void deleteSession(String sessionId) {
        jedis.del("session:" + sessionId);
    }

    public boolean sessionExists(String sessionId) {
        return jedis.exists("session:" + sessionId);
    }
}
```

### **14.2 Rate Limiting**

```java
@Component
public class RateLimiter {

    private final Jedis jedis;

    public RateLimiter(Jedis jedis) {
        this.jedis = jedis;
    }

    public boolean allowRequest(String userId, String action, int maxRequests, int windowSeconds) {
        String key = "rate:" + userId + ":" + action;

        // Increment counter
        Long current = jedis.incr(key);

        // Set expiry on first request
        if (current == 1) {
            jedis.expire(key, windowSeconds);
        }

        return current <= maxRequests;
    }

    // Sliding window using sorted sets
    public boolean allowRequestSliding(String userId, String action, int maxRequests, int windowSeconds) {
        String key = "rate:sliding:" + userId + ":" + action;
        long now = System.currentTimeMillis();

        // Add current request with timestamp
        jedis.zadd(key, now, String.valueOf(now));

        // Remove requests older than window
        jedis.zremrangeByScore(key, 0, now - (windowSeconds * 1000L));

        // Count requests in current window
        Long count = jedis.zcard(key);

        // Set expiry
        jedis.expire(key, windowSeconds);

        return count <= maxRequests;
    }
}
```

### **14.3 Leaderboard**

```java
@Component
public class LeaderboardService {

    private final Jedis jedis;
    private static final String LEADERBOARD_KEY = "game:leaderboard";

    public LeaderboardService(Jedis jedis) {
        this.jedis = jedis;
    }

    public void updateScore(String playerId, int score) {
        jedis.zadd(LEADERBOARD_KEY, score, playerId);
    }

    public void incrementScore(String playerId, int increment) {
        jedis.zincrby(LEADERBOARD_KEY, increment, playerId);
    }

    public Set<String> getTopPlayers(int count) {
        return jedis.zrevrange(LEADERBOARD_KEY, 0, count - 1);
    }

    public List<Tuple> getTopPlayersWithScores(int count) {
        return jedis.zrevrangeWithScores(LEADERBOARD_KEY, 0, count - 1);
    }

    public Long getPlayerRank(String playerId) {
        // 0-based rank, add 1 for display
        Long rank = jedis.zrevrank(LEADERBOARD_KEY, playerId);
        return rank != null ? rank + 1 : null;
    }

    public Double getPlayerScore(String playerId) {
        return jedis.zscore(LEADERBOARD_KEY, playerId);
    }

    public Set<String> getPlayersAround(String playerId, int range) {
        Long rank = jedis.zrevrank(LEADERBOARD_KEY, playerId);
        if (rank == null) return Collections.emptySet();

        long start = Math.max(0, rank - range);
        long end = rank + range;

        return jedis.zrevrange(LEADERBOARD_KEY, start, end);
    }
}
```

### **14.4 Message Queue**

```java
@Component
public class RedisQueue {

    private final Jedis jedis;
    private static final String QUEUE_KEY = "queue:tasks";

    public RedisQueue(Jedis jedis) {
        this.jedis = jedis;
    }

    public void push(String task) {
        jedis.lpush(QUEUE_KEY, task);
    }

    public String pop() {
        return jedis.rpop(QUEUE_KEY);
    }

    public String blockingPop(int timeoutSeconds) {
        List<String> result = jedis.brpop(timeoutSeconds, QUEUE_KEY);
        return result != null ? result.get(1) : null;
    }

    public Long size() {
        return jedis.llen(QUEUE_KEY);
    }

    public List<String> peek(int count) {
        return jedis.lrange(QUEUE_KEY, 0, count - 1);
    }
}
```

### **14.5 Distributed Lock**

```java
@Component
public class DistributedLock {

    private final Jedis jedis;
    private static final String LOCK_PREFIX = "lock:";

    public DistributedLock(Jedis jedis) {
        this.jedis = jedis;
    }

    public boolean acquireLock(String lockName, String requestId, int ttlSeconds) {
        String key = LOCK_PREFIX + lockName;

        // SET NX (if not exists) with expiration
        String result = jedis.set(key, requestId, SetParams.setParams()
            .nx()
            .ex(ttlSeconds));

        return "OK".equals(result);
    }

    public boolean releaseLock(String lockName, String requestId) {
        String key = LOCK_PREFIX + lockName;

        // Lua script to ensure we only delete our own lock
        String script = "if redis.call('get', KEYS[1]) == ARGV[1] then " +
                       "    return redis.call('del', KEYS[1]) " +
                       "else " +
                       "    return 0 " +
                       "end";

        Long result = (Long) jedis.eval(script,
            Collections.singletonList(key),
            Collections.singletonList(requestId));

        return result == 1L;
    }

    public void executeWithLock(String lockName, Runnable task, int ttlSeconds) {
        String requestId = UUID.randomUUID().toString();

        try {
            if (acquireLock(lockName, requestId, ttlSeconds)) {
                task.run();
            } else {
                throw new RuntimeException("Failed to acquire lock: " + lockName);
            }
        } finally {
            releaseLock(lockName, requestId);
        }
    }
}
```

---

## **15. PERFORMANCE & MEMORY OPTIMIZATION**

> **Concept:** Optimizing Redis for maximum performance and efficient memory usage .

### **15.1 Memory Optimization Techniques**

| Technique                          | Description                          |
| ---------------------------------- | ------------------------------------ |
| **Use appropriate data types**     | Hashes over strings for objects      |
| **Short keys**                     | Meaningful but concise keys          |
| **Memory-efficient serialization** | Protocol buffers, MessagePack        |
| **Hash field space optimization**  | Use hash field to store related data |
| **Enable compression**             | For large values                     |
| **Set maxmemory policy**           | Control eviction behavior            |

```java
// Inefficient (each attribute as separate key)
jedis.set("user:1000:name", "John");
jedis.set("user:1000:email", "john@example.com");
jedis.set("user:1000:age", "30");

// Efficient (use hash)
jedis.hset("user:1000", "name", "John");
jedis.hset("user:1000", "email", "john@example.com");
jedis.hset("user:1000", "age", "30");
```

### **15.2 Memory Policies**

```properties
# redis.conf
maxmemory 2gb

# Eviction policies
maxmemory-policy volatile-lru  # Evict keys with TTL using LRU
# maxmemory-policy allkeys-lru  # Evict any key using LRU
# maxmemory-policy volatile-ttl  # Evict keys with shortest TTL
# maxmemory-policy volatile-random  # Random eviction with TTL
# maxmemory-policy allkeys-random  # Random eviction
# maxmemory-policy noeviction  # Return errors on writes
```

### **15.3 Performance Optimization**

```java
// 1. Use pipelining for multiple commands
public void pipelineExample(Jedis jedis) {
    Pipeline pipeline = jedis.pipelined();

    for (int i = 0; i < 1000; i++) {
        pipeline.set("key:" + i, "value:" + i);
    }

    pipeline.sync(); // Execute all at once
}

// 2. Use batch operations
public void batchExample(Jedis jedis) {
    // MSET for multiple key-value pairs
    Map<String, String> pairs = new HashMap<>();
    for (int i = 0; i < 100; i++) {
        pairs.put("key:" + i, "value:" + i);
    }
    jedis.mset(pairs);
}

// 3. Connection pooling
JedisPoolConfig config = new JedisPoolConfig();
config.setMaxTotal(50);        // Maximum connections
config.setMaxIdle(10);          // Maximum idle connections
config.setMinIdle(5);           // Minimum idle connections
config.setTestOnBorrow(true);   // Validate connections
```

### **15.4 Performance Comparison**

| Operation               | Without Optimization       | With Optimization | Improvement |
| ----------------------- | -------------------------- | ----------------- | ----------- |
| **1000 SET operations** | ~50ms (round trips)        | ~5ms (pipelined)  | 10x         |
| **Object storage**      | 3 keys per object          | 1 hash per object | 3x memory   |
| **Connection overhead** | New connection per request | Connection pool   | 100x        |

---

## **16. SECURITY BEST PRACTICES**

> **Concept:** Protecting Redis from unauthorized access and data breaches .

### **16.1 Authentication**

```properties
# redis.conf
requirepass YourStrongPassword
masterauth YourStrongPassword  # For replication
```

```java
// Connect with password
Jedis jedis = new Jedis("localhost", 6379);
jedis.auth("YourStrongPassword");
```

### **16.2 Network Security**

```properties
# redis.conf
bind 127.0.0.1  # Listen only on localhost
# bind 192.168.1.100  # Specific network interface

protected-mode yes  # Require password or binding

port 6379  # Change default port (not strong security)
```

### **16.3 TLS/SSL Encryption**

```properties
# redis.conf (Redis 6+)
tls-port 6379
tls-cert-file /path/to/redis.crt
tls-key-file /path/to/redis.key
tls-ca-cert-file /path/to/ca.crt
tls-auth-clients yes
```

```java
// Java client with TLS
import redis.clients.jedis.Jedis;
import javax.net.ssl.SSLParameters;

SSLParameters sslParams = new SSLParameters();
sslParams.setEndpointIdentificationAlgorithm("HTTPS");

Jedis jedis = new Jedis(URI.create("rediss://localhost:6379"));
jedis.auth("password");
```

### **16.4 Command Renaming**

Disable dangerous commands or rename them.

```properties
# redis.conf
rename-command FLUSHDB ""
rename-command FLUSHALL ""
rename-command CONFIG "veryhardguess"
rename-command SHUTDOWN ""
```

### **16.5 Security Checklist**

| Item                   | Recommendation                           |
| ---------------------- | ---------------------------------------- |
| **Authentication**     | Always set a strong password             |
| **Network Binding**    | Bind to specific interfaces, not 0.0.0.0 |
| **Port**               | Consider changing from default           |
| **Protected Mode**     | Enable in production                     |
| **Dangerous Commands** | Disable or rename                        |
| **TLS/SSL**            | Use for sensitive data                   |
| **Updates**            | Keep Redis version updated               |
| **Monitoring**         | Monitor for suspicious activity          |

---

## **17. MONITORING & TROUBLESHOOTING**

> **Concept:** Keeping Redis healthy requires monitoring key metrics and knowing how to diagnose issues .

### **17.1 Key Metrics**

| Metric                  | Command            | What it indicates                     |
| ----------------------- | ------------------ | ------------------------------------- |
| **Memory usage**        | `INFO memory`      | Used_memory, peak_memory              |
| **CPU usage**           | `INFO cpu`         | used_cpu_sys, used_cpu_user           |
| **Connected clients**   | `INFO clients`     | connected_clients                     |
| **Commands per second** | `INFO stats`       | instantaneous_ops_per_sec             |
| **Hit ratio**           | `INFO stats`       | keyspace_hits / (hits + misses)       |
| **Replication lag**     | `INFO replication` | master_repl_offset, slave_repl_offset |
| **Slow queries**        | `SLOWLOG GET 10`   | Log of slow commands                  |

### **17.2 INFO Command**

```java
public class RedisMonitor {

    private Jedis jedis;

    public void printRedisInfo() {
        String info = jedis.info();
        System.out.println(info);

        // Get specific sections
        String serverInfo = jedis.info("server");
        String memoryInfo = jedis.info("memory");
        String statsInfo = jedis.info("stats");
    }

    public Map<String, Object> getMemoryStats() {
        String memoryInfo = jedis.info("memory");
        Map<String, Object> stats = new HashMap<>();

        for (String line : memoryInfo.split("\n")) {
            if (line.contains(":")) {
                String[] parts = line.split(":");
                stats.put(parts[0], parts[1]);
            }
        }

        return stats;
    }

    public double getHitRatio() {
        String stats = jedis.info("stats");
        long hits = 0, misses = 0;

        for (String line : stats.split("\n")) {
            if (line.startsWith("keyspace_hits:")) {
                hits = Long.parseLong(line.split(":")[1]);
            } else if (line.startsWith("keyspace_misses:")) {
                misses = Long.parseLong(line.split(":")[1]);
            }
        }

        return hits + misses > 0 ? (double) hits / (hits + misses) : 0;
    }
}
```

### **17.3 Slow Log**

```java
public class SlowLogAnalyzer {

    private Jedis jedis;

    public List<Slowlog> getSlowLogs(int count) {
        return jedis.slowlogGet(count);
    }

    public void analyzeSlowLogs() {
        List<Slowlog> slowLogs = jedis.slowlogGet(100);

        for (Slowlog log : slowLogs) {
            System.out.println("ID: " + log.getId());
            System.out.println("Time: " + new Date(log.getTimeStamp() * 1000L));
            System.out.println("Duration: " + log.getExecutionTime() + " microseconds");
            System.out.println("Command: " + log.getArgs());
            System.out.println("---");
        }
    }

    public void resetSlowLog() {
        jedis.slowlogReset();
    }
}
```

### **17.4 Common Issues & Solutions**

| Issue                  | Symptoms              | Solutions                                     |
| ---------------------- | --------------------- | --------------------------------------------- |
| **Out of memory**      | OOM errors, evictions | Increase maxmemory, optimize data structures  |
| **High latency**       | Slow responses        | Check slowlog, monitor CPU, optimize commands |
| **Connection limit**   | Connection refused    | Increase maxclients, use connection pool      |
| **Replication lag**    | Slave falling behind  | Check network, reduce master load             |
| **High CPU**           | 100% CPU usage        | Optimize expensive operations, scale          |
| **Data inconsistency** | Mismatched data       | Check replication, AOF corruption             |

### **17.5 Redis-cli Commands**

```bash
# Monitor real-time commands
redis-cli monitor

# Check latency
redis-cli --latency
redis-cli --latency-history

# Check memory
redis-cli memory stats
redis-cli memory doctor

# Slow log
redis-cli slowlog get 10

# Info
redis-cli info stats
redis-cli info memory
```

---

## **18. COMMON INTERVIEW QUESTIONS**

### **Basic Level**

| Question                                   | Answer                                                                   |
| ------------------------------------------ | ------------------------------------------------------------------------ |
| **What is Redis?**                         | In-memory data structure store used as database, cache, message broker   |
| **What data types does Redis support?**    | Strings, Hashes, Lists, Sets, Sorted Sets, Bitmaps, HyperLogLog, Streams |
| **How is Redis different from Memcached?** | Redis supports rich data types, persistence, replication, clustering     |
| **What is Redis persistence?**             | RDB snapshots and AOF logs to save data to disk                          |
| **What are Redis keyspace notifications?** | Pub/Sub events when keys change                                          |

### **Intermediate Level**

| Question                                             | Answer                                                                     |
| ---------------------------------------------------- | -------------------------------------------------------------------------- |
| **How does Redis replication work?**                 | Master sends commands to slaves asynchronously, initial full sync with RDB |
| **What is Redis Sentinel?**                          | High availability solution with automatic failover                         |
| **How does Redis Cluster shard data?**               | 16384 hash slots distributed across nodes using CRC16(key)                 |
| **What is cache stampede?**                          | Multiple requests hitting DB when cache expires                            |
| **How do you implement distributed locks in Redis?** | SETNX with expiration, Lua script for safe release                         |

### **Advanced Level**

| Question                                           | Answer                                                                                |
| -------------------------------------------------- | ------------------------------------------------------------------------------------- |
| **How does Redis achieve high performance?**       | In-memory, single-threaded event loop, O(1) operations, zero-copy                     |
| **Explain Redis LRU eviction**                     | Approximate LRU using pool of candidates                                              |
| **What happens during failover in Redis Cluster?** | Slaves promoted, cluster unavailable during election                                  |
| **How do you handle hot keys in Redis?**           | Sharding, local caching, read replicas                                                |
| **Compare Redis Streams vs Kafka**                 | Both: event streaming; Redis: simpler, lower latency; Kafka: longer retention, replay |

### **Scenario-Based Questions**

**Q: Design a rate limiter using Redis**

> **A:** Use INCR with EXPIRE for fixed window, or sorted sets for sliding window.

**Q: How would you implement a real-time leaderboard?**

> **A:** Use Sorted Sets with ZADD for scores, ZREVRANGE for top players.

**Q: Your Redis cache is frequently evicting data. What do you do?**

> **A:** Increase maxmemory, optimize data structures, adjust eviction policy, add nodes.

**Q: How to handle cache warming after Redis restart?**

> **A:** Lazy loading (cache-aside) with TTL, or proactive warming of critical data.

---

## **19. QUICK REFERENCE CHEAT SHEET**

### **Common Redis Commands**

```bash
# Strings
SET key value [EX seconds] [NX|XX]
GET key
INCR key
MSET key1 value1 key2 value2

# Hashes
HSET hash field value
HGET hash field
HGETALL hash
HINCRBY hash field increment

# Lists
LPUSH list value
RPUSH list value
LPOP list
RPOP list
LRANGE list start stop

# Sets
SADD set member
SREM set member
SMEMBERS set
SINTER set1 set2

# Sorted Sets
ZADD zset score member
ZRANGE zset start stop [WITHSCORES]
ZREVRANGE zset start stop [WITHSCORES]
ZINCRBY zset increment member

# Keys
EXPIRE key seconds
TTL key
DEL key
KEYS pattern   # Avoid in production

# Server
INFO [section]
MONITOR
SLOWLOG GET [count]
FLUSHALL        # Dangerous!
```

### **Maven Dependencies**

```xml
<!-- Jedis -->
<dependency>
    <groupId>redis.clients</groupId>
    <artifactId>jedis</artifactId>
    <version>4.3.0</version>
</dependency>

<!-- Lettuce -->
<dependency>
    <groupId>io.lettuce</groupId>
    <artifactId>lettuce-core</artifactId>
    <version>6.2.0</version>
</dependency>

<!-- Spring Boot Redis -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```

### **Configuration Cheat Sheet**

```properties
# redis.conf
port 6379
bind 127.0.0.1
requirepass yourpassword
maxmemory 2gb
maxmemory-policy volatile-lru
save 900 1
save 300 10
save 60 10000
appendonly yes
appendfsync everysec
```

### **Java Client Cheat Sheet**

```java
// Jedis
JedisPool pool = new JedisPool("localhost", 6379);
try (Jedis jedis = pool.getResource()) {
    jedis.set("key", "value");
}

// Lettuce
RedisClient client = RedisClient.create("redis://localhost:6379");
StatefulRedisConnection<String, String> conn = client.connect();
RedisCommands<String, String> commands = conn.sync();
commands.set("key", "value");

// Spring Boot
@Autowired
private RedisTemplate<String, Object> redisTemplate;
redisTemplate.opsForValue().set("key", "value");
```

---

## **📝 KEY TAKEAWAYS**

1. **In-memory speed** makes Redis ideal for caching, real-time applications
2. **Rich data structures** solve diverse problems efficiently
3. **Persistence options** (RDB/AOF) balance performance vs durability
4. **Replication + Sentinel** provide high availability
5. **Redis Cluster** enables horizontal scaling
6. **Single-threaded** ensures atomicity but requires careful optimization
7. **Common use cases**: caching, session store, leaderboards, rate limiting, queues
8. **Memory management** is critical with policies and optimization
9. **Security** requires authentication, network isolation, command renaming
10. **Monitoring** key metrics ensures healthy operations

---

_Good luck with your Redis interview! 🚀🎉_
