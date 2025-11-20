# Simple Database Implementation & Indexing Fundamentals

## Basic Key-Value Store Example
```bash
#!/bin/bash
db_set () {
  echo "$1,$2" >> database  # Appends key-value pair
}

db_get () {
  grep "^$1," database | sed -e "s/^$1,//" | tail -n 1  # Finds last occurrence
}
```

## Characteristics
* **Write Operation**:
   * Extremely efficient (O(1) append-only)
   * No overwrites - creates multiple versions
   * Similar to real database logs/WAL
* **Read Operation**:
   * Inefficient O(n) full scan
   * Must check all entries for key
   * `tail -n 1` gets most recent version

## Core Concepts

### Append-Only Log Benefits
1. **Write Performance**: Appending is fastest possible disk operation
2. **Durability**: Completed writes are preserved
3. **Crash Recovery**: Simple to recover (no partial updates)
4. **Audit Trail**: Natural version history maintained

### The Indexing Tradeoff
| | **With Index** | **Without Index** |
|------------------|-----------------|-------------------|
| **Read Speed** | Fast (O(1) or O(log n)) | Slow (O(n)) |
| **Write Speed** | Slower (must update index) | Fastest possible |
| **Storage Overhead** | Additional space required | Minimal |

## Index Fundamentals
* **Purpose**: Additional metadata structure for faster lookups
* **Key Properties**:
   * Derived from primary data
   * Optional (can add/remove without affecting data)
   * Impacts performance but not functionality
* **Maintenance Cost**:
   * Slows down writes
   * Requires additional storage
   * Needs careful selection based on query patterns

## Real-World Implications
1. **Database Design**:
   * Default indexes (usually just primary key)
   * Additional indexes added based on query needs
   * Often limited to ~5-10 indexes per table
2. **Storage Engine Types**:
   * **Log-structured**: Optimized for writes (LSM trees)
   * **Page-oriented**: Balanced read/write (B-trees)
3. **Version Retention**:
   * Some databases keep history (like our example)
   * Others overwrite values (space efficiency)

## Key takeaways:
1. The simple example demonstrates fundamental database operations
2. Shows why real databases need indexes despite write costs
3. Illustrates the core performance tradeoffs in storage systems
4. Highlights why index selection is a critical design decision