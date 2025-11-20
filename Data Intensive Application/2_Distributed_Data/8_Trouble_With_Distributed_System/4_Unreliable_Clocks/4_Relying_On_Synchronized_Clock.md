# Relying on Synchronized Clocks

Clocks may appear simple, but they are riddled with challenges:

- A day isn't always exactly 86,400 seconds.
- Clocks can go backwards.
- Clock drift between nodes can cause issues.

Just like we assume networks will occasionally fail and design fault-tolerant software accordingly, **software must also be resilient to faulty clocks**.

## The Hidden Danger of Clock Drift

Unlike a broken CPU or misconfigured network that fails obviously, a misconfigured NTP client or faulty quartz clock often goes unnoticed—until silent, subtle data loss occurs.

Thus, **if software depends on synchronized clocks**, it’s essential to **monitor clock offsets between machines**. Machines with excessive clock drift should be **marked as dead and removed from the cluster**.

---

## Timestamps for Ordering Events

### Example: Multi-Leader Replication

Suppose:

1. Client A writes `x = 1` on Node 1.
2. This is replicated to Node 3.
3. Client B then increments `x` to `2` on Node 3.
4. Both writes propagate to Node 2.

Due to small timestamp differences (e.g., 42.004s vs. 42.003s), Node 2 may **discard the more recent write** (`x = 2`) if it uses **Last Write Wins (LWW)** conflict resolution.

### Problems with LWW:

- **Silent data loss** due to clock skew.
- Can't distinguish **causal vs. concurrent writes**.
- Identical timestamps may require arbitrary tiebreakers, which break causality.

Even tightly synchronized NTP clocks can fail: A message sent at 100ms may **arrive at 99ms** on the recipient node.

---

## Logical vs Physical Clocks

- **Physical clocks** (time-of-day, monotonic) measure actual time but suffer from drift.
- **Logical clocks** use counters to track **event order**, not real time.

Use logical clocks (like **version vectors**) when event ordering matters.

---

## Clock Readings Have Confidence Intervals

Even if your clock has nanosecond resolution, its **actual accuracy** could be **± tens or hundreds of milliseconds**.

### Confidence Intervals

Think of time readings as ranges:
- _"The current time is likely between 10.3s and 10.5s past the minute."_

Accuracy depends on:
- Sync interval.
- Clock drift since last sync.
- NTP server accuracy.
- Network round-trip time.

Most systems **don’t expose this uncertainty**. For example, `clock_gettime()` returns no error margin.

### Exception: Google's TrueTime

Spanner uses **TrueTime API**, which returns:
- `earliest` and `latest` values
- Ensures transaction timestamps reflect **causal order** within known uncertainty bounds.

---

## Synchronized Clocks for Global Snapshots

### Snapshot Isolation in Distributed Databases

- Snapshot isolation allows read-only transactions to **see a consistent state**.
- Needs a **monotonically increasing transaction ID**.
- In distributed systems, generating such IDs **requires coordination**.

### Can Timestamps Help?

Using synchronized timestamps might help, but:

- NTP and physical clocks can't provide **strong enough guarantees**.
- Drift and uncertainty make this fragile.

### Spanner’s Solution

- Uses **TrueTime**.
- Timestamps include a **confidence interval**.
- Ensures snapshot consistency **despite clock uncertainties**.

---

> Summary: **Don’t rely on physical clocks for correctness in distributed systems**. Use logical clocks or design mechanisms that tolerate uncertainty, like Google Spanner’s use of TrueTime.

