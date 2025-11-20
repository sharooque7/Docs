# Understanding Faults in Distributed Systems

## 🌩️ Theme of Failure in Systems

- Throughout previous chapters, a recurring theme has been **how systems deal with failure**.
- Topics already discussed:
  - **Replica Failover** – how systems handle node outages.
  - **Replication Lag** – the challenges of data replication delays.
  - **Concurrency Control in Transactions** – especially under weak isolation levels.

> As we uncover more edge cases in real systems, our ability to handle them improves.

---

## ⚠️ A More Realistic View: Embracing Pessimism

- Despite many discussions on fault tolerance, the outlook has still been **too optimistic**.
- The new mindset:  
  > **"Anything that can go wrong, will go wrong."**

- **Experienced systems operators**:
  - Know this pessimism is justified.
  - Often share **frightening stories** from past failures.

---

## 💻 Distributed Systems ≠ Single Machine Programming

- Key difference:  
  > **Many more unique and unpredictable failure modes.**

- This chapter provides:
  - A **realistic view of practical problems** in distributed systems.
  - Insight into **what can and cannot be relied upon**.

---

## 🛠️ The Engineer’s Mission

> **Build reliable systems that meet user expectations – even in the face of failure.**

- Next (Chapter 9):  
  - Discussion of **algorithms that offer strong guarantees** in distributed systems.
- First (this chapter):  
  - Understand the **challenges** and **failures** we must overcome.

---

## 🧱 This Chapter: A Tour of Failure Modes

1. **Unreliable Networks** (Page 277)  
   - How and why networks can fail.
   
2. **Unreliable Clocks** (Page 287)  
   - Problems due to clock skew, synchronization issues.
   
3. **Reasoning About System State**  
   - Chapter: *Knowledge, Truth, and Lies* (Page 300)  
   - Understanding what has really happened in the system.

> ⚠️ Warning: This chapter is **pessimistic and unsettling**, but crucial for building resilient systems.

---
