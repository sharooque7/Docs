# Message-Passing Dataflow

## Core Characteristics

### Hybrid Approach
- Combines aspects of RPC and databases
- Asynchronous communication model
- Messages stored temporarily in broker

### Key Components
1. **Producers**: Send messages to broker
2. **Message Broker**: Temporary storage/routing
3. **Consumers**: Receive messages from broker

## Advantages Over Direct RPC

| Advantage | Description |
|-----------|-------------|
| Buffering | Handles recipient unavailability |
| Redelivery | Survives consumer crashes |
| Discovery | No need for direct addressing |
| Multicast | One-to-many message distribution |
| Decoupling | Producers unaware of consumers |

## Message Broker Implementations

### Open Source Options
- **RabbitMQ** - AMQP implementation
- **Apache Kafka** - High-throughput log-based
- **NATS** - Lightweight pub-sub
- **ActiveMQ/HornetQ** - JMS implementations

### Enterprise Solutions
- TIBCO
- IBM WebSphere
- webMethods

## Delivery Semantics

### Common Patterns
1. **Point-to-Point**: Queue with competing consumers
2. **Publish-Subscribe**: Topic with multiple subscribers
3. **Request-Reply**: Temporary response channels

### Quality of Service
- At-most-once (may lose messages)
- At-least-once (may duplicate)
- Exactly-once (complex, not truly possible)

## Data Encoding Considerations

### Compatibility Requirements
- **Forward compatibility**: Old consumers read new messages
- **Backward compatibility**: New consumers read old messages
- **Field preservation**: Critical for message forwarding

### Recommended Formats
1. **Avro**: Good for evolving schemas
2. **Protocol Buffers**: Efficient, widely supported
3. **JSON**: Human-readable, flexible

## Distributed Actor Frameworks

### Actor Model Basics
- Encapsulated state and behavior
- Asynchronous message passing
- Concurrent processing without locks

### Popular Frameworks

#### Akka (JVM)
- Default Java serialization (limited compatibility)
- Pluggable serialization (e.g., Protobuf)

#### Orleans (.NET)
- Custom encoding (no rolling upgrades)
- Requires cluster migration for changes

#### Erlang OTP
- Challenging schema evolution
- Experimental map type improves flexibility

## Practical Recommendations

### When to Use Message-Passing
- Asynchronous workflows
- Event-driven architectures
- Decoupled system components
- High-volume data pipelines

### Implementation Best Practices
1. Design for idempotent processing
2. Plan for schema evolution
3. Monitor consumer lag
4. Consider dead letter queues
5. Document message formats

### Evolution Strategy
- Prefer additive changes
- Maintain compatibility windows
- Test with mixed versions