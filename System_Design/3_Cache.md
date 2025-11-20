# 🧠 Cache in System Design

## ✅ What is a Cache?
A **cache** is a high-speed data storage layer that stores a subset of data, typically transient in nature, so future requests for that data are served faster than fetching from the primary storage.

---

## 📈 Benefits of Caching
- **Improves performance** by reducing access latency
- **Reduces load** on backend systems/databases
- **Enhances scalability**

---

## 🧱 Cache Tier
A dedicated layer between the application and the database. The application checks the cache before hitting the DB.

---

## 🧠 Caching Strategies

### 1. **Read-through Cache**
- Application checks cache first
- If not present, fetches from DB, stores in cache, then returns

### 2. **Write-through Cache**
- Application writes data to cache and DB simultaneously

### 3. **Write-behind (Write-back) Cache**
- Writes are first cached, then written to DB asynchronously

---

## 🔁 Cache Eviction Policies
Used when cache is full and a new entry needs to be added.

### 1. **LRU (Least Recently Used)**
- Removes the item that was least recently accessed

### 2. **LFU (Least Frequently Used)**
- Removes the item with the lowest access frequency

### 3. **FIFO (First In First Out)**
- Removes the oldest cached item

---

## 🧮 LRU Cache - Implementation Concept
- Uses **Deque** + **HashMap**
- On access/update:
  - Move key to the end of deque
- On insert:
  - If full, evict from front (least recently used)

---

## 🔢 LFU Cache - Implementation Concept
- Stores:
  - cache: key → value
  - freqMap: key → frequency
  - freqListMap: frequency → ordered set of keys
- Keeps track of **min frequency**
- On access/update:
  - Increment frequency and move key accordingly

---

## 🚨 Considerations for Caching
- Use for **read-heavy**, **infrequently updated** data
- Avoid caching **sensitive or rapidly changing data**
- Set appropriate **expiration** policies
- Ensure **consistency** between cache and DB
- Handle **cache failures** gracefully (fallback to DB)

---

## 🧰 Caching in Spring Boot

### Enable Caching
```java
@SpringBootApplication
@EnableCaching
public class App {}
```

### Use Annotations
* `@Cacheable`: Read from cache
* `@CachePut`: Update cache without skipping method
* `@CacheEvict`: Remove from cache

```java
@Cacheable(value = "userCache", key = "#userId")
public User getUser(String userId) {}

@CacheEvict(value = "userCache", key = "#userId")
public void evictUser(String userId) {}
```

## 🧱 Spring Boot + Redis

### Dependencies (Maven)
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-cache</artifactId>
</dependency>
```

### Configuration
```yaml
spring:
  cache:
    type: redis
  redis:
    host: localhost
    port: 6379
```

### Customize TTL
```java
@Bean
public RedisCacheManager cacheManager(RedisConnectionFactory factory) {
    RedisCacheConfiguration config = RedisCacheConfiguration.defaultCacheConfig()
        .entryTtl(Duration.ofMinutes(10));
    return RedisCacheManager.builder(factory).cacheDefaults(config).build();
}
```

## 🔄 Redis Eviction Policies (Server Level)
Set in `redis.conf` or Docker config:
* `allkeys-lru` ✅
* `allkeys-lfu`
* `noeviction`
* `volatile-lru`

```conf
maxmemory 100mb
maxmemory-policy allkeys-lru
```

## 🧪 Testing Caching
* Unit test with mock repository
* Enable Redis locally with Docker:

```bash
docker run -d -p 6379:6379 redis
```

## 📌 Summary

| Feature | In-Memory | Redis |
|---------|-----------|-------|
| Fast Access | ✅ | ✅ |
| Distributed | ❌ | ✅ |
| Persistence | ❌ | ✅ (optional) |
| TTL/Eviction Config | Manual | Redis conf |
| Spring Boot Support | ✅ | ✅ |