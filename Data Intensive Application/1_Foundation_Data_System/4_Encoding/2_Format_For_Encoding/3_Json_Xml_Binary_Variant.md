# JSON, XML, and Binary Encoding Variants

## Text-Based Encoding Formats

### Common Options
- **JSON** (JavaScript Object Notation)
- **XML** (eXtensible Markup Language)
- **CSV** (Comma-Separated Values)

| Format | Pros | Cons |
|--------|------|------|
| JSON | Browser-native, simple syntax | Limited number precision, no binary support |
| XML | Strong schema support, extensible | Verbose, complex spec |
| CSV | Simple, spreadsheet-friendly | No schema, ambiguous parsing |

### Key Limitations

1. **Number Representation Issues**:
   - No clear distinction between numbers and numeric strings
   - JSON lacks integer vs float distinction
   - Large numbers (>2⁵³) lose precision in JavaScript
   - *Example*: Twitter's dual-format tweet IDs

2. **Binary Data Handling**:
   - No native binary string support
   - Requires Base64 encoding (33% size overhead)
   - Schema needed to indicate encoding type

3. **Schema Challenges**:
   - XML schemas (XSD) are powerful but complex
   - JSON schemas often unused
   - CSV has no schema support at all

## Binary Encoding Alternatives

### Why Use Binary Formats?
- Significant space savings (especially at scale)
- Faster parsing performance
- Better type system support

### Binary JSON Variants
- **MessagePack** (shown in example)
- BSON, BJSON, UBJSON, Smile
- Typically 20-30% smaller than textual JSON

### Binary XML Variants
- WBXML
- Fast Infoset

### MessagePack Example
**Original JSON (81 bytes)**:
```json
{"userName":"Martin","favoriteNumber":1337,"interests":["daydreaming","hacking"]}
```

# MessagePack Binary Encoding Analysis

## MessagePack Encoding (66 bytes):
```
83 a8 75 73 65 72 4e 61 6d 65 a6 4d 61 72 74 69 6e 
aa 66 61 76 6f 72 69 74 65 4e 75 6d 62 65 72 cd 05 
39 a9 69 6e 74 65 72 65 73 74 73 92 ab 64 61 79 64 
72 65 61 6d 69 6e 67 a7 68 61 63 6b 69 6e 67
```

## Encoding Breakdown:
1. `0x83` - Object with 3 fields
2. `0xa8` - 8-byte string field name ("userName")
3. `0xa6` - 6-byte string value ("Martin")
4. Subsequent fields similarly encoded

## Evaluation of Binary JSON/XML

### Advantages
* More compact than text formats
* Faster parsing
* Additional type support possible

### Disadvantages
* Minimal space savings (~15-30%)
* Lose human-readability
* Less ecosystem support than text formats
* Still carry field name overhead

**Key Insight**: For substantial improvements, we need schema-driven binary formats (covered next section) that can achieve 50%+ space reduction.