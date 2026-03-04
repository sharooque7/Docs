# Complete AWS Lambda Guide - The Ultimate Interview Reference ⚡

*Your comprehensive go-to reference for AWS Lambda with explanations, Java examples, and interview-focused insights*

---

## **📋 TABLE OF CONTENTS**

1. [What is AWS Lambda?](#1-what-is-aws-lambda)
2. [Lambda vs Traditional Compute](#2-lambda-vs-traditional-compute)
3. [Core Concepts](#3-core-concepts)
4. [Function Configuration](#4-function-configuration)
5. [Execution Environment](#5-execution-environment)
6. [Event Sources & Invocation Types](#6-event-sources--invocation-types)
7. [Lambda with Java](#7-lambda-with-java)
8. [Handler Signatures](#8-handler-signatures)
9. [Context Object](#9-context-object)
10. [Environment Variables](#10-environment-variables)
11. [Lambda Layers](#11-lambda-layers)
12. [VPC Integration](#12-vpc-integration)
13. [IAM Permissions & Roles](#13-iam-permissions--roles)
14. [Concurrency & Scaling](#14-concurrency--scaling)
15. [Cold Starts & Performance](#15-cold-starts--performance)
16. [Monitoring & Logging](#16-monitoring--logging)
17. [Error Handling & Retries](#17-error-handling--retries)
18. [Lambda Destinations](#18-lambda-destinations)
19. [Best Practices](#19-best-practices)
20. [Common Use Cases](#20-common-use-cases)
21. [Limits & Quotas](#21-limits--quotas)
22. [Lambda vs Other Compute Services](#22-lambda-vs-other-compute-services)
23. [Common Interview Questions](#23-common-interview-questions)
24. [Quick Reference Cheat Sheet](#24-quick-reference-cheat-sheet)

---

## **1. WHAT IS AWS LAMBDA?**

> **Concept:** AWS Lambda is a serverless, event-driven compute service that lets you run code without provisioning or managing servers. You pay only for the compute time you consume – no charge when your code isn't running .

```java
// The simplest Lambda function in Java
public class SimpleHandler implements RequestHandler<String, String> {
    @Override
    public String handleRequest(String input, Context context) {
        return "Hello, " + input;
    }
}
```

### **Key Characteristics**

| Characteristic | Description |
|----------------|-------------|
| **Serverless** | No servers to provision, patch, or manage |
| **Event-Driven** | Triggers in response to events from 200+ AWS services |
| **Auto-Scaling** | Scales automatically from zero to thousands of concurrent executions |
| **Pay-per-use** | Billed only for execution time (rounded to nearest millisecond) |
| **Stateless** | No persistent local storage between invocations |
| **Language Support** | Java, Python, Node.js, Go, Ruby, .NET, Custom Runtimes |

---

## **2. LAMBDA VS TRADITIONAL COMPUTE**

> **Concept:** Understanding the key differences between Lambda and traditional compute models is crucial for architecture decisions .

### **Lambda vs EC2**

| Aspect | Lambda | EC2 |
|--------|--------|-----|
| **Management** | Fully managed (no servers) | You manage OS, patches, scaling |
| **Scaling** | Automatic, instant | Manual or Auto Scaling groups |
| **Pricing** | Per millisecond execution | Per hour (regardless of usage) |
| **Execution time** | Max 15 minutes | Unlimited |
| **Memory** | Up to 10GB | Up to 24TB (RAM) |
| **Storage** | /tmp (512MB to 10GB) | EBS volumes (any size) |
| **Startup time** | Cold starts (milliseconds to seconds) | Always running (no cold start) |
| **Use case** | Event-driven, short-running tasks | Long-running, stateful applications |

### **Lambda vs ECS/Fargate**

| Aspect | Lambda | Fargate |
|--------|--------|---------|
| **Granularity** | Single function | Containerized application |
| **Execution model** | Event-driven | Continuous running |
| **Scaling** | Instant per invocation | Service-based scaling |
| **Packaging** | Code + dependencies (250MB) | Container images (any size) |
| **Warm containers** | Cold starts possible | Always warm if running |
| **Cost** | Per invocation | Per hour for vCPU/memory |

### **Lambda vs Step Functions**

| Aspect | Lambda | Step Functions |
|--------|--------|----------------|
| **Purpose** | Execute code | Orchestrate workflows |
| **State management** | Stateless | Manages state between steps |
| **Duration** | Max 15 minutes per execution | Up to 1 year |
| **Complexity** | Single task | Multi-step, branching, parallel |

---

## **3. CORE CONCEPTS**

> **Concept:** Lambda has several fundamental concepts that define how functions operate .

### **Lambda Anatomy**

```
┌─────────────────────────────────────────────┐
│           LAMBDA FUNCTION                    │
├─────────────────────────────────────────────┤
│  ┌───────────────────────────────────────┐ │
│  │         HANDLER CODE                   │ │
│  │  (Your business logic)                 │ │
│  └───────────────────────────────────────┘ │
├─────────────────────────────────────────────┤
│  ┌───────────────────────────────────────┐ │
│  │         ENVIRONMENT VARIABLES          │ │
│  │  Database URLs, API keys, config      │ │
│  └───────────────────────────────────────┘ │
├─────────────────────────────────────────────┤
│  ┌───────────────────────────────────────┐ │
│  │          LAYERS                         │ │
│  │  Dependencies, shared code, runtimes   │ │
│  └───────────────────────────────────────┘ │
├─────────────────────────────────────────────┤
│  ┌───────────────────────────────────────┐ │
│  │      TRIGGERS / EVENT SOURCES          │ │
│  │  S3, DynamoDB, API Gateway, SQS       │ │
│  └───────────────────────────────────────┘ │
└─────────────────────────────────────────────┘
```

### **Lambda Execution Model**

1. **Event Source** triggers the function
2. **Lambda service** allocates resources
3. **Handler** executes with event data
4. **Result** returned to caller (if synchronous)
5. **Logs** sent to CloudWatch

### **Key Terminology**

| Term | Definition |
|------|------------|
| **Handler** | Entry point method that executes on invocation |
| **Event** | JSON-formatted data passed to the function |
| **Context** | Runtime information about the invocation |
| **Cold Start** | Delay when invoking a new function instance |
| **Warm Container** | Reused execution environment |
| **Concurrency** | Number of simultaneous executions |

---

## **4. FUNCTION CONFIGURATION**

> **Concept:** Lambda functions are configured with specific resources and settings that impact performance and cost .

### **Core Configuration Settings**

| Setting | Range/Options | Description |
|---------|---------------|-------------|
| **Memory** | 128MB to 10,240MB | Allocated memory (CPU scales proportionally) |
| **Timeout** | 1 second to 15 minutes | Maximum execution time |
| **Ephemeral Storage** | 512MB to 10GB | `/tmp` directory space |
| **IAM Role** | Required | Permissions for the function |
| **VPC** | Optional | Access resources in VPC |
| **Environment Variables** | 4KB total | Key-value configuration |
| **Layers** | Up to 5 layers | Dependency management |

### **Memory and CPU Relationship**

```java
// CPU power scales with memory
// More memory = more CPU
// Example: 1,769MB gives 1 vCPU, 3,538MB gives 2 vCPUs

public class MemoryOptimization {
    // For CPU-intensive tasks, allocate more memory
    // For I/O-bound tasks, minimal memory may be sufficient
}
```

### **Timeout Configuration**

```java
// Java example of handling timeout gracefully
public class TimeoutHandler implements RequestHandler<String, String> {
    
    private static final long TIMEOUT_BUFFER_MS = 5000; // 5 seconds buffer
    
    @Override
    public String handleRequest(String input, Context context) {
        long startTime = System.currentTimeMillis();
        long timeout = context.getRemainingTimeInMillis();
        
        // Monitor remaining time
        if (System.currentTimeMillis() - startTime > timeout - TIMEOUT_BUFFER_MS) {
            // Clean up and prepare to exit
            return "Partial result";
        }
        
        // Continue processing
        return "Complete result";
    }
}
```

---

## **5. EXECUTION ENVIRONMENT**

> **Concept:** Lambda maintains execution environments for a period after invocation to reduce latency for subsequent requests .

### **Cold Start vs Warm Start**

```
Time
│
├── First invocation (COLD START)
│   │
│   ├── Download code (S3)
│   ├── Start JVM (Java specific)
│   ├── Load classes
│   ├── Initialize static context
│   └── Execute handler → 2-5 seconds
│
├── Second invocation (WARM START)  
│   │
│   ├── Reuse existing container
│   ├── Handler executes → 100-500ms
│   └── Container stays alive for ~5-15 minutes
│
└── Third invocation (REUSED)
    │
    └── Immediate execution
```

### **Java-Specific Cold Start Considerations**

```java
// ❌ BAD: Heavy initialization in handler
public class BadHandler implements RequestHandler<String, String> {
    @Override
    public String handleRequest(String input, Context context) {
        // This happens on EVERY invocation
        DatabaseConnection conn = new DatabaseConnection(); // Expensive!
        return process(input, conn);
    }
}

// ✅ GOOD: Initialize once, reuse across invocations
public class GoodHandler implements RequestHandler<String, String> {
    
    // Static initialization runs ONCE per container
    private static final DatabaseConnection CONN;
    
    static {
        CONN = new DatabaseConnection(); // Happens during cold start only
    }
    
    @Override
    public String handleRequest(String input, Context context) {
        // Reuse existing connection
        return process(input, CONN);
    }
}
```

### **Execution Environment Lifecycle**

```java
public class LifecycleHandler implements RequestHandler<String, String> {
    
    // 1. Static initialization (once per container)
    private static final String STATIC_DATA = loadData();
    
    // 2. Instance initialization (once per instance)
    private final Object instanceData = new Object();
    
    // 3. Constructor (once per instance)
    public LifecycleHandler() {
        System.out.println("Constructor called");
    }
    
    @Override
    public String handleRequest(String input, Context context) {
        // 4. Handler execution (per invocation)
        System.out.println("Handler called");
        return "Result";
    }
    
    // 5. Shutdown (when container is destroyed)
    @Override
    protected void finalize() {
        System.out.println("Cleaning up");
    }
}
```

---

## **6. EVENT SOURCES & INVOCATION TYPES**

> **Concept:** Lambda functions can be invoked by over 200 AWS services through different invocation patterns .

### **Invocation Types**

| Type | Description | Use Case |
|------|-------------|----------|
| **Synchronous** | Caller waits for response | API Gateway, direct invocation |
| **Asynchronous** | Lambda queues event, returns immediately | S3, SNS, EventBridge |
| **Polling** | Lambda polls source on your behalf | SQS, DynamoDB Streams, Kinesis |

### **Synchronous Invocation**

```java
// Direct invocation using AWS SDK
public class SyncInvocationExample {
    public void invokeLambda() {
        LambdaClient lambda = LambdaClient.create();
        
        InvokeRequest request = InvokeRequest.builder()
            .functionName("my-function")
            .payload(SdkBytes.fromUtf8String("{\"key\":\"value\"}"))
            .invocationType(InvocationType.REQUEST_RESPONSE) // Synchronous
            .build();
        
        InvokeResponse response = lambda.invoke(request);
        String result = response.payload().asUtf8String();
    }
}
```

### **Asynchronous Invocation**

```java
// Lambda will retry failed invocations twice (total 3 attempts)
// Dead Letter Queue can capture failed events
public class AsyncExample {
    public void invokeAsync() {
        LambdaClient lambda = LambdaClient.create();
        
        InvokeRequest request = InvokeRequest.builder()
            .functionName("my-function")
            .payload(SdkBytes.fromUtf8String("{\"key\":\"value\"}"))
            .invocationType(InvocationType.EVENT) // Asynchronous
            .build();
        
        lambda.invoke(request); // Returns immediately
    }
}
```

### **Common Event Sources**

| Service | Invocation Type | Common Use Case |
|---------|-----------------|-----------------|
| **API Gateway** | Synchronous | REST APIs |
| **S3** | Asynchronous | Image processing on upload |
| **DynamoDB Streams** | Polling | Real-time analytics |
| **SQS** | Polling | Message processing |
| **SNS** | Asynchronous | Notification processing |
| **EventBridge** | Asynchronous | Scheduled tasks, events |
| **CloudWatch Logs** | Asynchronous | Log processing |
| **Alexa** | Synchronous | Voice skills |

### **S3 Event Example**

```java
// S3 event handler for image processing
public class S3EventHandler implements RequestHandler<S3Event, String> {
    
    private final AmazonS3 s3Client = AmazonS3ClientBuilder.defaultClient();
    
    @Override
    public String handleRequest(S3Event event, Context context) {
        S3EventNotification.S3Entity s3Entity = event.getRecords().get(0).getS3();
        
        String bucket = s3Entity.getBucket().getName();
        String key = s3Entity.getObject().getKey();
        
        // Process image
        S3Object image = s3Client.getObject(bucket, key);
        processImage(image);
        
        return "OK";
    }
    
    private void processImage(S3Object image) {
        // Image processing logic
    }
}
```

### **SQS Event Example**

```java
public class SQSEventHandler implements RequestHandler<SQSEvent, Void> {
    
    @Override
    public Void handleRequest(SQSEvent event, Context context) {
        for (SQSEvent.SQSMessage message : event.getRecords()) {
            try {
                processMessage(message.getBody());
                // If success, Lambda automatically deletes from queue
            } catch (Exception e) {
                // If failure, message becomes visible again after visibility timeout
                throw new RuntimeException("Processing failed", e);
            }
        }
        return null;
    }
    
    private void processMessage(String message) {
        // Business logic
    }
}
```

### **API Gateway Event Example**

```java
public class APIGatewayHandler implements RequestHandler<APIGatewayProxyRequestEvent, 
                                                         APIGatewayProxyResponseEvent> {
    
    @Override
    public APIGatewayProxyResponseEvent handleRequest(
            APIGatewayProxyRequestEvent request, Context context) {
        
        String path = request.getPath();
        Map<String, String> headers = request.getHeaders();
        String body = request.getBody();
        
        // Business logic
        String responseBody = "Processed: " + body;
        
        return new APIGatewayProxyResponseEvent()
            .withStatusCode(200)
            .withBody(responseBody)
            .withHeaders(Map.of("Content-Type", "application/json"));
    }
}
```

---

## **7. LAMBDA WITH JAVA**

> **Concept:** Java is a first-class language for Lambda with full support for all features, though it requires attention to cold start optimization .

### **Java Runtime Options**

| Runtime | Java Version | Description |
|---------|--------------|-------------|
| **java8** | Java 8 | Original Java runtime |
| **java8.al2** | Java 8 (Corretto) | Amazon Linux 2 based |
| **java11** | Java 11 | Long-term support version |
| **java17** | Java 17 | Current LTS version |
| **java21** | Java 21 | Latest LTS version |

### **Project Structure**

```
my-lambda-project/
├── src/
│   └── main/
│       └── java/
│           └── com/
│               └── example/
│                   └── Handler.java
├── pom.xml (or build.gradle)
└── template.yaml (optional, for SAM)
```

### **Maven Dependencies**

```xml
<dependencies>
    <!-- AWS Lambda Core -->
    <dependency>
        <groupId>com.amazonaws</groupId>
        <artifactId>aws-lambda-java-core</artifactId>
        <version>1.2.2</version>
    </dependency>
    
    <!-- AWS Lambda Events -->
    <dependency>
        <groupId>com.amazonaws</groupId>
        <artifactId>aws-lambda-java-events</artifactId>
        <version>3.11.1</version>
    </dependency>
    
    <!-- AWS SDK (if needed) -->
    <dependency>
        <groupId>com.amazonaws</groupId>
        <artifactId>aws-java-sdk-s3</artifactId>
        <version>1.12.500</version>
    </dependency>
    
    <!-- Logging -->
    <dependency>
        <groupId>org.apache.logging.log4j</groupId>
        <artifactId>log4j-core</artifactId>
        <version>2.20.0</version>
    </dependency>
</dependencies>

<build>
    <plugins>
        <!-- Shade plugin for fat JAR -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-shade-plugin</artifactId>
            <version>3.4.1</version>
            <executions>
                <execution>
                    <phase>package</phase>
                    <goals>
                        <goal>shade</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

### **Gradle Dependencies**

```gradle
dependencies {
    implementation 'com.amazonaws:aws-lambda-java-core:1.2.2'
    implementation 'com.amazonaws:aws-lambda-java-events:3.11.1'
    implementation 'com.amazonaws:aws-java-sdk-s3:1.12.500'
    implementation 'org.apache.logging.log4j:log4j-core:2.20.0'
}

task buildZip(type: Zip) {
    from compileJava
    from processResources
    into('lib') {
        from configurations.runtimeClasspath
    }
}
```

### **Building and Packaging**

```bash
# Maven
mvn clean package

# Gradle
gradle buildZip

# Output files
target/lambda-java-example-1.0-SNAPSHOT.jar  # Fat JAR with dependencies
```

---

## **8. HANDLER SIGNATURES**

> **Concept:** The handler is the entry point method that Lambda calls when your function is invoked. It can follow several signature patterns .

### **Handler Interface Options**

| Interface | Input Type | Output Type | Description |
|-----------|------------|-------------|-------------|
| **RequestHandler<I, O>** | Any | Any | Process input, return output |
| **RequestStreamHandler** | InputStream | OutputStream | Handle raw byte streams |
| **Custom method** | Any | Any | Flexible method signature |

### **RequestHandler Interface**

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

public class StringHandler implements RequestHandler<String, String> {
    
    @Override
    public String handleRequest(String input, Context context) {
        // Lambda automatically deserializes JSON to String
        return "Processed: " + input;
    }
}

// With custom POJO
public class User {
    private String name;
    private int age;
    // getters and setters
}

public class UserHandler implements RequestHandler<User, UserResponse> {
    
    @Override
    public UserResponse handleRequest(User user, Context context) {
        // Automatically deserializes JSON to User object
        return new UserResponse("Hello " + user.getName());
    }
}
```

### **RequestStreamHandler Interface**

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestStreamHandler;
import com.fasterxml.jackson.databind.ObjectMapper;

public class StreamHandler implements RequestStreamHandler {
    
    private final ObjectMapper mapper = new ObjectMapper();
    
    @Override
    public void handleRequest(InputStream input, OutputStream output, Context context) 
            throws IOException {
        
        // Read raw input
        byte[] bytes = input.readAllBytes();
        String rawRequest = new String(bytes);
        
        // Process
        String result = "Processed: " + rawRequest;
        
        // Write raw output
        output.write(result.getBytes());
    }
}
```

### **Custom Method Handler**

```java
public class CustomMethodHandler {
    
    // Can have any name, but must match handler configuration
    public String myHandler(String name, Context context) {
        return "Hello " + name;
    }
    
    // With custom types
    public ApiResponse processOrder(OrderRequest request, Context context) {
        // Business logic
        return new ApiResponse("Order processed");
    }
}
```

### **Handler Configuration**

```yaml
# In SAM template.yaml
Resources:
  MyFunction:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: target/my-lambda.jar
      Handler: com.example.CustomMethodHandler::myHandler
      Runtime: java17
      MemorySize: 1024
      Timeout: 30
```

```json
// Direct Lambda configuration
{
  "Handler": "com.example.CustomMethodHandler::myHandler",
  "Runtime": "java17"
}
```

---

## **9. CONTEXT OBJECT**

> **Concept:** The `Context` object provides runtime information about the Lambda function execution environment .

### **Context Methods**

| Method | Description | Example Value |
|--------|-------------|---------------|
| `getAwsRequestId()` | Unique invocation ID | "123e4567-e89b-12d3-a456-426614174000" |
| `getLogGroupName()` | CloudWatch Log group | "/aws/lambda/my-function" |
| `getLogStreamName()` | CloudWatch Log stream | "2024/02/27/[$LATEST]1234" |
| `getFunctionName()` | Function name | "my-function" |
| `getFunctionVersion()` | Function version | "$LATEST" |
| `getInvokedFunctionArn()` | Full ARN | "arn:aws:lambda:..." |
| `getMemoryLimitInMB()` | Configured memory | 1024 |
| `getRemainingTimeInMillis()` | Time left | 15000 (15 seconds) |
| `getIdentity()` | Cognito identity | CognitoIdentity object |
| `getClientContext()` | Client info | ClientContext object |
| `getLogger()` | Lambda logger | LambdaLogger |

### **Using Context in Handler**

```java
public class ContextHandler implements RequestHandler<String, String> {
    
    @Override
    public String handleRequest(String input, Context context) {
        
        LambdaLogger logger = context.getLogger();
        
        // Log invocation details
        logger.log("Request ID: " + context.getAwsRequestId());
        logger.log("Function: " + context.getFunctionName());
        logger.log("Remaining time: " + context.getRemainingTimeInMillis() + "ms");
        
        // Check remaining time before long operations
        if (context.getRemainingTimeInMillis() < 5000) {
            logger.log("Not enough time remaining, aborting");
            return "Partial result";
        }
        
        // Process based on memory allocation
        int memory = context.getMemoryLimitInMB();
        if (memory >= 2048) {
            // Use more aggressive processing
            processLargeDataset();
        } else {
            processSmallDataset();
        }
        
        return "Processed: " + input;
    }
    
    private void processLargeDataset() {
        // Memory-intensive operations
    }
    
    private void processSmallDataset() {
        // Memory-conservative operations
    }
}
```

### **Logger Usage**

```java
import com.amazonaws.services.lambda.runtime.LambdaLogger;

public class LoggingHandler implements RequestHandler<String, String> {
    
    @Override
    public String handleRequest(String input, Context context) {
        LambdaLogger logger = context.getLogger();
        
        // Simple logging
        logger.log("Processing started for: " + input);
        
        try {
            // Business logic
            String result = process(input);
            logger.log("Processing completed: " + result);
            return result;
        } catch (Exception e) {
            logger.log("Error: " + e.getMessage());
            throw new RuntimeException(e);
        }
    }
}
```

---

## **10. ENVIRONMENT VARIABLES**

> **Concept:** Environment variables provide a way to pass configuration to your Lambda function without changing code .

### **Setting Environment Variables**

```yaml
# SAM template.yaml
Properties:
  Environment:
    Variables:
      TABLE_NAME: Users
      STAGE: prod
      MAX_RETRIES: '3'
      API_ENDPOINT: https://api.example.com
```

```bash
# AWS CLI
aws lambda update-function-configuration \
    --function-name my-function \
    --environment Variables="{TABLE_NAME=Users,STAGE=prod}"
```

### **Reading Environment Variables in Java**

```java
public class EnvironmentHandler implements RequestHandler<String, String> {
    
    // Read at static initialization (once per container)
    private static final String TABLE_NAME = System.getenv("TABLE_NAME");
    private static final String STAGE = System.getenv("STAGE");
    private static final int MAX_RETRIES = Integer.parseInt(
        System.getenv().getOrDefault("MAX_RETRIES", "3")
    );
    
    private final DynamoDbClient dynamoDb;
    
    public EnvironmentHandler() {
        // Configure client based on environment
        this.dynamoDb = DynamoDbClient.builder()
            .region(Region.of(System.getenv("AWS_REGION")))
            .build();
    }
    
    @Override
    public String handleRequest(String input, Context context) {
        LambdaLogger logger = context.getLogger();
        
        logger.log("Table: " + TABLE_NAME);
        logger.log("Stage: " + STAGE);
        logger.log("Max retries: " + MAX_RETRIES);
        
        // Use configuration
        if ("prod".equals(STAGE)) {
            // Production-specific logic
        }
        
        return process(input);
    }
}
```

### **Environment Variables Best Practices**

| Practice | Example | Reason |
|----------|---------|--------|
| **Don't hardcode secrets** | Use environment variables | Keep secrets out of code |
| **Use default values** | `System.getenv().getOrDefault("VAR", "default")` | Fail gracefully |
| **Validate at startup** | Check required variables | Fail fast |
| **Type conversion** | Parse to appropriate types | Avoid runtime errors |

```java
public class ConfigValidation {
    
    private static final String DB_URL;
    private static final int PORT;
    private static final boolean ENABLED;
    
    static {
        // Validate required variables
        DB_URL = getRequiredEnv("DB_URL");
        
        // Parse with defaults
        PORT = Integer.parseInt(System.getenv().getOrDefault("PORT", "8080"));
        ENABLED = Boolean.parseBoolean(System.getenv().getOrDefault("ENABLED", "true"));
        
        // Validate PORT range
        if (PORT < 1024 || PORT > 65535) {
            throw new RuntimeException("Invalid PORT: " + PORT);
        }
    }
    
    private static String getRequiredEnv(String name) {
        String value = System.getenv(name);
        if (value == null || value.isEmpty()) {
            throw new RuntimeException("Missing required env var: " + name);
        }
        return value;
    }
}
```

---

## **11. LAMBDA LAYERS**

> **Concept:** Lambda layers are ZIP archives that contain libraries, custom runtimes, or other dependencies. Layers promote code reuse and reduce deployment package size .

### **Layer Benefits**

| Benefit | Description |
|---------|-------------|
| **Code Reuse** | Share common code across multiple functions |
| **Smaller Deployments** | Keep function code small, dependencies in layers |
| **Faster Deployments** | Upload only changed code, layers remain |
| **Version Management** | Version layers independently |
| **Language Extensions** | Add custom runtimes |

### **Layer Structure**

```
my-layer.zip
├── java/
│   └── lib/
│       ├── aws-sdk.jar
│       ├── jackson.jar
│       └── commons-lang.jar
├── lib/
│   └── native-lib.so
└── bin/
    └── custom-runtime
```

### **Creating a Layer**

```bash
# Create directory structure
mkdir -p java/lib

# Copy JAR files
cp target/dependency/*.jar java/lib/

# Create ZIP
zip -r my-layer.zip java/

# Publish layer
aws lambda publish-layer-version \
    --layer-name my-java-dependencies \
    --zip-file fileb://my-layer.zip \
    --compatible-runtimes java11 java17
```

### **Using Layer in Function**

```yaml
# SAM template.yaml
Resources:
  MyFunction:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: target/my-function.jar
      Handler: com.example.Handler::handleRequest
      Runtime: java17
      Layers:
        - arn:aws:lambda:us-west-2:123456789012:layer:my-java-dependencies:3
        - !Ref MyCustomLayer
```

### **Accessing Layer Content in Code**

```java
// Dependencies from layer are automatically available on classpath
import com.fasterxml.jackson.databind.ObjectMapper; // From layer
import software.amazon.awssdk.services.s3.S3Client; // From layer

public class LayerHandler implements RequestHandler<String, String> {
    
    private final ObjectMapper mapper = new ObjectMapper(); // From layer
    private final S3Client s3 = S3Client.create(); // From layer
    
    @Override
    public String handleRequest(String input, Context context) {
        // All dependencies are available
        return "Processed";
    }
}
```

### **Layer Limits**

| Limit | Value |
|-------|-------|
| **Layers per function** | Up to 5 layers |
| **Total unzipped size** | 250 MB (function + layers) |
| **Layer size** | Up to 50 MB (zipped) |

---

## **12. VPC INTEGRATION**

> **Concept:** Lambda functions can access resources inside a VPC, such as RDS databases, ElastiCache clusters, or EC2 instances .

### **VPC Configuration**

```yaml
# SAM template.yaml
Resources:
  MyFunction:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: target/my-function.jar
      Handler: com.example.Handler::handleRequest
      Runtime: java17
      VpcConfig:
        SecurityGroupIds:
          - sg-12345678
        SubnetIds:
          - subnet-12345678
          - subnet-87654321
```

### **Lambda in VPC Considerations**

| Aspect | Impact |
|--------|--------|
| **Internet Access** | No internet access unless NAT Gateway |
| **Cold Start** | ENI attachment adds latency (10-30 seconds) |
| **Concurrency** | ENIs limit scaling (max 250 ENIs per VPC) |
| **Cost** | NAT Gateway costs if internet access needed |

### **Java Example: Accessing RDS in VPC**

```java
public class VpcHandler implements RequestHandler<String, String> {
    
    private final DataSource dataSource;
    
    public VpcHandler() {
        // Configure database connection
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(System.getenv("DB_URL"));
        config.setUsername(System.getenv("DB_USER"));
        config.setPassword(System.getenv("DB_PASS"));
        config.setMaximumPoolSize(2); // Limit connections per instance
        config.setConnectionTimeout(3000);
        
        this.dataSource = new HikariDataSource(config);
    }
    
    @Override
    public String handleRequest(String input, Context context) {
        try (Connection conn = dataSource.getConnection()) {
            // Execute query
            try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT * FROM users WHERE id = ?")) {
                stmt.setString(1, input);
                ResultSet rs = stmt.executeQuery();
                return processResult(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Database error", e);
        }
    }
}
```

### **VPC Best Practices**

```java
public class VpcBestPractices {
    
    // 1. Use connection pooling
    private static final DataSource DATA_SOURCE = createDataSource();
    
    // 2. Limit concurrent connections
    private static final int MAX_CONNECTIONS = 2;
    
    // 3. Set reasonable timeouts
    private static DataSource createDataSource() {
        HikariConfig config = new HikariConfig();
        config.setMaximumPoolSize(MAX_CONNECTIONS);
        config.setConnectionTimeout(3000); // 3 seconds
        config.setValidationTimeout(2000);
        return new HikariDataSource(config);
    }
    
    // 4. Use VPC endpoints for AWS services
    // Instead of NAT Gateway, use VPC endpoints for S3, DynamoDB, etc.
    
    // 5. Monitor ENI usage
    // CloudWatch metric: `ENIConnections` in Lambda namespace
}
```

---

## **13. IAM PERMISSIONS & ROLES**

> **Concept:** Lambda functions need an IAM role that grants permissions to access AWS services and resources .

### **IAM Role Structure**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

### **Common Permission Policies**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      // CloudWatch Logs permissions (required)
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      // S3 permissions
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::my-bucket/*"
    },
    {
      // DynamoDB permissions
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:Query"
      ],
      "Resource": "arn:aws:dynamodb:us-west-2:123456789012:table/Users"
    }
  ]
}
```

### **Java Example: Using Permissions**

```java
public class PermissionsHandler implements RequestHandler<String, String> {
    
    private final S3Client s3;
    private final DynamoDbClient dynamoDb;
    
    public PermissionsHandler() {
        // SDK automatically uses Lambda's IAM role
        this.s3 = S3Client.create();
        this.dynamoDb = DynamoDbClient.create();
    }
    
    @Override
    public String handleRequest(String input, Context context) {
        // These operations require proper IAM permissions
        
        // S3 operation (needs s3:GetObject)
        GetObjectRequest getRequest = GetObjectRequest.builder()
            .bucket("my-bucket")
            .key(input)
            .build();
        s3.getObject(getRequest);
        
        // DynamoDB operation (needs dynamodb:Query)
        QueryRequest queryRequest = QueryRequest.builder()
            .tableName("Users")
            .keyConditionExpression("userId = :uid")
            .expressionAttributeValues(Map.of(
                ":uid", AttributeValue.builder().s(input).build()
            ))
            .build();
        dynamoDb.query(queryRequest);
        
        return "Processed";
    }
}
```

### **Least Privilege Principle**

```yaml
# SAM template.yaml - Grant only needed permissions
Resources:
  MyFunctionRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: lambda.amazonaws.com
            Action: sts:AssumeRole
      Policies:
        - PolicyName: S3ReadAccess
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action:
                  - s3:GetObject
                Resource: !Sub 'arn:aws:s3:::${MyBucket}/*'
```

---

## **14. CONCURRENCY & SCALING**

> **Concept:** Lambda automatically scales your function by running multiple instances in parallel based on incoming requests .

### **Concurrency Types**

| Type | Description |
|------|-------------|
| **Reserved Concurrency** | Guaranteed maximum concurrency for a function |
| **Provisioned Concurrency** | Pre-initialized instances for no cold starts |
| **Unreserved Account Concurrency** | Remaining concurrency shared across functions |

### **Scaling Behavior**

```
┌─────────────────────────────────────────────────────┐
│                    SCALING MODEL                     │
├─────────────────────────────────────────────────────┤
│  Initial burst: 500-3000 concurrency (per region)   │
│  After burst: 500 per minute growth                 │
│  Total account limit: 1000 concurrent executions    │
└─────────────────────────────────────────────────────┘
```

### **Reserved Concurrency Configuration**

```yaml
# SAM template.yaml
Resources:
  MyFunction:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: target/my-function.jar
      Handler: com.example.Handler::handleRequest
      Runtime: java17
      ReservedConcurrentExecutions: 50
```

```java
// Setting concurrency with AWS SDK
public void configureConcurrency() {
    LambdaClient lambda = LambdaClient.create();
    
    PutFunctionConcurrencyRequest request = PutFunctionConcurrencyRequest.builder()
        .functionName("my-function")
        .reservedConcurrentExecutions(50)
        .build();
    
    lambda.putFunctionConcurrency(request);
}
```

### **Provisioned Concurrency**

```yaml
# SAM template.yaml
Resources:
  MyFunction:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: target/my-function.jar
      Handler: com.example.Handler::handleRequest
      Runtime: java17
      AutoPublishAlias: live
      ProvisionedConcurrencyConfig:
        ProvisionedConcurrentExecutions: 10
```

### **Scaling Considerations for Java**

```java
public class ScalingHandler implements RequestHandler<String, String> {
    
    // Static initialization runs once per concurrent instance
    private static final long INIT_TIME = System.currentTimeMillis();
    private static final int INSTANCE_ID = (int) (Math.random() * 1000);
    
    @Override
    public String handleRequest(String input, Context context) {
        // Each concurrent instance has its own copy of static variables
        return String.format("Instance %d processed %s", INSTANCE_ID, input);
    }
    
    // Monitor scaling through CloudWatch metrics
    // - ConcurrentExecutions
    // - Throttles
    // - ProvisionedConcurrencyUtilization
}
```

---

## **15. COLD STARTS & PERFORMANCE**

> **Concept:** Cold starts occur when Lambda initializes a new execution environment, which is especially important for Java functions .

### **Cold Start Components (Java)**

```
Cold Start Duration
├── Download code (50-500ms)
├── Start JVM (200-1000ms)
├── Class loading (300-2000ms)
├── Static initialization (100-1000ms)
├── Constructor (0-100ms)
└── Handler execution (varies)
Total: 1-5 seconds
```

### **Cold Start Optimization Strategies**

| Strategy | Implementation | Impact |
|----------|----------------|--------|
| **Increase memory** | Set higher memory | Faster JVM startup |
| **Minimize dependencies** | Use only needed JARs | Less class loading |
| **Lazy initialization** | Initialize on first use | Faster cold start |
| **SnapStart** | Lambda SnapStart (Java 11+) | Near-zero cold starts |
| **Provisioned concurrency** | Keep instances warm | No cold starts |

### **Lazy Initialization Example**

```java
public class LazyInitHandler implements RequestHandler<String, String> {
    
    // Use lazy initialization for expensive resources
    private static class LazyHolder {
        static final DynamoDbClient DYNAMO_DB = DynamoDbClient.create();
        static final ObjectMapper MAPPER = new ObjectMapper();
    }
    
    private DynamoDbClient getDynamoDb() {
        return LazyHolder.DYNAMO_DB;
    }
    
    private ObjectMapper getMapper() {
        return LazyHolder.MAPPER;
    }
    
    @Override
    public String handleRequest(String input, Context context) {
        // Resources initialized on first use, not during cold start
        DynamoDbClient dynamoDb = getDynamoDb();
        ObjectMapper mapper = getMapper();
        
        return "Processed";
    }
}
```

### **Lambda SnapStart (Java 11+)**

```java
// SnapStart takes a snapshot of the initialized environment
// Subsequent invocations start from snapshot (100-200ms)

public class SnapStartHandler implements RequestHandler<String, String> {
    
    // All initialization runs during snapshot creation
    private static final DynamoDbClient DYNAMO_DB = DynamoDbClient.create();
    private static final ObjectMapper MAPPER = new ObjectMapper();
    
    static {
        // Warm up connections, load data
        performWarmup();
    }
    
    @Override
    public String handleRequest(String input, Context context) {
        // Fast execution from snapshot
        return process(input);
    }
}
```

### **Memory and CPU Trade-off**

```java
public class MemoryOptimizer {
    
    // CPU scales with memory
    // 1792MB → 1 vCPU
    // 3008MB → 2 vCPUs
    // 4224MB → 3 vCPUs
    
    public void demonstrateScaling() {
        if (Runtime.getRuntime().availableProcessors() > 1) {
            // Use parallel processing
            parallelProcess();
        } else {
            // Single-threaded processing
            sequentialProcess();
        }
    }
}
```

---

## **16. MONITORING & LOGGING**

> **Concept:** Lambda integrates with CloudWatch for metrics, logs, and tracing .

### **CloudWatch Metrics**

| Metric | Description |
|--------|-------------|
| **Invocations** | Number of times function invoked |
| **Duration** | Execution time in milliseconds |
| **Errors** | Number of failed invocations |
| **Throttles** | Number of throttled invocations |
| **ConcurrentExecutions** | Number of concurrent instances |
| **IteratorAge** | Age of last record in stream (for stream sources) |

### **Custom Metrics**

```java
import software.amazon.awssdk.services.cloudwatch.CloudWatchClient;
import software.amazon.awssdk.services.cloudwatch.model.*;

public class MetricsHandler implements RequestHandler<String, String> {
    
    private final CloudWatchClient cloudWatch = CloudWatchClient.create();
    
    @Override
    public String handleRequest(String input, Context context) {
        long startTime = System.currentTimeMillis();
        
        try {
            String result = process(input);
            
            // Record success
            publishMetric("Success", 1, StandardUnit.COUNT);
            
            return result;
        } catch (Exception e) {
            // Record failure
            publishMetric("Failure", 1, StandardUnit.COUNT);
            throw e;
        } finally {
            // Record custom processing time
            long duration = System.currentTimeMillis() - startTime;
            publishMetric("ProcessingTime", duration, StandardUnit.MILLISECONDS);
        }
    }
    
    private void publishMetric(String metricName, double value, StandardUnit unit) {
        PutMetricDataRequest request = PutMetricDataRequest.builder()
            .namespace("Custom/MyApplication")
            .metricData(MetricDatum.builder()
                .metricName(metricName)
                .value(value)
                .unit(unit)
                .timestamp(Instant.now())
                .build())
            .build();
        
        cloudWatch.putMetricData(request);
    }
}
```

### **Structured Logging**

```java
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import com.fasterxml.jackson.databind.ObjectMapper;

public class StructuredLoggingHandler implements RequestHandler<String, String> {
    
    private static final Logger LOG = LogManager.getLogger(StructuredLoggingHandler.class);
    private final ObjectMapper mapper = new ObjectMapper();
    
    @Override
    public String handleRequest(String input, Context context) {
        // Structured logging (JSON format)
        Map<String, Object> logEntry = new HashMap<>();
        logEntry.put("requestId", context.getAwsRequestId());
        logEntry.put("functionName", context.getFunctionName());
        logEntry.put("input", input);
        logEntry.put("timestamp", Instant.now().toString());
        
        LOG.info(mapper.writeValueAsString(logEntry));
        
        try {
            String result = process(input);
            
            logEntry.put("result", result);
            logEntry.put("status", "SUCCESS");
            LOG.info(mapper.writeValueAsString(logEntry));
            
            return result;
        } catch (Exception e) {
            logEntry.put("error", e.getMessage());
            logEntry.put("status", "FAILURE");
            LOG.error(mapper.writeValueAsString(logEntry), e);
            throw e;
        }
    }
}
```

### **CloudWatch Logs Configuration**

```yaml
# SAM template.yaml
Resources:
  MyFunction:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: target/my-function.jar
      Handler: com.example.Handler::handleRequest
      Runtime: java17
      LoggingConfig:
        LogGroup: /aws/lambda/my-function
        LogFormat: JSON
        ApplicationLogLevel: INFO
        SystemLogLevel: WARN
```

### **X-Ray Tracing**

```java
import com.amazonaws.xray.AWSXRay;
import com.amazonaws.xray.entities.Subsegment;
import com.amazonaws.xray.entities.TraceHeader;

public class TracingHandler implements RequestHandler<String, String> {
    
    @Override
    public String handleRequest(String input, Context context) {
        // X-Ray is automatically enabled if configured
        
        // Create custom subsegment
        Subsegment subsegment = AWSXRay.beginSubsegment("processData");
        try {
            subsegment.putAnnotation("inputSize", input.length());
            
            String result = process(input);
            
            subsegment.putMetadata("result", result);
            return result;
        } catch (Exception e) {
            subsegment.addException(e);
            throw e;
        } finally {
            AWSXRay.endSubsegment();
        }
    }
}
```

---

## **17. ERROR HANDLING & RETRIES**

> **Concept:** Lambda provides built-in retry behavior and mechanisms for handling errors .

### **Retry Behavior by Invocation Type**

| Invocation Type | Retry Behavior |
|-----------------|----------------|
| **Synchronous** | No retries (client must retry) |
| **Asynchronous** | 2 retries (total 3 attempts) |
| **Stream-based** | Retries until success or expiration |
| **SQS** | Based on queue visibility timeout |

### **Asynchronous Invocation Retry Flow**

```
Event → Lambda
   │
   ├─ Success → Processed
   │
   ├─ Fail (1st) → Retry after 1 min
   │   │
   │   ├─ Success → Processed
   │   │
   │   └─ Fail (2nd) → Retry after 2 min
   │       │
   │       ├─ Success → Processed
   │       │
   │       └─ Fail (3rd) → DLQ or discard
```

### **Handling Errors in Code**

```java
public class ErrorHandler implements RequestHandler<String, String> {
    
    @Override
    public String handleRequest(String input, Context context) {
        LambdaLogger logger = context.getLogger();
        
        try {
            // Validate input
            if (input == null || input.isEmpty()) {
                // Return error response for API Gateway
                throw new IllegalArgumentException("Input cannot be empty");
            }
            
            // Process
            String result = process(input);
            
            // Success
            return result;
            
        } catch (IllegalArgumentException e) {
            // Client error - don't retry
            logger.log("Invalid input: " + e.getMessage());
            throw new RuntimeException("Invalid input", e);
            
        } catch (TemporaryException e) {
            // Temporary error - retry might help
            logger.log("Temporary error: " + e.getMessage());
            throw e; // Lambda will retry
            
        } catch (Exception e) {
            // Unexpected error
            logger.log("Unexpected error: " + e.getMessage());
            throw new RuntimeException(e);
        }
    }
    
    // Mark retryable exceptions
    public static class TemporaryException extends RuntimeException {
        public TemporaryException(String message) {
            super(message);
        }
    }
}
```

### **Dead Letter Queue (DLQ) Configuration**

```yaml
# SAM template.yaml
Resources:
  MyFunction:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: target/my-function.jar
      Handler: com.example.Handler::handleRequest
      Runtime: java17
      DeadLetterQueue:
        Type: SQS
        TargetArn: !GetAtt DeadLetterQueue.Arn
      
  DeadLetterQueue:
    Type: AWS::SQS::Queue
```

### **Processing DLQ Messages**

```java
public class DLQProcessor implements RequestHandler<SQSEvent, Void> {
    
    @Override
    public Void handleRequest(SQSEvent event, Context context) {
        for (SQSEvent.SQSMessage message : event.getRecords()) {
            try {
                // Attempt to reprocess
                String originalEvent = message.getBody();
                reprocess(originalEvent);
                
                // If successful, message is deleted automatically
            } catch (Exception e) {
                // Log failure and move to manual review
                logFailure(message, e);
                
                // Message will return to DLQ (configured redrive policy)
                throw new RuntimeException("Still failing", e);
            }
        }
        return null;
    }
}
```

### **Destination Configuration**

```yaml
# SAM template.yaml
Resources:
  MyFunction:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: target/my-function.jar
      Handler: com.example.Handler::handleRequest
      Runtime: java17
      EventInvokeConfig:
        DestinationConfig:
          OnSuccess:
            Type: SQS
            Destination: !GetAtt SuccessQueue.Arn
          OnFailure:
            Type: SNS
            Destination: !Ref FailureTopic
```

---

## **18. LAMBDA DESTINATIONS**

> **Concept:** Destinations allow you to route asynchronous invocation results to other AWS services without writing additional code .

### **Destination Types**

| Destination | Use Case |
|-------------|----------|
| **SQS** | Queue successful/failed events for processing |
| **SNS** | Send notifications on failures |
| **Lambda** | Chain functions together |
| **EventBridge** | Route events to multiple targets |

### **Destination Configuration**

```yaml
# SAM template.yaml
Resources:
  MyFunction:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: target/my-function.jar
      Handler: com.example.Handler::handleRequest
      Runtime: java17
      EventInvokeConfig:
        MaximumRetryAttempts: 2
        DestinationConfig:
          OnSuccess:
            Type: SQS
            Destination: !GetAtt SuccessQueue.Arn
          OnFailure:
            Type: SNS
            Destination: !Ref FailureTopic
```

### **Processing Destination Events**

```java
// Process successful events from queue
public class SuccessProcessor implements RequestHandler<SQSEvent, Void> {
    
    @Override
    public Void handleRequest(SQSEvent event, Context context) {
        for (SQSEvent.SQSMessage message : event.getRecords()) {
            // Message contains original event + response
            processSuccess(message.getBody());
        }
        return null;
    }
}

// Process failure events from topic
public class FailureProcessor implements RequestHandler<SNSEvent, Void> {
    
    @Override
    public Void handleRequest(SNSEvent event, Context context) {
        for (SNSEvent.SNSRecord record : event.getRecords()) {
            String message = record.getSNS().getMessage();
            // Contains error details and original event
            handleFailure(message);
        }
        return null;
    }
}
```

---

## **19. BEST PRACTICES**

> **Concept:** Following best practices ensures optimal performance, reliability, and cost efficiency with Lambda .

### **Code Organization**

```java
// ✅ GOOD: Separate concerns
public class BestPracticesHandler implements RequestHandler<String, String> {
    
    private final Service service;
    private final Validator validator;
    
    public BestPracticesHandler() {
        // Initialize dependencies in constructor
        this.service = new Service();
        this.validator = new Validator();
    }
    
    @Override
    public String handleRequest(String input, Context context) {
        // Validate early
        validator.validate(input);
        
        // Log with context
        context.getLogger().log("Processing: " + input);
        
        // Execute business logic
        String result = service.process(input);
        
        return result;
    }
}
```

### **Performance Checklist**

| Area | Best Practice |
|------|---------------|
| **Initialization** | Move expensive init outside handler |
| **Connections** | Reuse connections across invocations |
| **Memory** | Right-size memory (monitor usage) |
| **Timeouts** | Set appropriate timeout (don't guess) |
| **Dependencies** | Minimize JAR size, use layers |
| **Concurrency** | Set reserved concurrency for critical functions |

### **Connection Reuse Example**

```java
public class ConnectionPoolHandler implements RequestHandler<String, String> {
    
    // ✅ GOOD: Reuse connections across invocations
    private static final DynamoDbClient DYNAMO_DB = DynamoDbClient.create();
    private static final S3Client S3 = S3Client.create();
    private static final ObjectMapper MAPPER = new ObjectMapper();
    
    // ❌ BAD: Create new connections per invocation
    private DynamoDbClient getDynamoDb() {
        return DynamoDbClient.create(); // Don't do this!
    }
    
    @Override
    public String handleRequest(String input, Context context) {
        // Use static clients
        DYNAMO_DB.getItem(...);
        
        return "Processed";
    }
}
```

### **Error Handling Best Practices**

```java
public class RobustHandler implements RequestHandler<String, String> {
    
    @Override
    public String handleRequest(String input, Context context) {
        try {
            // Validate input
            if (input == null) {
                return createErrorResponse("Input required");
            }
            
            // Process with timeout awareness
            if (context.getRemainingTimeInMillis() < 5000) {
                return createErrorResponse("Insufficient time remaining");
            }
            
            // Business logic
            return process(input);
            
        } catch (RetryableException e) {
            // Will be retried by Lambda
            throw e;
        } catch (Exception e) {
            // Log and return error
            context.getLogger().log("Error: " + e.getMessage());
            return createErrorResponse("Internal error");
        }
    }
    
    private String createErrorResponse(String message) {
        return "{\"error\":\"" + message + "\"}";
    }
}
```

---

## **20. COMMON USE CASES**

> **Concept:** Lambda excels in specific scenarios where its event-driven, scalable nature provides maximum value .

### **Data Processing**

```java
// S3 file processing
public class ImageProcessor implements RequestHandler<S3Event, String> {
    
    @Override
    public String handleRequest(S3Event event, Context context) {
        for (S3EventNotification.S3EventNotificationRecord record : 
                event.getRecords()) {
            String bucket = record.getS3().getBucket().getName();
            String key = record.getS3().getObject().getKey();
            
            // Process image
            processImage(bucket, key);
        }
        return "OK";
    }
}
```

### **REST APIs**

```java
// API Gateway + Lambda
public class ApiHandler implements RequestHandler<APIGatewayProxyRequestEvent, 
                                                   APIGatewayProxyResponseEvent> {
    
    @Override
    public APIGatewayProxyResponseEvent handleRequest(
            APIGatewayProxyRequestEvent request, Context context) {
        
        String path = request.getPath();
        String method = request.getHttpMethod();
        String body = request.getBody();
        
        // Route based on path
        switch (path) {
            case "/users":
                return handleUsers(method, body);
            case "/orders":
                return handleOrders(method, body);
            default:
                return notFound();
        }
    }
}
```

### **Real-time Stream Processing**

```java
// Kinesis/DynamoDB Streams
public class StreamHandler implements RequestHandler<DynamodbEvent, Void> {
    
    @Override
    public Void handleRequest(DynamodbEvent event, Context context) {
        for (DynamodbEvent.DynamodbStreamRecord record : event.getRecords()) {
            String eventName = record.getEventName();
            Map<String, AttributeValue> newImage = record.getDynamodb().getNewImage();
            
            switch (eventName) {
                case "INSERT":
                    handleInsert(newImage);
                    break;
                case "MODIFY":
                    handleModify(newImage);
                    break;
                case "REMOVE":
                    handleRemove(record.getDynamodb().getKeys());
                    break;
            }
        }
        return null;
    }
}
```

### **Scheduled Tasks**

```java
// CloudWatch Events / EventBridge
public class ScheduledHandler implements RequestHandler<Map<String, Object>, String> {
    
    @Override
    public String handleRequest(Map<String, Object> event, Context context) {
        // Run daily batch job
        generateDailyReport();
        cleanupOldData();
        sendNotifications();
        
        return "Scheduled task completed";
    }
}
```

### **Event-Driven Workflows**

```java
// Step Functions integration
public class WorkflowStepHandler implements RequestHandler<Map<String, Object>, Map<String, Object>> {
    
    @Override
    public Map<String, Object> handleRequest(Map<String, Object> input, Context context) {
        String step = (String) input.get("step");
        
        switch (step) {
            case "validate":
                return validate(input);
            case "process":
                return process(input);
            case "notify":
                return notify(input);
            default:
                throw new IllegalArgumentException("Unknown step: " + step);
        }
    }
}
```

---

## **21. LIMITS & QUOTAS**

> **Concept:** Lambda has service limits that affect function design and scalability .

### **Soft Limits (Can be increased)**

| Limit | Default Value |
|-------|---------------|
| **Concurrent executions** | 1000 per account per region |
| **Function and layer storage** | 75 GB per region |
| **Elastic Network Interfaces per VPC** | 250 |
| **Test invocations per day** | 1000 |

### **Hard Limits (Cannot be increased)**

| Limit | Value |
|-------|-------|
| **Memory allocation** | 128 MB to 10,240 MB |
| **Function timeout** | 900 seconds (15 minutes) |
| **Function package size** | 50 MB (zipped), 250 MB (unzipped) |
| **Environment variables** | 4 KB total |
| **Function layers** | 5 layers |
| **/tmp storage** | 512 MB to 10 GB |
| **Request/response payload** | 6 MB (synchronous), 256 KB (async) |
| **Burst concurrency** | 500-3000 (per region) |

### **Java-Specific Considerations**

```java
public class LimitAwareHandler implements RequestHandler<String, String> {
    
    // 250 MB total for function + layers (unzipped)
    // Be mindful of JAR size
    
    @Override
    public String handleRequest(String input, Context context) {
        // Check remaining time (max 15 minutes)
        long remainingMs = context.getRemainingTimeInMillis();
        
        // Check /tmp storage (max 10 GB)
        File tmpDir = new File("/tmp");
        long freeSpace = tmpDir.getFreeSpace();
        
        // Process accordingly
        if (remainingMs < 60000) {
            // Use faster algorithm
            return fastProcess(input);
        } else {
            // Use complete algorithm
            return thoroughProcess(input);
        }
    }
}
```

---

## **22. LAMBDA VS OTHER COMPUTE SERVICES**

> **Concept:** Choosing the right compute service depends on your workload characteristics .

### **Service Comparison**

| Aspect | Lambda | Fargate | ECS/EKS | EC2 |
|--------|--------|---------|---------|-----|
| **Granularity** | Function | Container | Container | VM |
| **Startup time** | Milliseconds | Seconds | Seconds | Minutes |
| **Max duration** | 15 minutes | Unlimited | Unlimited | Unlimited |
| **Scaling** | Automatic | Service-based | Manual/auto | Manual/auto |
| **State** | Stateless | Stateless | Stateful | Stateful |
| **Pricing** | Per invocation | Per hour | Per hour | Per hour |
| **Use case** | Event-driven | Batch, web apps | Microservices | Full control |

### **Decision Matrix**

| Workload Type | Recommended Service | Reason |
|---------------|---------------------|--------|
| **Event-driven processing** | Lambda | Automatic scaling, pay per use |
| **Web application** | Fargate/ECS | Long-running, stateful |
| **Batch processing** | Fargate/Fargate | Longer than 15 minutes |
| **Legacy application** | EC2 | Full control, any OS |
| **Microservices** | ECS/EKS | Container orchestration |
| **Real-time file processing** | Lambda | Event-driven, scalable |

---

## **23. COMMON INTERVIEW QUESTIONS**

### **Basic Level**

| Question | Answer |
|----------|--------|
| **What is AWS Lambda?** | Serverless compute service that runs code without provisioning servers, scales automatically, and charges only for compute time used |
| **What are Lambda triggers?** | Event sources that invoke Lambda functions (S3, DynamoDB, API Gateway, etc.) |
| **What is the maximum execution time?** | 15 minutes (900 seconds) |
| **What is a cold start?** | Delay when Lambda initializes a new execution environment |
| **What languages does Lambda support?** | Java, Python, Node.js, Go, Ruby, .NET, Custom runtimes |

### **Intermediate Level**

| Question | Answer |
|----------|--------|
| **How does Lambda scale?** | Creates new instances based on incoming requests, up to account concurrency limits |
| **What is reserved concurrency?** | Guaranteed maximum concurrency for a function |
| **What is provisioned concurrency?** | Pre-initialized instances for no cold starts |
| **How do you optimize Java cold starts?** | Increase memory, minimize dependencies, use SnapStart, lazy initialization |
| **What is the difference between synchronous and asynchronous invocation?** | Synchronous: client waits for response; Async: Lambda queues event, returns immediately |
| **How does Lambda handle retries?** | Async: 2 retries; Stream-based: retries until success; Sync: client must retry |

### **Advanced Level**

| Question | Answer |
|----------|--------|
| **How does Lambda VPC integration work?** | Creates ENIs in subnets, function must have internet access via NAT Gateway |
| **What are Lambda layers?** | ZIP archives with dependencies shared across functions |
| **How do you monitor Lambda performance?** | CloudWatch metrics, logs, X-Ray tracing |
| **What is Lambda SnapStart?** | Caches initialized environment for faster Java cold starts |
| **How do you handle large payloads?** | Store in S3, pass references; or use Lambda Destinations for async processing |
| **What is the Lambda execution environment lifecycle?** | Create → Initialize (cold) → Invoke → Idle → Destroy |

### **Scenario-Based Questions**

**Q: Design a serverless image processing pipeline.**
> **A:** S3 upload triggers Lambda → Lambda processes image → Stores result in S3 → Updates DynamoDB metadata → Optional: CloudFront for serving.

**Q: Your Lambda function is timing out. What do you do?**
> **A:** Check timeout configuration, increase memory (more CPU), optimize code, use async processing, break into smaller functions.

**Q: How would you handle millions of concurrent requests?**
> **A:** Lambda scales automatically, but set reserved concurrency, use SQS for buffering, implement throttling, monitor CloudWatch metrics.

**Q: Your Java Lambda has 5-second cold starts. How do you improve?**
> **A:** Increase memory, minimize JAR size, use SnapStart, lazy initialization, provisioned concurrency, move initialization to static blocks.

---

## **24. QUICK REFERENCE CHEAT SHEET**

### **Maven Dependencies**

```xml
<dependency>
    <groupId>com.amazonaws</groupId>
    <artifactId>aws-lambda-java-core</artifactId>
    <version>1.2.2</version>
</dependency>
<dependency>
    <groupId>com.amazonaws</groupId>
    <artifactId>aws-lambda-java-events</artifactId>
    <version>3.11.1</version>
</dependency>
```

### **Basic Handler Template**

```java
public class Handler implements RequestHandler<String, String> {
    @Override
    public String handleRequest(String input, Context context) {
        LambdaLogger logger = context.getLogger();
        logger.log("Processing: " + input);
        return "Result: " + input;
    }
}
```

### **Common Handler Signatures**

```java
// API Gateway
RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent>

// S3
RequestHandler<S3Event, String>

// SQS
RequestHandler<SQSEvent, Void>

// DynamoDB
RequestHandler<DynamodbEvent, Void>

// Scheduled (CloudWatch)
RequestHandler<Map<String, Object>, String>
```

### **Configuration Limits**

```
Memory: 128 MB - 10,240 MB
Timeout: 1 sec - 15 minutes
Package size: 50 MB (zip), 250 MB (unzipped)
Layers: Up to 5
/tmp: 512 MB - 10 GB
Concurrency: 1000 default
```

### **Cold Start Optimization**

```java
// ✅ GOOD
private static final DynamoDbClient DYNAMO_DB = DynamoDbClient.create();

// ❌ BAD
DynamoDbClient DYNAMO_DB = DynamoDbClient.create(); // Inside handler
```

### **SAM Template Snippet**

```yaml
MyFunction:
  Type: AWS::Serverless::Function
  Properties:
    CodeUri: target/my-function.jar
    Handler: com.example.Handler::handleRequest
    Runtime: java17
    MemorySize: 1024
    Timeout: 30
    Environment:
      Variables:
        TABLE_NAME: Users
    Events:
      Api:
        Type: Api
        Properties:
          Path: /users
          Method: GET
```

---

## **📝 KEY TAKEAWAYS**

1. **Serverless by design** – No servers to manage, auto-scaling, pay-per-use 
2. **Event-driven architecture** – Responds to events from 200+ AWS services 
3. **Java cold starts** – Need optimization (memory, SnapStart, lazy loading) 
4. **15-minute timeout** – Not for long-running processes 
5. **Concurrency limits** – Account level, can request increase 
6. **Stateless by default** – Use external storage for persistence 
7. **IAM roles essential** – Least privilege principle 
8. **VPC adds latency** – Only when needed 
9. **Monitor everything** – CloudWatch metrics, logs, X-Ray 
10. **Design for failure** – Retries, DLQs, destinations 

---

*Good luck with your AWS Lambda interview! ⚡🎉*