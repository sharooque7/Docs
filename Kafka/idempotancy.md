## **Kafka Idempotency - Quick Interview Refresher** 🚀

### **What is Idempotency?**
**Definition:** Producing the same message multiple times results in ONLY ONE copy being stored in Kafka.

### **Why Needed?**
Without idempotency, network retries cause duplicates:
```
Producer → Send Message → Network Glitch → Retry → 2 COPIES! ❌
```

### **How It Works**
```
┌──────────────┐     ┌─────────────────┐     ┌──────────────┐
│  Producer    │────▶│  Producer ID    │────▶│   Broker     │
│              │     │  (PID) + Seq #  │     │  Deduplicates│
└──────────────┘     └─────────────────┘     └──────────────┘
```

**3 Key Components:**
1. **Producer ID (PID)** - Unique per producer instance
2. **Sequence Number** - Monotonically increasing per partition
3. **Broker Cache** - Remembers last 5 sequence numbers per PID

### **Configuration (One Line!)**
```properties
enable.idempotence=true
# Automatically forces: acks=all, retries>0, max.in.flight≤5
```

### **What Idempotency DOES vs DOESN'T Do**

| ✅ **PREVENTS** | ❌ **DOES NOT PREVENT** |
|----------------|------------------------|
| Duplicates from automatic retries | Multiple explicit send() calls |
| Duplicates from broker failover | Application-level duplicates |
| Duplicates from network timeouts | Duplicate business transactions |

### **Message Ordering Guarantees**

**With Idempotency:**
- Messages to same partition are **ordered by sequence number**
- Retries don't break ordering
- Max 5 in-flight requests (can't exceed)

**Without Idempotency:**
- Set `max.in.flight=1` for ordering
- But slower performance

### **Idempotency + Ordering Matrix**

| Scenario | Duplicates | Ordering | Config |
|----------|------------|----------|---------|
| No idempotency, in-flight=1 | ❌ Duplicates possible | ✅ Perfect order | `enable.idempotence=false, max.in.flight=1` |
| No idempotency, in-flight>1 | ❌ Duplicates possible | ❌ Out of order | `enable.idempotence=false, max.in.flight=5` |
| **Idempotency, in-flight≤5** | ✅ **No duplicates** | ✅ **Ordered** | `enable.idempotence=true` |

### **Common Interview Questions**

**Q: Does idempotency guarantee exactly-once?**
A: No - it guarantees **no duplicates from retries**, but multiple explicit sends still create duplicates. Use transactions for exactly-once.

**Q: Does idempotency affect ordering?**
A: Yes - it forces `max.in.flight ≤ 5` and uses sequence numbers to maintain order per partition.

**Q: Performance impact?**
A: Minimal (3-5% overhead) - worth it for exactly-once semantics.

### **One-Line Summary**
> "Idempotency uses Producer ID + Sequence Numbers to prevent duplicates from retries while maintaining message order, with minimal performance overhead."

# CORE IDEMPOTENCY
enable.idempotence=true
acks=all
retries=2147483647
max.in.flight.requests.per.connection=5

# RECOMMENDED ADDITIONS
delivery.timeout.ms=120000
request.timeout.ms=30000
linger.ms=5
batch.size=16384
buffer.memory=33554432
compression.type=snappy