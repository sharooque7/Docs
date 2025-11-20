# Network Faults in Practice

Despite decades of development, **networks are still not reliably fault-free**.

> 🛠️ We might expect mature networks to be stable by now — but studies and real-world experiences suggest otherwise.

---

## Real-World Studies & Observations

📊 **Findings from controlled environments like datacenters**:

- A medium-sized datacenter reported:
  - ~12 network faults per month.
  - ~50% affected **a single machine**.
  - ~50% affected **an entire rack**.  
    *[Ref: Study [15]]*

- A separate study examined:
  - **Top-of-rack switches**
  - **Aggregation switches**
  - **Load balancers**

  🔍 It found that:
  - Adding **redundant networking gear** doesn't always prevent failures.
  - **Human errors** (e.g., misconfigured switches) remain a **major source of outages**.  
    *[Ref: Study [16]]*

---

## Cloud vs Private Datacenters

☁️ **Public clouds** (e.g., EC2):
- Frequently experience **transient network glitches**.  
  *[Ref: [14]]*

🏢 **Private datacenters**:
- Tend to be more stable.
- But **not immune** from faults:
  - E.g., switch software upgrades can delay packets **for more than a minute**.  
    *[Ref: [17]]*

🦈 Other surprising issues:
- **Undersea cables bitten by sharks** 🦈  
  *[Ref: [18]]*
- **One-way link failures**:
  - A NIC might drop all **inbound** packets while **outbound** works fine.  
    *[Ref: [19]]*

---

## 📦 Network Partitions

> When a section of a network is **cut off** from the rest due to a fault, it's called a **network partition** (aka **netsplit**).

📘 In this book:
- We'll use the more general term: **network fault**.
- (To avoid confusion with **data partitions/shards** discussed in [Chapter 6]).

---

## Why You Must Plan for Network Faults

Even if faults are rare:

- 🧩 Your software **must handle them**.
- 📉 **All network communication can potentially fail**.
- 🚨 If error handling is undefined or untested:
  - The system could **deadlock**, even after the network recovers.  
    *[Ref: [20]]*
  - It could even **delete all your data**.  
    *[Ref: [21]]*

---

## 🧪 Handling Network Faults

- Handling doesn’t mean tolerating:
  - Sometimes it's okay to **show users an error** if the fault is rare.
- But:
  - You must know **how your software behaves** during faults.
  - You must ensure the system can **recover**.

💡 **Chaos Monkey** is a tool that:
- **Deliberately causes faults** to test recovery.
- (See: *"Reliability"* on page 6)

---

# 🧭 Detecting Faults in Distributed Systems

In distributed systems, **automatically detecting faulty nodes** is essential — but **network uncertainty makes this tricky**.

---

## ⚙️ Why Fault Detection Matters

Examples of systems needing fault detection:

- **Load Balancer**:  
  Must **stop routing requests** to dead nodes (take them out of rotation).
  
- **Single-Leader Replication (Distributed DBs)**:  
  If the leader fails, **a follower must be promoted**.  
  ➡️ See: *“Handling Node Outages” (page 156)*

---

## 🚦 Challenges with Fault Detection

Even if a node is unreachable, it doesn’t mean it has failed — the **network might just be slow or broken**.

But in some specific cases, you can detect failure signals:

---

## ✅ Possible (But Limited) Feedback Mechanisms

### 1. **No Process Listening on Port**
- If OS receives a request but no process is listening:
  - It sends back a **TCP RST or FIN**.
- ❗ Caveat:
  - If the node **crashed mid-request**, you won’t know **how much of the request was processed**.  
    *[Ref: [22]]*

---

### 2. **Crash Notification by Script**
- If a node process crashes but OS stays up:
  - A script can **notify other nodes** quickly.
  - ➡️ Example: **HBase** does this.  
    *[Ref: [23]]*

---

### 3. **Datacenter Switch Link Check**
- If you control the switch:
  - You can **query link status** to detect if a node is **powered off**.
- ❌ Doesn’t work when:
  - Using public internet.
  - In shared datacenters.
  - Management interface is inaccessible due to faults.

---

### 4. **ICMP: Destination Unreachable**
- Routers might reply with **ICMP Destination Unreachable**.
- ❗But routers can’t **magically detect all failures** — they rely on basic networking rules.

