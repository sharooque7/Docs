You're summarizing **B+ Trees** **very well**, and your intuition is absolutely correct.  
Let’s break this down cleanly so it's even sharper in your mind:

---

✅ **1. Internal nodes store only keys (not values)**  
- Root and all internal nodes **store just keys** (and child pointers), **no data values**.  
- **Root is an internal node** too (you are right — sometimes people distinguish it, but for practical purposes, it's "internal").

✅ **2. Leaf nodes store keys + data pointers (or the actual data)**  
- **Only leaf nodes** have the **actual values** (or pointers to them).
- This means **internal nodes are smaller** → fit **more keys per page** → **shallower tree** → **faster traversal**.

✅ **3. Linked Leaf Nodes (Crucial!)**  
- Leaf nodes are **doubly (sometimes singly) linked**.
- So once you find the starting key, **range queries** (like `WHERE id BETWEEN 4 AND 9`) are **super fast** — just follow the next leaf pointers without climbing back up the tree.

✅ **4. Duplicated keys**  
- Some keys **appear in internal nodes and leaf nodes**. That's okay.
- Internal keys act as **routing guides**, leaves have **real data**.
- The duplication is minimal compared to the huge performance benefit.

✅ **5. Page IO Efficiency**  
- In a real database, one page (say 4KB or 8KB) holds **many keys** (hundreds or even thousands depending on key size).
- **One page read (1 I/O)** brings **lots of keys**, so searching or scanning is very efficient.
- Your comment about the small example (one key per node) being unrealistic in databases is spot-on.

✅ **6. Finding a range (example you gave — 4 to 9)**  
- Search for `4` → land at the right leaf node (1 IO).
- Then **keep walking right** via leaf links to get 5, 6, 7, 8, 9.
- Likely **all in the same leaf page**, or at worst, adjacent pages — still **extremely efficient**.

---

### Tiny Diagram Summary:

```
[internal nodes: keys only]
        [5]
       /   \
   [3]       [7,9]
  /   \     /   | \
[1,2] [4,5] [6,7] [8,9,10]
(leaf nodes: keys + values, linked to each other)
```

- Internal node `[5]` tells you if key < 5, go left; else right.
- Leaf nodes like `[1,2]`, `[4,5]`, etc., are linked together.
- After finding `4`, you can read `5`, `6`, `7`, etc., by following the leaf links.

---

### One Last Note:
When people say "B-Tree" in databases like MySQL (InnoDB), PostgreSQL, etc., **they really mean B+Tree** most of the time.  
**Pure B-Trees** (where both keys and values are in every node) are very rare in modern database indexes.

---

**Summary in your own style:**  
🌟 Internal nodes = thin & sexy = only keys.  
🌟 Leafs = fat & juicy = keys + data + linked.  
🌟 1 IO = hundreds of keys = super speed.  
🌟 Range queries = butter smooth sliding over linked leaves.

---

Would you also like a quick example showing an **actual disk page layout** (like how a real database page in B+Tree looks internally)? 🚀  
It can make it even more "real-world" for you!