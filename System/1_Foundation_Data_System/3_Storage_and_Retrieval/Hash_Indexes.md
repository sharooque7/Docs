### Storage and Retrieval

### Database
1. How to Store
2. How to retrieve

### Storage Engine
1. Optimized for Transaction Processing
2. Optimized for Analytics

### Two Family of storage engine
1. Log Structured Storage Engines
(Storage engines that are based on this principle of
merging and compacting sorted files are often called LSM storage engines)
2. Page Oriented Storage Engines - B Trees

### Notes
* Fastest way to write is to append to file without index.
### Index:
* Additional metadata derived from primary data
* Any kind of index slow's down the writes, because index need to be updated every time data is written

### Trade Off
* Index speed's up read queries but slow's down write queries

### Hash Indexes DB
#### Hash
key -> hash function() -> hashed value -> Hash collison -> bucket (array or linked list) -> value

#### Log file
Log - Append Only

HashMap to maintain key and byte offset which maintains address of key value in log file

* So actual file is written to disk. But the reference is stored in - memory RAM
* How not to make file out of storage
* Segment the data and do compaction(removing duplicates, keeping recent update)
* Merge several segments. Each Segment has it's own hash Map

#### Issue with this:
* File format - CSV not goot. Binary format is good
* Deleting records 
    -   delete key and value
    -   tombstone(append special deletion record in file)
    -   log are merged tombstone tells merging process to discard any previous value for deleted key
* Crash recovery
    -   DB restarted in-memory are lost
    -   snapshot hashmap
    -   re-create hashmap
* Partially written record
    -   DB may crash in middle of write
    -   checksum to aviod this
* Concurrency control
    -   one writer thread
    -   multiple reader thread


### SSTables (Sorted String Tables)
* Take the segment file and sort by key
* Segement file 
    *   Latest segment file contains latest values
    *   if key not found in latest. search in older file
    *   Merge sort algo to merge
* In memory 
    * Instead of maintainin key and offset in hash we maintain block's address
    * key
    * offset -> compressed blocks address
    * suppose we want to find key means it will fall between a block

### Constructing and maintaining SSTables
* B-Tree Maintains sorted structure in Disk
* AVL / Red Black tree in memory called memtable
* Write request: memtable exceed threshold write to SSTables. Recent data will be in Memtable -> segmentfile -> oldsegnementfile -> so on
* Read request: key in memtable -> latest_segment_file -> old_segment_file

### Issue:
* DB crashed.
* memtable lost.
* so keep a seprate log file and re-create memtable when bootup.

### Making LSM-tree(Log Structure Merge Tree) out of SSTables:
* Level DB and Rocks DB
* Storage engines that are based on this principle of
merging and compacting sorted files are often called LSM storage engines
* Elastic Search and Solr uses lucence storage engine
* Term Dictionary
* Full text index more difficult than key value.
* A Full text each word is key and related document is list of document Id
* So term(word) is query is looked upon this (postings list) with list of document Id 

### Performance optimization:
* If key not present 
    * First search memtable/SSTables
    * latest segement to oldest segemtn
    * So many disk seek
* Bloom Filter (Data Structure)
    * memory efficient DSA
    * tells key does not exist in DB, saves disk seeks 

### Compaction:
* Strategies to determine order and timing SSTables compacted and merged.
* size tiered(HBase) and leveled tiered (Rocks and level DB)
* Level
    * Key is split into smaller SSTables
    * Older data moved in seperate levels


### B Trees
* widely indexed structure B Tree
* sorted by key
* Breaks DB into fixed size blocks or pages 4KB
* SSTables / LSM breaks into variable size segment
* Branch Factor: No of references to child page in one page of B tree
* Depth O(log n) n -> number of key
* Four level tree of 4kb Pages with branching factor 500 can store 256 TB 

### Making B - trees reliable:
* Write : Overwrite pages with new data
* SSD : erase and write fairly large block
* HDD : Magnetic HD moving disk head to plattter position and overwriting appropriate sector
* Split happens parent and child page oiverwrite
* So if crases when these overwriting we may have corrupt data
* Write Ahead Log (WAL or redo log) : Append only log where every tree modifications are written to it before page modification happens
* concurrency control using latches(leight weight locks)


### Optimizations:
* Copy on write instead of WAL. Modified page to different location and new version of parent page is created concurrency controk
* Saving space by not storing entire key
* Additonal Pointers to left and right of left tree.

### B Tree VS LSM

Write:
    * B Tree Slow
    * LSM FAST
Read
    * B Tree Fast
    * LSM Slow

### Advantage of LSM
* Write to WAL and Page Block(Split page(overload) due to data size)
* LSM memheap -> segment -> compaction -> merging
* Write heavy application LSM (Performcance cost) due to many writes to DB slows down fewer writer per second 
* LSM compressed size is less

#### Other Indexin Structures
* Secondary Index can be duplicated in many places. To reduce
    * S index - list of row identifiers
    * S Index uniqiue by appending row identifier to it

### Storing values withing index
* Values can be document
* Values cab be reference to document (heap file)
* heap file no order, append only, tomstone record
* heap 
    * new record less than old record fine (perfect)
    * new record larger than old. remove and replace where space is available, may be all index need to updated
* Extra hop from index to heap is costly

### CLustered Index
* stored index row identifier directly in index
* Mysql PK is Cluset, So SI points to PK
* A compromise between a clustered index (storing all row data within the index) and a nonclustered index (storing only references to the data within the index) is known
as a covering index or index with included columns

#### Multi Column index
*  concatenated index - combines serveral column one key 
* 2 D into single number using space filling curve then use B Tree
* R Tree - Specialized Spatial index - Geo Spatial

### Full Text Search and Fuzzy Indexes
* search for  text with misspelling and other
### Keep everything in memeory
* In memory
* Memchaed - not durable
* Redis /Couche DB - durable weakly async write to disk
* VoltDB, MemSQL, and Oracle TimesTen are strong durable 
* Since RAM memeory is less we use in memeory DB with least recently used being removed from memory
* Append only file for crash restore and durability

#### OLTP(Online Transaction Processing) vs OLAP (Online Analytic Processing)

OLTP : SQL
OLAP : Data Warehousing 

Data Models: Relational for both commonly

OLAP: SAP HANA, Terradata, Vertica, ParAccel(Amazon Redshift hosted version), Apache Hive, Spark SQl

* Multiple OLTP DB server will dump data through stream or period dump to OLAP server
* ELT.
* Read only data's in OLAP

### Schemas for anaylis
1. Star Schema (Dimensional Modelling) Warehouse Schema
2. fact table - event data with many columns
3. Dimension table - event data , time, product
4. Snow flake schema - dimension into sub - dimension (mostly used)

#### Column Oriented Storage
* each column as pages / segments
#### Column Compression
* BitMap Encoding
#### Memory bandwidth and vectorized processing
* Disk to memory issue (RAM may be less but disk volumen is huge)
* main memory to CPU cache due to bandwith of Cache 

