# Data Encoding and Flow Patterns

## Core Concept Recap
- **Encoding**: Converting in-memory data to byte sequences for transfer/storage
- **Decoding**: Reconstructing data from bytes to memory representation
- **Compatibility**:
  - *Backward*: New code reads old data
  - *Forward*: Old code reads new data

## Data Flow Architectures

### 1. Dataflow Through Databases
**Characteristics**:
- Writers encode, readers decode
- Multiple versions may coexist
- Long-lived data requires special consideration

**Evolution Challenges**:
- Migrating legacy data
- Handling mixed schema versions
- Index compatibility

### 2. Dataflow Through Services (REST/RPC)
**Characteristics**:
- Client-server interaction model
- APIs as compatibility boundary
- Common patterns:
  - RESTful HTTP
  - RPC frameworks

**Evolution Considerations**:
- API versioning strategies
- Parameter handling
- Error response formats

### 3. Message-Passing Dataflow
**Characteristics**:
- Asynchronous communication
- Message brokers as intermediaries
- Processing pipelines

**Evolution Aspects**:
- Message format compatibility
- Queue schema evolution
- Consumer upgrade coordination

## Comparison of Dataflow Patterns

| Pattern | Latency | Coupling | Scale | Evolution Complexity |
|---------|---------|----------|-------|----------------------|
| Database | Medium | Tight | High | High (data longevity) |
| Services | Low-Medium | Loose | Medium | Medium |
| Messages | High | Loose | High | Low-Medium |

## Implementation Guidelines

1. **Database Flow**:
   - Prefer append-only models
   - Consider schema migration tools
   - Plan for long-term data compatibility

2. **Service Flow**:
   - Design versioning from start
   - Use schema-driven formats
   - Document compatibility windows

3. **Message Flow**:
   - Define clear message schemas
   - Use dead-letter queues for invalid messages
   - Monitor consumer lag during upgrades

> **Key Principle**: Choose dataflow pattern based on system requirements, not convenience. Consider evolution needs from day one.