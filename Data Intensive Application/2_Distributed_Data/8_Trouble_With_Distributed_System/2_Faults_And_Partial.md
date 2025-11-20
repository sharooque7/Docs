# Faults and Partial Failures

When you are writing a program on a single computer, it normally behaves in a fairly predictable way: either it works or it doesn’t. Buggy software may give the appearance that the computer is sometimes “having a bad day” (a problem that is often fixed by a reboot), but that is mostly just a consequence of badly written software.

There is no fundamental reason why software on a single computer should be flaky: when the hardware is working correctly, the same operation always produces the same result (it is deterministic). If there is a hardware problem (e.g., memory corruption or a loose connector), the consequence is usually a total system failure (e.g., kernel panic, “blue screen of death,” failure to start up). An individual computer with good software is usually either fully functional or entirely broken, but not something in between.

This is a deliberate choice in the design of computers: if an internal fault occurs, we prefer a computer to crash completely rather than returning a wrong result, because wrong results are difficult and confusing to deal with. Thus, computers hide the fuzzy physical reality on which they are implemented and present an idealized system model that operates with mathematical perfection. A CPU instruction always does the same thing; if you write some data to memory or disk, that data remains intact and doesn’t get randomly corrupted. This design goal of always-correct computation goes all the way back to the very first digital computer.

When you are writing software that runs on several computers, connected by a network, the situation is fundamentally different. In distributed systems, we are no longer operating in an idealized system model—we have no choice but to confront the messy reality of the physical world. And in the physical world, a remarkably wide range of things can go wrong, as illustrated by this anecdote:

> In my limited experience I’ve dealt with long-lived network partitions in a single data center (DC), PDU [power distribution unit] failures, switch failures, accidental power cycles of whole racks, whole-DC backbone failures, whole-DC power failures, and a hypoglycemic driver smashing his Ford pickup truck into a DC’s HVAC [heating, ventilation, and air conditioning] system. And I’m not even an ops guy.
> — *Coda Hale*

In a distributed system, there may well be some parts of the system that are broken in some unpredictable way, even though other parts of the system are working fine. This is known as a **partial failure**. The difficulty is that partial failures are **nondeterministic**: if you try to do anything involving multiple nodes and the network, it may sometimes work and sometimes unpredictably fail. As we shall see, you may not even know whether something succeeded or not, as the time it takes for a message to travel across a network is also nondeterministic!

This nondeterminism and possibility of partial failures is what makes distributed systems hard to work with.

---

# Cloud Computing and Supercomputing

There is a spectrum of philosophies on how to build large-scale computing systems:

- **High-performance computing (HPC):** Supercomputers with thousands of CPUs are typically used for computationally intensive scientific computing tasks, such as weather forecasting or molecular dynamics.
- **Cloud computing:** Often associated with multi-tenant datacenters, commodity computers connected with IP networks (often Ethernet), elastic/on-demand resource allocation, and metered billing.
- **Traditional enterprise datacenters** lie somewhere in between.

## Fault Handling in Different Architectures

### Supercomputers:

- Jobs checkpoint computation state to durable storage.
- If a node fails, the entire job may be halted and restarted from the last checkpoint.
- More like a single-node computer than a distributed system.
- Handles partial failure by allowing it to become **total failure**.

### Internet Services (Focus of this book):

- Must be online and responsive to users at all times.
- Downtime for repairs is not acceptable.
- Built from **commodity machines** (cheaper, higher failure rates).
- **IP-based Clos topologies** are common in data centers.
- Components are always failing—systems must tolerate and recover gracefully.

## Benefits of Tolerating Node Failures:

- Enables **rolling upgrades** without downtime.
- Cloud VMs can be restarted easily when underperforming.
- Geographically distributed deployments rely on slow and unreliable internet communication.

To make distributed systems work, we must:

> Build **fault-tolerance mechanisms** into the software and accept **partial failures** as the norm.

Even in small systems, partial failure is possible. Fault handling must be a **core design** principle. Hoping faults are rare is unwise. It’s important to:

- Think through a wide range of possible faults
- **Test** systems under artificial failure conditions
- Adopt **pessimism** as a defensive programming mindset

---

# Building a Reliable System from Unreliable Components

Is this even possible? Surprisingly, yes!

It is a well-known principle to build a **more reliable system** on top of an **unreliable base**:

### Examples:

- **Error-correcting codes**: Deal with bit errors in data transmission.
- **IP (Internet Protocol)**: Unreliable—can drop, delay, duplicate, or reorder packets.
- **TCP (Transmission Control Protocol)**: Adds reliability by retransmitting, reordering, and de-duplicating.

Although these layers are more reliable, they are **not perfect**. For instance:

- Error-correcting codes can't fix large-scale interference.
- TCP can't eliminate latency—it just hides lower-level faults.

Still, **higher-level protocols make reasoning easier** by abstracting away many low-level issues.

We will explore these ideas further in *"The End-to-End Argument."*

---

