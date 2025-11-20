# Advanced Database Indexing Structures

## Beyond Primary Key Indexes

### Secondary Indexes
- Create with `CREATE INDEX` command in relational databases
- Crucial for performing joins efficiently
- Can be constructed from key-value indexes
- Handle non-unique keys via:
  - Lists of matching row identifiers (posting lists)
  - Making keys unique by appending row identifiers

### Value Storage Approaches
| Approach | Description | Advantages | Disadvantages |
|----------|-------------|------------|---------------|
| **Heap Files** | Store actual data separately from index | Avoids duplication with multiple indexes | Extra lookup hop impacts performance |
| **Clustered Indexes** | Store indexed row directly within index | Faster reads | Uses more storage, complicates writes |
| **Covering Indexes** | Store some columns within index | Can answer some queries from index alone | Requires data duplication |

## Multi-Column Indexing

### Concatenated Indexes
- Combines multiple fields into one key by appending columns
- Order of fields in index definition is critical
- Useful for queries on prefix of indexed columns
- Example: phone book index from (lastname, firstname) to phone number
- Limited: can't efficiently query non-prefix columns alone

### Multi-dimensional Indexes
- Support simultaneous range queries on multiple dimensions
- Important for geospatial data (latitude/longitude)
- Implementation approaches:
  - Space-filling curves with B-trees
  - R-trees (used by PostGIS)
  - Specialized indexes like HyperDex
- Applications beyond geography:
  - Product searches (color dimensions RGB)
  - Weather data (date, temperature)
  - Any multi-attribute range filtering

## Specialized Indexes

### Full-text Search and Fuzzy Indexes
- Allow searching for similar keys and misspelled words
- Features:
  - Synonym expansion
  - Grammatical variations
  - Proximity searches
  - Edit distance tolerance
- Techniques:
  - Levenshtein automata
  - Finite state automata over characters
  - SSTable-like structures with in-memory indexes

## In-Memory Databases

### Characteristics
- Keep entire dataset in RAM
- Potentially distributed across machines
- Durability approaches:
  - Special hardware (battery-powered RAM)
  - Write-ahead logs to disk
  - Periodic snapshots
  - Replication to other machines

### Performance Benefits
- Not primarily from avoiding disk reads
- Mainly from avoiding encoding/decoding overhead
- Can implement data models difficult with disk-based indexes

### Notable Examples
- VoltDB, MemSQL, Oracle TimesTen (relational)
- RAMCloud (key-value with log-structured approach)
- Redis, Couchbase (weak durability)

### Recent Developments
- Anti-caching: evict least recently used data to disk
- More efficient than OS virtual memory (record vs page granularity)
- Research into non-volatile memory (NVM) technologies