# Apache Avro

## Schema Definition

### Avro IDL (Human-readable)
```avro
record Person {
  string userName;
  union { null, long } favoriteNumber = null;
  array<string> interests;
}
```

### JSON Schema (Machine-readable)
```json
{
  "type": "record",
  "name": "Person",
  "fields": [
    {"name": "userName", "type": "string"},
    {"name": "favoriteNumber", "type": ["null", "long"], "default": null},
    {"name": "interests", "type": {"type": "array", "items": "string"}}
  ]
}
```

## Key Characteristics

### Schema Evolution Approach
* **No field tags** (uses field names for identification)
* **Writer's schema** vs **Reader's schema** paradigm
* Schema resolution happens during decoding

### Encoding Features
* Extremely compact (32 bytes for example record)
* Values concatenated without type markers
* Field identification purely by schema position
* Variable-length integer encoding

## Schema Resolution Mechanics

### Field Matching Rules
1. Fields matched by name (order irrelevant)
2. Missing writer fields → reader uses default
3. Extra writer fields → ignored by reader

### Evolution Compatibility Table

| **Change** | **Forward Compatible** | **Backward Compatible** |
|------------|------------------------|-------------------------|
| Add field with default | Yes | Yes |
| Add field without default | Yes | No |
| Remove field with default | Yes | Yes |
| Remove field without default | No | Yes |
| Rename field (with alias) | No | Yes |
| Change field type (convertible) | Sometimes | Sometimes |

## Schema Distribution Methods

### Storage Contexts
1. **Large files**:
   * Schema stored once in file header
   * Avro Object Container File format
2. **Databases**:
   * Version number per record
   * Schema registry service
3. **Network RPC**:
   * Schema negotiated on connection
   * Fixed for connection lifetime

## Advantages Over Thrift/Protocol Buffers

### Dynamic Schema Support
* No manual tag management
* Automatic schema generation from:
   * Database schemas
   * JSON structures
   * Other data sources

### Language Flexibility
* Optional code generation
* Native support in dynamic languages
* Self-describing data files

### Hadoop Ecosystem Integration
* Native support in Pig, Hive, etc.
* Schema evolution during ETL
* Efficient columnar storage (Parquet)

## Default Values and Nullability

### Special Handling
* Must explicitly declare null in unions
* Default values required for added fields
* No implicit nullability (unlike Protobuf/Thrift)

## Practical Considerations

### When to Choose Avro
* Hadoop/Spark ecosystems
* Dynamic schema environments
* When schema evolution is critical
* For self-describing data files

### Performance Notes
* Slightly slower than Thrift/Protobuf
* Schema resolution adds overhead
* Tradeoff for flexibility