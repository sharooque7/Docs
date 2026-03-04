# Complete Java Microservices - The Ultimate Interview Guide 🏗️

*Your comprehensive go-to reference for all Microservices concepts with brief explanations and code examples*

---

## **📋 TABLE OF CONTENTS**

- [Complete Java Microservices - The Ultimate Interview Guide 🏗️](#complete-java-microservices---the-ultimate-interview-guide-️)
  - [**📋 TABLE OF CONTENTS**](#-table-of-contents)
  - [**1. WHAT ARE MICROSOFT SERVICES?**](#1-what-are-microsoft-services)
  - [**2. MONOLITH VS MICROSERVICES**](#2-monolith-vs-microservices)
  - [**3. CORE PRINCIPLES**](#3-core-principles)
  - [**4. SERVICE COMMUNICATION**](#4-service-communication)
    - [**4.1 Synchronous Communication**](#41-synchronous-communication)
    - [**4.2 Asynchronous Communication (Messaging)**](#42-asynchronous-communication-messaging)
    - [**4.3 gRPC (High Performance)**](#43-grpc-high-performance)
  - [**5. API GATEWAY**](#5-api-gateway)
  - [**6. SERVICE DISCOVERY**](#6-service-discovery)
  - [**7. CONFIGURATION MANAGEMENT**](#7-configuration-management)
  - [**8. DATABASE PATTERNS**](#8-database-patterns)
    - [**8.1 Shared Database Anti-Pattern (Don't Do This!)**](#81-shared-database-anti-pattern-dont-do-this)
  - [**9. TRANSACTION MANAGEMENT (SAGA)**](#9-transaction-management-saga)
    - [**9.1 Choreography Saga (Event-Based)**](#91-choreography-saga-event-based)
    - [**9.2 Orchestration Saga (Centralized Controller)**](#92-orchestration-saga-centralized-controller)
  - [**10. CQRS PATTERN**](#10-cqrs-pattern)
  - [**11. EVENT-DRIVEN ARCHITECTURE**](#11-event-driven-architecture)
  - [**12. CIRCUIT BREAKER PATTERN**](#12-circuit-breaker-pattern)
  - [**13. BFF PATTERN (BACKEND FOR FRONTEND)**](#13-bff-pattern-backend-for-frontend)
  - [**14. OUTBOX PATTERN**](#14-outbox-pattern)
  - [**15. API VERSIONING**](#15-api-versioning)
  - [**16. SECURITY IN MICROSOFT SERVICES**](#16-security-in-microsoft-services)
    - [**16.1 JWT-Based Authentication**](#161-jwt-based-authentication)
    - [**16.2 mTLS for Service-to-Service**](#162-mtls-for-service-to-service)
    - [**16.3 OAuth2 / OpenID Connect**](#163-oauth2--openid-connect)
  - [**17. CONTAINERIZATION (DOCKER)**](#17-containerization-docker)
  - [**18. ORCHESTRATION (KUBERNETES)**](#18-orchestration-kubernetes)
  - [**19. SERVICE MESH**](#19-service-mesh)
  - [**20. OBSERVABILITY**](#20-observability)
  - [**21. DISTRIBUTED TRACING**](#21-distributed-tracing)
  - [**22. CENTRALIZED LOGGING**](#22-centralized-logging)
  - [**23. TESTING MICROSERVICES**](#23-testing-microservices)
  - [**24. DEPLOYMENT STRATEGIES**](#24-deployment-strategies)
    - [**24.1 Blue-Green Deployment**](#241-blue-green-deployment)
    - [**24.2 Canary Deployment**](#242-canary-deployment)
    - [**24.3 Rolling Update**](#243-rolling-update)
  - [**25. DOMAIN-DRIVEN DESIGN (DDD)**](#25-domain-driven-design-ddd)
  - [**26. STRANGLER FIG PATTERN**](#26-strangler-fig-pattern)
  - [**27. COMMON INTERVIEW QUESTIONS**](#27-common-interview-questions)
  - [**28. QUICK REFERENCE CHEAT SHEET**](#28-quick-reference-cheat-sheet)
  - [**📝 KEY TAKEAWAYS**](#-key-takeaways)

---

## **1. WHAT ARE MICROSOFT SERVICES?**

> **Concept:** Microservices are an architectural style that structures an application as a collection of small, autonomous, independently deployable services, each focused on a specific business capability and operating within a well-defined bounded context .

```java
// Traditional Monolithic Controller
@RestController
public class MonolithicController {
    @Autowired private UserService userService;
    @Autowired private OrderService orderService;
    @Autowired private PaymentService paymentService;
    @Autowired private InventoryService inventoryService;
    // Everything in one application
}

// Microservice - Product Service only
@RestController
@RequestMapping("/api/products")
public class ProductService {
    @Autowired
    private ProductRepository repository;
    
    @GetMapping
    public List<Product> getAllProducts() {
        return repository.findAll();
    }
    
    @PostMapping
    public Product createProduct(@RequestBody Product product) {
        return repository.save(product);
    }
}
```

---

## **2. MONOLITH VS MICROSERVICES**

> **Concept:** Comparing traditional monolithic architecture with microservices approach .

| Aspect | Monolith | Microservices |
|--------|----------|---------------|
| **Deployment** | Single unit, full redeploy | Independent per service |
| **Scaling** | Scale entire application | Scale individual services |
| **Development** | One large codebase | Multiple small codebases |
| **Team Structure** | Multiple teams on same code | Cross-functional teams per service |
| **Technology** | Single tech stack | Polyglot (different per service) |
| **Failure Impact** | Single failure can bring down all | Isolated to one service |
| **Complexity** | Simple development, complex scaling | Complex development, simple scaling |

```java
// Monolith - one application
monolith.jar
├── user module
├── order module
├── payment module
└── inventory module

// Microservices - multiple applications
user-service.jar    // Runs separately
order-service.jar   // Runs separately  
payment-service.jar // Runs separately
inventory-service.jar // Runs separately
```

---

## **3. CORE PRINCIPLES**

> **Concept:** Fundamental design principles that guide microservices architecture .

| Principle | Description | Implementation |
|-----------|-------------|----------------|
| **Single Responsibility** | Each service does one thing well | Bounded contexts per business capability |
| **Autonomous** | Services can be developed/deployed independently | CI/CD, versioning, backward compatibility |
| **Decentralized** | No central orchestration | Domain-driven design, choreography |
| **Isolated** | Failure in one doesn't cascade | Bulkheads, circuit breakers |
| **Stateless** | No session data stored in service | Externalize state to cache/db |
| **APIs First** | Communication via well-defined APIs | REST, gRPC, event contracts |

```java
// Good - Single responsibility
@RestController
@RequestMapping("/api/users")
public class UserService {
    // Only user-related endpoints
}

// Good - Stateless service
@Service
public class StatelessService {
    // No instance variables storing state
    public Result process(Request req) {
        // Use request data only
        return new Result();
    }
}
```

---

## **4. SERVICE COMMUNICATION**

> **Concept:** How microservices talk to each other .

### **4.1 Synchronous Communication**

```java
// REST API call between services
@Service
public class OrderService {
    private final RestTemplate restTemplate;
    
    public Order createOrder(OrderRequest request) {
        // Call User Service synchronously
        String userServiceUrl = "http://user-service/api/users/" + request.getUserId();
        User user = restTemplate.getForObject(userServiceUrl, User.class);
        
        // Call Inventory Service
        String inventoryUrl = "http://inventory-service/api/inventory/check";
        Boolean available = restTemplate.postForObject(inventoryUrl, request, Boolean.class);
        
        // Create order
        return orderRepository.save(new Order(user, request));
    }
}

// Using WebClient (reactive)
@Service
public class ProductService {
    private final WebClient webClient;
    
    public Mono<Product> getProductWithReviews(Long productId) {
        return webClient.get()
            .uri("http://review-service/api/reviews/product/" + productId)
            .retrieve()
            .bodyToFlux(Review.class)
            .collectList()
            .map(reviews -> new Product(productId, reviews));
    }
}
```

### **4.2 Asynchronous Communication (Messaging)**

```java
// Publisher service
@Service
public class OrderService {
    @Autowired
    private KafkaTemplate<String, OrderEvent> kafkaTemplate;
    
    public Order createOrder(OrderRequest request) {
        Order order = orderRepository.save(new Order(request));
        
        // Publish event - doesn't wait for response
        OrderCreatedEvent event = new OrderCreatedEvent(order.getId(), order.getUserId());
        kafkaTemplate.send("order-events", event);
        
        return order;
    }
}

// Consumer service
@Component
public class InventoryServiceConsumer {
    @KafkaListener(topics = "order-events")
    public void handleOrderCreated(OrderCreatedEvent event) {
        // Process asynchronously
        inventoryService.reserveInventory(event.getOrderId());
    }
}
```

### **4.3 gRPC (High Performance)**

```protobuf
// product.proto
service ProductService {
    rpc GetProduct (ProductRequest) returns (ProductResponse) {}
    rpc ListProducts (Empty) returns (stream ProductResponse) {}
}

message ProductRequest {
    int64 id = 1;
}

message ProductResponse {
    int64 id = 1;
    string name = 2;
    double price = 3;
}
```

```java
// gRPC client
public class ProductGrpcClient {
    private final ProductServiceGrpc.ProductServiceBlockingStub stub;
    
    public Product getProduct(Long id) {
        ProductRequest request = ProductRequest.newBuilder()
            .setId(id)
            .build();
        
        ProductResponse response = stub.getProduct(request);
        return mapToProduct(response);
    }
}
```

---

## **5. API GATEWAY**

> **Concept:** Single entry point for all clients that handles routing, authentication, rate limiting, and aggregation .

```java
// Spring Cloud Gateway configuration
@Configuration
public class GatewayConfig {
    
    @Bean
    public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
        return builder.routes()
            // Route to user service
            .route("user-service", r -> r
                .path("/api/users/**")
                .filters(f -> f
                    .addRequestHeader("X-Request-Id", UUID.randomUUID().toString())
                    .circuitBreaker(config -> config
                        .setName("userServiceCB")
                        .setFallbackUri("forward:/fallback/users")))
                .uri("lb://USER-SERVICE"))
            
            // Route to product service
            .route("product-service", r -> r
                .path("/api/products/**")
                .filters(f -> f
                    .rewritePath("/api/products/(?<segment>.*)", "/products/${segment}")
                    .retry(config -> config.setRetries(3)))
                .uri("lb://PRODUCT-SERVICE"))
            
            // Route to order service with aggregation
            .route("order-service", r -> r
                .path("/api/orders/**")
                .filters(f -> f
                    .addRequestParameter("source", "gateway")
                    .requestRateLimiter(config -> config
                        .setRateLimiter(redisRateLimiter())))
                .uri("lb://ORDER-SERVICE"))
            .build();
    }
    
    @Bean
    public RedisRateLimiter redisRateLimiter() {
        return new RedisRateLimiter(10, 20, 1); // replenishRate, burstCapacity, requestedTokens
    }
}

// BFF pattern - different gateways for different clients
@RestController
@RequestMapping("/mobile-api")
public class MobileBFFController {
    // Aggregates data from multiple services for mobile client
    @GetMapping("/dashboard")
    public MobileDashboard getMobileDashboard(@RequestParam String userId) {
        // Call multiple services and aggregate
        UserProfile profile = userServiceClient.getProfile(userId);
        List<Order> recentOrders = orderServiceClient.getRecentOrders(userId);
        List<Product> recommendations = recommendationClient.getForUser(userId);
        
        return new MobileDashboard(profile, recentOrders, recommendations);
    }
}
```

---

## **6. SERVICE DISCOVERY**

> **Concept:** Mechanism for services to find each other dynamically without hardcoding locations .

```java
// Using Netflix Eureka
@SpringBootApplication
@EnableEurekaServer
public class ServiceRegistryApplication {
    public static void main(String[] args) {
        SpringApplication.run(ServiceRegistryApplication.class, args);
    }
}

// application.yml for Eureka Server
server:
  port: 8761

eureka:
  client:
    register-with-eureka: false
    fetch-registry: false
```

```java
// Service registering with Eureka
@SpringBootApplication
@EnableEurekaClient
@RestController
public class ProductServiceApplication {
    
    @Value("${spring.application.name}")
    private String serviceName;
    
    @Autowired
    private DiscoveryClient discoveryClient;
    
    @GetMapping("/discover")
    public List<String> discoverServices() {
        // Get all instances of a service
        List<ServiceInstance> instances = discoveryClient.getInstances("order-service");
        
        return instances.stream()
            .map(instance -> instance.getUri().toString())
            .collect(Collectors.toList());
    }
    
    public static void main(String[] args) {
        SpringApplication.run(ProductServiceApplication.class, args);
    }
}

// application.yml for client
spring:
  application:
    name: product-service

eureka:
  client:
    service-url:
      defaultZone: http://localhost:8761/eureka/
  instance:
    hostname: ${HOSTNAME:localhost}
    prefer-ip-address: true
```

```java
// Using Ribbon for client-side load balancing
@Configuration
public class RibbonConfig {
    
    @LoadBalanced
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}

@Service
public class OrderService {
    @Autowired
    @LoadBalanced
    private RestTemplate restTemplate;
    
    public User getUser(Long userId) {
        // Uses service discovery to find user-service
        return restTemplate.getForObject("http://user-service/api/users/" + userId, User.class);
    }
}
```

---

## **7. CONFIGURATION MANAGEMENT**

> **Concept:** Externalized configuration for services across environments .

```java
// Spring Cloud Config Server
@SpringBootApplication
@EnableConfigServer
public class ConfigServerApplication {
    public static void main(String[] args) {
        SpringApplication.run(ConfigServerApplication.class, args);
    }
}

// application.yml for config server
spring:
  cloud:
    config:
      server:
        git:
          uri: https://github.com/company/config-repo
          search-paths: '{application}'
          default-label: main
server:
  port: 8888
```

```java
// Config client
@SpringBootApplication
@RefreshScope  // Allows dynamic refresh without restart
public class ProductServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(ProductServiceApplication.class, args);
    }
}

// application.yml for client
spring:
  application:
    name: product-service
  config:
    import: "configserver:http://localhost:8888"
  cloud:
    config:
      profile: dev
      label: main
```

```java
// Using configuration properties
@Component
@ConfigurationProperties(prefix = "app.product")
@RefreshScope
public class ProductConfig {
    private int maxItems;
    private boolean discountEnabled;
    private List<String> categories;
    private Map<String, Double> pricingRules;
    
    // getters and setters
}

// Bootstrap with different profiles
// application-dev.yml
app:
  product:
    max-items: 100
    discount-enabled: true
    categories: electronics, books, clothing
    pricing-rules:
      electronics: 0.1
      books: 0.05

// application-prod.yml  
app:
  product:
    max-items: 1000
    discount-enabled: false
```

---

## **8. DATABASE PATTERNS**

> **Concept:** Database per service pattern - each service has its own private database .

```java
// Product Service - uses its own database
@Entity
@Table(name = "products")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private double price;
    private int stock;
}

// Product Repository
@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    List<Product> findByPriceLessThan(double price);
}

// application-product.yml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/product_db
    username: product_user
    password: password
  jpa:
    hibernate:
      ddl-auto: update
```

```java
// Order Service - uses its own database
@Entity
@Table(name = "orders")
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private Long userId;
    private Long productId;
    private int quantity;
    private OrderStatus status;
    private LocalDateTime createdAt;
}

// application-order.yml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/order_db
    username: order_user
    password: password
  jpa:
    database: POSTGRESQL
```

### **8.1 Shared Database Anti-Pattern (Don't Do This!)**

```java
// ❌ BAD - Services sharing same database
// Both services access same tables
@Service
public class ProductService {
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    public void updateProductStock(Long productId, int quantity) {
        // Direct DB access - tightly coupled
        jdbcTemplate.update("UPDATE products SET stock = stock - ? WHERE id = ?", 
            quantity, productId);
    }
}

@Service
public class OrderService {
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    public void createOrder(Order order) {
        // Also accesses same products table
        jdbcTemplate.update("INSERT INTO orders...");
        jdbcTemplate.update("UPDATE products SET stock = stock - ? WHERE id = ?",
            order.getQuantity(), order.getProductId());
    }
}
```

---

## **9. TRANSACTION MANAGEMENT (SAGA)**

> **Concept:** Pattern for managing distributed transactions across multiple services .

### **9.1 Choreography Saga (Event-Based)**

```java
// Order Service publishes events
@Service
public class OrderSaga {
    @Autowired
    private KafkaTemplate<String, Object> kafkaTemplate;
    
    @Transactional
    public Order createOrder(OrderRequest request) {
        // Step 1: Create order in PENDING state
        Order order = new Order(request);
        order.setStatus(OrderStatus.PENDING);
        order = orderRepository.save(order);
        
        // Step 2: Publish OrderCreated event
        OrderCreatedEvent event = new OrderCreatedEvent(
            order.getId(), 
            request.getProductId(), 
            request.getQuantity()
        );
        kafkaTemplate.send("order-events", event);
        
        return order;
    }
}

// Payment Service listens and responds
@Component
public class PaymentSagaParticipant {
    
    @KafkaListener(topics = "order-events")
    public void handleOrderCreated(OrderCreatedEvent event) {
        try {
            // Process payment
            Payment payment = paymentService.processPayment(event.getOrderId());
            
            // Success - publish PaymentProcessed
            PaymentProcessedEvent success = new PaymentProcessedEvent(
                event.getOrderId(), payment.getId()
            );
            kafkaTemplate.send("payment-events", success);
            
        } catch (Exception e) {
            // Failure - publish PaymentFailed
            PaymentFailedEvent failure = new PaymentFailedEvent(
                event.getOrderId(), e.getMessage()
            );
            kafkaTemplate.send("payment-events", failure);
        }
    }
}

// Inventory Service
@Component
public class InventorySagaParticipant {
    
    @KafkaListener(topics = "payment-events")
    public void handlePaymentProcessed(PaymentProcessedEvent event) {
        // Reserve inventory
        inventoryService.reserveInventory(event.getOrderId());
        
        // Publish InventoryReserved
        InventoryReservedEvent reserved = new InventoryReservedEvent(event.getOrderId());
        kafkaTemplate.send("inventory-events", reserved);
    }
    
    @KafkaListener(topics = "payment-events")
    public void handlePaymentFailed(PaymentFailedEvent event) {
        // Compensating transaction - update order status to FAILED
        orderService.updateOrderStatus(event.getOrderId(), OrderStatus.FAILED);
    }
}
```

### **9.2 Orchestration Saga (Centralized Controller)**

```java
// Saga orchestrator
@Component
public class OrderSagaOrchestrator {
    
    @Autowired
    private PaymentServiceClient paymentClient;
    
    @Autowired
    private InventoryServiceClient inventoryClient;
    
    @Autowired
    private OrderRepository orderRepository;
    
    @Transactional
    public void executeSaga(OrderRequest request) {
        Order order = null;
        
        try {
            // Step 1: Create order
            order = createOrder(request);
            
            // Step 2: Reserve inventory
            InventoryResponse inventory = inventoryClient.reserve(order.getId(), 
                request.getProductId(), request.getQuantity());
            
            // Step 3: Process payment
            PaymentResponse payment = paymentClient.process(order.getId(), 
                request.getTotalAmount());
            
            // Step 4: Complete order
            order.setStatus(OrderStatus.COMPLETED);
            orderRepository.save(order);
            
        } catch (Exception e) {
            // Compensating transactions
            if (order != null) {
                order.setStatus(OrderStatus.FAILED);
                orderRepository.save(order);
                
                // Call compensating actions
                inventoryClient.cancelReservation(order.getId());
                paymentClient.refund(order.getId());
            }
            
            throw new SagaException("Order failed", e);
        }
    }
}
```

---

## **10. CQRS PATTERN**

> **Concept:** Command Query Responsibility Segregation - separating read and write operations into different models .

```java
// Command Model (Write)
@RestController
@RequestMapping("/api/commands/products")
public class ProductCommandController {
    
    @Autowired
    private ProductCommandService commandService;
    
    @PostMapping
    public CompletableFuture<CommandResponse> createProduct(@RequestBody AddProductCommand command) {
        return commandService.handle(command);
    }
}

@Service
public class ProductCommandService {
    
    @Autowired
    private ProductWriteRepository writeRepository;
    
    @Autowired
    private EventPublisher eventPublisher;
    
    @Transactional
    public CompletableFuture<CommandResponse> handle(AddProductCommand command) {
        return CompletableFuture.supplyAsync(() -> {
            // Validate and save to write DB
            ProductWriteModel product = new ProductWriteModel(
                command.getName(),
                command.getPrice(),
                command.getStock()
            );
            
            product = writeRepository.save(product);
            
            // Publish event for read model update
            eventPublisher.publish(new ProductCreatedEvent(
                product.getId(),
                product.getName(),
                product.getPrice(),
                product.getStock()
            ));
            
            return new CommandResponse(product.getId(), "Product created");
        });
    }
}

// Query Model (Read)
@RestController
@RequestMapping("/api/queries/products")
public class ProductQueryController {
    
    @Autowired
    private ProductQueryService queryService;
    
    @GetMapping("/{id}")
    public ProductDTO getProduct(@PathVariable Long id) {
        return queryService.getProduct(id);
    }
    
    @GetMapping
    public List<ProductDTO> getAllProducts(
        @RequestParam(required = false) String category,
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "20") int size) {
        
        return queryService.getProducts(category, page, size);
    }
}

@Service
public class ProductQueryService {
    
    @Autowired
    private ProductReadRepository readRepository;
    
    // Optimized for queries - denormalized data
    public ProductDTO getProduct(Long id) {
        return readRepository.findById(id)
            .map(this::toDTO)
            .orElseThrow(() -> new ProductNotFoundException(id));
    }
    
    public List<ProductDTO> getProducts(String category, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<ProductReadModel> products;
        
        if (category != null) {
            products = readRepository.findByCategory(category, pageable);
        } else {
            products = readRepository.findAll(pageable);
        }
        
        return products.stream()
            .map(this::toDTO)
            .collect(Collectors.toList());
    }
}

// Event handler to update read model
@Component
public class ProductEventConsumer {
    
    @Autowired
    private ProductReadRepository readRepository;
    
    @KafkaListener(topics = "product-events")
    public void handleProductCreated(ProductCreatedEvent event) {
        // Update read-optimized database
        ProductReadModel readModel = new ProductReadModel(
            event.getProductId(),
            event.getName(),
            event.getPrice(),
            event.getStock(),
            // Include denormalized data for query performance
            getCategoryInfo(event.getCategoryId()),
            getAverageRating(event.getProductId())
        );
        
        readRepository.save(readModel);
    }
}
```

---

## **11. EVENT-DRIVEN ARCHITECTURE**

> **Concept:** Services communicate through events, enabling loose coupling and eventual consistency .

```java
// Event definitions
@Value
public class OrderCreatedEvent {
    String eventId = UUID.randomUUID().toString();
    Instant timestamp = Instant.now();
    Long orderId;
    Long userId;
    List<OrderItem> items;
    Money totalAmount;
}

@Value
public class PaymentProcessedEvent {
    String eventId;
    Long orderId;
    String paymentId;
    PaymentStatus status;
}

@Value
public class InventoryUpdatedEvent {
    String eventId;
    Long productId;
    int quantityChange;
    int newStock;
}
```

```java
// Producer service
@Service
public class OrderEventProducer {
    
    @Autowired
    private KafkaTemplate<String, Object> kafkaTemplate;
    
    @Autowired
    private OutboxRepository outboxRepository;
    
    @Transactional
    public Order createOrder(OrderRequest request) {
        // Save to database
        Order order = orderRepository.save(new Order(request));
        
        // Save to outbox (ensures atomicity)
        OutboxEvent outboxEvent = new OutboxEvent(
            "order-events",
            new OrderCreatedEvent(order.getId(), order.getUserId(), 
                order.getItems(), order.getTotal())
        );
        outboxRepository.save(outboxEvent);
        
        return order;
    }
    
    @Scheduled(fixedDelay = 5000)
    @Transactional
    public void publishOutboxEvents() {
        List<OutboxEvent> events = outboxRepository.findUnpublished();
        
        for (OutboxEvent event : events) {
            try {
                kafkaTemplate.send(event.getTopic(), event.getPayload());
                event.markPublished();
                outboxRepository.save(event);
            } catch (Exception e) {
                log.error("Failed to publish event: {}", event.getId(), e);
                // Will retry on next schedule
            }
        }
    }
}
```

```java
// Consumer service with dead letter queue
@Component
public class OrderEventConsumer {
    
    @Autowired
    private InventoryService inventoryService;
    
    @Autowired
    private KafkaTemplate<String, Object> kafkaTemplate;
    
    @KafkaListener(topics = "order-events", groupId = "inventory-group")
    public void handleOrderCreated(OrderCreatedEvent event) {
        try {
            // Process event
            inventoryService.reserveInventory(event);
            
        } catch (Exception e) {
            log.error("Failed to process order event: {}", event, e);
            
            // Send to dead letter queue
            kafkaTemplate.send("order-events-dlq", event);
        }
    }
    
    @DltHandler
    public void handleDlt(OrderCreatedEvent event, @Header(KafkaHeaders.RECEIVED_TOPIC) String topic) {
        log.error("Event from topic {} moved to DLQ: {}", topic, event);
        // Manual intervention or alert
    }
}
```

---

## **12. CIRCUIT BREAKER PATTERN**

> **Concept:** Prevents cascading failures by stopping calls to failing services .

```java
// Using Resilience4j
@Service
public class ProductServiceClient {
    
    @Autowired
    private RestTemplate restTemplate;
    
    @CircuitBreaker(name = "productService", fallbackMethod = "getProductFallback")
    @Retry(name = "productService", fallbackMethod = "getProductFallback")
    @TimeLimiter(name = "productService")
    @Bulkhead(name = "productService", type = Bulkhead.Type.THREADPOOL)
    public CompletableFuture<Product> getProduct(Long id) {
        return CompletableFuture.supplyAsync(() -> 
            restTemplate.getForObject("http://product-service/api/products/" + id, Product.class)
        );
    }
    
    public CompletableFuture<Product> getProductFallback(Long id, Exception ex) {
        log.warn("Fallback for product {}: {}", id, ex.getMessage());
        
        // Return cached or default product
        return CompletableFuture.completedFuture(
            new Product(id, "Unavailable", 0.0)
        );
    }
}

// Configuration
@Configuration
public class Resilience4JConfig {
    
    @Bean
    public Customizer<Resilience4JCircuitBreakerFactory> circuitBreakerCustomizer() {
        return factory -> {
            factory.configure(builder -> builder
                .circuitBreakerConfig(CircuitBreakerConfig.custom()
                    .slidingWindowType(CircuitBreakerConfig.SlidingWindowType.COUNT_BASED)
                    .slidingWindowSize(10)
                    .failureRateThreshold(50.0f)
                    .waitDurationInOpenState(Duration.ofSeconds(30))
                    .permittedNumberOfCallsInHalfOpenState(3)
                    .recordExceptions(IOException.class, TimeoutException.class)
                    .build())
                .timeLimiterConfig(TimeLimiterConfig.custom()
                    .timeoutDuration(Duration.ofSeconds(2))
                    .build())
                .build(), "productService");
        };
    }
}

// Monitoring circuit breaker state
@Component
public class CircuitBreakerMonitor {
    
    @EventListener
    public void handleEvent(CircuitBreakerEvent event) {
        log.info("Circuit breaker {}: {} -> {}", 
            event.getCircuitBreakerName(),
            event.getEventType(),
            event.getStateTransition());
        
        if (event.getEventType() == CircuitBreakerEvent.Type.ERROR) {
            // Alert on errors
            alertService.sendAlert("Circuit breaker error: " + event);
        }
    }
}
```

---

## **13. BFF PATTERN (BACKEND FOR FRONTEND)**

> **Concept:** Separate backend services tailored to specific frontend clients .

```java
// Mobile BFF - optimized for mobile client
@RestController
@RequestMapping("/mobile-api/v1")
public class MobileBFFController {
    
    @Autowired
    private UserServiceClient userClient;
    
    @Autowired
    private ProductServiceClient productClient;
    
    @Autowired
    private OrderServiceClient orderClient;
    
    @GetMapping("/dashboard")
    public MobileDashboard getDashboard(@RequestParam String userId) {
        // Aggregate data for mobile home screen
        CompletableFuture<UserProfile> userFuture = 
            userClient.getProfile(userId);
        CompletableFuture<List<Product>> featuredFuture = 
            productClient.getFeaturedProducts(5);
        CompletableFuture<List<Order>> recentFuture = 
            orderClient.getRecentOrders(userId, 3);
        
        // Combine results
        return CompletableFuture.allOf(userFuture, featuredFuture, recentFuture)
            .thenApply(v -> new MobileDashboard(
                userFuture.join(),
                featuredFuture.join(),
                recentFuture.join()
            )).join();
    }
    
    @PostMapping("/checkout")
    public MobileCheckoutResult checkout(@RequestBody MobileCheckoutRequest request) {
        // Mobile-specific checkout flow
        // May combine multiple backend calls
        return orderClient.placeMobileOrder(request);
    }
}

// Web BFF - optimized for web client
@RestController
@RequestMapping("/web-api/v1")
public class WebBFFController {
    
    @Autowired
    private ProductServiceClient productClient;
    
    @Autowired
    private ReviewServiceClient reviewClient;
    
    @GetMapping("/product/{id}/details")
    public WebProductDetails getProductDetails(@PathVariable Long id) {
        // Web needs more detailed product view
        Product product = productClient.getProduct(id);
        List<Review> reviews = reviewClient.getReviews(id);
        List<Product> related = productClient.getRelatedProducts(id);
        
        return new WebProductDetails(product, reviews, related);
    }
}

// Admin BFF - for admin dashboard
@RestController
@RequestMapping("/admin-api/v1")
public class AdminBFFController {
    
    @Autowired
    private MetricsServiceClient metricsClient;
    
    @Autowired
    private UserServiceClient userClient;
    
    @GetMapping("/dashboard/metrics")
    public AdminDashboard getMetrics() {
        return new AdminDashboard(
            metricsClient.getSystemHealth(),
            metricsClient.getServiceMetrics(),
            userClient.getActiveUserCount(),
            metricsClient.getErrorRates()
        );
    }
}
```

---

## **14. OUTBOX PATTERN**

> **Concept:** Ensures reliable event publishing by storing events in database before sending .

```java
// Outbox entity
@Entity
@Table(name = "outbox_events")
public class OutboxEvent {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;
    
    private String aggregateId;
    
    private String eventType;
    
    @Convert(converter = PayloadConverter.class)
    private Object payload;
    
    private Instant createdAt;
    
    @Enumerated(EnumType.STRING)
    private OutboxStatus status;
    
    private int retryCount;
    
    private Instant lastAttemptAt;
}

// Service with outbox pattern
@Service
@Transactional
public class OrderServiceWithOutbox {
    
    @Autowired
    private OrderRepository orderRepository;
    
    @Autowired
    private OutboxRepository outboxRepository;
    
    @Autowired
    private KafkaTemplate<String, Object> kafkaTemplate;
    
    public Order createOrder(OrderRequest request) {
        // 1. Save to business database
        Order order = new Order(request);
        order.setStatus(OrderStatus.PENDING);
        order = orderRepository.save(order);
        
        // 2. Save to outbox (same transaction!)
        OutboxEvent outboxEvent = new OutboxEvent();
        outboxEvent.setAggregateId(order.getId().toString());
        outboxEvent.setEventType("OrderCreated");
        outboxEvent.setPayload(new OrderCreatedEvent(order));
        outboxEvent.setCreatedAt(Instant.now());
        outboxEvent.setStatus(OutboxStatus.PENDING);
        
        outboxRepository.save(outboxEvent);
        
        return order;
    }
}

// Outbox publisher - runs in separate thread
@Component
public class OutboxPublisher {
    
    @Autowired
    private OutboxRepository outboxRepository;
    
    @Autowired
    private KafkaTemplate<String, Object> kafkaTemplate;
    
    @Scheduled(fixedDelay = 5000)
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void publishPendingEvents() {
        List<OutboxEvent> pendingEvents = outboxRepository
            .findByStatusOrderByCreatedAt(OutboxStatus.PENDING);
        
        for (OutboxEvent event : pendingEvents) {
            try {
                // Publish to message broker
                kafkaTemplate.send(event.getEventType(), event.getPayload())
                    .get(10, TimeUnit.SECONDS);
                
                // Mark as published
                event.setStatus(OutboxStatus.PUBLISHED);
                outboxRepository.save(event);
                
            } catch (Exception e) {
                log.error("Failed to publish event: {}", event.getId(), e);
                
                // Update retry count
                event.setRetryCount(event.getRetryCount() + 1);
                event.setLastAttemptAt(Instant.now());
                
                if (event.getRetryCount() >= 3) {
                    event.setStatus(OutboxStatus.FAILED);
                }
                
                outboxRepository.save(event);
            }
        }
    }
}
```

---

## **15. API VERSIONING**

> **Concept:** Strategies for managing API changes without breaking clients .

```java
// URI Versioning (Most common)
@RestController
public class ProductController {
    
    // Version 1 - returns basic product
    @GetMapping("/v1/products/{id}")
    public ProductV1 getProductV1(@PathVariable Long id) {
        return productService.getProductV1(id);
    }
    
    // Version 2 - returns enhanced product with reviews
    @GetMapping("/v2/products/{id}")
    public ProductV2 getProductV2(@PathVariable Long id) {
        return productService.getProductV2(id);
    }
}

// Header Versioning
@RestController
@RequestMapping("/api/products")
public class ProductHeaderVersionController {
    
    @GetMapping("/{id}")
    public ResponseEntity<?> getProduct(
            @PathVariable Long id,
            @RequestHeader(value = "API-Version", defaultValue = "1") int version) {
        
        switch (version) {
            case 1:
                return ResponseEntity.ok(productService.getProductV1(id));
            case 2:
                return ResponseEntity.ok(productService.getProductV2(id));
            default:
                return ResponseEntity.status(400)
                    .body("Unsupported version: " + version);
        }
    }
}

// Content Negotiation (Accept header)
@GetMapping(value = "/{id}", produces = "application/vnd.company.v1+json")
public ProductV1 getProductV1(@PathVariable Long id) {
    return productService.getProductV1(id);
}

@GetMapping(value = "/{id}", produces = "application/vnd.company.v2+json")
public ProductV2 getProductV2(@PathVariable Long id) {
    return productService.getProductV2(id);
}
```

---

## **16. SECURITY IN MICROSOFT SERVICES**

> **Concept:** Securing inter-service communication and access control .

### **16.1 JWT-Based Authentication**

```java
// JWT Token Service
@Component
public class JwtTokenProvider {
    
    @Value("${security.jwt.secret}")
    private String jwtSecret;
    
    @Value("${security.jwt.expiration}")
    private int jwtExpiration;
    
    public String generateToken(Authentication authentication) {
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + jwtExpiration);
        
        return Jwts.builder()
            .setSubject(userDetails.getUsername())
            .setIssuedAt(now)
            .setExpiration(expiryDate)
            .claim("roles", userDetails.getAuthorities())
            .claim("userId", getUserId(authentication))
            .signWith(SignatureAlgorithm.HS512, jwtSecret)
            .compact();
    }
    
    public boolean validateToken(String token) {
        try {
            Jwts.parser().setSigningKey(jwtSecret).parseClaimsJws(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            log.error("Invalid JWT token: {}", e.getMessage());
            return false;
        }
    }
    
    public String getUserIdFromToken(String token) {
        Claims claims = Jwts.parser()
            .setSigningKey(jwtSecret)
            .parseClaimsJws(token)
            .getBody();
        
        return claims.get("userId", String.class);
    }
}

// JWT Authentication Filter
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {
    
    @Autowired
    private JwtTokenProvider tokenProvider;
    
    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws IOException, ServletException {
        try {
            String jwt = getJwtFromRequest(request);
            
            if (StringUtils.hasText(jwt) && tokenProvider.validateToken(jwt)) {
                String userId = tokenProvider.getUserIdFromToken(jwt);
                
                UsernamePasswordAuthenticationToken authentication = 
                    new UsernamePasswordAuthenticationToken(userId, null, Collections.emptyList());
                authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                
                SecurityContextHolder.getContext().setAuthentication(authentication);
            }
        } catch (Exception ex) {
            log.error("Could not set user authentication", ex);
        }
        
        filterChain.doFilter(request, response);
    }
    
    private String getJwtFromRequest(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (StringUtils.hasText(bearerToken) && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }
}
```

### **16.2 mTLS for Service-to-Service**

```yaml
# Kubernetes with Istio mTLS
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: prod
spec:
  mtls:
    mode: STRICT  # Require mTLS for all services
```

```java
// Spring Boot mTLS configuration
@Configuration
public class MtlsConfig {
    
    @Bean
    public RestTemplate restTemplate(RestTemplateBuilder builder) {
        return builder
            .requestFactory(() -> new HttpComponentsClientHttpRequestFactory(createHttpClient()))
            .build();
    }
    
    private CloseableHttpClient createHttpClient() {
        try {
            // Load client certificate
            KeyStore clientStore = KeyStore.getInstance("PKCS12");
            clientStore.load(new FileInputStream("client.p12"), "password".toCharArray());
            
            // Load trust store (CA certificates)
            KeyStore trustStore = KeyStore.getInstance("JKS");
            trustStore.load(new FileInputStream("truststore.jks"), "trustpass".toCharArray());
            
            SSLContext sslContext = SSLContexts.custom()
                .loadKeyMaterial(clientStore, "password".toCharArray())
                .loadTrustMaterial(trustStore, null)
                .build();
            
            return HttpClients.custom()
                .setSSLContext(sslContext)
                .setSSLHostnameVerifier(NoopHostnameVerifier.INSTANCE)
                .build();
        } catch (Exception e) {
            throw new RuntimeException("Failed to create mTLS client", e);
        }
    }
}
```

### **16.3 OAuth2 / OpenID Connect**

```yaml
# application.yml with OAuth2
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          issuer-uri: https://auth.company.com/auth/realms/myrealm
          jwk-set-uri: https://auth.company.com/auth/realms/myrealm/protocol/openid-connect/certs
```

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(authz -> authz
                .requestMatchers("/api/public/**").permitAll()
                .requestMatchers("/api/admin/**").hasRole("ADMIN")
                .requestMatchers("/api/**").authenticated()
            )
            .oauth2ResourceServer(oauth2 -> oauth2
                .jwt(jwt -> jwt
                    .jwtAuthenticationConverter(jwtAuthenticationConverter())
                )
            );
        
        return http.build();
    }
    
    @Bean
    public JwtAuthenticationConverter jwtAuthenticationConverter() {
        JwtGrantedAuthoritiesConverter converter = new JwtGrantedAuthoritiesConverter();
        converter.setAuthorityPrefix("ROLE_");
        converter.setAuthoritiesClaimName("roles");
        
        JwtAuthenticationConverter jwtConverter = new JwtAuthenticationConverter();
        jwtConverter.setJwtGrantedAuthoritiesConverter(converter);
        
        return jwtConverter;
    }
}
```

---

## **17. CONTAINERIZATION (DOCKER)**

> **Concept:** Packaging microservices with their dependencies into containers .

```dockerfile
# Dockerfile for Spring Boot microservice
FROM openjdk:17-jdk-slim AS build
WORKDIR /app
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
RUN ./mvnw dependency:go-offline -B

COPY src src
RUN ./mvnw package -DskipTests

FROM openjdk:17-jdk-slim
RUN addgroup --system --gid 1000 appuser && \
    adduser --system --uid 1000 --gid 1000 appuser

WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

# Security: run as non-root
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

```yaml
# docker-compose.yml for local development
version: '3.8'

services:
  # Service Discovery
  service-registry:
    build: ./service-registry
    ports:
      - "8761:8761"
    environment:
      - SPRING_PROFILES_ACTIVE=docker
    networks:
      - microservices-network

  # Config Server
  config-server:
    build: ./config-server
    ports:
      - "8888:8888"
    environment:
      - SPRING_PROFILES_ACTIVE=docker
    depends_on:
      - service-registry
    networks:
      - microservices-network

  # Product Service
  product-service:
    build: ./product-service
    ports:
      - "8081:8081"
    environment:
      - SPRING_PROFILES_ACTIVE=docker
      - EUREKA_CLIENT_SERVICEURL_DEFAULTZONE=http://service-registry:8761/eureka/
      - SPRING_CONFIG_IMPORT=configserver:http://config-server:8888
      - SPRING_DATASOURCE_URL=jdbc:postgresql://product-db:5432/productdb
    depends_on:
      - service-registry
      - config-server
      - product-db
    networks:
      - microservices-network
    deploy:
      replicas: 2
      resources:
        limits:
          memory: 512M
        reservations:
          memory: 256M

  # Product Database
  product-db:
    image: postgres:15
    environment:
      POSTGRES_DB: productdb
      POSTGRES_USER: product_user
      POSTGRES_PASSWORD: secret
    volumes:
      - product-data:/var/lib/postgresql/data
    networks:
      - microservices-network

  # Order Service
  order-service:
    build: ./order-service
    ports:
      - "8082:8082"
    environment:
      - SPRING_PROFILES_ACTIVE=docker
      - EUREKA_CLIENT_SERVICEURL_DEFAULTZONE=http://service-registry:8761/eureka/
    depends_on:
      - service-registry
      - config-server
      - order-db
    networks:
      - microservices-network

  order-db:
    image: mysql:8
    environment:
      MYSQL_DATABASE: orderdb
      MYSQL_USER: order_user
      MYSQL_PASSWORD: secret
      MYSQL_ROOT_PASSWORD: rootsecret
    volumes:
      - order-data:/var/lib/mysql
    networks:
      - microservices-network

  # API Gateway
  api-gateway:
    build: ./api-gateway
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=docker
      - EUREKA_CLIENT_SERVICEURL_DEFAULTZONE=http://service-registry:8761/eureka/
    depends_on:
      - service-registry
      - config-server
    networks:
      - microservices-network

  # Message Broker
  kafka:
    image: confluentinc/cp-kafka:latest
    ports:
      - "9092:9092"
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka:9092
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
    depends_on:
      - zookeeper
    networks:
      - microservices-network

  zookeeper:
    image: confluentinc/cp-zookeeper:latest
    ports:
      - "2181:2181"
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_TICK_TIME: 2000
    networks:
      - microservices-network

  # Monitoring
  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
    networks:
      - microservices-network

  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    networks:
      - microservices-network

networks:
  microservices-network:
    driver: bridge

volumes:
  product-data:
  order-data:
```

---

## **18. ORCHESTRATION (KUBERNETES)**

> **Concept:** Managing containerized microservices at scale .

```yaml
# kubernetes/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: product-service
  namespace: prod
  labels:
    app: product-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: product-service
  template:
    metadata:
      labels:
        app: product-service
    spec:
      containers:
      - name: product-service
        image: company/product-service:1.2.3
        ports:
        - containerPort: 8080
        env:
        - name: SPRING_PROFILES_ACTIVE
          value: "k8s"
        - name: DB_URL
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: url
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /actuator/health/liveness
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /actuator/health/readiness
            port: 8080
          initialDelaySeconds: 20
          periodSeconds: 5
---
# kubernetes/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: product-service
  namespace: prod
spec:
  selector:
    app: product-service
  ports:
  - port: 80
    targetPort: 8080
  type: ClusterIP
---
# kubernetes/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: product-service-config
  namespace: prod
data:
  application.yml: |
    app:
      features:
        discount-enabled: true
        reviews-enabled: true
    logging:
      level:
        com.company: DEBUG
---
# kubernetes/secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
  namespace: prod
type: Opaque
data:
  url: amRiYzpwb3N0Z3Jlc3FsOi8vcHJvZHVjdC1kYjozMzA2L3Byb2R1Y3RkYg==
  username: cHJvZHVjdF91c2Vy
  password: c2VjcmV0Cg==
---
# kubernetes/hpa.yaml (Horizontal Pod Autoscaler)
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: product-service-hpa
  namespace: prod
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: product-service
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
---
# kubernetes/ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-gateway-ingress
  namespace: prod
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - api.company.com
    secretName: api-tls
  rules:
  - host: api.company.com
    http:
      paths:
      - path: /api/products
        pathType: Prefix
        backend:
          service:
            name: product-service
            port:
              number: 80
      - path: /api/orders
        pathType: Prefix
        backend:
          service:
            name: order-service
            port:
              number: 80
```

---

## **19. SERVICE MESH**

> **Concept:** Dedicated infrastructure layer for service-to-service communication .

```yaml
# Istio VirtualService for traffic management
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: product-service
spec:
  hosts:
  - product-service
  http:
  - match:
    - headers:
        canary:
          exact: "true"
    route:
    - destination:
        host: product-service
        subset: v2
      weight: 100
  - route:
    - destination:
        host: product-service
        subset: v1
      weight: 90
    - destination:
        host: product-service
        subset: v2
      weight: 10
---
# Istio DestinationRule for load balancing and circuit breaking
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: product-service
spec:
  host: product-service
  trafficPolicy:
    connectionPool:
      tcp:
        maxConnections: 100
      http:
        http1MaxPendingRequests: 10
        http2MaxRequests: 1000
    loadBalancer:
      simple: ROUND_ROBIN
    outlierDetection:
      consecutive5xxErrors: 5
      interval: 30s
      baseEjectionTime: 30s
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
---
# Istio PeerAuthentication for mTLS
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: prod
spec:
  mtls:
    mode: STRICT
---
# Istio AuthorizationPolicy
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: product-service-authz
  namespace: prod
spec:
  selector:
    matchLabels:
      app: product-service
  action: ALLOW
  rules:
  - from:
    - source:
        principals: ["cluster.local/ns/prod/sa/order-service"]
    to:
    - operation:
        methods: ["GET"]
        paths: ["/api/products/*"]
```

---

## **20. OBSERVABILITY**

> **Concept:** Understanding system state through metrics, logs, and traces .

```java
// Micrometer metrics for Spring Boot
@RestController
@RequestMapping("/api/orders")
public class OrderController {
    
    private final MeterRegistry meterRegistry;
    private final Counter orderCounter;
    private final Timer orderTimer;
    
    public OrderController(MeterRegistry meterRegistry) {
        this.meterRegistry = meterRegistry;
        this.orderCounter = Counter.builder("orders.created")
            .description("Number of orders created")
            .tag("service", "order-service")
            .register(meterRegistry);
        
        this.orderTimer = Timer.builder("orders.processing.time")
            .description("Time to process orders")
            .register(meterRegistry);
    }
    
    @PostMapping
    public Order createOrder(@RequestBody OrderRequest request) {
        orderCounter.increment();  // Increment counter
        
        return orderTimer.record(() -> {
            // Actual order creation logic
            Order order = orderService.createOrder(request);
            
            // Custom metrics with tags
            meterRegistry.counter("orders.by.type", 
                "type", request.getOrderType()).increment();
            
            // Distribution summary for order value
            meterRegistry.summary("orders.value").record(order.getTotal());
            
            return order;
        });
    }
    
    @GetMapping("/metrics")
    public Map<String, Object> getMetrics() {
        return Map.of(
            "total_orders", orderCounter.count(),
            "average_time", orderTimer.totalTime(TimeUnit.MILLISECONDS) / orderTimer.count()
        );
    }
}
```

```yaml
# Prometheus configuration
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'microservices'
    metrics_path: '/actuator/prometheus'
    kubernetes_sd_configs:
    - role: pod
    relabel_configs:
    - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
      action: keep
      regex: true
    - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
      action: replace
      target_label: __metrics_path__
      regex: (.+)
    - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
      action: replace
      regex: ([^:]+)(?::\d+)?;(\d+)
      replacement: $1:$2
      target_label: __address__
```

---

## **21. DISTRIBUTED TRACING**

> **Concept:** Tracking requests across multiple services .

```java
// Spring Cloud Sleuth configuration
@Configuration
public class TracingConfig {
    
    @Bean
    public Sampler defaultSampler() {
        return Sampler.ALWAYS_SAMPLE;  // Sample all requests
    }
    
    @Bean
    public RestTemplate restTemplate(RestTemplateBuilder builder) {
        return builder
            .additionalInterceptors(new TracingClientHttpRequestInterceptor())
            .build();
    }
}

// Manual tracing
@Service
public class OrderService {
    
    @Autowired
    private Tracer tracer;
    
    public Order processOrder(OrderRequest request) {
        // Create custom span
        Span span = tracer.nextSpan().name("process-order").start();
        
        try (Tracer.SpanInScope ws = tracer.withSpanInScope(span)) {
            span.tag("order.id", request.getOrderId());
            span.tag("user.id", request.getUserId());
            
            // Business logic
            Order order = createOrder(request);
            
            span.annotate("order.created");
            return order;
            
        } catch (Exception e) {
            span.error(e);
            throw e;
        } finally {
            span.end();
        }
    }
}

// OpenTelemetry configuration
@Configuration
public class OpenTelemetryConfig {
    
    @Bean
    public OpenTelemetry openTelemetry() {
        Resource resource = Resource.getDefault()
            .toBuilder()
            .put(ResourceAttributes.SERVICE_NAME, "product-service")
            .put(ResourceAttributes.SERVICE_VERSION, "1.2.3")
            .build();
        
        SdkTracerProvider sdkTracerProvider = SdkTracerProvider.builder()
            .addSpanProcessor(BatchSpanProcessor.builder(
                OtlpGrpcSpanExporter.builder()
                    .setEndpoint("http://jaeger:4317")
                    .build()
            ).build())
            .setResource(resource)
            .build();
        
        return OpenTelemetrySdk.builder()
            .setTracerProvider(sdkTracerProvider)
            .build();
    }
}
```

```yaml
# docker-compose for tracing stack
version: '3'
services:
  jaeger:
    image: jaegertracing/all-in-one:latest
    ports:
      - "6831:6831/udp"
      - "16686:16686"
    environment:
      - COLLECTOR_OTLP_ENABLED=true
      
  zipkin:
    image: openzipkin/zipkin
    ports:
      - "9411:9411"
```

---

## **22. CENTRALIZED LOGGING**

> **Concept:** Aggregating logs from all services .

```xml
<!-- logback-spring.xml -->
<configuration>
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>
    
    <appender name="JSON" class="ch.qos.logback.core.ConsoleAppender">
        <encoder class="net.logstash.logback.encoder.LogstashEncoder">
            <includeMdcKeyName>traceId</includeMdcKeyName>
            <includeMdcKeyName>spanId</includeMdcKeyName>
            <includeMdcKeyName>userId</includeMdcKeyName>
            <includeMdcKeyName>requestId</includeMdcKeyName>
        </encoder>
    </appender>
    
    <logger name="com.company" level="DEBUG"/>
    
    <springProfile name="dev">
        <root level="INFO">
            <appender-ref ref="CONSOLE"/>
        </root>
    </springProfile>
    
    <springProfile name="prod">
        <root level="INFO">
            <appender-ref ref="JSON"/>
        </root>
    </springProfile>
</configuration>
```

```java
// Structured logging with MDC
@RestController
@Slf4j
public class LoggingController {
    
    @GetMapping("/api/users/{id}")
    public User getUser(@PathVariable String id) {
        // Add context to all logs in this thread
        MDC.put("userId", id);
        MDC.put("requestId", UUID.randomUUID().toString());
        
        try {
            log.info("Fetching user from database");
            User user = userService.findById(id);
            
            if (user == null) {
                log.warn("User not found: {}", id);
                throw new UserNotFoundException(id);
            }
            
            log.debug("User details: {}", user);
            return user;
            
        } catch (Exception e) {
            log.error("Error fetching user: {}", id, e);
            throw e;
        } finally {
            // Clean up MDC
            MDC.clear();
        }
    }
}

// Elasticsearch/Fluentd/Kibana stack
```

---

## **23. TESTING MICROSERVICES**

> **Concept:** Different levels of testing for microservices .

```java
// Unit Test
@ExtendWith(MockitoExtension.class)
class ProductServiceTest {
    
    @Mock
    private ProductRepository productRepository;
    
    @InjectMocks
    private ProductService productService;
    
    @Test
    void shouldReturnProductWhenFound() {
        // Given
        Long productId = 1L;
        Product expectedProduct = new Product(productId, "Test Product", 99.99);
        when(productRepository.findById(productId)).thenReturn(Optional.of(expectedProduct));
        
        // When
        Product result = productService.getProduct(productId);
        
        // Then
        assertEquals(expectedProduct, result);
        verify(productRepository).findById(productId);
    }
    
    @Test
    void shouldThrowExceptionWhenProductNotFound() {
        // Given
        Long productId = 999L;
        when(productRepository.findById(productId)).thenReturn(Optional.empty());
        
        // When/Then
        assertThrows(ProductNotFoundException.class, () -> {
            productService.getProduct(productId);
        });
    }
}

// Integration Test with testcontainers
@Testcontainers
@SpringBootTest
@AutoConfigureMockMvc
class ProductControllerIntegrationTest {
    
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:15")
            .withDatabaseName("testdb")
            .withUsername("test")
            .withPassword("test");
    
    @Container
    static KafkaContainer kafka = new KafkaContainer(DockerImageName.parse("confluentinc/cp-kafka:latest"));
    
    @Autowired
    private MockMvc mockMvc;
    
    @Autowired
    private ProductRepository productRepository;
    
    @DynamicPropertySource
    static void properties(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
        registry.add("spring.datasource.password", postgres::getPassword);
        registry.add("spring.datasource.username", postgres::getUsername);
        registry.add("spring.kafka.bootstrap-servers", kafka::getBootstrapServers);
    }
    
    @BeforeEach
    void setUp() {
        productRepository.deleteAll();
    }
    
    @Test
    void shouldCreateProduct() throws Exception {
        // Given
        ProductRequest request = new ProductRequest("New Product", 29.99);
        
        // When/Then
        mockMvc.perform(post("/api/products")
                .contentType(MediaType.APPLICATION_JSON)
                .content(asJsonString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.id").exists())
            .andExpect(jsonPath("$.name").value("New Product"))
            .andExpect(jsonPath("$.price").value(29.99));
        
        assertEquals(1, productRepository.count());
    }
}

// Contract Test with Pact
@ExtendWith(PactConsumerTestExt.class)
@PactTestFor(providerName = "product-service")
class ProductServiceContractTest {
    
    @Pact(consumer = "order-service")
    public RequestResponsePact createProductPact(PactDslWithProvider builder) {
        return builder
            .given("product exists")
            .uponReceiving("request for product with id 1")
                .path("/api/products/1")
                .method("GET")
            .willRespondWith()
                .status(200)
                .body(new PactDslJsonBody()
                    .integerType("id", 1)
                    .stringType("name", "Laptop")
                    .numberType("price", 999.99))
            .toPact();
    }
    
    @Test
    @PactTestFor(pactMethod = "createProductPact")
    void shouldReturnProduct() {
        RestTemplate restTemplate = new RestTemplate();
        Product product = restTemplate.getForObject("http://localhost:8080/api/products/1", Product.class);
        
        assertEquals(1L, product.getId());
        assertEquals("Laptop", product.getName());
        assertEquals(999.99, product.getPrice(), 0.01);
    }
}
```

---

## **24. DEPLOYMENT STRATEGIES**

> **Concept:** Different strategies for deploying microservices .

### **24.1 Blue-Green Deployment**

```yaml
# Kubernetes blue-green deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: product-service-blue
spec:
  replicas: 3
  selector:
    matchLabels:
      app: product-service
      version: blue
  template:
    metadata:
      labels:
        app: product-service
        version: blue
    spec:
      containers:
      - name: product-service
        image: company/product-service:1.0.0
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: product-service-green
spec:
  replicas: 3
  selector:
    matchLabels:
      app: product-service
      version: green
  template:
    metadata:
      labels:
        app: product-service
        version: green
    spec:
      containers:
      - name: product-service
        image: company/product-service:2.0.0
---
apiVersion: v1
kind: Service
metadata:
  name: product-service
spec:
  selector:
    app: product-service
    version: blue  # Switch to green when ready
  ports:
  - port: 80
    targetPort: 8080
```

### **24.2 Canary Deployment**

```yaml
# Istio canary deployment
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: product-service
spec:
  hosts:
  - product-service
  http:
  - route:
    - destination:
        host: product-service
        subset: v1
      weight: 90
    - destination:
        host: product-service
        subset: v2
      weight: 10  # Canary 10% traffic
---
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: product-service
spec:
  host: product-service
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
```

### **24.3 Rolling Update**

```yaml
# Kubernetes rolling update
apiVersion: apps/v1
kind: Deployment
metadata:
  name: product-service
spec:
  replicas: 5
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1        # Can create 1 extra pod
      maxUnavailable: 1  # Can take down 1 pod at a time
  template:
    spec:
      containers:
      - name: product-service
        image: company/product-service:2.0.0
```

---

## **25. DOMAIN-DRIVEN DESIGN (DDD)**

> **Concept:** Modeling microservices based on business domains and bounded contexts .

```java
// Domain Aggregate
@DomainAggregate
@Entity
@Table(name = "orders")
public class Order {
    
    @Id
    @GeneratedValue
    private Long id;
    
    @Embedded
    private CustomerId customerId;
    
    @Embedded
    private OrderStatus status;
    
    @Embedded
    private Money totalAmount;
    
    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id")
    private List<OrderItem> items = new ArrayList<>();
    
    // Domain behavior (not just getters/setters)
    public void addItem(Product product, int quantity) {
        OrderItem item = new OrderItem(product, quantity);
        items.add(item);
        recalculateTotal();
    }
    
    public void submit() {
        if (items.isEmpty()) {
            throw new DomainException("Cannot submit empty order");
        }
        this.status = OrderStatus.SUBMITTED;
        registerEvent(new OrderSubmittedEvent(this));
    }
    
    public void cancel() {
        if (status == OrderStatus.SHIPPED) {
            throw new DomainException("Cannot cancel shipped order");
        }
        this.status = OrderStatus.CANCELLED;
        registerEvent(new OrderCancelledEvent(this));
    }
    
    private void recalculateTotal() {
        this.totalAmount = items.stream()
            .map(OrderItem::getSubtotal)
            .reduce(Money.ZERO, Money::add);
    }
}

// Value Object
@Embeddable
public class Money {
    
    private BigDecimal amount;
    private String currency;
    
    protected Money() {}
    
    public Money(BigDecimal amount, String currency) {
        this.amount = amount;
        this.currency = currency;
    }
    
    public Money add(Money other) {
        if (!this.currency.equals(other.currency)) {
            throw new DomainException("Cannot add different currencies");
        }
        return new Money(this.amount.add(other.amount), this.currency);
    }
    
    // equals, hashCode
}

// Domain Service
@Service
@DomainService
public class PricingService {
    
    public Money calculatePrice(Product product, Customer customer) {
        Money basePrice = product.getBasePrice();
        
        if (customer.isVip()) {
            return basePrice.applyDiscount(new Percentage(10));
        }
        
        return basePrice;
    }
}

// Repository
@DomainRepository
public interface OrderRepository {
    Order findById(OrderId id);
    void save(Order order);
    List<Order> findByCustomer(CustomerId customerId);
}

// Application Service (orchestrates domain)
@Service
@Transactional
public class OrderApplicationService {
    
    @Autowired
    private OrderRepository orderRepository;
    
    @Autowired
    private PricingService pricingService;
    
    public OrderId createOrder(CreateOrderCommand command) {
        Order order = new Order(command.getCustomerId());
        
        for (OrderItemCommand itemCmd : command.getItems()) {
            Product product = productRepository.findById(itemCmd.getProductId());
            Money price = pricingService.calculatePrice(product, customer);
            order.addItem(product, itemCmd.getQuantity(), price);
        }
        
        orderRepository.save(order);
        return order.getId();
    }
}
```

---

## **26. STRANGLER FIG PATTERN**

> **Concept:** Incrementally migrating from monolith to microservices .

```java
// Step 1: Identify and extract a service boundary
// Original monolithic controller
@RestController
public class MonolithicController {
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private ProductService productService;
    
    @Autowired
    private OrderService orderService;
    
    @Autowired
    private PaymentService paymentService;
    
    @GetMapping("/user/{id}")
    public User getUser(@PathVariable Long id) {
        return userService.getUser(id);
    }
    
    @GetMapping("/product/{id}")
    public Product getProduct(@PathVariable Long id) {
        return productService.getProduct(id);
    }
    
    @PostMapping("/order")
    public Order createOrder(@RequestBody OrderRequest request) {
        return orderService.createOrder(request);
    }
}

// Step 2: Extract Product Service as separate microservice
// Add routing logic to monolith
@RestController
public class StranglerController {
    
    @Autowired
    private RestTemplate restTemplate;
    
    @Autowired
    private OrderService localOrderService;  // Still in monolith
    
    @Value("${services.product.url}")
    private String productServiceUrl;
    
    @GetMapping("/product/{id}")
    public Product getProduct(@PathVariable Long id) {
        // Route to new microservice
        return restTemplate.getForObject(
            productServiceUrl + "/api/products/" + id, 
            Product.class
        );
    }
    
    @PostMapping("/order")
    public Order createOrder(@RequestBody OrderRequest request) {
        // Still handled by monolith
        return localOrderService.createOrder(request);
    }
}

// Step 3: Implement routing pattern with feature flags
@Component
public class RoutingService {
    
    @Autowired
    private FeatureFlagService featureFlag;
    
    @Autowired
    private RestTemplate restTemplate;
    
    @Autowired
    private MonolithicService monolithService;
    
    public Order processOrder(OrderRequest request) {
        if (featureFlag.isEnabled("use-order-microservice")) {
            // Route to new microservice
            return restTemplate.postForObject(
                "http://order-service/api/orders",
                request,
                Order.class
            );
        } else {
            // Use monolith
            return monolithService.createOrder(request);
        }
    }
}
```

---

## **27. COMMON INTERVIEW QUESTIONS**

| Question | Answer |
|----------|--------|
| **What are microservices?** | Small, independent, deployable services each focused on specific business capability  |
| **Monolith vs Microservices?** | Monolith: single deployable unit. Microservices: multiple independent services with benefits in scalability, deployment speed, but added complexity  |
| **How do microservices communicate?** | Synchronous (REST, gRPC) or Asynchronous (messaging like Kafka, RabbitMQ)  |
| **What is API Gateway?** | Single entry point that routes requests, handles cross-cutting concerns (auth, rate limiting, aggregation)  |
| **What is Service Discovery?** | Mechanism for services to find each other dynamically (Eureka, Consul, Kubernetes DNS)  |
| **What is Circuit Breaker?** | Pattern that prevents cascading failures by stopping calls to failing services  |
| **What is Saga Pattern?** | Manages distributed transactions through series of local transactions with compensating actions  |
| **What is CQRS?** | Separating read and write operations into different models for optimization  |
| **What is BFF?** | Backend for Frontend - specialized backend for each frontend client  |
| **What is Outbox Pattern?** | Ensures reliable event publishing by storing events in database before sending  |
| **How do you handle distributed transactions?** | Use Saga pattern (choreography or orchestration), avoid distributed transactions (2PC)  |
| **What is Domain-Driven Design?** | Modeling services based on business domains and bounded contexts  |
| **How do you secure microservices?** | JWT/OAuth2 for authentication, mTLS for service-to-service, API Gateway for edge security  |
| **What is containerization?** | Packaging service with dependencies using Docker for consistency across environments  |
| **What is orchestration?** | Managing containers at scale with Kubernetes (deployment, scaling, service discovery) |
| **What is service mesh?** | Infrastructure layer for service-to-service communication (Istio, Linkerd)  |
| **What is observability?** | Understanding system through metrics, logs, and distributed traces  |
| **What is Strangler Fig pattern?** | Incrementally migrating from monolith to microservices  |

---

## **28. QUICK REFERENCE CHEAT SHEET**

```java
// ========== MICROSERVICE DEFINITION ==========
@SpringBootApplication
@RestController
public class ProductService {
    @GetMapping("/products/{id}")
    public Product getProduct(@PathVariable Long id) {
        return repository.findById(id);
    }
}

// ========== SERVICE COMMUNICATION ==========
// REST
restTemplate.getForObject("http://user-service/users/{id}", User.class, userId);

// Messaging
kafkaTemplate.send("order-events", new OrderCreatedEvent(order));

// ========== API GATEWAY ==========
@Bean
public RouteLocator routes(RouteLocatorBuilder builder) {
    return builder.routes()
        .route("products", r -> r.path("/api/products/**").uri("lb://PRODUCT-SERVICE"))
        .build();
}

// ========== SERVICE DISCOVERY ==========
@LoadBalanced
@Bean
public RestTemplate restTemplate() { return new RestTemplate(); }

// ========== CIRCUIT BREAKER ==========
@CircuitBreaker(name = "productService", fallbackMethod = "fallback")
public Product getProduct(Long id) { return client.getProduct(id); }

// ========== DISTRIBUTED TRACING ==========
// Add spring-cloud-starter-sleuth for automatic tracing

// ========== CENTRALIZED CONFIG ==========
@RefreshScope
@ConfigurationProperties(prefix = "app.product")

// ========== DOCKERFILE ==========
// FROM openjdk:17
// COPY target/*.jar app.jar
// ENTRYPOINT ["java", "-jar", "app.jar"]

// ========== KUBERNETES DEPLOYMENT ==========
// kubectl create deployment product-service --image=company/product-service:1.0
// kubectl expose deployment product-service --port=80 --target-port=8080

// ========== HEALTH CHECK ==========
// Add spring-boot-starter-actuator
// /actuator/health, /actuator/info

// ========== METRICS ==========
// micrometer.prometheus for Prometheus monitoring

// ========== DISTRIBUTED TRANSACTIONS ==========
// Use Saga pattern - event-based with compensating actions

// ========== CQRS EXAMPLE ==========
// Command: @PostMapping("/commands/products")
// Query: @GetMapping("/queries/products")
```

---

## **📝 KEY TAKEAWAYS**

1. **Microservices** are small, independent services focused on business capabilities 
2. **Communication** can be synchronous (REST/gRPC) or asynchronous (messaging) 
3. **API Gateway** handles cross-cutting concerns and routing 
4. **Service Discovery** enables dynamic location of services 
5. **Circuit Breaker** prevents cascading failures 
6. **Saga pattern** manages distributed transactions 
7. **CQRS** separates read and write models for optimization 
8. **BFF** provides specialized backends for each client 
9. **Outbox pattern** ensures reliable event publishing 
10. **Observability** through metrics, logs, and traces is essential 
11. **Containers (Docker)** package services consistently 
12. **Orchestration (Kubernetes)** manages container lifecycle
13. **Service Mesh** adds infrastructure layer for communication 
14. **Domain-Driven Design** helps define service boundaries 
15. **Strangler Fig pattern** enables incremental migration 

---

*Good luck with your interview! 🎉*