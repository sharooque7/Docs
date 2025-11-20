### Reliability ### Scalability ### Maintainbility

### Reliability 
* Failiure -  stops deilvering output
* Fault - one system fails 

### Hardware Fauls
* Hard Disk Crash
* RAM faults
* Grid Blackout 
* Redundancy to solve issue
### Software Faults 
### Human Errors

### Scalability

#### Describing Load
* request / second to server
* ration read::write to DB
* no of cache hit
* active user connection

### Performance
* Throughtput: -> the number of records we can process per second
* Response time : besides the actual time to process the request (the service time), it includes network delays and queueing delays
* Latency : e duration that request is waiting to be handled—during which it is latent, await‐ing service

* a background process
* a loss of a network packet and TCP retransmission
* a garbage collection pause
* a page fault forcing a read from disk
* a mechanical vibrations in the server rack

### Percentile
If the 95th percentile response time is 1.5 seconds, 
that means 95 out of 100 requests take less than 1.5 seconds, 
and 5 out of 100 requests take 1.5 seconds or more.

### Maintainbility
