Absolutely! Here's a clean, **Markdown template** for **Back-of-the-Envelope Estimation**, ideal for interviews. You can copy this into your notes, Notion, or any Markdown editor.

---

```markdown
# 🧮 Back-of-the-Envelope Estimation Cheat Sheet (System Design Interviews)

---

## 📌 Step-by-Step Framework

1. **Clarify the requirements**  
   - Users? Features? SLA?
2. **Estimate scale**  
   - Users, requests per day/second, data size
3. **Estimate system workload**  
   - Read/write ratios, request size, data per request
4. **Estimate data size**  
   - Storage needs (daily/monthly/annually)
5. **Estimate throughput & latency**  
   - QPS (queries per second), network/disk latency
6. **Estimate hardware/resource needs**  
   - Number of servers, bandwidth, storage

---

## ⚙️ Estimation Building Blocks

### 👤 Users
- Daily Active Users (DAU): 1M = 1,000,000
- Monthly Active Users (MAU): 30x DAU

### 🕒 Requests
- Avg requests/user/day: e.g., 10 → 10M reqs/day
- Req/sec (QPS) = total reqs per day ÷ 86,400

### 📦 Data Size
| Type         | Size             |
|--------------|------------------|
| Text         | ~1 KB / message  |
| Image        | ~500 KB – 2 MB   |
| Video        | ~5 MB – 50 MB/min |
| JSON object  | ~1 KB – 5 KB     |
| UUID         | 16 Bytes         |
| Timestamp    | 8 Bytes          |

### 🧠 Memory & Cache
- Redis lookup: ~1–5 µs
- RAM access: ~100 ns
- 1 GB = ~1M objects of 1 KB each

### 🛰️ Network
- 1 Gbps = 125 MB/sec
- 10 Gbps = 1.25 GB/sec
- Cross-datacenter latency: ~150 ms

### 💽 Disk (SSD)
- Seq. read/write: ~500 MB/sec
- Random read/write: ~50–100 MB/sec
- Disk seek (HDD): ~10 ms

### 🧾 Log Example
- 1 log entry = ~0.5 KB  
- 10M logs/day = 5 GB/day = ~150 GB/month

---

## 📈 Sample Estimation – Messaging System

**Assume:**
- DAU: 10M
- Avg messages per user/day: 20  
- Message size: 1 KB

```text
Total messages/day = 10M * 20 = 200M
Data/day = 200M * 1 KB = 200 GB/day
QPS = 200M / 86400 ≈ ~2,300 messages/sec
```

- Redis cache for recent messages (1M messages = 1 GB)
- DB write throughput: Needs to support ~2,300 writes/sec
- Storage: ~6 TB/month (before compression)

---

## 📦 Storage Sizing Tips

| Duration     | Size @ 1 GB/day |
|--------------|----------------|
| 1 Day        | 1 GB           |
| 1 Month      | 30 GB          |
| 1 Year       | ~365 GB        |

Multiply by estimated data/day to get final storage.

---

## 🛠️ Server Estimation (Ballpark)

**Assume:**
- 1 server handles 1K QPS
- Total QPS: 20K

→ Need: `20K / 1K = 20 servers`  
Add buffer (e.g., 50% for peak): **30 servers**

---

## 🔁 Cheat Phrases (for Interviews)

- “Assuming 1 KB per request...”
- “Let’s say 10M DAUs, that gives us about 100M requests/day…”
- “1 Gbps link gives us ~125 MB/sec bandwidth…”
- “SSD read speeds are fast enough to serve 500MB/sec...”
- “Redis can hold 1M 1KB objects per GB of RAM…”

---

## 📄 Pro Tip

🔁 **Round to powers of 10**: Use 1M instead of 1,048,576  
🧠 **Focus on relative cost**: Memory < Disk < Network  
🎯 **Always validate with SLA**: Latency, throughput, uptime

---

```

---

Would you like this turned into a downloadable PDF or Notion template as well?