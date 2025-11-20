# Summary: Distributed Data

## Introduction
Distributed data systems involve multiple machines for storage and retrieval. The primary motivations for distributing a database include:
- **Scalability**: Handling increased data volume, read, and write load.
- **Fault Tolerance**: Ensuring redundancy for high availability.
- **Latency Reduction**: Serving users from geographically closer data centers.

## Scaling Approaches
1. **Vertical Scaling (Scaling Up)**
   - Uses a more powerful machine with more CPUs, RAM, and disks.
   - Limited by cost and scalability constraints.
   
2. **Shared-Disk Architecture**
   - Multiple machines with independent CPUs and RAM share a common disk array.
   - Scalability is limited by contention and locking overhead.
   
3. **Shared-Nothing Architecture (Scaling Out)**
   - Each node operates independently with its own CPU, RAM, and disk.
   - More cost-effective and geographically distributed but introduces software-level complexity.

## Data Distribution Mechanisms
1. **Replication** (Discussed in Chapter 5)
   - Duplicates data across multiple nodes.
   - Ensures redundancy and can improve read performance.

2. **Partitioning (Sharding)** (Discussed in Chapter 6)
   - Splits data into smaller subsets across multiple nodes.
   - Helps distribute load efficiently.

## Key Trade-offs
- Distributed systems introduce complexity but offer better scalability and fault tolerance.
- Some workloads perform better on a single-threaded system rather than a large distributed setup.
- Future chapters will explore transactions, limitations, and multi-datastore integration.

This section sets the foundation for understanding distributed systems and their associated challenges.
