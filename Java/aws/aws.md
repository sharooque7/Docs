# Complete AWS Services Guide for Java SDE II - The Ultimate Interview Reference ☁️

*Your comprehensive go-to reference for essential AWS services with explanations, Java examples, and interview-focused insights*

---

## **📋 TABLE OF CONTENTS**

1. [AWS Fundamentals](#1-aws-fundamentals)
2. [Compute Services](#2-compute-services)
3. [Storage Services](#3-storage-services)
4. [Database Services](#4-database-services)
5. [Networking & Content Delivery](#5-networking--content-delivery)
6. [Security, Identity & Compliance](#6-security-identity--compliance)
7. [Application Integration](#7-application-integration)
8. [Monitoring & Management](#8-monitoring--management)
9. [Developer Tools & CI/CD](#9-developer-tools--cicd)
10. [Caching & Performance](#10-caching--performance)
11. [Architecture Patterns & Best Practices](#11-architecture-patterns--best-practices)
12. [Common Interview Questions](#12-common-interview-questions)
13. [Quick Reference Cheat Sheet](#13-quick-reference-cheat-sheet)

---

## **1. AWS FUNDAMENTALS**

### **1.1 What is AWS?**

> **Concept:** Amazon Web Services (AWS) is a comprehensive cloud computing platform providing over 200 fully featured services across computing, storage, databases, networking, and more . It allows businesses to rent computing resources instead of investing in physical hardware .

### **1.2 Global Infrastructure**

| Component | Description | Key Points |
|-----------|-------------|------------|
| **Region** | Geographic area with multiple AZs | Choose based on latency, compliance, cost |
| **Availability Zone (AZ)** | Isolated data center within a region  | Physically separate, connected via low-latency links |
| **Edge Location** | CDN endpoint for CloudFront | 400+ locations globally |

### **1.3 Shared Responsibility Model**

> **Concept:** AWS is responsible for security **OF** the cloud (physical infrastructure, hardware, foundational services). You are responsible for security **IN** the cloud (data, access management, OS patching, application configuration) .

```
┌─────────────────────────────────────────────────┐
│               CUSTOMER RESPONSIBILITY           │
│  • Data, encryption, OS patching                 │
│  • IAM roles & policies                          │
│  • Firewall & network configuration              │
└─────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────┐
│                 AWS RESPONSIBILITY               │
│  • Physical hardware & data centers              │
│  • Global network infrastructure                 │
│  • Foundational services (compute, storage)      │
└─────────────────────────────────────────────────┘
```

---

## **2. COMPUTE SERVICES**

### **2.1 Amazon EC2 (Elastic Compute Cloud)**

> **Purpose:** Virtual servers in the cloud. Provides resizable compute capacity with complete control over the OS and environment .

#### **Key Concepts**

| Term | Description |
|------|-------------|
| **Instance** | Virtual server with configurable CPU, memory, storage |
| **AMI** | Preconfigured template for instances |
| **Instance Type** | Family optimized for workloads (t2.micro, c5.large, r5, etc.) |
| **Security Group** | Virtual firewall controlling instance traffic |
| **Key Pair** | SSH keys for secure login |

#### **Instance Types **

| Family | Use Case | Examples |
|--------|----------|----------|
| **General Purpose** | Balanced compute/memory | t3, m5 |
| **Compute Optimized** | High-performance processors | c5, c6g |
| **Memory Optimized** | Memory-intensive workloads | r5, x1e |
| **Storage Optimized** | High I/O operations | i3, d2 |
| **Accelerated Computing** | GPU workloads | p3, g4 |

#### **Pricing Models **

| Model | Description | Best For |
|-------|-------------|----------|
| **On-Demand** | Pay per hour/second | Flexible, short-term workloads |
| **Reserved** | 1-3 year commitment | Steady-state, predictable usage |
| **Spot** | Up to 90% off, can be interrupted | Fault-tolerant, batch jobs |

#### **Java SDK Example **

```java
import com.amazonaws.services.ec2.AmazonEC2;
import com.amazonaws.services.ec2.AmazonEC2ClientBuilder;
import com.amazonaws.services.ec2.model.*;

public class EC2Example {
    public static void main(String[] args) {
        // Create EC2 client
        AmazonEC2 ec2 = AmazonEC2ClientBuilder.standard()
                .withRegion("us-west-2")
                .build();
        
        // Launch EC2 instance
        RunInstancesRequest request = new RunInstancesRequest()
                .withImageId("ami-0c55b159cbfafe1f0")
                .withInstanceType(InstanceType.T2Micro)
                .withMinCount(1)
                .withMaxCount(1)
                .withKeyName("my-key-pair")
                .withSecurityGroupIds("sg-12345678");
        
        RunInstancesResult result = ec2.runInstances(request);
        String instanceId = result.getReservation().getInstances().get(0).getInstanceId();
        System.out.println("Launched instance: " + instanceId);
        
        // List instances
        DescribeInstancesResult instances = ec2.describeInstances();
        instances.getReservations().forEach(reservation -> 
            reservation.getInstances().forEach(instance -> 
                System.out.println("Instance: " + instance.getInstanceId() + 
                                 ", State: " + instance.getState().getName())
            )
        );
        
        // Start/Stop instance
        ec2.startInstances(new StartInstancesRequest().withInstanceIds(instanceId));
        ec2.stopInstances(new StopInstancesRequest().withInstanceIds(instanceId));
        ec2.terminateInstances(new TerminateInstancesRequest().withInstanceIds(instanceId));
    }
}
```

#### **Interview Tips **

| Scenario | Choose EC2 when... |
|----------|-------------------|
| **Long-running processes** | Need persistent servers |
| **Custom OS configuration** | Need root access, specific kernel modules |
| **Legacy applications** | Can't containerize or run serverless |
| **Regulatory requirements** | Need dedicated hosts |

### **2.2 AWS Lambda**

> **Purpose:** Serverless compute service that runs code without provisioning or managing servers. Pay only for compute time consumed (billed by millisecond) .

#### **Key Features **

- **Event-driven**: Triggered by S3 events, API Gateway, SQS, CloudWatch schedules
- **Automatic scaling**: Scales from 0 to thousands of concurrent executions
- **No infrastructure management**: AWS handles servers, OS, patches
- **Cold starts**: First invocation may have latency (1-10 seconds)

#### **Supported Languages**

Java, Python, Node.js, Go, Ruby, .NET, Custom Runtimes

#### **Java Example**

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.S3Event;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

public class S3EventProcessor implements RequestHandler<S3Event, String> {
    
    private final AmazonS3 s3 = AmazonS3ClientBuilder.defaultClient();
    
    @Override
    public String handleRequest(S3Event event, Context context) {
        context.getLogger().log("Processing S3 event");
        
        // Get bucket and key from event
        String bucket = event.getRecords().get(0).getS3().getBucket().getName();
        String key = event.getRecords().get(0).getS3().getObject().getKey();
        
        try {
            // Read file from S3
            var s3Object = s3.getObject(bucket, key);
            var reader = new BufferedReader(
                new InputStreamReader(s3Object.getObjectContent(), StandardCharsets.UTF_8)
            );
            
            String line;
            while ((line = reader.readLine()) != null) {
                context.getLogger().log("Processing: " + line);
                // Process each line
            }
            
            return "Processed " + key;
        } catch (Exception e) {
            context.getLogger().log("Error: " + e.getMessage());
            throw new RuntimeException(e);
        }
    }
}
```

#### **EC2 vs Lambda Comparison **

| Aspect | EC2 | Lambda |
|--------|-----|--------|
| **Management** | Full control (OS, updates, scaling) | Fully managed, no server concerns |
| **Pricing** | Per hour (instance running) | Per request + compute duration (milliseconds) |
| **Scaling** | Manual or Auto Scaling | Automatic, instant |
| **Duration** | Any | Max 15 minutes |
| **Use Cases** | Long-running apps, databases | Event-driven, short tasks, APIs |

### **2.3 Amazon ECS & EKS**

> **Purpose:** Container orchestration services .

| Service | Description | Use Case |
|---------|-------------|----------|
| **ECS** | Amazon's container orchestration | Docker containers, simpler AWS integration |
| **EKS** | Managed Kubernetes service | Kubernetes-native workloads, portability |
| **Fargate** | Serverless compute for containers | No cluster management needed |

---

## **3. STORAGE SERVICES**

### **3.1 Amazon S3 (Simple Storage Service)**

> **Purpose:** Object storage service for storing and retrieving any amount of data from anywhere . Provides 99.999999999% (11 9's) durability .

#### **Storage Classes **

| Class | Use Case | Retrieval Time |
|-------|----------|----------------|
| **S3 Standard** | Frequently accessed data | Milliseconds |
| **S3 Intelligent-Tiering** | Unknown/Changing access patterns | Milliseconds |
| **S3 Standard-IA** | Infrequent access, needs fast retrieval | Milliseconds (but retrieval fee) |
| **S3 One Zone-IA** | Non-critical, infrequent data | Milliseconds |
| **S3 Glacier Instant Retrieval** | Archive with immediate access | Milliseconds |
| **S3 Glacier Flexible Retrieval** | Long-term archive | Minutes to hours |
| **S3 Glacier Deep Archive** | Longest-term archive | 12+ hours |

#### **Java SDK Example **

```java
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.*;

public class S3Example {
    
    public static void main(String[] args) {
        // Initialize S3 client
        BasicAWSCredentials awsCreds = new BasicAWSCredentials("ACCESS_KEY", "SECRET_KEY");
        AmazonS3 s3Client = AmazonS3ClientBuilder.standard()
                .withCredentials(new AWSStaticCredentialsProvider(awsCreds))
                .withRegion("us-west-2")
                .build();
        
        // List buckets
        List<Bucket> buckets = s3Client.listBuckets();
        buckets.forEach(bucket -> 
            System.out.println("Bucket: " + bucket.getName())
        );
        
        // Upload object
        String bucketName = "my-java-app-bucket";
        String key = "data/file.txt";
        
        s3Client.putObject(bucketName, key, "Hello, S3 from Java!");
        System.out.println("Uploaded: " + key);
        
        // Download object
        S3Object object = s3Client.getObject(bucketName, key);
        S3ObjectInputStream inputStream = object.getObjectContent();
        // Read inputStream...
        
        // Generate pre-signed URL (temporary access)
        java.util.Date expiration = new java.util.Date();
        long expTimeMillis = expiration.getTime() + 3600000; // 1 hour
        expiration.setTime(expTimeMillis);
        
        GeneratePresignedUrlRequest generatePresignedUrlRequest = 
                new GeneratePresignedUrlRequest(bucketName, key)
                .withMethod(HttpMethod.GET)
                .withExpiration(expiration);
        
        java.net.URL url = s3Client.generatePresignedUrl(generatePresignedUrlRequest);
        System.out.println("Pre-signed URL: " + url);
    }
}
```

#### **Common Use Cases **

- **Static website hosting**: Store HTML, CSS, JS, serve publicly
- **File storage**: User uploads, images, videos
- **Backup & archive**: Database backups, log archival
- **Data lake**: Raw data storage for analytics
- **Signed URLs**: Temporary access to private files

### **3.2 Amazon EBS (Elastic Block Store)**

> **Purpose:** Persistent block storage volumes for EC2 instances .

| Type | Use Case |
|------|----------|
| **gp2/gp3** | General purpose SSD |
| **io1/io2** | Provisioned IOPS for databases |
| **st1** | Throughput-optimized HDD |
| **sc1** | Cold HDD, infrequent access |

**Key Point**: EBS persists independently of EC2 instance lifecycle. Can be backed up as snapshots to S3.

### **3.3 Amazon EFS (Elastic File System)**

> **Purpose:** Scalable, elastic file storage for Linux-based EC2 instances . Can be mounted by multiple instances simultaneously.

---

## **4. DATABASE SERVICES**

### **4.1 Amazon RDS (Relational Database Service)**

> **Purpose:** Managed relational database service supporting multiple engines .

#### **Supported Engines**
- MySQL
- PostgreSQL
- MariaDB
- Oracle
- SQL Server
- Amazon Aurora (MySQL/PostgreSQL-compatible)

#### **Key Features **

| Feature | Description |
|---------|-------------|
| **Automated backups** | Point-in-time recovery, automated snapshots |
| **Multi-AZ** | Synchronous standby replica for high availability |
| **Read Replicas** | Asynchronous replicas for read scaling |
| **Storage auto-scaling** | Automatically grows storage |
| **Performance Insights** | Database performance monitoring |

#### **RDS vs Traditional Database **

| Aspect | Traditional DB | RDS |
|--------|----------------|-----|
| **Administration** | Manual provisioning, patching, backups | Automated |
| **Scaling** | Manual hardware upgrades | Easy via API |
| **High Availability** | Manual setup, complex | Multi-AZ with automatic failover |
| **Backups** | Custom scripts | Automated, point-in-time |

#### **RDS vs Aurora **

| Feature | RDS | Aurora |
|---------|-----|--------|
| **Architecture** | Traditional database engine on EC2 | AWS-optimized distributed storage |
| **Performance** | Standard | 5x faster than MySQL, 3x than PostgreSQL |
| **Storage** | EBS-based | Distributed, 6 copies across 3 AZs |
| **Failover** | Minutes | 30-60 seconds |
| **Scaling** | Vertical only | Auto-scaling storage up to 128TB |

### **4.2 Amazon DynamoDB**

> **Purpose:** Fully managed NoSQL key-value and document database for single-digit millisecond performance at any scale .

#### **Key Concepts**

| Term | Description |
|------|-------------|
| **Table** | Collection of items |
| **Item** | Group of attributes (max 400KB) |
| **Primary Key** | Partition key or partition + sort key |
| **GSI** | Global Secondary Index for alternate query patterns |
| **LSI** | Local Secondary Index (same partition key) |

#### **Capacity Modes **

| Mode | Description | Best For |
|------|-------------|----------|
| **On-Demand** | Pay per request, automatic scaling | Unpredictable workloads |
| **Provisioned** | Set read/write capacity, auto-scaling optional | Predictable workloads |

#### **Java SDK Example**

```java
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.dynamodb.model.*;
import java.util.HashMap;
import java.util.Map;

public class DynamoDBExample {
    
    private final DynamoDbClient dynamoDbClient;
    
    public DynamoDBExample() {
        this.dynamoDbClient = DynamoDbClient.builder()
                .region(Region.US_WEST_2)
                .build();
    }
    
    // Put item
    public void putUser(String userId, String name, String email) {
        Map<String, AttributeValue> item = new HashMap<>();
        item.put("userId", AttributeValue.builder().s(userId).build());
        item.put("name", AttributeValue.builder().s(name).build());
        item.put("email", AttributeValue.builder().s(email).build());
        item.put("createdAt", AttributeValue.builder().n(String.valueOf(System.currentTimeMillis())).build());
        
        PutItemRequest request = PutItemRequest.builder()
                .tableName("Users")
                .item(item)
                .build();
        
        dynamoDbClient.putItem(request);
        System.out.println("User created: " + userId);
    }
    
    // Get item
    public Map<String, AttributeValue> getUser(String userId) {
        GetItemRequest request = GetItemRequest.builder()
                .tableName("Users")
                .key(Map.of("userId", AttributeValue.builder().s(userId).build()))
                .build();
        
        GetItemResponse response = dynamoDbClient.getItem(request);
        return response.item();
    }
    
    // Query with index
    public List<Map<String, AttributeValue>> queryByEmail(String email) {
        QueryRequest request = QueryRequest.builder()
                .tableName("Users")
                .indexName("email-index")
                .keyConditionExpression("email = :email")
                .expressionAttributeValues(Map.of(
                    ":email", AttributeValue.builder().s(email).build()
                ))
                .build();
        
        QueryResponse response = dynamoDbClient.query(request);
        return response.items();
    }
}
```

#### **RDS vs DynamoDB **

| Aspect | RDS | DynamoDB |
|--------|-----|----------|
| **Data Model** | Relational (tables, joins) | NoSQL (key-value, document) |
| **Schema** | Fixed, predefined | Schemaless |
| **Performance** | Disk I/O bound | Single-digit millisecond at any scale |
| **Scaling** | Vertical + read replicas | Horizontal, automatic |
| **Query Capabilities** | Complex joins, aggregations | Simple key lookups, limited filters |

### **4.3 Amazon ElastiCache**

> **Purpose:** In-memory caching service supporting Redis and Memcached .

#### **Use Cases**
- Database query result caching
- Session management
- Real-time leaderboards
- Message queues (Redis pub/sub)

---

## **5. NETWORKING & CONTENT DELIVERY**

### **5.1 Amazon VPC (Virtual Private Cloud)**

> **Purpose:** Logically isolated virtual network where you launch AWS resources .

#### **Key Components **

| Component | Description |
|-----------|-------------|
| **Subnet** | Range of IP addresses within VPC |
| **Route Table** | Rules directing network traffic |
| **Internet Gateway** | Enables internet access for public subnets |
| **NAT Gateway** | Allows private subnets to access internet |
| **Security Group** | Stateful firewall at instance level |
| **NACL** | Stateless firewall at subnet level |

#### **Public vs Private Subnets **

| Aspect | Public Subnet | Private Subnet |
|--------|---------------|----------------|
| **Internet Access** | Yes (via IGW) | No direct access |
| **Use Cases** | ALB/ELB, Bastion Host, NAT Gateway | Application servers, Databases |
| **Route Table** | 0.0.0.0/0 → IGW | 0.0.0.0/0 → NAT Gateway (optional) |

#### **Security Group vs NACL **

| Feature | Security Group | NACL |
|---------|---------------|------|
| **Level** | Instance-level | Subnet-level |
| **State** | Stateful | Stateless |
| **Rules** | Allow only | Allow/Deny |
| **Evaluation** | All rules evaluated | Rule number order |

### **5.2 Elastic Load Balancing (ELB)**

> **Purpose:** Automatically distributes incoming traffic across multiple targets .

| Type | Layer | Use Case |
|------|-------|----------|
| **ALB (Application LB)** | Layer 7 | HTTP/HTTPS traffic, path-based routing |
| **NLB (Network LB)** | Layer 4 | TCP/UDP, extreme performance |
| **CLB (Classic LB)** | Legacy | Previous generation |

### **5.3 Amazon CloudFront**

> **Purpose:** Content Delivery Network (CDN) for low-latency content delivery .

#### **Features**
- Global edge locations
- DDoS protection (AWS Shield)
- Lambda@Edge for custom logic
- SSL/TLS termination

---

## **6. SECURITY, IDENTITY & COMPLIANCE**

### **6.1 AWS IAM (Identity and Access Management)**

> **Purpose:** Centrally manage access to AWS services and resources .

#### **Core Components **

| Component | Description |
|-----------|-------------|
| **User** | Person or application with permanent credentials |
| **Group** | Collection of users with shared permissions |
| **Role** | Temporary permissions for AWS services or federated users |
| **Policy** | JSON document defining permissions |
| **MFA** | Multi-factor authentication for extra security |

#### **IAM Policy Example **

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::my-app-bucket",
        "arn:aws:s3:::my-app-bucket/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "dynamodb:Query",
      "Resource": "arn:aws:dynamodb:us-west-2:123456789012:table/Users"
    },
    {
      "Effect": "Deny",
      "Action": "s3:DeleteObject",
      "Resource": "arn:aws:s3:::my-app-bucket/*"
    }
  ]
}
```

#### **Java SDK IAM Example**

```java
import com.amazonaws.services.identitymanagement.AmazonIdentityManagement;
import com.amazonaws.services.identitymanagement.AmazonIdentityManagementClientBuilder;
import com.amazonaws.services.identitymanagement.model.*;

public class IAMExample {
    
    private final AmazonIdentityManagement iam = AmazonIdentityManagementClientBuilder.defaultClient();
    
    public void createUser(String userName) {
        CreateUserRequest request = new CreateUserRequest()
                .withUserName(userName);
        CreateUserResult result = iam.createUser(request);
        System.out.println("Created user: " + result.getUser().getUserId());
    }
    
    public void attachPolicy(String userName, String policyArn) {
        AttachUserPolicyRequest request = new AttachUserPolicyRequest()
                .withUserName(userName)
                .withPolicyArn(policyArn);
        iam.attachUserPolicy(request);
    }
    
    public void createRole(String roleName, String trustPolicy) {
        CreateRoleRequest request = new CreateRoleRequest()
                .withRoleName(roleName)
                .withAssumeRolePolicyDocument(trustPolicy);
        CreateRoleResult result = iam.createRole(request);
        System.out.println("Created role: " + result.getRole().getArn());
    }
}
```

#### **IAM Best Practices **

| Practice | Why |
|----------|-----|
| **Least privilege** | Grant only necessary permissions |
| **Use roles, not users** | For services, prefer roles |
| **Enable MFA** | Critical for privileged users |
| **Rotate credentials** | Regular key rotation |
| **No hardcoded secrets** | Use Instance Profiles for EC2 |

### **6.2 AWS KMS (Key Management Service)**

> **Purpose:** Create and manage encryption keys for data encryption .

#### **Integration with**
- S3 Server-Side Encryption
- EBS volume encryption
- RDS encryption
- Lambda environment variables

---

## **7. APPLICATION INTEGRATION**

### **7.1 Amazon SQS (Simple Queue Service)**

> **Purpose:** Fully managed message queuing service for decoupling application components .

#### **Queue Types **

| Type | Description | Throughput |
|------|-------------|------------|
| **Standard** | Best-effort ordering, at-least-once delivery | Unlimited |
| **FIFO** | Exactly-once processing, guaranteed order | 3000 messages/sec |

#### **Java SDK Example **

```java
import com.amazonaws.services.sqs.AmazonSQS;
import com.amazonaws.services.sqs.AmazonSQSClientBuilder;
import com.amazonaws.services.sqs.model.*;

public class SQSExample {
    
    private final AmazonSQS sqs = AmazonSQSClientBuilder.defaultClient();
    
    public String createQueue(String queueName) {
        CreateQueueRequest request = new CreateQueueRequest(queueName);
        CreateQueueResult result = sqs.createQueue(request);
        return result.getQueueUrl();
    }
    
    public void sendMessage(String queueUrl, String message) {
        SendMessageRequest request = new SendMessageRequest(queueUrl, message);
        sqs.sendMessage(request);
    }
    
    public void sendMessageWithDelay(String queueUrl, String message, int delaySeconds) {
        SendMessageRequest request = new SendMessageRequest(queueUrl, message)
                .withDelaySeconds(delaySeconds);
        sqs.sendMessage(request);
    }
    
    public List<Message> receiveMessages(String queueUrl) {
        ReceiveMessageRequest request = new ReceiveMessageRequest(queueUrl)
                .withMaxNumberOfMessages(10)
                .withVisibilityTimeout(30)
                .withWaitTimeSeconds(20); // Long polling
                
        ReceiveMessageResult result = sqs.receiveMessage(request);
        return result.getMessages();
    }
    
    public void deleteMessage(String queueUrl, Message message) {
        DeleteMessageRequest request = new DeleteMessageRequest(queueUrl, message.getReceiptHandle());
        sqs.deleteMessage(request);
    }
    
    // Dead Letter Queue configuration
    public void configureDeadLetterQueue(String sourceQueueUrl, String deadLetterQueueUrl) {
        GetQueueAttributesResult attributes = sqs.getQueueAttributes(
            new GetQueueAttributesRequest(sourceQueueUrl)
                .withAttributeNames("QueueArn")
        );
        
        String deadLetterQueueArn = sqs.getQueueAttributes(
            new GetQueueAttributesRequest(deadLetterQueueUrl)
                .withAttributeNames("QueueArn")
        ).getAttributes().get("QueueArn");
        
        Map<String, String> redrivePolicy = new HashMap<>();
        redrivePolicy.put("deadLetterTargetArn", deadLetterQueueArn);
        redrivePolicy.put("maxReceiveCount", "5");
        
        try {
            sqs.setQueueAttributes(new SetQueueAttributesRequest()
                .withQueueUrl(sourceQueueUrl)
                .addAttributesEntry("RedrivePolicy", 
                    new com.fasterxml.jackson.databind.ObjectMapper().writeValueAsString(redrivePolicy)));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

### **7.2 Amazon SNS (Simple Notification Service)**

> **Purpose:** Pub/sub messaging service for sending notifications to subscribers .

#### **Subscriber Types**
- SQS queues
- Lambda functions
- HTTP/HTTPS endpoints
- Email
- SMS
- Mobile push

### **7.3 Amazon EventBridge**

> **Purpose:** Serverless event bus for connecting application data from AWS services and SaaS applications .

---

## **8. MONITORING & MANAGEMENT**

### **8.1 Amazon CloudWatch**

> **Purpose:** Monitoring service for AWS resources and applications .

#### **What CloudWatch Monitors **

| Category | Examples |
|----------|----------|
| **Metrics** | CPU, memory, disk I/O, network |
| **Logs** | Application logs, system logs |
| **Events** | AWS resource state changes |
| **Alarms** | Trigger actions based on thresholds |

#### **Java SDK Example**

```java
import com.amazonaws.services.cloudwatch.AmazonCloudWatch;
import com.amazonaws.services.cloudwatch.AmazonCloudWatchClientBuilder;
import com.amazonaws.services.cloudwatch.model.*;

public class CloudWatchExample {
    
    private final AmazonCloudWatch cloudWatch = AmazonCloudWatchClientBuilder.defaultClient();
    
    public void putCustomMetric(String namespace, String metricName, double value) {
        PutMetricDataRequest request = new PutMetricDataRequest()
                .withNamespace(namespace)
                .withMetricData(new MetricDatum()
                        .withMetricName(metricName)
                        .withValue(value)
                        .withUnit(StandardUnit.Count));
        
        cloudWatch.putMetricData(request);
    }
    
    public void createAlarm(String alarmName, String metricName, double threshold) {
        PutMetricAlarmRequest request = new PutMetricAlarmRequest()
                .withAlarmName(alarmName)
                .withComparisonOperator(ComparisonOperator.GreaterThanThreshold)
                .withEvaluationPeriods(2)
                .withMetricName(metricName)
                .withNamespace("AWS/EC2")
                .withPeriod(300) // 5 minutes
                .withStatistic(Statistic.Average)
                .withThreshold(threshold)
                .withActionsEnabled(true)
                .withAlarmActions("arn:aws:sns:us-west-2:123456789012:NotifyMe");
        
        cloudWatch.putMetricAlarm(request);
    }
}
```

### **8.2 AWS CloudTrail**

> **Purpose:** Audit API activity across AWS account .

#### **Use Cases**
- Security analysis
- Compliance auditing
- Operational troubleshooting

### **8.3 AWS X-Ray**

> **Purpose:** Distributed tracing for microservices applications . Helps debug performance issues and service dependencies.

---

## **9. DEVELOPER TOOLS & CI/CD**

### **9.1 AWS CodePipeline**

> **Purpose:** Fully managed continuous delivery service orchestrating build, test, and deploy phases .

### **9.2 AWS CodeBuild**

> **Purpose:** Fully managed build service compiling source code and running tests .

### **9.3 AWS CodeDeploy**

> **Purpose:** Automates code deployments to EC2, Lambda, or on-premises instances .

#### **Deployment Strategies**

| Strategy | Description |
|----------|-------------|
| **In-place** | Stop instances, deploy, restart |
| **Blue/Green** | New environment, switch traffic |
| **Canary** | Gradual traffic shifting |
| **Linear** | Incremental deployment |

---

## **10. CACHING & PERFORMANCE**

### **10.1 Amazon ElastiCache for Redis**

> **Purpose:** In-memory data store for caching, session management, and real-time analytics .

#### **Java Example with Jedis**

```java
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

public class ElastiCacheExample {
    
    private final JedisPool jedisPool;
    
    public ElastiCacheExample(String redisEndpoint, int port) {
        JedisPoolConfig poolConfig = new JedisPoolConfig();
        poolConfig.setMaxTotal(50);
        poolConfig.setMaxIdle(10);
        
        this.jedisPool = new JedisPool(poolConfig, redisEndpoint, port, 2000);
    }
    
    public void cacheUserSession(String sessionId, String userData) {
        try (Jedis jedis = jedisPool.getResource()) {
            jedis.setex("session:" + sessionId, 3600, userData); // 1 hour TTL
        }
    }
    
    public String getUserSession(String sessionId) {
        try (Jedis jedis = jedisPool.getResource()) {
            return jedis.get("session:" + sessionId);
        }
    }
    
    public void cacheQueryResult(String queryHash, String result, int ttlSeconds) {
        try (Jedis jedis = jedisPool.getResource()) {
            jedis.setex("query:" + queryHash, ttlSeconds, result);
        }
    }
    
    public void close() {
        jedisPool.close();
    }
}
```

---

## **11. ARCHITECTURE PATTERNS & BEST PRACTICES**

### **11.1 High Availability Architecture **

```
User → Route 53 → CloudFront → ALB (Multi-AZ) → Auto Scaling Group → RDS Multi-AZ
                                          ↓                         ↓
                                    EC2 Instances              Read Replica
                                    (App Tier)
```

#### **Key Components**

| Component | Purpose |
|-----------|---------|
| **Route 53** | DNS with health checks and failover |
| **CloudFront** | CDN, edge caching |
| **ALB** | Traffic distribution, health checks |
| **Auto Scaling** | Automatically adjust capacity |
| **Multi-AZ** | Resources across multiple AZs |
| **RDS Multi-AZ** | Database failover |

### **11.2 Microservices Patterns**

#### **Service Discovery**
- AWS Cloud Map
- ECS/EKS service discovery

#### **API Gateway Pattern**
```
Client → Amazon API Gateway → Lambda → DynamoDB
                           → ECS → RDS
                           → SQS → Lambda
```

#### **Event-Driven Architecture**
```
S3 Upload → S3 Event → SQS Queue → Lambda → DynamoDB
                       ↓           ↓
                     Dead Letter  Error Handler
                     Queue
```

### **11.3 Caching Strategy**

```
Request → CloudFront (Edge Cache) → ALB → ElastiCache (Redis) → DynamoDB
                                        ↓
                                    Cache miss → Query DB → Update cache
```

### **11.4 Security Best Practices **

| Practice | Implementation |
|----------|----------------|
| **Least privilege** | IAM roles with minimal permissions |
| **Network isolation** | Private subnets for databases |
| **Encryption at rest** | S3 SSE, EBS encryption, RDS encryption |
| **Encryption in transit** | TLS/SSL for all services |
| **Secrets management** | AWS Secrets Manager, Parameter Store |
| **No hardcoded credentials** | Instance profiles, Lambda environment variables |

### **11.5 Cost Optimization **

| Strategy | Action |
|----------|--------|
| **Right-sizing** | Use Compute Optimizer recommendations |
| **Spot Instances** | For fault-tolerant, flexible workloads |
| **S3 Lifecycle** | Move data to cheaper tiers |
| **Auto Scaling** | Scale down during low demand |
| **Reserved Instances** | Commit for steady-state workloads |

---

## **12. COMMON INTERVIEW QUESTIONS**

### **Basic Level**

| Question | Answer |
|----------|--------|
| **What is AWS?** | Comprehensive cloud platform providing compute, storage, database, and other services on-demand  |
| **What's the difference between EC2 and Lambda?** | EC2: full control over VMs, long-running; Lambda: serverless, event-driven, short-running  |
| **What is S3 and its storage classes?** | Object storage with 11 9s durability; classes: Standard, IA, Glacier, etc.  |
| **What is IAM?** | Identity and Access Management for controlling access to AWS resources  |
| **What are Availability Zones?** | Physically isolated data centers within a region  |

### **Intermediate Level**

| Question | Answer |
|----------|--------|
| **EC2 vs Lambda - when to use which?** | EC2: long-running apps, custom OS, predictable load; Lambda: event-driven, variable load, no ops  |
| **RDS vs DynamoDB?** | RDS: relational, complex queries, ACID; DynamoDB: NoSQL, key-value, massive scale, single-digit ms  |
| **How does Auto Scaling work?** | Monitors CloudWatch metrics, adjusts EC2 capacity based on policies  |
| **What's a VPC and its components?** | Virtual network with subnets, route tables, gateways, security groups  |
| **How to make an application highly available?** | Multi-AZ, ELB, Auto Scaling, RDS Multi-AZ  |

### **Advanced Level**

| Question | Answer |
|----------|--------|
| **How to design a fault-tolerant system?** | Distribute across AZs, use ELB, Auto Scaling, health checks, circuit breakers, retries, dead letter queues |
| **How to handle database consistency in distributed systems?** | DynamoDB transactions, RDS ACID, eventual consistency patterns, idempotency |
| **EC2, ECS, Lambda comparison for microservices?** | EC2: full control; ECS: container orchestration; Lambda: serverless, event-driven  |
| **How to implement caching in AWS?** | CloudFront (edge), ElastiCache (Redis/Memcached), DynamoDB DAX |
| **How to secure data in transit and at rest?** | TLS/SSL, KMS encryption, IAM roles, VPC endpoints  |

### **Scenario-Based Questions**

**Q: Your web app experiences traffic spikes. How do you handle it?**
> A: Use Auto Scaling with CloudWatch alarms to add instances during spikes, ELB to distribute traffic, and ElastiCache to reduce database load. Consider serverless for variable workloads.

**Q: How would you migrate an on-premise MySQL database to AWS?**
> A: Options: AWS DMS (Database Migration Service) for minimal downtime, create RDS instance and import backup, or use Aurora MySQL for better performance.

**Q: Design a serverless image processing pipeline.**
> A: S3 upload triggers Lambda → Lambda processes image → Stores result in S3 → Updates DynamoDB metadata → CloudFront serves optimized images.

**Q: How do you reduce costs for a non-production environment?**
> A: Use instance scheduling to stop instances overnight, spot instances for batch jobs, S3 lifecycle policies, delete unused resources.

---

## **13. QUICK REFERENCE CHEAT SHEET**

```java
// ========== EC2 ==========
// Add Maven dependency
<dependency>
    <groupId>com.amazonaws</groupId>
    <artifactId>aws-java-sdk-ec2</artifactId>
    <version>1.12.500</version>
</dependency>

// Create EC2 client
AmazonEC2 ec2 = AmazonEC2ClientBuilder.standard()
        .withRegion("us-west-2")
        .build();

// ========== S3 ==========
<dependency>
    <groupId>com.amazonaws</groupId>
    <artifactId>aws-java-sdk-s3</artifactId>
    <version>1.12.500</version>
</dependency>

AmazonS3 s3 = AmazonS3ClientBuilder.standard().build();
s3.putObject("bucket", "key", "content");
S3Object obj = s3.getObject("bucket", "key");

// ========== DynamoDB ==========
<dependency>
    <groupId>software.amazon.awssdk</groupId>
    <artifactId>dynamodb</artifactId>
    <version>2.20.0</version>
</dependency>

DynamoDbClient dynamoDb = DynamoDbClient.builder().build();

// ========== Lambda ==========
// Handler template
public class Handler implements RequestHandler<S3Event, String> {
    public String handleRequest(S3Event event, Context context) {
        return "Success";
    }
}

// ========== SQS ==========
<dependency>
    <groupId>com.amazonaws</groupId>
    <artifactId>aws-java-sdk-sqs</artifactId>
    <version>1.12.500</version>
</dependency>

AmazonSQS sqs = AmazonSQSClientBuilder.defaultClient();
sqs.sendMessage(queueUrl, message);

// ========== CloudWatch ==========
<dependency>
    <groupId>com.amazonaws</groupId>
    <artifactId>aws-java-sdk-cloudwatch</artifactId>
    <version>1.12.500</version>
</dependency>

AmazonCloudWatch cloudWatch = AmazonCloudWatchClientBuilder.defaultClient();

// ========== IAM ==========
<dependency>
    <groupId>com.amazonaws</groupId>
    <artifactId>aws-java-sdk-iam</artifactId>
    <version>1.12.500</version>
</dependency>

AmazonIdentityManagement iam = AmazonIdentityManagementClientBuilder.defaultClient();

// ========== Kinesis ==========
<dependency>
    <groupId>com.amazonaws</groupId>
    <artifactId>aws-java-sdk-kinesis</artifactId>
    <version>1.12.500</version>
</dependency>
```

### **AWS Service Decision Tree**

```
┌──────────────────────────────────────────────────────────┐
│                    WHAT'S YOUR USE CASE?                  │
└──────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌───────────────┐    ┌───────────────┐    ┌───────────────┐
│   COMPUTE      │    │    STORAGE    │    │   DATABASE    │
├───────────────┤    ├───────────────┤    ├───────────────┤
│ • Long-running│    │ • Files/images│    │ • Relational  │
│   → EC2       │    │   → S3        │    │   → RDS       │
│ • Event-driven│    │ • Block storage│   │ • NoSQL       │
│   → Lambda    │    │   → EBS       │    │   → DynamoDB  │
│ • Containers  │    │ • Shared files│    │ • Cache       │
│   → ECS/EKS   │    │   → EFS       │    │   → ElastiCache│
└───────────────┘    └───────────────┘    └───────────────┘
```

---

## **📝 KEY TAKEAWAYS**

1. **Compute** – EC2 for control, Lambda for serverless, ECS/EKS for containers 
2. **Storage** – S3 for objects, EBS for block, EFS for shared files 
3. **Database** – RDS for relational, DynamoDB for NoSQL, ElastiCache for caching 
4. **Networking** – VPC for isolation, subnets for tiers, security groups for firewalls 
5. **Security** – IAM for access control, least privilege principle, roles for services 
6. **Integration** – SQS for queues, SNS for notifications, EventBridge for event bus 
7. **Monitoring** – CloudWatch for metrics/alarms, CloudTrail for audit, X-Ray for tracing 
8. **High Availability** – Multi-AZ, ELB, Auto Scaling, health checks 
9. **Cost Optimization** – Right-sizing, spot instances, reserved instances, lifecycle policies 
10. **SDK Usage** – Always use credential providers, never hardcode keys, handle exceptions 

---

*Good luck with your AWS interview! ☁️🎉*