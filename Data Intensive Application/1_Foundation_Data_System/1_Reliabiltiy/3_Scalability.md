# Scalability in Systems

## Defining Scalability
Scalability describes a system's ability to handle increased load. Key questions:
- How does performance change when load increases?
- How much must resources increase to maintain performance?

## Describing Load
**Load Parameters** (metrics that characterize load):
- Web servers: Requests per second
- Databases: Read/write ratio
- Chat systems: Concurrent active users
- Caches: Hit rate

### Twitter Example (2012 data)
| Operation | Rate |
|-----------|------|
| Post tweet | 4.6k/sec (avg), 12k/sec (peak) |
| Home timeline | 300k/sec |

**Key Challenge**: Fan-out (each tweet delivered to ~75 followers on average, but some users have 30M+ followers)

## Describing Performance
### Metrics:
- **Throughput**: Records processed/sec (batch systems)
- **Response Time**: Client-observed request duration
  - Includes network delays, queueing, and service time
  - Best measured as percentiles (not averages)

### Response Time Percentiles
| Percentile | Meaning | Importance |
|------------|---------|------------|
| p50 (median) | 50% faster, 50% slower | Typical user experience |
| p95 | 95% faster, 5% slower | Most users |
| p99 | 99% faster, 1% slower | High-value users |
| p999 | 99.9% faster, 0.1% slower | Extreme cases |

**Tail latency amplification**: When a request depends on multiple backend calls, the slowest call determines overall response time.

## Coping with Increased Load
### Scaling Approaches:
1. **Vertical Scaling (Scale Up)**
   - Use more powerful machines
   - Simpler but hits cost limits

2. **Horizontal Scaling (Scale Out)**
   - Distribute load across multiple machines
   - Shared-nothing architecture
   - More complex but better for large loads

### Patterns:
- **Elastic Systems**: Automatically add resources under load
- **Manual Scaling**: Human-controlled resource allocation
- **Hybrid Approaches**: Mix of vertical and horizontal scaling

## Key Considerations
- No "one-size-fits-all" solution - architecture depends on:
  - Read/write patterns
  - Data volume/complexity
  - Response time requirements
- Early-stage systems should prioritize iteration over hypothetical scaling
- Distributed systems introduce complexity but are becoming more accessible