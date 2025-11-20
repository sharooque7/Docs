# Thrift and Protocol Buffers

## Schema-Based Binary Encoding

### Core Characteristics
- Require schema definitions for data structures
- Generate code for multiple programming languages
- Focus on compact binary representations
- Designed for efficient cross-language communication

## Schema Definition Examples

### Thrift IDL
```thrift
struct Person {
  1: required string userName,
  2: optional i64 favoriteNumber,
  3: optional list<string> interests
}
```

### Protocol Buffers
```protobuf
message Person {
  required string user_name = 1;
  optional int64 favorite_number = 2;
  repeated string interests = 3;
}
```

## Encoding Formats Comparison

### Thrift BinaryProtocol (59 bytes)
* Explicit type annotations
* Length indicators for variable-length fields
* Field tags instead of names
* ASCII/UTF-8 string encoding

### Thrift CompactProtocol (34 bytes)
* Packed field type + tag in single byte
* Variable-length integers
* More efficient packing than BinaryProtocol

### Protocol Buffers (33 bytes)
* Similar to CompactProtocol
* Slightly different packing approach
* `repeated` marker instead of explicit list type

## Schema Evolution Mechanics

### Field Tag Rules
* Never change a field's tag number
* Can rename fields safely (tags identify fields)
* New fields must get new tag numbers

### Compatibility Guidelines
| **Change** | **Backward Compatible** | **Forward Compatible** |
|------------|------------------------|------------------------|
| Add optional field | Yes | Yes |
| Add required field | No | Yes |
| Remove optional field | Yes | No |
| Remove required field | Never allowed | Never allowed |
| Change field type | Sometimes* | Sometimes* |

*Type changes possible but risk precision loss/truncation

### Protocol Buffers Special Case
* `optional` → `repeated` conversion supported
* Old code sees last element, new code sees list
* More flexible than Thrift's explicit list type

## Key Advantages Over JSON/XML

1. **Size Efficiency**:
   * 50%+ smaller than text formats
   * Compact binary representation
   * No field names in encoded data

2. **Performance**:
   * Faster parsing
   * Lower CPU/memory overhead

3. **Type Safety**:
   * Clear numeric types
   * Schema validation
   * Better handling of large numbers

4. **Evolution Support**:
   * Built-in versioning through field tags
   * Clean compatibility rules

## Implementation Considerations
* **Required Fields**:
   * Enable runtime validation
   * Limit schema evolution flexibility
* **Default Values**:
   * Important for added fields
   * Maintain backward compatibility
* **Nested Structures**:
   * Thrift supports nested lists
   * Protocol Buffers uses message nesting