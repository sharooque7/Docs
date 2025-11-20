# Relational vs Document Data Models

## Historical Context
- **Relational Model**: 
  - Proposed by Edgar Codd (1970)
  - Dominant for 25-30 years
  - Roots in 1960s business data processing

- **Document Model**:
  - Emerged with NoSQL movement (2009+)
  - Inspired by hierarchical models (e.g., IBM IMS)
  - JSON-based implementations (MongoDB, CouchDB)

## Key Differences

| Feature | Relational | Document |
|---------|-----------|----------|
| **Structure** | Tables with rows/columns | Nested documents (JSON/XML) |
| **Schema** | Schema-on-write (strict) | Schema-on-read (flexible) |
| **Relationships** | Foreign keys + joins | References + application-side joins |
| **Locality** | Data split across tables | Entire document stored together |
| **Scalability** | Vertical + complex horizontal | Generally easier horizontal |

## Strengths Comparison

### Relational Advantages
✔ Strong consistency guarantees  
✔ Powerful join operations  
✔ Mature query optimizers  
✔ Better for interconnected data  

### Document Advantages
✔ More natural object mapping  
✔ Schema flexibility (easier evolution)  
✔ Better read performance for whole documents  
✔ Often simpler for hierarchical data  

## Modern Convergence
- **Relational DBs** now support JSON (PostgreSQL, MySQL)
- **Document DBs** adding join-like features (RethinkDB)
- Hybrid approaches emerging (e.g., interleaved tables in Spanner)

## When to Use Which

**Choose Relational When:**
- Complex transactions needed
- Data is highly interconnected
- Strong consistency requirements
- Mature tooling is critical

**Choose Document When:**
- Data is document-shaped (tree structure)
- Schema flexibility is important
- Read performance for whole records is key
- Development speed is prioritized

> "The optimal choice depends on how the data will be queried and updated, not just on its inherent structure."  
> *- Designing Data-Intensive Applications*

## Key Tradeoffs
1. **Impedance Mismatch**: Relational ↔ OOP vs Document ↔ OOP
2. **Schema Flexibility**: Migration costs vs runtime checks
3. **Query Complexity**: Joins vs multiple fetches
4. **Performance**: Optimized access paths vs data locality