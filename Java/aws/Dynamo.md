# Complete DynamoDB Guide - The Ultimate Interview Reference 📊

*Your comprehensive go-to reference for Amazon DynamoDB with explanations, Java examples, and interview-focused insights*

---

## **📋 TABLE OF CONTENTS**

1. [What is DynamoDB?](#1-what-is-dynamodb)
2. [DynamoDB vs Traditional Databases](#2-dynamodb-vs-traditional-databases)
3. [Core Concepts](#3-core-concepts)
4. [Primary Keys](#4-primary-keys)
5. [Read/Write Capacity Modes](#5-readwrite-capacity-modes)
6. [Data Types](#6-data-types)
7. [Query Operations](#7-query-operations)
8. [Scan Operations](#8-scan-operations)
9. [Secondary Indexes](#9-secondary-indexes)
10. [DynamoDB Streams](#10-dynamodb-streams)
11. [DynamoDB Accelerator (DAX)](#11-dynamodb-accelerator-dax)
12. [Global Tables](#12-global-tables)
13. [Transactions in DynamoDB](#13-transactions-in-dynamodb)
14. [Time-to-Live (TTL)](#14-time-to-live-ttl)
15. [Backup and Restore](#15-backup-and-restore)
16. [Security Features](#16-security-features)
17. [Java SDK Examples](#17-java-sdk-examples)
18. [Best Practices](#18-best-practices)
19. [Common Use Cases](#19-common-use-cases)
20. [DynamoDB vs Other NoSQL Databases](#20-dynamodb-vs-other-nosql-databases)
21. [Common Interview Questions](#21-common-interview-questions)
22. [Quick Reference Cheat Sheet](#22-quick-reference-cheat-sheet)

---

## **1. WHAT IS DYNAMODB?**

> **Concept:** Amazon DynamoDB is a fully managed, serverless, NoSQL database service that delivers single-digit millisecond performance at any scale. It supports both key-value and document data models .

```java
// DynamoDB at its core - a fast, scalable NoSQL database
// No servers to manage, no patching, no downtime
```

### **Key Characteristics**

| Characteristic | Description |
|----------------|-------------|
| **Serverless** | No servers to provision, patch, or manage. No software to install  |
| **Fully Managed** | AWS handles hardware provisioning, setup, configuration, and backups |
| **Scalable** | Scales horizontally to handle petabytes of data and millions of requests per second  |
| **Fast** | Consistent single-digit millisecond response times at any scale  |
| **Flexible Schema** | Each item can have different attributes (schemaless)  |
| **Multi-Region** | Global tables for cross-region replication  |
| **ACID Transactions** | Supports transactions across multiple items and tables  |

### **DynamoDB by the Numbers**

| Metric | Value |
|--------|-------|
| **Customers** | 1,000,000+ active customers  |
| **Daily Requests** | 10+ trillion requests per day  |
| **Peak Requests** | 20+ million requests per second  |
| **Table Size** | Up to petabytes (virtually unlimited)  |
| **Availability SLA** | 99.999% for global tables  |

---

## **2. DYNAMODB VS TRADITIONAL DATABASES**

> **Concept:** Understanding key differences between DynamoDB and traditional relational databases is crucial for interview success.

### **DynamoDB vs RDBMS**

| Aspect | DynamoDB | Traditional RDBMS |
|--------|----------|-------------------|
| **Data Model** | Key-value and document | Relational (tables with rows/columns) |
| **Schema** | Flexible (items can have different attributes) | Fixed schema (predefined columns)  |
| **Scaling** | Horizontal, automatic | Vertical (bigger servers) or complex sharding |
| **Performance** | Single-digit milliseconds at any scale | Degrades as data grows |
| **Query Language** | API-based (no SQL) | SQL |
| **Joins** | Not supported (denormalization required) | Supported |
| **ACID Transactions** | Supported (across items/tables)  | Supported |
| **Management** | Fully managed by AWS | Self-managed or managed service |

### **Design Philosophy**

Unlike traditional databases where you can run arbitrary queries after the fact, DynamoDB requires you to **design your data model based on your access patterns upfront** . This is the single most important concept to understand.

```sql
-- Traditional RDBMS: You can query however you want later
SELECT * FROM orders WHERE customer_id = 123 AND order_date > '2024-01-01';
SELECT * FROM orders WHERE product_id = 456;
SELECT * FROM orders WHERE status = 'SHIPPED';
```

```javascript
// DynamoDB: You must design your primary keys and indexes based on how you'll query
// For customer orders: Use customer_id as partition key, order_date as sort key
// For product orders: Create a GSI with product_id as partition key
// For status queries: Consider a different design pattern
```

**Interview Tip:** "DynamoDB is not a drop-in replacement for SQL databases. You need to know your access patterns first, then design your tables around them." 

---

## **3. CORE CONCEPTS**

> **Concept:** DynamoDB organizes data in a specific hierarchy and uses unique terminology .

### **DynamoDB Terminology**

| Term | Description | SQL Equivalent |
|------|-------------|----------------|
| **Table** | Collection of items | Table |
| **Item** | Individual record (can have varying attributes) | Row/Tuple |
| **Attribute** | Data element within an item | Column/Field |
| **Primary Key** | Uniquely identifies each item | Primary Key |
| **Partition Key** | First part of primary key (determines partition) | None |
| **Sort Key** | Second part of primary key (sorts within partition) | None |

### **Data Hierarchy**

```
DynamoDB
├── Table: "Users"
│   ├── Item (Partition Key: "user123")
│   │   ├── Attribute: name = "John Doe"
│   │   ├── Attribute: email = "john@example.com"
│   │   └── Attribute: age = 30
│   ├── Item (Partition Key: "user456")
│   │   ├── Attribute: name = "Jane Smith"
│   │   ├── Attribute: email = "jane@example.com"
│   │   ├── Attribute: phone = "555-1234"
│   │   └── Attribute: address = "123 Main St"
│   └── ...
└── Table: "Orders"
    └── ...
```

### **Flexible Schema Example**

```javascript
// Items in the same table can have completely different attributes
// Users table - Item 1
{
  "userId": "user123",           // Primary key (required)
  "name": "John Doe",            // Common attribute
  "email": "john@example.com",   // Common attribute
  "preferences": {                // Nested object
    "theme": "dark",
    "notifications": true
  }
}

// Users table - Item 2 (different attributes)
{
  "userId": "user456",           // Primary key (required)
  "name": "Jane Smith",           // Common attribute  
  "phone": "555-1234",            // Different attribute
  "address": "123 Main St",       // Different attribute
  "createdAt": "2024-01-15"       // Different attribute
}
```

---

## **4. PRIMARY KEYS**

> **Concept:** DynamoDB supports two types of primary keys: simple (partition key only) and composite (partition key + sort key) .

### **Simple Primary Key (Partition Key Only)**

```javascript
// Table: Users
// Primary Key: userId (partition key)
{
  "userId": "user123",  // Uniquely identifies the item
  "name": "John Doe",
  "email": "john@example.com"
}

// Can only query by userId directly
// Query: Get item where userId = "user123"
```

### **Composite Primary Key (Partition Key + Sort Key)** 

```javascript
// Table: UserOrders
// Primary Key: userId (partition key) + orderDate (sort key)
{
  "userId": "user123",      // Partition key - determines storage location
  "orderDate": "2024-01-15", // Sort key - sorted within partition
  "orderId": "ORD-1001",
  "amount": 99.99
}
{
  "userId": "user123",      // Same partition
  "orderDate": "2024-02-20", // Different sort key value
  "orderId": "ORD-1002",
  "amount": 149.99
}
{
  "userId": "user456",      // Different partition
  "orderDate": "2024-01-15",
  "orderId": "ORD-2001",
  "amount": 49.99
}
```

### **Query Capabilities with Composite Key** 

| Query Type | Key Condition Expression | Example |
|------------|-------------------------|---------|
| **Exact partition key** | `userId = :uid` | All orders for user |
| **Partition + exact sort key** | `userId = :uid AND orderDate = :date` | Specific order by date |
| **Partition + sort key range** | `userId = :uid AND orderDate BETWEEN :from AND :to` | Orders in date range |
| **Partition + sort key prefix** | `userId = :uid AND begins_with(orderDate, :prefix)` | Orders from 2024-01 |
| **Partition + sort key comparison** | `userId = :uid AND orderDate > :date` | Orders after a date |

### **Choosing a Good Partition Key** 

| Good Partition Keys | Bad Partition Keys |
|--------------------|--------------------|
| `userId`, `customerId` (high cardinality) | `status` (low cardinality - only few values) |
| `orderId`, `transactionId` (unique values) | `gender` (male/female - only 2 values) |
| `deviceId` (many unique values) | Timestamp (monotonically increasing) |

**Hot Partition Problem:** When one partition key value receives disproportionately more traffic, it creates a "hot partition" that can throttle your application .

```javascript
// ❌ BAD - Using timestamp as partition key
// All new items go to the same partition (current hour's timestamp)
{
  "timestamp": "2024-02-27T10:00:00Z", // Partition key
  "event": "click"
}

// ✅ GOOD - Using user ID as partition key
// Evenly distributes load across partitions
{
  "userId": "user123", // Partition key
  "timestamp": "2024-02-27T10:00:00Z", // Sort key
  "event": "click"
}
```

---

## **5. READ/WRITE CAPACITY MODES**

> **Concept:** DynamoDB offers two capacity modes for handling throughput, each optimized for different usage patterns .

### **On-Demand Capacity Mode** 

DynamoDB instantly accommodates your workloads as they ramp up or down. You pay per request.

| Feature | Description |
|---------|-------------|
| **Scaling** | Automatic, instant scaling to any previously reached traffic level |
| **Pricing** | Pay-per-request (read/write units consumed) |
| **Best for** | Unpredictable workloads, new applications, variable traffic |
| **Management** | No capacity planning required |

### **Provisioned Capacity Mode** 

You specify the number of reads and writes per second, and DynamoDB Auto Scaling adjusts based on utilization.

| Feature | Description |
|---------|-------------|
| **Scaling** | Auto Scaling based on configured utilization targets |
| **Pricing** | Pay for provisioned capacity (cheaper for steady workloads) |
| **Best for** | Predictable workloads, steady traffic, cost optimization |
| **Management** | Set read/write capacity units, configure auto scaling |

### **Capacity Units Explained**

| Unit | Description |
|------|-------------|
| **Read Capacity Unit (RCU)** | One strongly consistent read per second for items up to 4KB |
| **Write Capacity Unit (WCU)** | One write per second for items up to 1KB |

```javascript
// Example: 4KB item with eventually consistent read
// 1 RCU = 2 eventually consistent reads per second for 4KB items
// You need 0.5 RCU per second per 4KB item for eventually consistent reads

// Example: 2KB item with strong consistency
// 1 RCU = 1 strongly consistent read per second for 4KB items
// For 2KB item, you need 0.5 RCU per second

// Example: 5KB item write
// 1 WCU = 1 write per second for 1KB items
// For 5KB item, you need 5 WCU per second
```

### **Choosing the Right Mode** 

| Scenario | Recommended Mode |
|----------|------------------|
| **New application with unknown traffic** | On-demand |
| **Steady, predictable traffic** | Provisioned with Auto Scaling |
| **Sporadic traffic with peaks** | On-demand |
| **Cost optimization for known workloads** | Provisioned (significantly cheaper) |

---

## **6. DATA TYPES**

> **Concept:** DynamoDB supports a rich set of data types, including scalars, sets, and document types .

### **Scalar Types**

| Type | Description | Example |
|------|-------------|---------|
| **String** | UTF-8 encoded text | `"John Doe"` |
| **Number** | Any positive or negative integer or decimal | `123`, `45.67` |
| **Binary** | Any binary data | Base64-encoded data |
| **Boolean** | true/false | `true` |
| **Null** | Represents null value | `null` |

### **Set Types** (all values must be unique)

| Type | Description | Example |
|------|-------------|---------|
| **String Set** | Set of unique strings | `["Red", "Blue", "Green"]` |
| **Number Set** | Set of unique numbers | `[1, 2, 3, 4, 5]` |
| **Binary Set** | Set of unique binary values | `[Base64, Base64]` |

### **Document Types**

| Type | Description | Example |
|------|-------------|---------|
| **List** | Ordered collection of values (can be different types) | `[341, 472, 649]`  |
| **Map** | Unordered collection of key-value pairs (nested objects) | `{"FrontView": "http://..."}`  |

### **Java Data Type Mapping** 

```java
// Creating an item with various data types
Item item = new Item()
    .withPrimaryKey("Id", 123)                       // Number
    .withString("Title", "Bicycle 123")               // String
    .withString("Description", "123 description")     // String
    .withNumber("Price", 500)                         // Number
    .withStringSet("Color", new HashSet<>(Arrays.asList("Red", "Black"))) // String Set
    .withBoolean("InStock", true)                     // Boolean
    .withNull("QuantityOnHand")                       // Null
    .withList("RelatedItems", Arrays.asList(341, 472, 649)) // List
    .withMap("Pictures", pictures)                    // Map
    .withMap("Reviews", reviews);                      // Map (nested)
```

### **JSON Document Support** 

DynamoDB can store entire JSON documents and query them efficiently:

```java
// Storing a JSON document as a map attribute
String vendorDocument = "{"
    + "    \"V01\": {"
    + "        \"Name\": \"Acme Books\","
    + "        \"Offices\": [ \"Seattle\" ]"
    + "    },"
    + "    \"V02\": {"
    + "        \"Name\": \"New Publishers, Inc.\","
    + "        \"Offices\": [ \"London\", \"New York\" ]"
    + "    }"
    + "}";

Item item = new Item()
    .withPrimaryKey("Id", 210)
    .withString("Title", "Book 210 Title")
    .withJSON("VendorInfo", vendorDocument); // Store JSON directly
```

---

## **7. QUERY OPERATIONS**

> **Concept:** Query is the most efficient way to retrieve data from DynamoDB. It always requires a partition key and can optionally use sort key conditions .

### **Basic Query by Partition Key**

```java
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.dynamodb.model.*;

// Query for all items with a specific partition key
public List<Map<String, AttributeValue>> queryByUserId(String userId) {
    QueryRequest request = QueryRequest.builder()
        .tableName("UserOrders")
        .keyConditionExpression("userId = :uid")
        .expressionAttributeValues(Map.of(
            ":uid", AttributeValue.builder().s(userId).build()
        ))
        .build();
    
    QueryResponse response = dynamoDbClient.query(request);
    return response.items();
}
```

### **Query with Sort Key Conditions** 

```java
// Query with partition key and sort key condition
public List<Map<String, AttributeValue>> queryByDateRange(
        String userId, String fromDate, String toDate) {
    
    QueryRequest request = QueryRequest.builder()
        .tableName("UserOrders")
        .keyConditionExpression("userId = :uid AND orderDate BETWEEN :from AND :to")
        .expressionAttributeValues(Map.of(
            ":uid", AttributeValue.builder().s(userId).build(),
            ":from", AttributeValue.builder().s(fromDate).build(),
            ":to", AttributeValue.builder().s(toDate).build()
        ))
        .build();
    
    return dynamoDbClient.query(request).items();
}
```

### **Common Sort Key Operators** 

| Operator | Description | Example |
|----------|-------------|---------|
| `=` | Equal to | `orderDate = :date` |
| `<` | Less than | `orderDate < :date` |
| `<=` | Less than or equal | `orderDate <= :date` |
| `>` | Greater than | `orderDate > :date` |
| `>=` | Greater than or equal | `orderDate >= :date` |
| `BETWEEN` | Between two values | `orderDate BETWEEN :from AND :to` |
| `begins_with` | String starts with prefix | `begins_with(orderDate, :prefix)` |

### **begins_with Example** 

```java
// Get all orders from January 2024
QueryRequest request = QueryRequest.builder()
    .tableName("UserOrders")
    .keyConditionExpression("userId = :uid AND begins_with(orderDate, :prefix)")
    .expressionAttributeValues(Map.of(
        ":uid", AttributeValue.builder().s("user123").build(),
        ":prefix", AttributeValue.builder().s("2024-01").build()
    ))
    .build();
```

### **Pagination in Queries** 

DynamoDB limits each query response to 1MB. Use pagination for larger result sets:

```java
public List<Map<String, AttributeValue>> queryAllWithPagination(String userId) {
    List<Map<String, AttributeValue>> allItems = new ArrayList<>();
    Map<String, AttributeValue> lastKey = null;
    
    do {
        QueryRequest.Builder requestBuilder = QueryRequest.builder()
            .tableName("UserOrders")
            .keyConditionExpression("userId = :uid")
            .expressionAttributeValues(Map.of(
                ":uid", AttributeValue.fromS(userId)
            ));
        
        if (lastKey != null) {
            requestBuilder.exclusiveStartKey(lastKey);
        }
        
        QueryResponse response = dynamoDbClient.query(requestBuilder.build());
        allItems.addAll(response.items());
        lastKey = response.lastEvaluatedKey();
        
    } while (lastKey != null && !lastKey.isEmpty());
    
    return allItems;
}
```

### **Query vs Scan**

| Aspect | Query | Scan |
|--------|-------|------|
| **Required** | Must specify partition key | No requirements |
| **Efficiency** | Highly efficient (index-based) | Inefficient (full table scan) |
| **Cost** | Low (only reads matching items) | High (reads entire table) |
| **Use when** | You know the partition key | Full table exports, one-time operations |

---

## **8. SCAN OPERATIONS**

> **Concept:** Scan reads every item in a table, which is inefficient and should be avoided in production applications .

### **Basic Scan**

```java
// Read all items from a table (expensive!)
public List<Map<String, AttributeValue>> scanAllItems() {
    ScanRequest request = ScanRequest.builder()
        .tableName("UserOrders")
        .build();
    
    return dynamoDbClient.scan(request).items();
}
```

### **Scan with Filters**

```java
// Scan with filter (still reads all items, then filters)
public List<Map<String, AttributeValue>> scanWithFilter(double minAmount) {
    ScanRequest request = ScanRequest.builder()
        .tableName("UserOrders")
        .filterExpression("amount > :minAmount")
        .expressionAttributeValues(Map.of(
            ":minAmount", AttributeValue.builder().n(String.valueOf(minAmount)).build()
        ))
        .build();
    
    return dynamoDbClient.scan(request).items();
}
```

**Important:** Filter expressions are applied **after** reading all items. You still pay for reading every item, even if most are filtered out.

### **When to Use Scan**

| Use Case | Alternative |
|----------|-------------|
| **One-time data export** | Scan (acceptable for small tables) |
| **Full table analytics** | Use DynamoDB Export to S3 + Athena |
| **Production queries** | Never – use Query with proper indexes |

---

## **9. SECONDARY INDEXES**

> **Concept:** Secondary indexes allow you to query data based on non-primary key attributes. DynamoDB supports two types: Global Secondary Indexes (GSIs) and Local Secondary Indexes (LSIs) .

### **Index Types Comparison** 

| Feature | Global Secondary Index (GSI) | Local Secondary Index (LSI) |
|---------|------------------------------|------------------------------|
| **Partition Key** | Can be different from table's partition key | Same as table's partition key |
| **Scope** | Entire table | Within the same partition key |
| **Creation** | Can add after table creation | Must create at table creation |
| **Capacity** | Own provisioned throughput | Shares table's throughput |
| **Size Limit** | No limit | 10GB per partition key value |

### **Global Secondary Index (GSI) Example**

```java
// Table: Orders
// Primary Key: orderId (partition key)
// GSI: customerId-index (partition key: customerId, sort key: orderDate)

// Query by customerId using GSI
public List<Map<String, AttributeValue>> queryByCustomerId(String customerId) {
    QueryRequest request = QueryRequest.builder()
        .tableName("Orders")
        .indexName("customerId-index")
        .keyConditionExpression("customerId = :cid")
        .expressionAttributeValues(Map.of(
            ":cid", AttributeValue.builder().s(customerId).build()
        ))
        .build();
    
    return dynamoDbClient.query(request).items();
}
```

### **Local Secondary Index (LSI) Example**

```java
// Table: UserOrders
// Primary Key: userId (partition key) + orderDate (sort key)
// LSI: status-index (sort key: status, same partition key: userId)

// Query by userId and status using LSI
public List<Map<String, AttributeValue>> queryByStatus(String userId, String status) {
    QueryRequest request = QueryRequest.builder()
        .tableName("UserOrders")
        .indexName("status-index")
        .keyConditionExpression("userId = :uid AND status = :status")
        .expressionAttributeValues(Map.of(
            ":uid", AttributeValue.builder().s(userId).build(),
            ":status", AttributeValue.builder().s(status).build()
        ))
        .build();
    
    return dynamoDbClient.query(request).items();
}
```

### **Index Design Considerations** 

| Consideration | Implication |
|---------------|-------------|
| **Cardinality** | Index on high-cardinality attributes (e.g., customerId) for efficiency |
| **Write overhead** | Each GSI adds write cost – every write to table updates all GSIs |
| **Storage cost** | Indexes consume additional storage |
| **Projection** | Choose which attributes to project (KEYS_ONLY, INCLUDE, ALL) |

### **GSI Best Practices** 

```javascript
// ✅ GOOD - High cardinality GSI
// GSI on customerId (many unique values)
// Queries are efficient, load is distributed

// ✅ GOOD - Composite key GSI
// GSI with partition key = status, sort key = createdAt
// Allows querying by status with time range

// ❌ BAD - Low cardinality GSI
// GSI on gender (only 2 values)
// Creates "hot" partitions, queries still scan many items
```

---

## **10. DYNAMODB STREAMS**

> **Concept:** DynamoDB Streams captures a time-ordered sequence of item-level changes in a table and stores this information for up to 24 hours .

### **Stream Records**

Each stream record contains:
- **Event name** (INSERT, MODIFY, REMOVE)
- **Old image** (item before change – optional)
- **New image** (item after change – optional)
- **Keys** (primary key of the changed item)
- **Approximate creation time**

### **Use Cases for DynamoDB Streams** 

| Use Case | Description |
|----------|-------------|
| **Event-driven architectures** | Trigger Lambda functions on data changes |
| **Real-time analytics** | Stream data to analytics platforms |
| **Cross-region replication** | Build custom replication solutions |
| **Audit logging** | Capture change history for compliance |
| **Materialized views** | Maintain derived tables/views |

### **Java Example: Processing Stream Records**

```java
import software.amazon.awssdk.services.dynamodb.model.Record;
import software.amazon.awssdk.services.lambda.runtime.Context;
import software.amazon.awssdk.services.lambda.runtime.events.DynamodbEvent;

public class StreamProcessor {
    
    public void handleRequest(DynamodbEvent event, Context context) {
        for (DynamodbEvent.DynamodbStreamRecord record : event.getRecords()) {
            String eventName = record.getEventName();
            
            switch (eventName) {
                case "INSERT":
                    processInsert(record.getDynamodb().getNewImage());
                    break;
                case "MODIFY":
                    processModify(
                        record.getDynamodb().getOldImage(),
                        record.getDynamodb().getNewImage()
                    );
                    break;
                case "REMOVE":
                    processRemove(record.getDynamodb().getKeys());
                    break;
            }
        }
    }
    
    private void processInsert(Map<String, AttributeValue> newImage) {
        // Handle new item
    }
    
    private void processModify(Map<String, AttributeValue> oldImage,
                               Map<String, AttributeValue> newImage) {
        // Handle update
    }
    
    private void processRemove(Map<String, AttributeValue> keys) {
        // Handle deletion
    }
}
```

### **Stream Configuration Options**

| Option | Description |
|--------|-------------|
| **View type** | KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES |
| **TTL** | 24 hours retention (cannot be extended) |
| **Ordering** | Items appear in the order they were changed |

---

## **11. DYNAMODB ACCELERATOR (DAX)**

> **Concept:** DAX is an in-memory cache for DynamoDB that delivers up to 10x performance improvement – from milliseconds to microseconds – even at millions of requests per second .

### **DAX Architecture**

```
Application → DAX Cluster → DynamoDB
                │
                ▼
           In-memory cache
```

### **DAX Benefits** 

| Benefit | Description |
|---------|-------------|
| **Performance** | Microsecond read latency (up to 10x faster) |
| **Scalability** | Handles millions of requests per second |
| **Managed** | Fully managed cache cluster |
| **Transparent** | API-compatible with DynamoDB (minimal code changes) |

### **Using DAX with Java**

```java
// Regular DynamoDB client
AmazonDynamoDB client = AmazonDynamoDBClientBuilder.standard().build();

// DAX client (same API, different endpoint)
AmazonDynamoDB daxClient = new AmazonDynamoDBClient()
    .withEndpointConfiguration(
        new EndpointConfiguration("my-dax-cluster.region.dax.amazonaws.com:8111", "region")
    );

// Same code works with both!
Table table = new Table(daxClient, "MyTable");
Item item = table.getItem("Id", 123);
```

### **When to Use DAX**

| Use Case | DAX Benefit |
|----------|-------------|
| **Read-heavy workloads** | 90%+ read operations benefit most |
| **Hot data** | Frequently accessed items get cached |
| **Real-time applications** | Need lowest possible latency |
| **Cost optimization** | Reduce read capacity consumption |

---

## **12. GLOBAL TABLES**

> **Concept:** Global tables provide multi-region, multi-active replication, enabling you to scale globally with 99.999% availability .

### **Global Tables Features** 

| Feature | Description |
|---------|-------------|
| **Multi-active** | Read and write to any region |
| **Auto-scaling** | Capacity automatically scales in each region |
| **Conflict resolution** | Last writer wins (based on timestamp) |
| **Replication latency** | Typically sub-second |
| **Availability** | 99.999% SLA |

### **Benefits of Global Tables** 

- **Global read/write performance** – Applications access data locally in each region
- **Business continuity** – Multi-region disaster recovery
- **Data sovereignty** – Keep data within specific geographic boundaries
- **Global user base** – Local access for users worldwide

### **Java Example: Writing to Global Tables**

```java
// Same code works for any region – replication is automatic
public void writeToGlobalTable(String region, Item item) {
    AmazonDynamoDB client = AmazonDynamoDBClientBuilder.standard()
        .withRegion(region)
        .build();
    
    Table table = new Table(client, "GlobalTable");
    table.putItem(item);  // Automatically replicated to all regions
}
```

---

## **13. TRANSACTIONS IN DYNAMODB**

> **Concept:** DynamoDB transactions provide ACID guarantees across multiple items and tables, making it suitable for mission-critical applications .

### **Transaction Operations** 

| Operation | Description |
|-----------|-------------|
| **TransactWriteItems** | Up to 100 write actions (Put, Update, Delete, ConditionCheck) |
| **TransactGetItems** | Up to 100 read actions with consistent reads |

### **Transaction Example** 

```java
public void transferFunds(String fromAccount, String toAccount, double amount) {
    List<TransactWriteItem> actions = Arrays.asList(
        // Debit from account (conditionally)
        TransactWriteItem.builder()
            .update(Update.builder()
                .tableName("Accounts")
                .key(Map.of("accountId", AttributeValue.builder().s(fromAccount).build()))
                .updateExpression("SET balance = balance - :amount")
                .conditionExpression("balance >= :amount")
                .expressionAttributeValues(Map.of(
                    ":amount", AttributeValue.builder().n(String.valueOf(amount)).build()
                ))
                .build())
            .build(),
        
        // Credit to account
        TransactWriteItem.builder()
            .update(Update.builder()
                .tableName("Accounts")
                .key(Map.of("accountId", AttributeValue.builder().s(toAccount).build()))
                .updateExpression("SET balance = balance + :amount")
                .expressionAttributeValues(Map.of(
                    ":amount", AttributeValue.builder().n(String.valueOf(amount)).build()
                ))
                .build())
            .build()
    );
    
    TransactWriteItemsRequest request = TransactWriteItemsRequest.builder()
        .transactItems(actions)
        .build();
    
    dynamoDbClient.transactWriteItems(request);
    // Either both succeed or both fail atomically
}
```

### **Transaction Limitations**

| Limitation | Value |
|------------|-------|
| **Items per transaction** | 100 max  |
| **Transaction duration** | 3 seconds max |
| **Targets** | Within same account and region |

---

## **14. TIME-TO-LIVE (TTL)**

> **Concept:** TTL allows you to automatically delete items after a specified timestamp, helping you manage storage costs and remove stale data.

### **TTL Benefits**

| Benefit | Description |
|---------|-------------|
| **No cost** | TTL deletions don't consume write capacity |
| **Automatic** | Items deleted automatically within 48 hours of expiry |
| **Storage optimization** | Automatically remove expired data |
| **Regulatory compliance** | Enforce data retention policies |

### **Java Example: Setting TTL**

```java
public void putItemWithTTL(String userId, int ttlSeconds) {
    long ttl = Instant.now().getEpochSecond() + ttlSeconds;
    
    Item item = new Item()
        .withPrimaryKey("userId", userId)
        .withString("data", "some data")
        .withNumber("ttl", ttl);  // TTL attribute name
    
    table.putItem(item);
}
```

### **Use Cases for TTL**

- **Session data** – Automatically expire user sessions
- **Event logs** – Remove old log entries
- **Temporary data** – Clean up temporary records
- **Time-limited offers** – Expire promotional content

---

## **15. BACKUP AND RESTORE**

> **Concept:** DynamoDB offers two backup mechanisms: on-demand backups and point-in-time recovery (PITR) .

### **On-Demand Backups** 

| Feature | Description |
|---------|-------------|
| **Scope** | Full table backup |
| **Performance impact** | No impact on production tables |
| **Retention** | Until explicitly deleted |
| **Use case** | Compliance archives, long-term retention |

### **Point-in-Time Recovery (PITR)** 

| Feature | Description |
|---------|-------------|
| **Retention** | 35 days (latest 35 days) |
| **Granularity** | Restore to any second within retention period |
| **Performance impact** | No impact on production tables |
| **Use case** | Protection from accidental writes/deletes |

### **Java Example: PITR Configuration**

```java
// Enable PITR
public void enablePITR(String tableName) {
    UpdateContinuousBackupsRequest request = UpdateContinuousBackupsRequest.builder()
        .tableName(tableName)
        .pointInTimeRecoverySpecification(
            PointInTimeRecoverySpecification.builder()
                .pointInTimeRecoveryEnabled(true)
                .build()
        )
        .build();
    
    dynamoDbClient.updateContinuousBackups(request);
}
```

### **Backup Comparison**

| Feature | On-Demand Backup | Point-in-Time Recovery |
|---------|------------------|------------------------|
| **Retention** | Unlimited | 35 days |
| **Granularity** | Snapshot | Second-level |
| **Cost** | Storage cost | Continuous backup cost |
| **Use case** | Archiving | Disaster recovery |

---

## **16. SECURITY FEATURES**

> **Concept:** DynamoDB provides comprehensive security controls including encryption, IAM policies, and VPC endpoints .

### **Encryption at Rest** 

- **Default**: All data encrypted at rest by default
- **Key types**: AWS owned keys (default, free), AWS managed keys, Customer managed keys (CMK)
- **Scope**: Tables, indexes, streams, backups

### **Fine-Grained Access Control** 

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "dynamodb:GetItem",
            "Resource": "arn:aws:dynamodb:us-west-2:123456789012:table/Users",
            "Condition": {
                "ForAllValues:StringEquals": {
                    "dynamodb:LeadingKeys": ["${cognito-identity.amazonaws.com:sub}"]
                }
            }
        }
    ]
}
```

### **Security Features** 

| Feature | Description |
|---------|-------------|
| **IAM integration** | Authentication and authorization |
| **VPC endpoints** | Private connectivity without internet |
| **Attribute-level encryption** | Client-side encryption for sensitive fields |
| **CloudTrail integration** | API activity logging |
| **Compliance** | SOC, PCI, HIPAA, ISO, FedRAMP |

### **Java Example: Client-Side Encryption**

```java
// Using AWS Database Encryption SDK
MaterialProviders materialProviders = MaterialProviders.builder()
    .MaterialProvidersConfig(MaterialProvidersConfig.builder().build())
    .build();

CreateAwsKmsMrkMultiKeyringInput keyringInput = CreateAwsKmsMrkMultiKeyringInput.builder()
    .generatorKeyId("arn:aws:kms:us-west-2:123456789012:key/abcd1234")
    .build();

Keyring keyring = materialProviders.CreateAwsKmsMrkMultiKeyring(keyringInput);

DynamoDbEncryptionInterceptor interceptor = DynamoDbEncryptionInterceptor.builder()
    .keyring(keyring)
    .itemEncryptor(itemEncryptor)
    .build();

DynamoDbClient encryptedClient = DynamoDbClient.builder()
    .addInterceptor(interceptor)
    .build();
```

---

## **17. JAVA SDK EXAMPLES**

> **Concept:** The AWS SDK for Java provides multiple ways to interact with DynamoDB. The examples in this guide use the AWS SDK for Java v2 .

### **Maven Dependencies** 

```xml
<dependency>
    <groupId>software.amazon.awssdk</groupId>
    <artifactId>dynamodb</artifactId>
    <version>2.31.26</version>
</dependency>
```

### **Creating a DynamoDB Client**

```java
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.regions.Region;

DynamoDbClient dynamoDbClient = DynamoDbClient.builder()
    .region(Region.US_WEST_2)
    .build();
```

### **PutItem Example** 

```java
public void putItemExample() {
    // Build an item with various attributes
    List<Number> relatedItems = Arrays.asList(341, 472, 649);
    
    Map<String, String> pictures = new HashMap<>();
    pictures.put("FrontView", "http://example.com/products/123_front.jpg");
    pictures.put("RearView", "http://example.com/products/123_rear.jpg");
    
    Map<String, List<String>> reviews = new HashMap<>();
    reviews.put("FiveStar", Arrays.asList("Excellent!", "Buy it!"));
    reviews.put("OneStar", Arrays.asList("Terrible product!"));
    
    Item item = new Item()
        .withPrimaryKey("Id", 123)
        .withString("Title", "Bicycle 123")
        .withNumber("Price", 500)
        .withStringSet("Color", new HashSet<>(Arrays.asList("Red", "Black")))
        .withBoolean("InStock", true)
        .withList("RelatedItems", relatedItems)
        .withMap("Pictures", pictures)
        .withMap("Reviews", reviews);
    
    PutItemOutcome outcome = table.putItem(item);
}
```

### **GetItem Example** 

```java
public void getItemExample() {
    // Simple get by primary key
    Item item = table.getItem("Id", 123);
    
    // Get with projection expression (only specific attributes)
    GetItemSpec spec = new GetItemSpec()
        .withPrimaryKey("Id", 123)
        .withProjectionExpression("Id, Title, Price")
        .withConsistentRead(true);  // Strong consistency
    
    Item projectedItem = table.getItem(spec);
    
    // Pretty print as JSON
    System.out.println(projectedItem.toJSONPretty());
}
```

### **UpdateItem Example**

```java
public void updateItemExample() {
    // Update item attributes
    UpdateItemSpec spec = new UpdateItemSpec()
        .withPrimaryKey("Id", 123)
        .withUpdateExpression("SET Price = :newPrice")
        .withValueMap(new ValueMap()
            .withNumber(":newPrice", 550))
        .withReturnValues(ReturnValue.UPDATED_NEW);
    
    UpdateItemOutcome outcome = table.updateItem(spec);
}
```

### **DeleteItem Example**

```java
public void deleteItemExample() {
    // Simple delete
    DeleteItemOutcome outcome = table.deleteItem("Id", 123);
    
    // Conditional delete
    DeleteItemSpec spec = new DeleteItemSpec()
        .withPrimaryKey("Id", 123)
        .withConditionExpression("Price <= :maxPrice")
        .withValueMap(new ValueMap()
            .withNumber(":maxPrice", 600));
    
    try {
        table.deleteItem(spec);
    } catch (ConditionalCheckFailedException e) {
        // Condition not met, item not deleted
    }
}
```

### **Batch Operations**

```java
public void batchWriteExample() {
    TableWriteItems items = new TableWriteItems("ProductCatalog")
        .withItemsToPut(
            new Item().withPrimaryKey("Id", 101).withString("Name", "Product A"),
            new Item().withPrimaryKey("Id", 102).withString("Name", "Product B")
        );
    
    BatchWriteItemOutcome outcome = dynamoDB.batchWriteItem(items);
    
    // Handle unprocessed items
    while (outcome.getUnprocessedItems().size() > 0) {
        outcome = dynamoDB.batchWriteItemUnprocessed(outcome.getUnprocessedItems());
    }
}
```

---

## **18. BEST PRACTICES**

> **Concept:** Following best practices ensures optimal performance, cost, and scalability with DynamoDB .

### **Data Modeling Best Practices** 

| Practice | Description |
|----------|-------------|
| **Know access patterns first** | Design tables based on how you'll query |
| **Denormalize** | Store related data together (no joins) |
| **Use composite keys** | Partition key + sort key for flexible querying |
| **Create appropriate GSIs** | For alternative access patterns |
| **Avoid scans** | Design queries to use indexes |

### **Partition Key Best Practices** 

```java
// ✅ GOOD: High cardinality partition key
"userId": "user-123e4567-e89b-12d3-a456-426614174000"

// ✅ GOOD: Composite key for distribution
"orderId": "2024-01-15#order-12345"  // Date prefix + UUID

// ❌ BAD: Low cardinality
"status": "ACTIVE"  // Only few values -> hot partitions

// ❌ BAD: Monotonically increasing
"timestamp": "2024-02-27T10:00:00Z"  // All writes to same partition
```

### **Access Pattern Design Patterns** 

| Pattern | Description | Example |
|---------|-------------|---------|
| **Single table design** | Store multiple entity types in one table | Users, Orders, Products in one table |
| **Hierarchical data** | Use composite keys for parent-child | `userId` + `orderId` |
| **Time series data** | Use date-based partition keys | `2024-01-15#orderId` |
| **Aggregation** | Pre-aggregate data for reporting | Store daily totals |

### **Single Table Design Example**

```javascript
// One table for multiple entity types
{
  "pk": "USER#123",           // Partition key
  "sk": "METADATA",           // Sort key
  "name": "John Doe",
  "email": "john@example.com"
}
{
  "pk": "USER#123",           // Same partition
  "sk": "ORDER#2024-01-15#1001", // Sort key with order info
  "amount": 99.99,
  "status": "COMPLETED"
}
{
  "pk": "PRODUCT#456",        // Different partition
  "sk": "METADATA",
  "name": "Bicycle",
  "price": 500
}
```

### **Item Size Optimization** 

| Technique | Description |
|-----------|-------------|
| **Compress large data** | Store compressed data (gzip, etc.) |
| **External storage** | Store large files in S3, reference by key |
| **Use short attribute names** | "fn" instead of "firstName" |
| **Split large items** | Break into multiple related items |

### **Hot and Cold Data Management** 

Separate frequently accessed (hot) data from infrequently accessed (cold) data:

```javascript
// Hot data – frequently accessed
{
  "userId": "123",
  "recentOrders": ["ORD-1001", "ORD-1002"],
  "lastLogin": "2024-02-27"
}

// Cold data – historical orders (archived or separate table)
{
  "orderId": "ORD-1001",
  "userId": "123",
  "date": "2024-01-15",
  "items": [...]
}
```

---

## **19. COMMON USE CASES**

> **Concept:** DynamoDB excels in specific scenarios where its scalability, performance, and serverless nature provide maximum value .

### **Ad Tech Applications** 

| Use Case | Description |
|----------|-------------|
| **User profiles** | Store user data for targeting |
| **Click streams** | Capture user events in real-time |
| **Real-time bidding** | Sub-millisecond latency for ad auctions |
| **Attribution data** | Track conversion events |

### **Gaming Applications** 

| Use Case | Description |
|----------|-------------|
| **Game state** | Save player progress |
| **Player data** | Profiles, achievements, inventory |
| **Session history** | Track player sessions |
| **Leaderboards** | Real-time ranking with sorted sets |

### **Retail Applications** 

| Use Case | Description |
|----------|-------------|
| **Shopping carts** | Customer cart data |
| **Inventory tracking** | Real-time stock levels |
| **Order processing** | Order status and history |
| **Customer profiles** | Account and preference data |

### **Banking & Finance** 

| Use Case | Description |
|----------|-------------|
| **User transactions** | Account activity history |
| **Fraud detection** | Real-time pattern analysis |
| **Mainframe offloading** | Replicate legacy data |
| **Event-driven processing** | Transaction workflows |

### **Media & Entertainment** 

| Use Case | Description |
|----------|-------------|
| **Content metadata** | Media asset information |
| **User data stores** | Subscriptions, watch history |
| **Digital rights management** | License tracking |
| **Concurrent user handling** | Millions of simultaneous users |

### **Serverless Web Applications** 

```java
// Serverless web app architecture
// API Gateway → Lambda → DynamoDB

public class APIGatewayHandler implements RequestHandler<APIGatewayRequest, APIGatewayResponse> {
    
    @Override
    public APIGatewayResponse handleRequest(APIGatewayRequest request, Context context) {
        String userId = request.getPathParameters().get("userId");
        
        // Get item from DynamoDB
        Item item = table.getItem("userId", userId);
        
        return APIGatewayResponse.builder()
            .setStatusCode(200)
            .setBody(item.toJSON())
            .build();
    }
}
```

---

## **20. DYNAMODB VS OTHER NOSQL DATABASES**

> **Concept:** Understanding how DynamoDB compares to other NoSQL databases helps in architecture decisions.

### **DynamoDB vs MongoDB**

| Feature | DynamoDB | MongoDB |
|---------|----------|---------|
| **Managed service** | Yes (fully managed) | Self-managed or Atlas |
| **Scaling** | Automatic, horizontal | Sharding required |
| **Query language** | API-based | MongoDB Query Language |
| **Indexes** | Limited (max 20 GSIs) | Rich indexing |
| **Transactions** | ACID (across items) | ACID (since v4.0) |
| **Consistency** | Strong/Eventual | Strong/Eventual |
| **Best for** | AWS ecosystem, predictable patterns | Flexible queries, rich documents |

### **DynamoDB vs Cassandra**

| Feature | DynamoDB | Apache Cassandra |
|---------|----------|------------------|
| **Management** | Fully managed | Self-managed |
| **Data model** | Key-value + document | Wide column |
| **Query language** | API | CQL (SQL-like) |
| **Consistency** | Tunable | Tunable |
| **Partitioning** | Automatic | Manual (partition key design) |
| **Secondary indexes** | Limited | Materialized views |

### **DynamoDB vs Redis**

| Feature | DynamoDB | Redis |
|---------|----------|-------|
| **Primary use** | Database | Cache/Data structure store |
| **Persistence** | Durable by default | Optional |
| **Data structures** | Limited | Rich (lists, sets, sorted sets) |
| **Latency** | Single-digit ms | Microseconds |
| **Size limit** | Virtually unlimited | Memory-bound |

---

## **21. COMMON INTERVIEW QUESTIONS**

### **Basic Level**

| Question | Answer |
|----------|--------|
| **What is DynamoDB?** | Fully managed, serverless NoSQL database with single-digit millisecond performance at any scale  |
| **What data models does DynamoDB support?** | Key-value and document data models  |
| **What are the two types of primary keys?** | Simple (partition key only) and composite (partition key + sort key)  |
| **What is the difference between Query and Scan?** | Query requires partition key and is efficient; Scan reads entire table and is expensive  |
| **What are RCUs and WCUs?** | Read Capacity Units and Write Capacity Units for provisioned capacity  |

### **Intermediate Level**

| Question | Answer |
|----------|--------|
| **How do you choose a good partition key?** | High cardinality, even distribution, avoid monotonically increasing values  |
| **What is a Global Secondary Index (GSI)?** | Index with different partition key, can be created anytime, has its own throughput  |
| **What is a Local Secondary Index (LSI)?** | Index with same partition key but different sort key, must be created at table creation  |
| **What is DynamoDB Streams?** | Time-ordered sequence of item-level changes, retained for 24 hours  |
| **What is DAX?** | In-memory cache for DynamoDB, up to 10x faster reads  |
| **What is the difference between On-Demand and Provisioned capacity?** | On-Demand: pay per request, automatic scaling; Provisioned: set throughput, Auto Scaling available  |

### **Advanced Level**

| Question | Answer |
|----------|--------|
| **How do you handle hot partitions?** | Use higher cardinality partition keys, implement write sharding, use cache (DAX)  |
| **What is single table design and why use it?** | Store multiple entity types in one table to reduce reads and complexity  |
| **How do DynamoDB transactions work?** | ACID across up to 100 items within same account and region  |
| **What is point-in-time recovery (PITR)?** | Continuous backups for last 35 days, restore to any second  |
| **How does Global Tables achieve multi-region replication?** | Active-active replication using DynamoDB Streams, last-writer-wins conflict resolution  |

### **Scenario-Based Questions**

**Q: Design a leaderboard for a game with millions of players.** 
> **A:** Use a DynamoDB table with game ID as partition key, player score as sort key (descending). Query with `ScanIndexForward=false` to get top scores. For real-time updates, use DynamoDB Streams to update aggregate tables.

**Q: How would you model an e-commerce shopping cart?** 
> **A:** Single table design with user ID as partition key, "CART" + timestamp as sort key. Store cart items as a list or map within the item. Use transactions for checkout operations.

**Q: Your application is experiencing throttling. What do you check?** 
> **A:** Check CloudWatch metrics for throttled events, identify hot partitions, review partition key distribution, consider increasing capacity or using DAX for reads.

**Q: How do you migrate data from an RDBMS to DynamoDB?** 
> **A:** Analyze access patterns first, denormalize data, use single table design, export to CSV/JSON, use DynamoDB import feature or write custom migration code.

---

## **22. QUICK REFERENCE CHEAT SHEET**

### **Maven Dependencies** 

```xml
<dependency>
    <groupId>software.amazon.awssdk</groupId>
    <artifactId>dynamodb</artifactId>
    <version>2.31.26</version>
</dependency>
```

### **Create DynamoDB Client**

```java
DynamoDbClient dynamoDbClient = DynamoDbClient.builder()
    .region(Region.US_WEST_2)
    .build();
```

### **CRUD Operations** 

```java
// PutItem
Item item = new Item().withPrimaryKey("Id", 123).withString("Name", "Product");
table.putItem(item);

// GetItem
Item result = table.getItem("Id", 123);

// UpdateItem
UpdateItemSpec spec = new UpdateItemSpec()
    .withPrimaryKey("Id", 123)
    .withUpdateExpression("SET Price = :price")
    .withValueMap(new ValueMap().withNumber(":price", 99.99));
table.updateItem(spec);

// DeleteItem
table.deleteItem("Id", 123);
```

### **Query Examples** 

```java
// Query by partition key
QueryRequest request = QueryRequest.builder()
    .tableName("Orders")
    .keyConditionExpression("userId = :uid")
    .expressionAttributeValues(Map.of(":uid", AttributeValue.builder().s("user123").build()))
    .build();

// Query with sort key condition
QueryRequest request2 = QueryRequest.builder()
    .tableName("Orders")
    .keyConditionExpression("userId = :uid AND orderDate BETWEEN :from AND :to")
    .expressionAttributeValues(Map.of(
        ":uid", AttributeValue.fromS("user123"),
        ":from", AttributeValue.fromS("2024-01-01"),
        ":to", AttributeValue.fromS("2024-12-31")
    ))
    .build();
```

### **Capacity Calculation** 

```java
// RCU calculation
// 1 RCU = 1 strongly consistent read/sec for 4KB items
// 1 RCU = 2 eventually consistent reads/sec for 4KB items

// WCU calculation
// 1 WCU = 1 write/sec for 1KB items
// For 5KB item, need 5 WCU
```

### **Secondary Index Query** 

```java
QueryRequest request = QueryRequest.builder()
    .tableName("Orders")
    .indexName("customerId-index")
    .keyConditionExpression("customerId = :cid")
    .expressionAttributeValues(Map.of(
        ":cid", AttributeValue.builder().s("cust123").build()
    ))
    .build();
```

### **Transaction Example** 

```java
TransactWriteItemsRequest request = TransactWriteItemsRequest.builder()
    .transactItems(
        TransactWriteItem.builder()
            .update(Update.builder()
                .tableName("Accounts")
                .key(Map.of("accountId", AttributeValue.fromS("acc1")))
                .updateExpression("SET balance = balance - :amt")
                .conditionExpression("balance >= :amt")
                .build())
            .build(),
        TransactWriteItem.builder()
            .update(Update.builder()
                .tableName("Accounts")
                .key(Map.of("accountId", AttributeValue.fromS("acc2")))
                .updateExpression("SET balance = balance + :amt")
                .build())
            .build()
    )
    .expressionAttributeValues(Map.of(
        ":amt", AttributeValue.fromN("100")
    ))
    .build();
```

---

## **📝 KEY TAKEAWAYS**

1. **Serverless by design** – No servers to manage, auto-scaling, pay-per-request 
2. **Know your access patterns first** – Design tables based on how you'll query 
3. **Partition key is critical** – Choose high cardinality keys to avoid hot partitions 
4. **Composite keys enable flexibility** – Partition key + sort key for efficient queries 
5. **Indexes for alternative patterns** – GSIs for different access patterns (can add anytime) 
6. **Single table design** – Store multiple entity types in one table for efficiency 
7. **DAX for microsecond reads** – In-memory cache for read-heavy workloads 
8. **Global Tables for multi-region** – Active-active replication with 99.999% availability 
9. **Transactions for ACID** – Across multiple items and tables 
10. **Streams for event-driven** – Capture changes for real-time processing 

---

*Good luck with your DynamoDB interview! 📊🎉*