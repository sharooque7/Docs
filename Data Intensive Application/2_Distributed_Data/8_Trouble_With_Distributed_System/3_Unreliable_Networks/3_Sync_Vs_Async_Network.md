# 🌐 Synchronous vs Asynchronous Networks in Distributed Systems

## 🧩 Problem Statement
Distributed systems would be simpler if the network:
- Delivered packets with **fixed maximum delay**
- **Never dropped** packets

But this isn’t possible in modern networks due to trade-offs in design.

---

## 🔁 Circuit Switching vs Packet Switching

### 📞 Circuit-Switched Networks (e.g., Traditional Telephone)
- Establishes a **dedicated circuit** with fixed bandwidth
- **No queueing** or congestion
- **Bounded latency**
- Efficient for **steady streams** like audio/video calls

### 💻 Packet-Switched Networks (e.g., Internet, Datacenters)
- **No reserved path** — packets take different routes
- **Queueing delays** and **packet drops** can happen
- Efficient for **bursty traffic** like:
  - Web requests
  - File transfers
  - Emails

---

## ⚖️ Trade-off: Latency vs Utilization

| Resource Sharing Method     | Latency             | Resource Utilization | Cost  |
|-----------------------------|----------------------|------------------------|--------|
| **Static (Circuit-Switched)** | Predictable (low)    | Inefficient            | High   |
| **Dynamic (Packet-Switched)** | Variable (queueing)  | Efficient              | Lower  |

- 🎯 **Static partitioning**: Fixed slices of bandwidth or CPU cycles
- ⚙️ **Dynamic partitioning**: Resources shared & scheduled at runtime

---

## 🚫 Why Not Fix It with Hardware?

- We **could** emulate circuits using technologies like:
  - ATM (Asynchronous Transfer Mode)
  - InfiniBand + QoS
- But:
  - Costly to implement
  - Reduces flexibility
  - Doesn’t scale well in **multi-tenant** or **cloud** environments

---

## 🧠 Key Insight
> Variable delays are not a physical necessity — they are a **cost-benefit trade-off** in system design.

---

## ⚠️ Implications for Distributed System Design

- ✅ Assume the network is **unreliable**
- ✅ Implement:
  - Retries
  - Timeouts (determined **experimentally**)
  - Idempotency
  - Fault-tolerance
