# ⏳ Monotonic vs Time-of-Day Clocks

Modern systems use **two types of clocks** that serve different purposes:

---

## 🕰 Time-of-Day Clock (Wall-Clock Time)

### ✅ Purpose
- Reports the **current calendar date and time**
- Used when you need to **timestamp events**, e.g.:
  - Logging
  - Scheduling
  - Publishing content

### 📚 Examples
- `System.currentTimeMillis()` (Java)
- `clock_gettime(CLOCK_REALTIME)` (Linux)

### 🧭 Reference Point
- Returns milliseconds/seconds since **epoch** (usually Jan 1, 1970 UTC)

### ⚠️ Gotchas
- **May jump backward** if NTP resets an out-of-sync clock
- **Not suitable for measuring elapsed time**
- **Leap seconds ignored** on most systems
- Historically **low resolution** (e.g., 10ms on old systems)

---

## 🌀 Monotonic Clock

### ✅ Purpose
- Measures **durations or intervals**, e.g.:
  - Timeout calculations
  - Benchmarking
  - Performance metrics

### 📚 Examples
- `System.nanoTime()` (Java)
- `clock_gettime(CLOCK_MONOTONIC)` (Linux)

### 🕐 Characteristics
- Always **moves forward** — never jumps backward
- Returns arbitrary values (e.g., nanoseconds since boot)
- **Only useful for measuring differences**, not absolute time

### ⚠️ Gotchas
- **Not comparable across machines**
- Different CPU cores may have **unsynchronized timers**
- OS mitigates discrepancies, but monotonicity isn’t bulletproof
- NTP may **slew the clock** (slightly speed up/down), but won’t cause jumps

---

## 🧠 Key Design Guidelines

| Use Case                         | Recommended Clock     |
|----------------------------------|------------------------|
| Timeout / Delay                  | ✅ Monotonic Clock     |
| Measuring elapsed time           | ✅ Monotonic Clock     |
| Logging / Event timestamps       | ✅ Time-of-Day Clock   |
| Coordinating actions across nodes| ✅ Time-of-Day Clock (with caution) |

---

## 🚀 TL;DR

> **Monotonic Clocks = durations**  
> **Time-of-Day Clocks = actual timestamps**  
> Mixing them up = bugs waiting to happen 🚨

