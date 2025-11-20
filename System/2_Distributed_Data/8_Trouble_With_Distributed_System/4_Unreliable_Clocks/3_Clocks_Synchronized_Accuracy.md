## 🧭 Clock Synchronization and Accuracy

Unlike **monotonic clocks**, **time-of-day clocks** need synchronization (e.g., via **NTP**). But synchronization isn't always reliable.

---

### ⚙️ Common Issues

#### ⏱ 1. Clock Drift
- Quartz clocks **drift** with temperature and hardware quality.
- Example (Google's assumption):  
  - 200 ppm drift = 6 ms in 30 seconds  
  - Or 17 seconds in 24 hours

#### 🔁 2. Clock Jumps
- If time is **too far off**, NTP may:
  - Refuse to sync
  - Forcefully reset the clock (→ time jumps forward/backward)

#### 🚫 3. NTP Connectivity
- Firewalls or misconfigs may **block NTP**
- Systems silently desync

#### 🌐 4. Network Delay
- Limits NTP precision
- Best-case error: ~35 ms  
- Spikes: ~1 second

#### ❌ 5. Misconfigured NTP Servers
- Some report time **off by hours**
- Clients use **multiple servers** and discard outliers, but risk remains

#### 🧨 6. Leap Seconds
- Cause 61- or 59-second minutes
- Can crash systems unaware of leap seconds
- ✅ **Mitigation:** NTP **smearing** (e.g., Google)

#### 💻 7. Virtual Machines
- Clocks are **virtualized**
- VMs paused → clock **jumps forward**

#### 📱 8. User-Tweaked Clocks
- Mobile/embedded users may set wrong time
- Apps relying on system clock can be misled

---

### 🏛 High-Precision Timing (Example: Finance)

#### MiFID II Regulation
- Requires time sync **within 100 microseconds of UTC**
- Used to detect **flash crashes**, market manipulation

#### How It's Achieved:
- **GPS receivers**
- **PTP (Precision Time Protocol)**
- Careful deployment and monitoring

---

### 🔍 Takeaways

| Risk                          | Impact                       | Mitigation Strategy                      |
|------------------------------|------------------------------|-------------------------------------------|
| Clock drift                  | Gradual time inaccuracy      | Frequent sync, PTP                        |
| Time jumps                   | Logic errors, data issues    | Use monotonic clocks for durations        |
| Leap seconds                 | Crashes, bugs                | NTP smearing, avoid naive assumptions     |
| VM time anomalies            | False durations              | Guest-host time sync                      |
| Misconfigured NTP            | Wrong timestamps             | Monitor NTP status                        |
| User-modified clocks         | Data integrity issues        | Validate time or avoid reliance           |

---

> ✅ **Monotonic clocks** for durations.  
> ⚠️ **Time-of-day clocks** need careful management and monitoring.

