# Dataflow Through Services: REST and RPC

## Service-Oriented Architectures

### Core Concepts
- **Servers**: Expose APIs over network
- **Clients**: Connect to servers to make requests
- **Evolution Requirement**: Services must be independently deployable and evolvable

### Common Patterns
1. **Web Applications**:
   - Browser ↔ Web server (HTML/CSS/JS)
   - AJAX requests (JSON/XML)

2. **Microservices**:
   - Service-to-service communication
   - Often within same datacenter

3. **Public APIs**:
   - Cross-organization integration
   - Payment processors, OAuth, etc.

## Web Service Approaches

### RESTful APIs
| Characteristics | Benefits | Challenges |
|----------------|----------|------------|
| HTTP principles | Simple | No strict standards |
| Resource-oriented | Good caching | Documentation needed |
| JSON/XML payloads | Tooling ecosystem | Versioning approaches vary |

### SOAP APIs
| Characteristics | Issues |
|----------------|--------|
| XML-based protocol | Complex WS-* standards |
| WSDL contracts | Poor cross-vendor compatibility |
| IDE integration | Heavyweight |

## Remote Procedure Calls (RPC)

### Fundamental Problems
1. **Network vs Local Differences**:
   - Latency variability
   - Timeouts and retries
   - Partial failures
   - Memory references impossible

2. **Language Interop Challenges**:
   - Type system mismatches
   - Large object serialization
   - Number precision issues

### Modern RPC Solutions
| Framework | Encoding | Features |
|-----------|----------|----------|
| gRPC | Protocol Buffers | Streaming, multi-language |
| Thrift RPC | Thrift | Cross-language |
| Finagle | Thrift | Futures, resilience |
| Rest.li | JSON | LinkedIn's approach |

## Compatibility Considerations

### Evolution Requirements
- **Backward Compatibility**: Old clients → new servers
- **Forward Compatibility**: New clients → old servers

### Versioning Strategies
1. **URL Versioning**:
   - `api/v2/resource`
   - Simple but breaks URLs

2. **Header Versioning**:
   - `Accept: application/vnd.myapi.v2+json`
   - Cleaner but less visible

3. **Client Configuration**:
   - API keys with version preferences
   - Server-side version selection

## Practical Recommendations

### When to Use REST
- Public-facing APIs
- Web/mobile clients
- When human readability matters
- Leveraging HTTP infrastructure

### When to Use RPC
- Internal services
- Performance-critical paths
- Strong typing requirements
- Complex interaction patterns

### General Best Practices
1. Assume network calls will fail
2. Design for idempotency
3. Use timeouts and retries
4. Monitor client/server version skew
5. Document compatibility guarantees