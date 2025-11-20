# ⏰ Unreliable Clocks in Distributed Systems

## 📌 Why Time Matters in Distributed Systems

Applications rely on **clocks** for:
1. ⏱ Detecting timeouts  
2. 📊 Measuring performance (e.g., 99th percentile latency)  
3. 📈 Monitoring metrics (e.g., queries/sec over time)  
4. 👤 Tracking user session durations  
5. 📰 Recording event timestamps (e.g., article published time)  
6. 📧 Scheduling actions (e.g., reminder emails)  
7. 🧠 Expiry logic (e.g., cache eviction)  
8. 🪵 Logging (timestamping error messages)

---

## 🕒 Two Types of Time Usage
- **Durations**: Time **intervals** (e.g., response time, session length)  
- **Timestamps**: Specific **points in time** (e.g., published date, expiry)

---

## ⚠️ The Problem in Distributed Systems

- Network **communication is not instantaneous**
- **Message arrival time > send time**, but **transit delays vary**
- **Uncertainty** in message delivery makes **event ordering hard**

---

## 🧭 Clock Skew & Drift

- Every machine has its **own hardware clock** (e.g., quartz crystal)
- Clocks may **run faster or slower** than each other
- Even small **inaccuracies accumulate over time**

---

## 🔧 Clock Synchronization

- **NTP (Network Time Protocol)** is used to align clocks
- NTP synchronizes a machine’s clock with **time servers**
- Time servers may be backed by highly accurate sources like:
  - **GPS receivers**
  - **Atomic clocks**

---

## 🚫 Limitations of Synchronization

- Synchronization is **approximate**, not perfect
- Small **clock skew** is inevitable
- **Causality** between events across nodes can be ambiguous

---

## 💡 Implication

> Distributed systems cannot rely on perfectly synchronized clocks.  
Instead, they must be designed with **tolerance for clock drift and uncertainty**.

---

## ✅ Design Considerations

- Use **monotonic clocks** for durations (won’t jump backward)
- For event ordering:
  - Use **logical clocks** (e.g., Lamport timestamps, vector clocks)
- Avoid assuming two nodes have **exactly the same notion of time**

