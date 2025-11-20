### Abstract
Expected Outcome:
    * High Availability
    * Maintain Peak throughput when demand exceeds system resource
Main Category: 
    * Event Based
    * Threaded System

### This Framework Suggest
* Tasks, Queues, Thread Pools

## Introduction
Example
1 Concurrent Session or Hit may translates to 10 IO and 10 Network requests. This place huge demands on underlying resources.

Burstiness : Overload the system resource
Continous Demand : Highly Available no less than 2 minutes downtime per year
Human Scale Access Latency : Optimize for High Through put than low latency

Cons
Thread: High resource usage and scalability limit
Event: Complex to develop and Debug

Event : Acheives High Cuncureency
Thread: Exploting MultiProcessor Parallism and IO Blocking 