# Unreliable Networks

As discussed in the introduction to Part II, the distributed systems we focus on in this book are **shared-nothing systems**: i.e., a bunch of machines connected by a network.

- The network is the **only way** those machines can communicate.
- Each machine has its **own memory and disk**.
- One machine **cannot access another** machine’s memory or disk (except via network requests).

### Why Shared-Nothing?

While not the only system architecture, shared-nothing has become the **dominant approach** for internet services because:

- 🧾 **Cost-effective** — Uses commodity hardware, no special equipment needed.
- ☁️ **Cloud-ready** — Easily deployable on cloud infrastructure.
- 🛡️ **Highly reliable** — Achieved via redundancy across multiple, geographically distributed datacenters.

---

## Asynchronous Packet Networks

Most modern networks, including the Internet and internal datacenter networks (often Ethernet), are **asynchronous packet networks**.

In such a network:

- A node sends a message (packet) to another node.
- The network **does not guarantee**:
  - **When** it will arrive.
  - **If** it will arrive at all.

---

## Possible Failures When Sending a Request

If you send a request and expect a response, many things could go wrong:

1. 🚫 The **request was lost**  
   *(e.g., someone unplugged a network cable).*

2. ⏳ The request is **delayed in a queue**  
   *(e.g., due to network congestion or recipient overload).*

3. 💥 The **remote node failed**  
   *(e.g., crashed or powered down).*

4. 💤 The **remote node paused temporarily**  
   *(e.g., due to long garbage collection pauses).*

5. 🛑 The **remote node processed the request**, but the **response was lost**  
   *(e.g., due to a misconfigured switch).*

6. 🐢 The **response was delayed**  
   *(e.g., your machine or the network is overloaded).*

---

> ⚠️ **Figure 8-1 Insight**  
If you don’t receive a response, it’s impossible to know whether:
- (a) the request was lost,
- (b) the remote node is down,
- (c) or the response was lost.

---

## The Timeout Dilemma

Because of this uncertainty, we rely on **timeouts**:

- ⏱️ If no response is received within a certain time, we **give up** and assume failure.
- But even after a timeout:
  - You still **don’t know** whether the remote node **received** your request.
  - The request may still be **queued and processed later** even though you gave up.

---

