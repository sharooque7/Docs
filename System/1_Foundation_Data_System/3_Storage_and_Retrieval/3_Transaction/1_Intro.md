# OLTP vs OLAP: Understanding Transaction Processing and Analytical Systems

## Origins of Transactions

- Originally, database transactions corresponded to commercial transactions
- Term "transaction" evolved to mean a group of reads and writes forming a logical unit
- Transaction processing means allowing clients to make low-latency reads and writes (vs. batch processing)

## Online Transaction Processing (OLTP)

OLTP became the standard pattern for interactive applications where users:
- Look up a small number of records by key using an index
- Insert or update records based on user input
- Need immediate processing of operations

**Examples include:**
- Processing sales
- Managing blog comments
- Recording game actions
- Updating contact information

## Online Analytical Processing (OLAP)

As databases expanded to analytics use cases, a different access pattern emerged:
- Scanning huge numbers of records
- Reading only specific columns
- Calculating aggregate statistics (count, sum, average)
- Supporting business intelligence and decision-making

**Examples include:**
- Store revenue analysis
- Promotional sales impact
- Product correlation analysis

## Key Differences Between OLTP and OLAP

| Property | Transaction Processing Systems (OLTP) | Analytical Systems (OLAP) |
|----------|--------------------------------------|--------------------------|
| **Main read pattern** | Small number of records per query, fetched by key | Aggregate over large number of records |
| **Main write pattern** | Random-access, low-latency writes from user input | Bulk import (ETL) or event stream |
| **Primary users** | End users/customers, via web applications | Internal analysts, for decision support |
| **Data representation** | Latest state of data (current point in time) | History of events that happened over time |
| **Dataset size** | Gigabytes to terabytes | Terabytes to petabytes |

## Evolution of Database Systems

- Initially, the same databases were used for both OLTP and OLAP
- SQL proved flexible for both transaction and analytical queries
- Late 1980s/early 1990s: Companies began separating analytics from OLTP systems
- This led to the development of dedicated **data warehouses** for analytical processing

The separation allowed each system to be optimized for its specific workload characteristics, leading to better performance for both transaction processing and analytical queries.