---

## 📭 What About Application-Level Confirmation?

- Even if TCP **acknowledges delivery**, the **application might still crash** before handling it.
- ✅ **Only a positive response from the app confirms success**.  
  *[Ref: [24]]*

---

## 🕰️ Timeouts & Retries: The Practical Approach

- Often, you’ll **get no response at all** if something’s wrong.
- What can you do?
  1. Retry a few times.
  2. Wait for a **timeout**.
  3. If still no reply ➡️ **declare node dead**.

📦 TCP handles some retries for you,  
🧠 But your application may need to retry at a higher level too.


# ⏱️ Timeouts and Unbounded Delays

> If timeout is the only reliable way to detect a fault, **how long should it be?**
➡️ There’s no simple answer.

---

## 📉 Timeout Trade-offs

- **Long timeout**  
  ✅ Less risk of false alarms  
  ❌ Users wait longer, might see errors

- **Short timeout**  
  ✅ Faster failure detection  
  ❌ Higher chance of mistakenly declaring a node dead (e.g., due to temporary slowness)

---

## ⚠️ The Danger of Premature Death

Declaring a node dead **too soon** is risky:

- If it’s still alive and **processing** (e.g., sending email), another node might take over → 💥 **duplicate actions**
- Responsibilities shift to other nodes → adds **extra load**
- If slow response is due to **overload**, moving work can worsen things → 📉 _Cascading Failures_

> In extreme cases: All nodes may declare each other dead → system halts

---

## 💭 What If We Had a Perfect World?

Imagine:

- All packets delivered in **≤ d** time or dropped
- Each node processes requests in **≤ r** time

✅ Then, we could set timeout = `2d + r`  
❌ But real-world systems don’t work like that

---

## 🚫 Real Systems Have...

- **Unbounded network delays**
- **No guaranteed processing time**
- Even rare spikes in latency can throw things off!

---

# 📦 Network Congestion & Queueing Delays

Just like **traffic jams** slow down cars 🚗, queues delay packets 📦.

### Sources of Delay:

1. **Switch Congestion**
   - Many senders target the same destination port
   - Switch queues build up → packets wait or get dropped

2. **OS Queueing**
   - CPU cores are busy → OS buffers network requests
   - App handles them **later**

3. **Virtualization Pauses**
   - VM is paused while another VM uses CPU
   - Incoming packets are **buffered** until it resumes

4. **TCP Flow Control (Backpressure)**
   - Limits sending speed to avoid overwhelming receivers
   - Packets get queued at sender before hitting the wire

---

## 🕳️ TCP Packet Loss & Retransmission

- TCP marks packets as lost if not acknowledged **within timeout**
- Retransmits them behind the scenes
- But... the **application still experiences the delay**

---

# 🌐 TCP vs UDP

| Feature        | TCP                      | UDP                              |
|----------------|---------------------------|-----------------------------------|
| Retransmission | ✅ Yes                   | ❌ No                             |
| Flow Control   | ✅ Yes                   | ❌ No                             |
| Delay          | Higher (variable)         | Lower (but less reliable)        |
| Use Case       | General apps, file xfer   | 🎥 Real-time apps (VoIP, video)   |

🧠 _UDP is better where **late data is useless**_ (e.g., VoIP).  
Lost packet = skip it = “Can you repeat that?”

---

## 📊 Wide Delay Variability Factors

- Queues **grow quickly** when system nears capacity
- In **public clouds / shared datacenters**:
  - Network & CPU are shared
  - **Noisy neighbors** (e.g., MapReduce jobs) can spike latency unpredictably

---

# 📏 Choosing Timeout Values

You must tune them **experimentally**:

- Measure round-trip times across many nodes over time
- Study delay distribution (incl. spikes)
- Choose a **trade-off**:
  - Faster detection vs. false positives

---

## 🤖 Smarter Failure Detection: Dynamic Timeouts

- Track real-time response variability (jitter)
- Adjust timeout values **on the fly**
- ✅ Example: **Phi Accrual Failure Detector**
  - Used in **Akka** and **Cassandra**
  - Similar to how TCP adjusts retransmit timeouts
