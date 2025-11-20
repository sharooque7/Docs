# Dataflow Through Databases

## Core Concepts

### Encoding/Decoding in Databases
- **Writer**: Encodes data when writing to database  
- **Reader**: Decodes data when reading from database  
- **Self-messaging**: Writing to DB = sending message to future self

### Compatibility Requirements
| Compatibility Type | Necessity | Example Scenario |
|--------------------|-----------|------------------|
| Backward | Required | New code reading old data |
| Forward | Often required | Old code reading new data |

## Multi-Process Database Access

### Common Patterns
- Multiple services/applications accessing same DB
- Rolling upgrades with mixed versions
- Parallel instances for scalability

### Key Challenge
- **Cross-version reads/writes**:  
  New data written by v2 → read by v1 → modified by v1 → must preserve v2 fields

### Solution Approaches
1. **Field Preservation**:  
   - Encoding formats should maintain unknown fields  
   - Application logic must avoid dropping unrecognized fields  
   - Example danger: ORM frameworks that re-encode entire objects

2. **Schema Evolution**:  
   - Add new columns with null defaults in SQL  
   - Use schema-compatible formats (Avro/Protobuf) for document stores

## Data Longevity Considerations

### The Data-Code Relationship
- **"Data outlives code" principle**:  
  - Application code may be replaced in minutes  
  - Database contents may persist for years  
  - Must support reading historical encodings

### Schema Migration Strategies
| Strategy | Pros | Cons | Best For |
|----------|------|------|----------|
| On-write migration | Clean schema | Expensive | Small datasets |
| On-read migration | No downtime | Complex logic | Large datasets |
| Never migrate | Simple | Messy schema | Archival data |

## Archival Storage

### Characteristics
- Point-in-time snapshots
- Immutable once written
- Often used for:
  - Backups
  - Data warehouses
  - Analytics

### Recommended Formats
1. **Avro Object Container Files**:
   - Embed schema version
   - Compact binary format
   - Good for row-oriented data

2. **Parquet**:
   - Column-oriented storage
   - Efficient compression
   - Ideal for analytics

### Implementation Benefits
- Single consistent schema for entire snapshot
- Opportunity to optimize storage format
- Separation from operational DB concerns