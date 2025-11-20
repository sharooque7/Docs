# Sort Order in Column-Oriented Storage

## Default Storage Approach
- Rows can be stored in insertion order (simplest approach)
  - New rows are simply appended to column files
- Alternatively, can impose a specific order for optimization

## Key Considerations for Sorting

⚠️ **Critical Constraint**:  
Cannot sort columns independently - must maintain row alignment:
- The kth item in one column must correspond to the kth item in other columns
- Entire rows must be sorted together, despite columnar storage

## Sorting Strategy
- Database administrator selects sort columns based on query patterns
- Example: For date-range queries, sort by `date_key` first
  - Enables scanning only relevant date ranges
- Secondary sort columns break ties in primary sort
  - Example: After `date_key`, sort by `product_sk`
  - Groups all sales for same product on same day together

## Compression Benefits
- Primary sort column with few distinct values shows:
  - Long sequences of repeated values
  - Excellent compression via run-length encoding
- Compression effectiveness decreases for lower-priority sort columns
  - Secondary columns: More value variation → shorter runs
  - Tertiary+ columns: Nearly random order → minimal compression

## Advanced Technique: Multiple Sort Orders
*(Introduced in C-Store, adopted by Vertica)*

### Concept:
- Store multiple copies of data with different sort orders
- Query processor selects the optimally-sorted version

### Advantages:
- Different queries benefit from different sort orders
- Complements natural data replication requirements
- More efficient than secondary indexes in row stores:
  - No pointer chasing (direct column values)
  - Each copy is a complete, independently-sorted dataset

### Comparison to Row Stores:
| Feature          | Column Store (Multiple Sorts) | Row Store (Secondary Indexes) |
|------------------|-------------------------------|-------------------------------|
| Data organization | Complete copies in different orders | Single copy + index pointers |
| Query efficiency | Direct access to optimal layout | Pointer lookups required |
| Storage overhead | Higher (full copies) | Lower (just indexes) |