Here’s a **brief, interview-ready explanation of hashing** 👇

---

## What is Hashing?

**Hashing** is a technique to map data of **arbitrary size** (key) to a **fixed-size value** using a **hash function**, enabling **fast data access**.

Example:
Key → Hash Function → Index in array/table

---

## Hash Function

A **hash function**:

* Takes an input key
* Produces an integer (hash code)
* Maps it to an index in a hash table

**Good hash function properties**:

* Deterministic (same input → same output)
* Uniform distribution (avoids clustering)
* Fast computation

---

## Hash Table

A **hash table** is a data structure that stores key-value pairs using hashing.

| Operation | Average Time |
| --------- | ------------ |
| Insert    | O(1)         |
| Search    | O(1)         |
| Delete    | O(1)         |

Worst case: **O(n)** (due to collisions)

---

## Collision

A **collision** occurs when two different keys produce the **same hash index**.

### Collision Handling Techniques

### 1. Chaining

* Store multiple elements at the same index using a **linked list / tree**
* Used in Java `HashMap`

```
Index 2 → [key1 → key2 → key3]
```

**Time**:

* Avg: O(1)
* Worst: O(n)

---

### 2. Open Addressing

Store elements in the table itself by finding another empty slot.

Types:

* **Linear Probing**: `(hash + i) % size`
* **Quadratic Probing**: `(hash + i²) % size`
* **Double Hashing**: second hash function

---

## Load Factor (α)

```
Load Factor = Number of elements / Table size
```

* Controls performance
* Higher load factor → more collisions
* Java HashMap default load factor = **0.75**

---

## Rehashing

When load factor exceeds threshold:

* Create a **bigger table**
* Recompute hash for all keys
* Improves performance but is **expensive**

---

## Hashing vs Searching Structures

| Structure  | Search Time |
| ---------- | ----------- |
| Array      | O(n)        |
| BST        | O(log n)    |
| Hash Table | O(1) avg    |

---

## Real-World Uses

* Database indexing
* Caching (Redis, Memcached)
* Password storage (hashed + salted)
* Symbol tables in compilers
* Distributed systems (consistent hashing)

---

## Key Interview Points

* Hashing gives **O(1)** average performance
* Collisions are unavoidable
* Choice of hash function is critical
* Worst case degrades to **O(n)**

---

