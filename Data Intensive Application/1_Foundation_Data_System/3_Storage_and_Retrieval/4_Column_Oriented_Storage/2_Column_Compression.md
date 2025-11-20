# Column Compression in Column-Oriented Storage

Column-oriented storage systems achieve significant performance advantages through compression techniques tailored to their data layout.

## Why Column Compression Works Well

- Column storage naturally creates sequences of values that are often repetitive  
- This repetition makes them highly compressible  
- Different compression techniques can be applied based on each column's data characteristics  

## Bitmap Encoding

### Key Characteristics
- Particularly effective when columns have few distinct values relative to row count (e.g., 100,000 products across billions of sales)  

### Technique:
1. Create one bitmap per distinct value  
2. Each bitmap has one bit per row:
   - `1` if row has that value  
   - `0` otherwise  

### Storage Optimization:
- **Low cardinality** (e.g., 200 countries): Store directly as one bit per row  
- **High cardinality/Sparse data**: Apply run-length encoding to further compress  

## Query Efficiency with Bitmap Indexes

| Query Type | Example | Bitmap Operation |
|------------|---------|------------------|
| OR | `WHERE product_sk IN (30, 68, 69)` | Bitwise OR of three bitmaps |
| AND | `WHERE product_sk = 31 AND store_sk = 3` | Bitwise AND of two bitmaps |

*Note*: Operations work efficiently because columns maintain consistent row order across bitmaps.

## Performance Benefits

### Memory Bandwidth
- Compression reduces data volume transferred from disk  

### CPU Efficiency
- Columnar data fits better in CPU caches (L1/L2)  
- Enables tight loops without function calls  
- Supports vectorized processing using SIMD instructions  
- Operators work directly on compressed data  

## Important Distinction: Column Families

⚠️ **Note on Cassandra/HBase**:  
- Use "column families" terminology but aren't truly column-oriented  
- Actually store all columns of a row together  
- Don't use column compression techniques  
- Their model remains fundamentally row-oriented  

> This approach is particularly valuable for analytical workloads scanning millions of rows, where both disk I/O and CPU efficiency are critical bottlenecks.