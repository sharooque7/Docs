Here's a summary of the **Multiprocessor Scheduling Algorithms and Load Balancing** explained in the video:

---

### 🔹 **1. Dedicated Scheduler CPU (Centralized Scheduling)**
- One CPU is dedicated to scheduling tasks for all other CPUs.
- Maintains a **local ready queue**.
- **Pros**: Simple to implement.
- **Cons**:
  - All CPUs wait for this scheduler → **performance bottleneck**.
  - Doesn’t scale well due to centralized control.

---

### 🔹 **2. Symmetrical Multiprocessing (SMP) Scheduling**
Each CPU runs its **own scheduler**. Two variants:

#### ➤ **a. Global Queue**
- One **shared ready queue** for all CPUs.
- Each CPU picks from the same queue.

**Pros**:
- Fair process distribution.
- Better CPU utilization.

**Cons**:
- **Concurrency issues**: Multiple CPUs may try to pick the same process.
- Requires **locking**, which causes:
  - Serialization → degrades performance.
  - **Scalability issues** as CPU count increases.
- **Processor Affinity** is harder to implement (can't easily bind a process to a specific CPU).

**Used in**: Linux 2.4, xv6.

---

#### ➤ **b. Per-CPU Queues**
- Each CPU has its **own ready queue**.
- Static partitioning: OS/user assigns processes to a CPU at start.

**Pros**:
- **Scalable** – no locking needed.
- **Locality** – CPU accesses only its own queue → faster decisions.

**Cons**:
- May lead to **load imbalance**: Some CPUs may be overloaded, others underutilized.

---

### 🔹 **3. Hybrid Scheduling**
**Used in**: Linux 2.6 and newer.

- Combines both:
  - **Local queues** for fast local decisions.
  - **Global queue** for load balancing.

#### ➤ **Load Balancing Techniques**:
1. **Push Migration**:
   - A monitoring task redistributes tasks from overloaded to underloaded CPUs.

2. **Pull Migration**:
   - An idle CPU pulls tasks from a busy CPU.

**Note**: **Process migration is costly**:
- Cache and TLB (Translation Lookaside Buffer) must be repopulated.
- Use migration **only when necessary**.

---

### ✅ Final Takeaways:
- **Centralized** scheduling is simple but doesn’t scale.
- **Symmetrical scheduling with local queues** is scalable but risks load imbalance.
- **Hybrid models** offer a balanced tradeoff using both **locality** and **global coordination**.

Let me know if you'd like this as a visual comparison table or if you need help remembering these for an exam or interview.