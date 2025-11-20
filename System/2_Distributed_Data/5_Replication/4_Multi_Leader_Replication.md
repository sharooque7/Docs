# Multi-Leader Replication

## Overview

Multi-leader replication (also called master-master or active/active replication) extends traditional single-leader replication by allowing multiple nodes to accept writes. Each leader simultaneously acts as a follower to other leaders.

## Use Cases

### Multi-datacenter operation
- Having leaders in different datacenters improves:
  - **Performance**: Writes processed locally, hiding network delays
  - **Tolerance of datacenter outages**: Each center operates independently
  - **Tolerance of network problems**: Asynchronous replication handles interruptions

### Clients with offline operation
- Applications that need to work without internet (e.g., calendar apps)
- Each device has a local database acting as a leader
- Changes sync when connectivity is restored

### Collaborative editing
- Real-time collaborative applications (e.g., Google Docs)
- Changes apply instantly to local state and replicate asynchronously 
- Small units of change (keystrokes) allow simultaneous editing

## Handling Write Conflicts

The major challenge with multi-leader replication is resolving conflicts when the same data is modified concurrently in different leaders.

### Conflict resolution approaches:
- **Conflict avoidance**: Route all writes for a particular record through the same leader
- **Convergent resolution**: Ensure all replicas reach the same final state:
  - Last write wins (using timestamps or unique IDs)
  - Priority-based (replica with higher ID wins)
  - Value merging (concatenate values)
  - Explicit conflict recording for later resolution

### Resolution timing:
- **On write**: Conflict handler runs automatically when conflict is detected
- **On read**: Multiple versions preserved until application resolves conflict

### Automatic conflict resolution:
- Conflict-free replicated datatypes (CRDTs)
- Mergeable persistent data structures
- Operational transformation (used in collaborative editors)

## Replication Topologies

Describes communication paths between leaders:
- **All-to-all**: Every leader sends writes to every other leader
- **Circular**: Each node forwards writes to one other node
- **Star**: One designated root forwards writes to all other nodes

### Challenges with topologies:
- In circular/star, node failures can interrupt replication flow
- In all-to-all, network speed differences can cause messages to arrive out of order
- Causality and event ordering is critical for proper operation

## Implementation Caveats
- Many multi-leader systems have poor implementations of conflict detection
- Autoincrementing keys, triggers, and integrity constraints can be problematic
- Often considered dangerous territory that should be avoided if possible
- Requires careful testing and understanding of the system's documentation