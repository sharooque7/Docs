# Complete Spring Boot Guide - The Ultimate Interview Reference 🍃

*Your comprehensive go-to reference for all Spring Boot concepts with brief explanations and code examples*

---

## **📋 TABLE OF CONTENTS**

1. [What is Spring Boot?](#1-what-is-spring-boot)
2. [Spring vs Spring Boot](#2-spring-vs-spring-boot)
3. [Core Features](#3-core-features)
4. [Spring Boot Starters](#4-spring-boot-starters)
5. [Auto-Configuration](#5-auto-configuration)
6. [Spring Boot Annotations](#6-spring-boot-annotations)
7. [Application Properties](#7-application-properties)
8. [Profiles](#8-profiles)
9. [Spring Boot Actuator](#9-spring-boot-actuator)
10. [Spring Boot DevTools](#10-spring-boot-devtools)
11. [Building REST APIs](#11-building-rest-apis)
12. [Spring Data JPA](#12-spring-data-jpa)
13. [Spring Security](#13-spring-security)
14. [Spring Boot Testing](#14-spring-boot-testing)
15. [Exception Handling](#15-exception-handling)
16. [Caching](#16-caching)
17. [Scheduling](#17-scheduling)
18. [Internationalization (i18n)](#18-internationalization-i18n)
19. [File Upload/Download](#19-file-uploaddownload)
20. [Validation](#20-validation)
21. [Logging](#21-logging)
22. [Spring Boot with Docker](#22-spring-boot-with-docker)
23. [Deployment Options](#23-deployment-options)
24. [Spring Boot 3.x New Features](#24-spring-boot-3x-new-features)
25. [Microservices with Spring Boot](#25-microservices-with-spring-boot)
26. [Spring Cloud Overview](#26-spring-cloud-overview)
27. [Reactive Programming with WebFlux](#27-reactive-programming-with-webflux)
28. [Performance Tuning](#28-performance-tuning)
29. [Common Interview Questions](#29-common-interview-questions)
30. [Quick Reference Cheat Sheet](#30-quick-reference-cheat-sheet)

---

## **1. WHAT IS SPRING BOOT?**

> **Concept:** Spring Boot is an open-source Java-based framework built on top of the Spring framework that simplifies the development of production-ready Spring applications with minimal configuration .

```java
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

### **Key Features :**

| Feature | Description |
|---------|-------------|
| **Auto-Configuration** | Automatically configures Spring applications based on dependencies |
| **Standalone** | Embedded servers (Tomcat, Jetty, Undertow) – no external server needed |
| **Starter Dependencies** | Simplified dependency management with "starter" POMs |
| **Actuator** | Production-ready features: health checks, metrics, monitoring |
| **No XML Configuration** | Java-based and annotation-based configuration only |
| **Spring Initializr** | Web-based tool to bootstrap projects quickly |

---

## **2. SPRING VS SPRING BOOT**

> **Concept:** Understanding the fundamental differences between the Spring Framework and Spring Boot .

| Feature | Spring Framework | Spring Boot |
|---------|------------------|-------------|
| **Configuration** | Requires manual XML or Java configuration | Provides auto-configuration with sensible defaults |
| **Server** | Needs external server (Tomcat, etc.) | Embedded server included |
| **Dependency Management** | Developers define all dependencies | Starter POMs simplify dependencies |
| **Boilerplate Code** | More boilerplate code | Significantly reduced boilerplate |
| **Production Features** | Not built-in | Actuator for monitoring, health checks |
| **Setup Time** | Longer (configuration required) | Rapid (minutes with Initializr) |

```java
// Spring (traditional) - requires configuration
@Configuration
@ComponentScan
@EnableWebMvc
public class AppConfig {
    @Bean
    public ViewResolver viewResolver() {
        // configuration
    }
}

// Spring Boot - single annotation
@SpringBootApplication
public class Application {
    // auto-configured!
}
```

---

## **3. CORE FEATURES**

> **Concept:** Spring Boot's core features that make development faster and easier .

### **3.1 Spring Boot Application Structure**

```
src/
├── main/
│   ├── java/
│   │   └── com/example/
│   │       ├── Application.java
│   │       ├── controller/
│   │       ├── service/
│   │       ├── repository/
│   │       ├── model/
│   │       └── config/
│   └── resources/
│       ├── application.properties
│       ├── static/
│       └── templates/
└── test/
    └── java/
```

### **3.2 Spring Boot Application Class**

```java
@SpringBootApplication  // Combines @Configuration + @EnableAutoConfiguration + @ComponentScan
public class Application {
    
    public static void main(String[] args) {
        // Bootstrap the application
        ConfigurableApplicationContext context = SpringApplication.run(Application.class, args);
        
        // Access beans
        MyService service = context.getBean(MyService.class);
    }
}

// Customizing SpringApplication
@SpringBootApplication
public class CustomApplication {
    
    public static void main(String[] args) {
        SpringApplication app = new SpringApplication(CustomApplication.class);
        app.setBannerMode(Banner.Mode.OFF);
        app.setDefaultProperties(Collections.singletonMap("server.port", "8083"));
        app.run(args);
    }
}
```

---

## **4. SPRING BOOT STARTERS**

> **Concept:** Starters are convenient dependency descriptors that bundle common dependencies for specific functionalities .

```xml
<!-- Maven dependencies -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

### **Common Starters :**

| Starter | Purpose |
|---------|---------|
| **spring-boot-starter-web** | Build web applications (RESTful, Spring MVC) with Tomcat |
| **spring-boot-starter-data-jpa** | Database access with JPA and Hibernate |
| **spring-boot-starter-security** | Authentication and authorization |
| **spring-boot-starter-test** | Testing dependencies (JUnit, Mockito, Hamcrest) |
| **spring-boot-starter-thymeleaf** | Server-side HTML templates |
| **spring-boot-starter-actuator** | Monitoring and management endpoints |
| **spring-boot-starter-validation** | Bean validation (Hibernate Validator) |
| **spring-boot-starter-cache** | Caching abstraction |

**Starter Naming Convention:** `spring-boot-starter-{module}`

---

## **5. AUTO-CONFIGURATION**

> **Concept:** Spring Boot automatically configures beans based on dependencies in the classpath and property settings .

### **How Auto-Configuration Works :**

1. **Scans classpath** for libraries (e.g., if H2 database is present)
2. **Applies @Conditional annotations** to decide which beans to create
3. **Configures default beans** (e.g., DataSource, EntityManagerFactory)
4. **Allows overriding** by providing custom beans

```java
// Auto-configuration example
@Configuration
@ConditionalOnClass(DataSource.class)
@EnableConfigurationProperties(DataSourceProperties.class)
public class DataSourceAutoConfiguration {
    
    @Bean
    @ConditionalOnMissingBean
    public DataSource dataSource(DataSourceProperties properties) {
        return properties.initializeDataSourceBuilder().build();
    }
}
```

### **Conditional Annotations :**

| Annotation | Condition |
|------------|-----------|
| `@ConditionalOnClass` | Class exists in classpath |
| `@ConditionalOnMissingClass` | Class does NOT exist |
| `@ConditionalOnBean` | Bean exists in context |
| `@ConditionalOnMissingBean` | Bean does NOT exist |
| `@ConditionalOnProperty` | Property has specific value |
| `@ConditionalOnResource` | Resource exists in classpath |
| `@ConditionalOnWebApplication` | Application is a web app |

### **Disabling Auto-Configuration**

```java
// Exclude specific auto-configuration
@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class})
public class Application {
    // ...
}

// Or in application.properties
spring.autoconfigure.exclude=org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration
```

### **Custom Starter Creation **

```java
// 1. Create auto-configuration class
@Configuration
@ConditionalOnClass(RedisOperations.class)
@EnableConfigurationProperties(RedisProperties.class)
public class RedisAutoConfiguration {
    
    @Bean
    @ConditionalOnMissingBean
    public RedisTemplate<String, Object> redisTemplate(
            RedisConnectionFactory factory) {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(factory);
        return template;
    }
}

// 2. Add to META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports
com.example.RedisAutoConfiguration
```

---

## **6. SPRING BOOT ANNOTATIONS**

> **Concept:** Core annotations used in Spring Boot applications .

### **6.1 Core Annotations**

```java
// @SpringBootApplication - main application class
@SpringBootApplication
public class Application { }

// @Configuration - defines bean configuration
@Configuration
public class AppConfig {
    
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}

// @Component - generic Spring-managed bean
@Component
public class MyComponent { }

// @Service - service layer bean
@Service
public class UserService { }

// @Repository - data access layer bean
@Repository
public class UserRepository { }

// @Controller - web controller (returns view)
@Controller
public class ViewController { }

// @RestController = @Controller + @ResponseBody
@RestController
@RequestMapping("/api/users")
public class UserController { }
```

### **6.2 Dependency Injection Annotations**

```java
@Service
public class UserService {
    
    // Field injection
    @Autowired
    private UserRepository userRepository;
    
    // Constructor injection (recommended)
    private final EmailService emailService;
    
    public UserService(EmailService emailService) {
        this.emailService = emailService;
    }
    
    // Setter injection
    @Autowired
    public void setConfig(Config config) {
        this.config = config;
    }
    
    // Qualifier for specific bean
    @Autowired
    @Qualifier("primaryDataSource")
    private DataSource dataSource;
    
    // Inject value from properties
    @Value("${app.name}")
    private String appName;
}
```

### **6.3 Web Annotations**

```java
@RestController
@RequestMapping("/api/users")
public class UserController {
    
    @GetMapping
    public List<User> getAllUsers() {
        return userService.findAll();
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<User> getUserById(@PathVariable Long id) {
        return userService.findById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }
    
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public User createUser(@RequestBody @Valid User user) {
        return userService.save(user);
    }
    
    @PutMapping("/{id}")
    public User updateUser(@PathVariable Long id, @RequestBody User user) {
        return userService.update(id, user);
    }
    
    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteUser(@PathVariable Long id) {
        userService.delete(id);
    }
    
    @GetMapping("/search")
    public List<User> searchUsers(
            @RequestParam(required = false) String name,
            @RequestParam(defaultValue = "0") int page) {
        return userService.search(name, page);
    }
}
```

---

## **7. APPLICATION PROPERTIES**

> **Concept:** Externalized configuration using properties or YAML files .

### **application.properties**

```properties
# Server configuration
server.port=8081
server.servlet.context-path=/api

# Database configuration
spring.datasource.url=jdbc:mysql://localhost:3306/mydb
spring.datasource.username=root
spring.datasource.password=secret
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA configuration
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect

# Logging
logging.level.org.springframework=INFO
logging.level.com.example=DEBUG
logging.file.path=./logs

# Custom properties
app.name=MyApplication
app.version=1.0.0
app.description=Sample Spring Boot App
```

### **application.yml (alternative)**

```yaml
server:
  port: 8081
  servlet:
    context-path: /api

spring:
  datasource:
    url: jdbc:mysql://localhost:3306/mydb
    username: root
    password: secret
    driver-class-name: com.mysql.cj.jdbc.Driver
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true
    properties:
      hibernate:
        dialect: org.hibernate.dialect.MySQL8Dialect

logging:
  level:
    org.springframework: INFO
    com.example: DEBUG
  file:
    path: ./logs

app:
  name: MyApplication
  version: 1.0.0
  description: Sample Spring Boot App
```

### **Reading Custom Properties **

```java
// Using @Value
@Component
public class AppConfig {
    
    @Value("${app.name}")
    private String appName;
    
    @Value("${app.version}")
    private String version;
}

// Using @ConfigurationProperties (recommended)
@Component
@ConfigurationProperties(prefix = "app")
@Data
public class AppProperties {
    private String name;
    private String version;
    private String description;
    private Security security = new Security();
    
    @Data
    public static class Security {
        private List<String> allowedOrigins;
        private boolean enabled;
    }
}
```

### **Property Sources Order **

1. Devtools global settings
2. `@TestPropertySource` on tests
3. `@SpringBootTest` properties
4. Command-line arguments
5. `SPRING_APPLICATION_JSON` environment variable
6. ServletConfig init parameters
7. ServletContext init parameters
8. JNDI attributes (`java:comp/env`)
9. Java System properties (`System.getProperties()`)
10. OS environment variables
11. `random.*` properties
12. Profile-specific properties (`application-{profile}.properties`)
13. Application properties (`application.properties`)

---

## **8. PROFILES**

> **Concept:** Segregate application configurations for different environments (dev, test, prod) .

### **Profile-Specific Properties**

```properties
# application-dev.properties
server.port=8081
spring.datasource.url=jdbc:h2:mem:devdb
logging.level.com.example=DEBUG

# application-prod.properties
server.port=80
spring.datasource.url=jdbc:mysql://prod-server:3306/proddb
logging.level.com.example=ERROR
```

### **Activating Profiles**

```properties
# In application.properties
spring.profiles.active=dev

# Command line
java -jar app.jar --spring.profiles.active=prod

# Environment variable
export SPRING_PROFILES_ACTIVE=dev

# Programmatically
SpringApplication.setAdditionalProfiles("dev");
```

### **Profile-Specific Beans**

```java
@Configuration
public class AppConfig {
    
    @Bean
    @Profile("dev")
    public DataSource devDataSource() {
        return new H2DataSource();
    }
    
    @Bean
    @Profile("prod")
    public DataSource prodDataSource() {
        return new MySQLDataSource();
    }
    
    @Bean
    @Profile("!test")  // NOT test profile
    public Service service() {
        return new Service();
    }
}

// Using @Profile on components
@Service
@Profile("dev")
public class DevEmailService implements EmailService {
    // only active in dev
}
```

---

## **9. SPRING BOOT ACTUATOR**

> **Concept:** Provides production-ready features to monitor and manage Spring Boot applications .

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

### **Configuration**

```properties
# Enable all endpoints
management.endpoints.web.exposure.include=*

# Enable specific endpoints
management.endpoints.web.exposure.include=health,info,metrics,env

# Disable sensitive endpoints
management.endpoint.shutdown.enabled=false

# Custom base path
management.endpoints.web.base-path=/manage

# Show details
management.endpoint.health.show-details=always
```

### **Common Actuator Endpoints **

| Endpoint | Description |
|----------|-------------|
| `/actuator/health` | Application health status |
| `/actuator/info` | Custom application information |
| `/actuator/metrics` | Metrics (memory, CPU, etc.) |
| `/actuator/env` | Environment properties |
| `/actuator/beans` | All Spring beans |
| `/actuator/mappings` | Request mappings |
| `/actuator/loggers` | Logger configuration |
| `/actuator/threaddump` | Thread dump |

### **Custom Health Indicator**

```java
@Component
public class CustomHealthIndicator implements HealthIndicator {
    
    @Override
    public Health health() {
        // Check external service
        boolean serviceUp = checkExternalService();
        
        if (serviceUp) {
            return Health.up()
                .withDetail("external.service", "available")
                .build();
        } else {
            return Health.down()
                .withDetail("external.service", "unavailable")
                .build();
        }
    }
    
    private boolean checkExternalService() {
        // logic
        return true;
    }
}
```

### **Custom Info Contributor**

```java
@Component
public class CustomInfoContributor implements InfoContributor {
    
    @Override
    public void contribute(Info.Builder builder) {
        builder.withDetail("app.name", "MyApp")
               .withDetail("app.version", "1.0.0")
               .withDetail("build.time", LocalDateTime.now());
    }
}
```

---

## **10. SPRING BOOT DEVTOOLS**

> **Concept:** Enhances development experience with automatic restarts, live reload, and configuration tweaks .

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <scope>runtime</scope>
    <optional>true</optional>
</dependency>
```

### **Features :**

| Feature | Description |
|---------|-------------|
| **Automatic Restart** | Restarts application when classpath files change |
| **Live Reload** | Integrates with browser LiveReload extension |
| **Property Defaults** | Disables caching (Thymeleaf, templates) |
| **Remote Debug** | Allows remote debugging |

### **Configuration**

```properties
# Disable automatic restart
spring.devtools.restart.enabled=false

# Additional paths to watch
spring.devtools.restart.additional-paths=src/main/java

# Exclude paths
spring.devtools.restart.exclude=static/**,public/**

# Trigger file (only restart when this file changes)
spring.devtools.restart.trigger-file=.reloadtrigger
```

---

## **11. BUILDING REST APIS**

> **Concept:** Creating RESTful web services with Spring Boot .

### **Complete REST Controller Example**

```java
@RestController
@RequestMapping("/api/v1/products")
@Slf4j
public class ProductController {
    
    private final ProductService productService;
    
    public ProductController(ProductService productService) {
        this.productService = productService;
    }
    
    // GET all
    @GetMapping
    public ResponseEntity<List<Product>> getAllProducts() {
        List<Product> products = productService.findAll();
        return ResponseEntity.ok(products);
    }
    
    // GET by id
    @GetMapping("/{id}")
    public ResponseEntity<Product> getProduct(@PathVariable Long id) {
        return productService.findById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }
    
    // POST create
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Product createProduct(@Valid @RequestBody Product product) {
        return productService.save(product);
    }
    
    // PUT update
    @PutMapping("/{id}")
    public ResponseEntity<Product> updateProduct(
            @PathVariable Long id,
            @Valid @RequestBody Product product) {
        return productService.update(id, product)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }
    
    // PATCH partial update
    @PatchMapping("/{id}")
    public ResponseEntity<Product> patchProduct(
            @PathVariable Long id,
            @RequestBody Map<String, Object> updates) {
        return productService.patch(id, updates)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }
    
    // DELETE
    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteProduct(@PathVariable Long id) {
        productService.delete(id);
    }
    
    // Custom query parameters
    @GetMapping("/search")
    public ResponseEntity<List<Product>> searchProducts(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) Double minPrice,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        
        List<Product> products = productService.search(category, minPrice, page, size);
        return ResponseEntity.ok(products);
    }
}
```

### **Request and Response DTOs**

```java
// Request DTO
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProductRequest {
    
    @NotBlank(message = "Name is required")
    @Size(min = 3, max = 100)
    private String name;
    
    @NotNull(message = "Price is required")
    @Positive(message = "Price must be positive")
    private BigDecimal price;
    
    private String description;
    
    @Min(0)
    private Integer stockQuantity;
}

// Response DTO
@Data
@AllArgsConstructor
public class ProductResponse {
    private Long id;
    private String name;
    private BigDecimal price;
    private String description;
    private Integer stockQuantity;
    private LocalDateTime createdAt;
}
```

### **ResponseEntity Usage**

```java
@GetMapping("/products")
public ResponseEntity<?> getProducts() {
    List<Product> products = productService.findAll();
    
    return ResponseEntity.ok()
        .header("X-Total-Count", String.valueOf(products.size()))
        .body(products);
}

@PostMapping("/products")
public ResponseEntity<Product> createProduct(@RequestBody Product product) {
    Product saved = productService.save(product);
    URI location = ServletUriComponentsBuilder
        .fromCurrentRequest()
        .path("/{id}")
        .buildAndExpand(saved.getId())
        .toUri();
    
    return ResponseEntity.created(location).body(saved);
}
```

---

## **12. SPRING DATA JPA**

> **Concept:** Simplifies data access using JPA with repository abstraction .

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
<dependency>
    <groupId>com.h2database</groupId>
    <artifactId>h2</artifactId>
    <scope>runtime</scope>
</dependency>
```

### **Entity Class **

```java
@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String username;
    
    @Column(nullable = false)
    private String password;
    
    @Column(nullable = false)
    private String email;
    
    @Column(name = "first_name")
    private String firstName;
    
    @Column(name = "last_name")
    private String lastName;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
    
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Order> orders;
}
```

### **Repository Layer **

```java
@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    
    // Derived query methods
    Optional<User> findByUsername(String username);
    
    List<User> findByLastName(String lastName);
    
    List<User> findByFirstNameContaining(String firstName);
    
    @Query("SELECT u FROM User u WHERE u.email = :email")
    Optional<User> findByEmailAddress(@Param("email") String email);
    
    @Query("SELECT u FROM User u WHERE u.lastName LIKE %:name% OR u.firstName LIKE %:name%")
    List<User> searchByName(@Param("name") String name);
    
    @Query(value = "SELECT * FROM users WHERE created_at > :date", nativeQuery = true)
    List<User> findRecentUsers(@Param("date") LocalDateTime date);
    
    boolean existsByUsername(String username);
    
    long countByLastName(String lastName);
    
    @Modifying
    @Query("UPDATE User u SET u.lastName = :lastName WHERE u.id = :id")
    int updateLastName(@Param("id") Long id, @Param("lastName") String lastName);
    
    // Pagination and sorting
    Page<User> findByLastName(String lastName, Pageable pageable);
    
    List<User> findByFirstName(String firstName, Sort sort);
}
```

### **Service Layer**

```java
@Service
@Transactional
@Slf4j
public class UserService {
    
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    
    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }
    
    public User createUser(User user) {
        // Validate
        if (userRepository.existsByUsername(user.getUsername())) {
            throw new UserAlreadyExistsException("Username already exists");
        }
        
        // Encode password
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        
        // Save
        User saved = userRepository.save(user);
        log.info("User created: {}", saved.getUsername());
        
        return saved;
    }
    
    public List<User> getAllUsers(Pageable pageable) {
        return userRepository.findAll(pageable).getContent();
    }
    
    public Optional<User> getUserById(Long id) {
        return userRepository.findById(id);
    }
    
    public User updateUser(Long id, User updatedUser) {
        return userRepository.findById(id)
            .map(existing -> {
                existing.setFirstName(updatedUser.getFirstName());
                existing.setLastName(updatedUser.getLastName());
                existing.setEmail(updatedUser.getEmail());
                return userRepository.save(existing);
            })
            .orElseThrow(() -> new UserNotFoundException("User not found with id: " + id));
    }
    
    @Transactional(readOnly = true)
    public List<User> searchUsers(String query) {
        return userRepository.searchByName(query);
    }
    
    public void deleteUser(Long id) {
        userRepository.deleteById(id);
        log.info("User deleted: {}", id);
    }
}
```

### **Pagination and Sorting**

```java
@GetMapping("/users")
public ResponseEntity<Page<User>> getUsers(
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "10") int size,
        @RequestParam(defaultValue = "id,asc") String[] sort) {
    
    List<Sort.Order> orders = new ArrayList<>();
    if (sort[0].contains(",")) {
        for (String sortOrder : sort) {
            String[] _sort = sortOrder.split(",");
            orders.add(new Sort.Order(getSortDirection(_sort[1]), _sort[0]));
        }
    } else {
        orders.add(new Sort.Order(getSortDirection(sort[1]), sort[0]));
    }
    
    Pageable pageable = PageRequest.of(page, size, Sort.by(orders));
    Page<User> userPage = userService.getUsers(pageable);
    
    return ResponseEntity.ok(userPage);
}

private Sort.Direction getSortDirection(String direction) {
    return direction.equalsIgnoreCase("desc") ? Sort.Direction.DESC : Sort.Direction.ASC;
}
```

---

## **13. SPRING SECURITY**

> **Concept:** Comprehensive security framework for authentication and authorization .

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

### **13.1 Basic Security Configuration (Spring Boot 3.x) **

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(authz -> authz
                .requestMatchers("/public/**").permitAll()
                .requestMatchers("/admin/**").hasRole("ADMIN")
                .requestMatchers("/api/**").authenticated()
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/login")
                .defaultSuccessUrl("/dashboard")
                .permitAll()
            )
            .logout(logout -> logout
                .logoutSuccessUrl("/")
                .permitAll()
            )
            .csrf(csrf -> csrf.disable()); // For APIs
            
        return http.build();
    }
    
    @Bean
    public UserDetailsService userDetailsService() {
        UserDetails user = User.builder()
            .username("user")
            .password(passwordEncoder().encode("password"))
            .roles("USER")
            .build();
        
        UserDetails admin = User.builder()
            .username("admin")
            .password(passwordEncoder().encode("admin"))
            .roles("ADMIN", "USER")
            .build();
        
        return new InMemoryUserDetailsManager(user, admin);
    }
    
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
```

### **13.2 JWT Authentication**

```java
@Component
public class JwtTokenProvider {
    
    @Value("${jwt.secret}")
    private String jwtSecret;
    
    @Value("${jwt.expiration}")
    private int jwtExpiration;
    
    public String generateToken(Authentication authentication) {
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        
        return Jwts.builder()
            .setSubject(userDetails.getUsername())
            .setIssuedAt(new Date())
            .setExpiration(new Date(new Date().getTime() + jwtExpiration))
            .signWith(SignatureAlgorithm.HS512, jwtSecret)
            .compact();
    }
    
    public boolean validateToken(String token) {
        try {
            Jwts.parser().setSigningKey(jwtSecret).parseClaimsJws(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }
    
    public String getUsernameFromToken(String token) {
        return Jwts.parser()
            .setSigningKey(jwtSecret)
            .parseClaimsJws(token)
            .getBody()
            .getSubject();
    }
}

// JWT Authentication Filter
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {
    
    @Autowired
    private JwtTokenProvider tokenProvider;
    
    @Autowired
    private UserDetailsService userDetailsService;
    
    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain chain) throws IOException, ServletException {
        String token = getJwtFromRequest(request);
        
        if (StringUtils.hasText(token) && tokenProvider.validateToken(token)) {
            String username = tokenProvider.getUsernameFromToken(token);
            UserDetails userDetails = userDetailsService.loadUserByUsername(username);
            
            UsernamePasswordAuthenticationToken authentication = 
                new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
            
            SecurityContextHolder.getContext().setAuthentication(authentication);
        }
        
        chain.doFilter(request, response);
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

### **13.3 Method Security**

```java
@Configuration
@EnableGlobalMethodSecurity(
    prePostEnabled = true,
    securedEnabled = true,
    jsr250Enabled = true
)
public class MethodSecurityConfig {
}

@Service
public class SecureService {
    
    @Secured("ROLE_ADMIN")
    public void adminOnly() { }
    
    @RolesAllowed("USER")
    public void userOnly() { }
    
    @PreAuthorize("hasRole('ADMIN')")
    public void adminOnlyPre() { }
    
    @PreAuthorize("hasAnyRole('USER', 'ADMIN')")
    public void userOrAdmin() { }
    
    @PreAuthorize("#id == authentication.principal.id")
    public void ownDataOnly(Long id) { }
    
    @PostAuthorize("returnObject.owner == authentication.name")
    public Document getDocument(Long id) { }
}
```

---

## **14. SPRING BOOT TESTING**

> **Concept:** Comprehensive testing support for Spring Boot applications .

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>
```

### **14.1 Unit Tests**

```java
@ExtendWith(MockitoExtension.class)
class UserServiceTest {
    
    @Mock
    private UserRepository userRepository;
    
    @InjectMocks
    private UserService userService;
    
    @Test
    void testFindUserById() {
        // Given
        Long userId = 1L;
        User expectedUser = new User();
        expectedUser.setId(userId);
        expectedUser.setUsername("testuser");
        
        when(userRepository.findById(userId)).thenReturn(Optional.of(expectedUser));
        
        // When
        Optional<User> result = userService.getUserById(userId);
        
        // Then
        assertThat(result).isPresent();
        assertThat(result.get().getUsername()).isEqualTo("testuser");
        verify(userRepository).findById(userId);
    }
}
```

### **14.2 Integration Tests**

```java
@SpringBootTest
@AutoConfigureMockMvc
@Transactional
class UserControllerIntegrationTest {
    
    @Autowired
    private MockMvc mockMvc;
    
    @Autowired
    private UserRepository userRepository;
    
    @Test
    void testGetAllUsers() throws Exception {
        // Create test data
        User user = new User();
        user.setUsername("testuser");
        user.setEmail("test@example.com");
        userRepository.save(user);
        
        // Perform request and verify
        mockMvc.perform(get("/api/users"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$", hasSize(1)))
            .andExpect(jsonPath("$[0].username").value("testuser"));
    }
    
    @Test
    void testCreateUser() throws Exception {
        String userJson = """
            {
                "username": "newuser",
                "email": "new@example.com",
                "password": "password123"
            }
            """;
        
        mockMvc.perform(post("/api/users")
                .contentType(MediaType.APPLICATION_JSON)
                .content(userJson))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.id").exists())
            .andExpect(jsonPath("$.username").value("newuser"));
    }
}
```

### **14.3 Web Layer Tests**

```java
@WebMvcTest(UserController.class)
class UserControllerWebTest {
    
    @Autowired
    private MockMvc mockMvc;
    
    @MockBean
    private UserService userService;
    
    @Test
    void testGetUserById() throws Exception {
        // Given
        Long userId = 1L;
        User user = new User();
        user.setId(userId);
        user.setUsername("testuser");
        
        when(userService.getUserById(userId)).thenReturn(Optional.of(user));
        
        // When/Then
        mockMvc.perform(get("/api/users/{id}", userId))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.username").value("testuser"));
    }
}
```

### **14.4 Data Layer Tests**

```java
@DataJpaTest
class UserRepositoryTest {
    
    @Autowired
    private TestEntityManager entityManager;
    
    @Autowired
    private UserRepository userRepository;
    
    @Test
    void testFindByUsername() {
        // Given
        User user = new User();
        user.setUsername("testuser");
        user.setEmail("test@example.com");
        entityManager.persist(user);
        entityManager.flush();
        
        // When
        Optional<User> found = userRepository.findByUsername("testuser");
        
        // Then
        assertThat(found).isPresent();
        assertThat(found.get().getEmail()).isEqualTo("test@example.com");
    }
}
```

---

## **15. EXCEPTION HANDLING**

> **Concept:** Global exception handling for REST APIs .

### **15.1 Custom Exceptions**

```java
@ResponseStatus(HttpStatus.NOT_FOUND)
public class ResourceNotFoundException extends RuntimeException {
    
    public ResourceNotFoundException(String message) {
        super(message);
    }
    
    public ResourceNotFoundException(String resource, Long id) {
        super(String.format("%s not found with id: %d", resource, id));
    }
}

@ResponseStatus(HttpStatus.BAD_REQUEST)
public class ValidationException extends RuntimeException {
    
    private final Map<String, String> errors;
    
    public ValidationException(String message) {
        super(message);
        this.errors = new HashMap<>();
    }
    
    public ValidationException(Map<String, String> errors) {
        super("Validation failed");
        this.errors = errors;
    }
}
```

### **15.2 Global Exception Handler**

```java
@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {
    
    @ExceptionHandler(ResourceNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ErrorResponse handleResourceNotFound(ResourceNotFoundException ex) {
        log.error("Resource not found: {}", ex.getMessage());
        return new ErrorResponse(HttpStatus.NOT_FOUND.value(), ex.getMessage());
    }
    
    @ExceptionHandler(ValidationException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ValidationErrorResponse handleValidation(ValidationException ex) {
        log.error("Validation failed", ex);
        return new ValidationErrorResponse(
            HttpStatus.BAD_REQUEST.value(),
            "Validation failed",
            ex.getErrors()
        );
    }
    
    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ValidationErrorResponse handleMethodArgumentNotValid(
            MethodArgumentNotValidException ex) {
        
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getFieldErrors()
            .forEach(error -> errors.put(error.getField(), error.getDefaultMessage()));
        
        return new ValidationErrorResponse(
            HttpStatus.BAD_REQUEST.value(),
            "Validation failed",
            errors
        );
    }
    
    @ExceptionHandler(AccessDeniedException.class)
    @ResponseStatus(HttpStatus.FORBIDDEN)
    public ErrorResponse handleAccessDenied(AccessDeniedException ex) {
        log.error("Access denied", ex);
        return new ErrorResponse(HttpStatus.FORBIDDEN.value(), "Access denied");
    }
    
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ErrorResponse handleGenericException(Exception ex) {
        log.error("Unexpected error", ex);
        return new ErrorResponse(
            HttpStatus.INTERNAL_SERVER_ERROR.value(),
            "An unexpected error occurred"
        );
    }
}

// Error Response DTOs
@Data
@AllArgsConstructor
class ErrorResponse {
    private int status;
    private String message;
    private LocalDateTime timestamp = LocalDateTime.now();
    
    public ErrorResponse(int status, String message) {
        this.status = status;
        this.message = message;
    }
}

@Data
class ValidationErrorResponse extends ErrorResponse {
    private Map<String, String> errors;
    
    public ValidationErrorResponse(int status, String message, Map<String, String> errors) {
        super(status, message);
        this.errors = errors;
    }
}
```

---

## **16. CACHING**

> **Concept:** Improve performance by caching method results .

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-cache</artifactId>
</dependency>
```

### **Configuration**

```java
@Configuration
@EnableCaching
public class CacheConfig {
    
    @Bean
    public CacheManager cacheManager() {
        SimpleCacheManager cacheManager = new SimpleCacheManager();
        cacheManager.setCaches(Arrays.asList(
            new ConcurrentMapCache("users"),
            new ConcurrentMapCache("products"),
            new ConcurrentMapCache("orders")
        ));
        return cacheManager;
    }
}

// Using Redis
@Configuration
@EnableCaching
public class RedisCacheConfig {
    
    @Bean
    public RedisCacheManager cacheManager(RedisConnectionFactory connectionFactory) {
        RedisCacheConfiguration config = RedisCacheConfiguration.defaultCacheConfig()
            .entryTtl(Duration.ofMinutes(10))
            .disableCachingNullValues();
        
        return RedisCacheManager.builder(connectionFactory)
            .cacheDefaults(config)
            .build();
    }
}
```

### **Caching Annotations**

```java
@Service
public class ProductService {
    
    // Cache result
    @Cacheable(value = "products", key = "#id")
    public Product getProductById(Long id) {
        slowMethod(); // Simulate expensive operation
        return productRepository.findById(id).orElse(null);
    }
    
    // Cache with condition
    @Cacheable(value = "products", condition = "#id > 100")
    public Product getExpensiveProduct(Long id) {
        return productRepository.findById(id).orElse(null);
    }
    
    // Update cache
    @CachePut(value = "products", key = "#product.id")
    public Product updateProduct(Product product) {
        return productRepository.save(product);
    }
    
    // Remove from cache
    @CacheEvict(value = "products", key = "#id")
    public void deleteProduct(Long id) {
        productRepository.deleteById(id);
    }
    
    // Clear entire cache
    @CacheEvict(value = "products", allEntries = true)
    public void clearProductCache() { }
    
    // Multiple caches
    @Caching(
        cacheable = @Cacheable("products"),
        evict = @CacheEvict(value = "popular", allEntries = true)
    )
    public Product getWithSideEffects(Long id) {
        return productRepository.findById(id).orElse(null);
    }
}
```

### **Cache Properties**

```properties
# Redis cache configuration
spring.cache.type=redis
spring.redis.host=localhost
spring.redis.port=6379
spring.cache.redis.time-to-live=600000
spring.cache.redis.cache-null-values=false
```

---

## **17. SCHEDULING**

> **Concept:** Execute tasks on a schedule .

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter</artifactId>
</dependency>
```

### **Enable Scheduling**

```java
@Configuration
@EnableScheduling
public class SchedulingConfig {
}
```

### **Scheduled Tasks**

```java
@Component
@Slf4j
public class ScheduledTasks {
    
    // Fixed delay (ms between task completion and next start)
    @Scheduled(fixedDelay = 5000)
    public void runWithFixedDelay() {
        log.info("Fixed delay task executed at {}", LocalDateTime.now());
    }
    
    // Fixed rate (ms between task start times)
    @Scheduled(fixedRate = 10000)
    public void runWithFixedRate() {
        log.info("Fixed rate task executed at {}", LocalDateTime.now());
    }
    
    // Initial delay before first execution
    @Scheduled(initialDelay = 10000, fixedRate = 5000)
    public void runWithInitialDelay() {
        log.info("Task with initial delay executed");
    }
    
    // Cron expression
    @Scheduled(cron = "0 0 2 * * ?") // Every day at 2 AM
    public void runDaily() {
        log.info("Daily task executed at {}", LocalDateTime.now());
    }
    
    // Cron with parameters
    @Scheduled(cron = "0 */5 * * * ?") // Every 5 minutes
    public void runEveryFiveMinutes() {
        log.info("Every 5 minutes task executed");
    }
    
    // Using fixed delay with properties
    @Scheduled(fixedDelayString = "${schedule.interval:5000}")
    public void runWithProperty() {
        log.info("Task with configurable interval");
    }
}

// application.properties
schedule.interval=10000
```

### **Cron Expression Format**

```
┌───────────── second (0-59)
│ ┌───────────── minute (0-59)
│ │ ┌───────────── hour (0-23)
│ │ │ ┌───────────── day of month (1-31)
│ │ │ │ ┌───────────── month (1-12)
│ │ │ │ │ ┌───────────── day of week (0-7) (0 or 7 is Sunday)
│ │ │ │ │ │
* * * * * *
```

---

## **18. INTERNATIONALIZATION (I18N)**

> **Concept:** Support multiple languages in your application .

### **Configuration**

```java
@Configuration
public class I18nConfig {
    
    @Bean
    public MessageSource messageSource() {
        ResourceBundleMessageSource messageSource = new ResourceBundleMessageSource();
        messageSource.setBasename("messages");
        messageSource.setDefaultEncoding("UTF-8");
        return messageSource;
    }
    
    @Bean
    public LocaleResolver localeResolver() {
        AcceptHeaderLocaleResolver resolver = new AcceptHeaderLocaleResolver();
        resolver.setDefaultLocale(Locale.ENGLISH);
        return resolver;
    }
    
    @Bean
    public LocaleChangeInterceptor localeChangeInterceptor() {
        LocaleChangeInterceptor interceptor = new LocaleChangeInterceptor();
        interceptor.setParamName("lang");
        return interceptor;
    }
    
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(localeChangeInterceptor());
    }
}
```

### **Message Properties Files**

```properties
# messages_en.properties
welcome.message=Welcome to our application!
greeting=Hello, {0}!
error.notfound=Resource not found

# messages_fr.properties
welcome.message=Bienvenue dans notre application!
greeting=Bonjour, {0}!
error.notfound=Ressource non trouvée

# messages_es.properties
welcome.message=¡Bienvenido a nuestra aplicación!
greeting=¡Hola, {0}!
error.notfound=Recurso no encontrado
```

### **Using Messages**

```java
@RestController
public class GreetingController {
    
    @Autowired
    private MessageSource messageSource;
    
    @GetMapping("/greet")
    public String greet(@RequestParam String name, Locale locale) {
        return messageSource.getMessage("greeting", new Object[]{name}, locale);
    }
    
    @GetMapping("/welcome")
    public String welcome(Locale locale) {
        return messageSource.getMessage("welcome.message", null, locale);
    }
}

// In Thymeleaf template
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<body>
    <h1 th:text="#{welcome.message}">Welcome</h1>
    <p th:text="#{greeting(${name})}">Hello, name</p>
    <a th:href="@{/?lang=en}">English</a> |
    <a th:href="@{/?lang=fr}">French</a>
</body>
</html>
```

---

## **19. FILE UPLOAD/DOWNLOAD**

> **Concept:** Handle file uploads and downloads in Spring Boot .

### **File Upload Configuration**

```java
@Configuration
public class FileUploadConfig {
    
    @Bean
    public MultipartConfigElement multipartConfigElement() {
        MultipartConfigFactory factory = new MultipartConfigFactory();
        factory.setMaxFileSize(DataSize.ofMegabytes(10));
        factory.setMaxRequestSize(DataSize.ofMegabytes(10));
        return factory.createMultipartConfig();
    }
}
```

### **application.properties**

```properties
# File upload configuration
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=10MB
spring.servlet.multipart.enabled=true
```

### **File Upload Controller**

```java
@RestController
@RequestMapping("/api/files")
@Slf4j
public class FileController {
    
    private final Path fileStorageLocation = Paths.get("uploads").toAbsolutePath().normalize();
    
    @PostMapping("/upload")
    public ResponseEntity<FileResponse> uploadFile(@RequestParam("file") MultipartFile file) {
        try {
            // Create directory if not exists
            Files.createDirectories(fileStorageLocation);
            
            // Generate unique filename
            String fileName = System.currentTimeMillis() + "_" + 
                StringUtils.cleanPath(file.getOriginalFilename());
            
            // Save file
            Path targetLocation = fileStorageLocation.resolve(fileName);
            Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);
            
            FileResponse response = new FileResponse(
                fileName,
                file.getContentType(),
                file.getSize(),
                "/api/files/download/" + fileName
            );
            
            return ResponseEntity.ok(response);
            
        } catch (IOException ex) {
            log.error("File upload failed", ex);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    @PostMapping("/upload/multiple")
    public ResponseEntity<List<FileResponse>> uploadMultipleFiles(
            @RequestParam("files") MultipartFile[] files) {
        
        List<FileResponse> responses = new ArrayList<>();
        
        for (MultipartFile file : files) {
            responses.add(uploadFile(file).getBody());
        }
        
        return ResponseEntity.ok(responses);
    }
    
    @GetMapping("/download/{fileName}")
    public ResponseEntity<Resource> downloadFile(@PathVariable String fileName) {
        try {
            Path filePath = fileStorageLocation.resolve(fileName).normalize();
            Resource resource = new UrlResource(filePath.toUri());
            
            if (resource.exists()) {
                return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .header(HttpHeaders.CONTENT_DISPOSITION, 
                        "attachment; filename=\"" + resource.getFilename() + "\"")
                    .body(resource);
            } else {
                return ResponseEntity.notFound().build();
            }
            
        } catch (IOException ex) {
            log.error("File download failed", ex);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    @GetMapping("/view/{fileName}")
    public ResponseEntity<Resource> viewFile(@PathVariable String fileName) {
        try {
            Path filePath = fileStorageLocation.resolve(fileName).normalize();
            Resource resource = new UrlResource(filePath.toUri());
            
            if (resource.exists()) {
                // Try to determine content type
                String contentType = Files.probeContentType(filePath);
                if (contentType == null) {
                    contentType = "application/octet-stream";
                }
                
                return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline")
                    .body(resource);
            } else {
                return ResponseEntity.notFound().build();
            }
            
        } catch (IOException ex) {
            log.error("File view failed", ex);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}

@Data
@AllArgsConstructor
class FileResponse {
    private String name;
    private String type;
    private long size;
    private String url;
}
```

---

## **20. VALIDATION**

> **Concept:** Validate incoming requests using Bean Validation .

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-validation</artifactId>
</dependency>
```

### **Validation Annotations **

```java
@Data
public class UserRegistrationRequest {
    
    @NotBlank(message = "Username is required")
    @Size(min = 3, max = 20, message = "Username must be between 3 and 20 characters")
    @Pattern(regexp = "^[a-zA-Z0-9_]+$", message = "Username can only contain letters, numbers, and underscore")
    private String username;
    
    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;
    
    @NotBlank(message = "Password is required")
    @Size(min = 8, message = "Password must be at least 8 characters")
    @Pattern(regexp = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=]).*$", 
             message = "Password must contain at least one digit, one lowercase, one uppercase, and one special character")
    private String password;
    
    @NotNull(message = "Age is required")
    @Min(value = 18, message = "Age must be at least 18")
    @Max(value = 100, message = "Age must be at most 100")
    private Integer age;
    
    @Past(message = "Birth date must be in the past")
    private LocalDate birthDate;
    
    @Future(message = "Event date must be in the future")
    private LocalDate eventDate;
    
    @NotBlank(message = "Phone number is required")
    @Pattern(regexp = "^\\d{10}$", message = "Phone number must be 10 digits")
    private String phoneNumber;
    
    @Valid  // Nested validation
    private Address address;
}

@Data
public class Address {
    
    @NotBlank(message = "Street is required")
    private String street;
    
    @NotBlank(message = "City is required")
    private String city;
    
    @NotBlank(message = "Zip code is required")
    @Pattern(regexp = "^\\d{5}$", message = "Zip code must be 5 digits")
    private String zipCode;
}
```

### **Controller Validation**

```java
@RestController
@RequestMapping("/api/users")
@Validated
public class UserController {
    
    @PostMapping("/register")
    public ResponseEntity<UserResponse> register(
            @Valid @RequestBody UserRegistrationRequest request) {
        // Validated automatically
        return ResponseEntity.ok(userService.register(request));
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<UserResponse> updateUser(
            @PathVariable @Positive(message = "ID must be positive") Long id,
            @Valid @RequestBody UserUpdateRequest request) {
        return ResponseEntity.ok(userService.update(id, request));
    }
    
    @GetMapping("/search")
    public ResponseEntity<List<UserResponse>> searchUsers(
            @RequestParam @Size(min = 3, message = "Query must be at least 3 characters") String query,
            @RequestParam(defaultValue = "0") @Min(0) int page,
            @RequestParam(defaultValue = "10") @Min(1) @Max(100) int size) {
        
        return ResponseEntity.ok(userService.search(query, page, size));
    }
}
```

### **Custom Validator**

```java
@Target({ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = UniqueEmailValidator.class)
public @interface UniqueEmail {
    String message() default "Email already exists";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}

@Component
public class UniqueEmailValidator implements ConstraintValidator<UniqueEmail, String> {
    
    @Autowired
    private UserRepository userRepository;
    
    @Override
    public boolean isValid(String email, ConstraintValidatorContext context) {
        return email != null && !userRepository.existsByEmail(email);
    }
}

// Usage
@Data
public class UserRequest {
    
    @NotBlank
    @Email
    @UniqueEmail
    private String email;
}
```

---

## **21. LOGGING**

> **Concept:** Configure and use logging in Spring Boot .

### **application.properties**

```properties
# Logging levels
logging.level.com.example=DEBUG
logging.level.org.springframework.web=INFO
logging.level.org.hibernate=ERROR

# File logging
logging.file.name=logs/application.log
logging.file.path=./logs
logging.logback.rollingpolicy.max-file-size=10MB
logging.logback.rollingpolicy.max-history=30

# Pattern
logging.pattern.console=%d{yyyy-MM-dd HH:mm:ss} - %msg%n
logging.pattern.file=%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n
```

### **logback-spring.xml**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <include resource="org/springframework/boot/logging/logback/base.xml"/>
    
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>logs/application.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>logs/application.%d{yyyy-MM-dd}.log</fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>
    
    <appender name="JSON" class="ch.qos.logback.core.ConsoleAppender">
        <encoder class="ch.qos.logback.classic.encoder.JsonEncoder"/>
    </appender>
    
    <springProfile name="dev">
        <root level="INFO">
            <appender-ref ref="CONSOLE"/>
        </root>
    </springProfile>
    
    <springProfile name="prod">
        <root level="WARN">
            <appender-ref ref="FILE"/>
            <appender-ref ref="JSON"/>
        </root>
    </springProfile>
</configuration>
```

### **Using Slf4j**

```java
@Service
@Slf4j  // Lombok annotation
public class UserService {
    
    // Equivalent to:
    // private static final Logger log = LoggerFactory.getLogger(UserService.class);
    
    public User createUser(User user) {
        log.debug("Creating user: {}", user);
        
        try {
            User saved = userRepository.save(user);
            log.info("User created successfully with id: {}", saved.getId());
            return saved;
        } catch (Exception e) {
            log.error("Failed to create user: {}", user.getUsername(), e);
            throw new UserCreationException("Failed to create user", e);
        }
    }
    
    public User getUser(Long id) {
        log.trace("Entering getUser with id: {}", id);
        
        Optional<User> user = userRepository.findById(id);
        
        if (user.isPresent()) {
            log.debug("Found user: {}", user.get());
            log.trace("Exiting getUser with found user");
            return user.get();
        }
        
        log.warn("User not found with id: {}", id);
        throw new UserNotFoundException("User not found");
    }
}
```

---

## **22. SPRING BOOT WITH DOCKER**

> **Concept:** Containerize Spring Boot applications using Docker.

### **Dockerfile**

```dockerfile
# Multi-stage build
FROM maven:3.8.4-openjdk-17-slim AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn package -DskipTests

FROM openjdk:17-jre-slim
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

# Create non-root user
RUN addgroup --system --gid 1000 appuser && \
    adduser --system --uid 1000 --gid 1000 appuser
USER appuser

EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]
```

### **docker-compose.yml**

```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      SPRING_PROFILES_ACTIVE: docker
      SPRING_DATASOURCE_URL: jdbc:postgresql://db:5432/mydb
      SPRING_DATASOURCE_USERNAME: user
      SPRING_DATASOURCE_PASSWORD: password
    depends_on:
      - db
      - redis
    networks:
      - app-network

  db:
    image: postgres:15
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    volumes:
      - postgres-data:/var/lib/postgresql/data
    networks:
      - app-network

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    networks:
      - app-network

volumes:
  postgres-data:

networks:
  app-network:
    driver: bridge
```

---

## **23. DEPLOYMENT OPTIONS**

> **Concept:** Different ways to deploy Spring Boot applications .

### **23.1 Executable JAR (Default)**

```bash
# Build
mvn clean package

# Run
java -jar target/myapp.jar

# With arguments
java -jar target/myapp.jar --server.port=8081 --spring.profiles.active=prod

# With JVM options
java -Xmx512m -Xms256m -jar target/myapp.jar

# As background service
nohup java -jar target/myapp.jar > app.log 2>&1 &
```

### **23.2 WAR Deployment (Traditional)**

```xml
<!-- pom.xml -->
<packaging>war</packaging>

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-tomcat</artifactId>
    <scope>provided</scope>
</dependency>
```

```java
@SpringBootApplication
public class Application extends SpringBootServletInitializer {
    
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(Application.class);
    }
    
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

### **23.3 Cloud Deployment (AWS Elastic Beanstalk)**

```yaml
# Procfile
web: java -jar target/myapp.jar
```

### **23.4 Kubernetes Deployment**

```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spring-boot-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: spring-boot-app
  template:
    metadata:
      labels:
        app: spring-boot-app
    spec:
      containers:
      - name: app
        image: myregistry/spring-app:latest
        ports:
        - containerPort: 8080
        env:
        - name: SPRING_PROFILES_ACTIVE
          value: "k8s"
        - name: SPRING_DATASOURCE_URL
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
# service.yaml
apiVersion: v1
kind: Service
metadata:
  name: spring-boot-service
spec:
  selector:
    app: spring-boot-app
  ports:
  - port: 80
    targetPort: 8080
  type: LoadBalancer
```

---

## **24. SPRING BOOT 3.X NEW FEATURES**

> **Concept:** Key features introduced in Spring Boot 3.x .

### **Major Changes **

| Feature | Description |
|---------|-------------|
| **Java 17+ Baseline** | Requires Java 17 minimum |
| **Jakarta EE 9+** | javax → jakarta namespace migration |
| **GraalVM Native Images** | Improved native image support |
| **Observability** | Enhanced with Micrometer Tracing |
| **AOT (Ahead-of-Time)** | Improved startup performance |
| **Problem Details** | RFC 7807 support for error responses |

### **Native Image Support**

```xml
<plugin>
    <groupId>org.graalvm.buildtools</groupId>
    <artifactId>native-maven-plugin</artifactId>
    <version>0.9.20</version>
    <extensions>true</extensions>
    <configuration>
        <mainClass>com.example.Application</mainClass>
        <buildArgs>
            <buildArg>-H:IncludeResources=.*/.*properties$</buildArg>
        </buildArgs>
    </configuration>
</plugin>
```

### **Observability with Micrometer**

```java
@Configuration
public class ObservabilityConfig {
    
    @Bean
    public ObservationRegistry observationRegistry() {
        return ObservationRegistry.create();
    }
    
    @Bean
    public ObservationHandler<Observation.Context> observationHandler() {
        return new LoggingObservationHandler();
    }
}

@Service
public class ObservedService {
    
    private final ObservationRegistry registry;
    
    public ObservedService(ObservationRegistry registry) {
        this.registry = registry;
    }
    
    @Observed(name = "user.service.process",
             contextualName = "user-processing")
    public User processUser(User user) {
        return userService.process(user);
    }
}
```

### **HTTP Problem Details**

```java
@RestControllerAdvice
public class ProblemDetailsExceptionHandler {
    
    @ExceptionHandler(ResourceNotFoundException.class)
    public ProblemDetail handleNotFound(ResourceNotFoundException ex) {
        ProblemDetail problemDetail = ProblemDetail.forStatus(HttpStatus.NOT_FOUND);
        problemDetail.setTitle("Resource Not Found");
        problemDetail.setDetail(ex.getMessage());
        problemDetail.setProperty("timestamp", LocalDateTime.now());
        return problemDetail;
    }
}
```

---

## **25. MICROSERVICES WITH SPRING BOOT**

> **Concept:** Building distributed systems using Spring Boot microservices .

### **Microservice Architecture **

```
                   ┌──────────────────┐
                   │   API Gateway    │
                   └────────┬─────────┘
         ┌──────────────────┼──────────────────┐
         │                  │                  │
    ┌────▼─────┐      ┌─────▼─────┐      ┌────▼─────┐
    │  Order   │      │  Product  │      │  User    │
    │ Service  │      │  Service  │      │ Service  │
    └────┬─────┘      └─────┬─────┘      └────┬─────┘
         │                  │                  │
    ┌────▼─────┐      ┌─────▼─────┐      ┌────▼─────┐
    │Order DB  │      │Product DB │      │ User DB  │
    └──────────┘      └───────────┘      └──────────┘
```

### **Service Discovery with Eureka**

```java
// Service Registry (Eureka Server)
@SpringBootApplication
@EnableEurekaServer
public class ServiceRegistryApplication {
    public static void main(String[] args) {
        SpringApplication.run(ServiceRegistryApplication.class, args);
    }
}

// application.yml
server:
  port: 8761

eureka:
  client:
    register-with-eureka: false
    fetch-registry: false
```

```java
// Microservice (Eureka Client)
@SpringBootApplication
@EnableEurekaClient
public class ProductServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(ProductServiceApplication.class, args);
    }
}

// application.yml
spring:
  application:
    name: product-service

eureka:
  client:
    service-url:
      defaultZone: http://localhost:8761/eureka/
```

### **API Gateway (Spring Cloud Gateway)**

```java
@SpringBootApplication
public class ApiGatewayApplication {
    
    @Bean
    public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
        return builder.routes()
            .route("product-service", r -> r
                .path("/api/products/**")
                .uri("lb://PRODUCT-SERVICE"))
            .route("order-service", r -> r
                .path("/api/orders/**")
                .filters(f -> f.circuitBreaker(config -> config
                    .setName("orderService")
                    .setFallbackUri("forward:/fallback/orders")))
                .uri("lb://ORDER-SERVICE"))
            .build();
    }
}
```

### **Feign Client for Service Communication**

```java
@FeignClient(name = "product-service", configuration = FeignConfig.class)
public interface ProductClient {
    
    @GetMapping("/api/products/{id}")
    Product getProductById(@PathVariable("id") Long id);
    
    @GetMapping("/api/products/search")
    List<Product> searchProducts(@RequestParam("query") String query);
}

@Configuration
public class FeignConfig {
    
    @Bean
    public Retryer feignRetryer() {
        return new Retryer.Default(100, 1000, 3);
    }
    
    @Bean
    public ErrorDecoder errorDecoder() {
        return (methodKey, response) -> {
            if (response.status() >= 500) {
                return new RetryableException("Server error", response.request());
            }
            return new Exception("Client error");
        };
    }
}
```

### **Resilience4j Circuit Breaker**

```java
@Service
public class ProductService {
    
    @Autowired
    private ProductClient productClient;
    
    @CircuitBreaker(name = "productService", fallbackMethod = "getProductFallback")
    @Retry(name = "productService")
    @Bulkhead(name = "productService")
    public Product getProduct(Long id) {
        return productClient.getProductById(id);
    }
    
    public Product getProductFallback(Long id, Exception ex) {
        // Fallback logic
        return new Product(id, "Unavailable", 0.0);
    }
}
```

### **Distributed Tracing**

```yaml
# application.yml
management:
  tracing:
    sampling:
      probability: 1.0
  zipkin:
    tracing:
      endpoint: http://zipkin:9411/api/v2/spans
```

---

## **26. SPRING CLOUD OVERVIEW**

> **Concept:** Suite of tools for building cloud-native applications .

### **Spring Cloud Components **

| Component | Purpose |
|-----------|---------|
| **Spring Cloud Config** | Externalized configuration |
| **Spring Cloud Netflix** | Eureka (discovery), Zuul (gateway) |
| **Spring Cloud Gateway** | API Gateway (reactive) |
| **Spring Cloud LoadBalancer** | Client-side load balancing |
| **Spring Cloud Circuit Breaker** | Resilience4j integration |
| **Spring Cloud Sleuth** | Distributed tracing |
| **Spring Cloud Stream** | Event-driven microservices |
| **Spring Cloud Bus** | Event bus for configuration |

### **Configuration Server**

```java
@SpringBootApplication
@EnableConfigServer
public class ConfigServerApplication {
    public static void main(String[] args) {
        SpringApplication.run(ConfigServerApplication.class, args);
    }
}

// application.yml
spring:
  cloud:
    config:
      server:
        git:
          uri: https://github.com/config-repo
          search-paths: '{application}'
          default-label: main
server:
  port: 8888
```

---

## **27. REACTIVE PROGRAMMING WITH WEBFLUX**

> **Concept:** Build non-blocking, reactive applications using Project Reactor .

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-webflux</artifactId>
</dependency>
```

### **Reactive Controller**

```java
@RestController
@RequestMapping("/api/reactive/users")
public class ReactiveUserController {
    
    private final ReactiveUserRepository userRepository;
    
    public ReactiveUserController(ReactiveUserRepository userRepository) {
        this.userRepository = userRepository;
    }
    
    @GetMapping
    public Flux<User> getAllUsers() {
        return userRepository.findAll();
    }
    
    @GetMapping("/{id}")
    public Mono<ResponseEntity<User>> getUserById(@PathVariable String id) {
        return userRepository.findById(id)
            .map(ResponseEntity::ok)
            .defaultIfEmpty(ResponseEntity.notFound().build());
    }
    
    @PostMapping
    public Mono<User> createUser(@RequestBody User user) {
        return userRepository.save(user);
    }
    
    @GetMapping("/stream")
    public Flux<User> streamUsers() {
        return userRepository.findBy();
    }
}

// Reactive Repository
public interface ReactiveUserRepository extends ReactiveCrudRepository<User, String> {
    Flux<User> findByLastName(String lastName);
    Mono<User> findByEmail(String email);
}
```

### **WebClient (Reactive HTTP Client)**

```java
@Service
public class ReactiveProductService {
    
    private final WebClient webClient;
    
    public ReactiveProductService() {
        this.webClient = WebClient.builder()
            .baseUrl("http://product-service")
            .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
            .build();
    }
    
    public Mono<Product> getProduct(Long id) {
        return webClient.get()
            .uri("/api/products/{id}", id)
            .retrieve()
            .bodyToMono(Product.class)
            .timeout(Duration.ofSeconds(5))
            .retryWhen(Retry.backoff(3, Duration.ofSeconds(1)));
    }
    
    public Flux<Product> searchProducts(String query) {
        return webClient.get()
            .uri(uriBuilder -> uriBuilder
                .path("/api/products/search")
                .queryParam("q", query)
                .build())
            .retrieve()
            .bodyToFlux(Product.class);
    }
}
```

### **Reactive vs Traditional Comparison **

| Aspect | Servlet (Traditional) | WebFlux (Reactive) |
|--------|----------------------|-------------------|
| **Thread Model** | One thread per request | Event loop (few threads) |
| **Concurrency** | Limited by thread pool | Handles many concurrent connections |
| **Blocking** | Blocking operations | Non-blocking throughout |
| **Backpressure** | Not supported | Built-in support |
| **Database** | JPA, JDBC | R2DBC, MongoDB Reactive |

---

## **28. PERFORMANCE TUNING**

> **Concept:** Optimize Spring Boot applications for better performance .

### **28.1 Database Optimization**

```java
// Use indexes
@Entity
@Table(name = "users", indexes = {
    @Index(name = "idx_email", columnList = "email"),
    @Index(name = "idx_last_name", columnList = "last_name")
})
public class User { }

// N+1 query prevention
@Query("SELECT u FROM User u JOIN FETCH u.orders")
List<User> findAllWithOrders();

// Pagination
@Query(value = "SELECT * FROM users ORDER BY id",
       countQuery = "SELECT count(*) FROM users",
       nativeQuery = true)
Page<User> findAllUsers(Pageable pageable);
```

### **28.2 Connection Pooling**

```properties
# HikariCP configuration
spring.datasource.hikari.connection-timeout=30000
spring.datasource.hikari.maximum-pool-size=20
spring.datasource.hikari.minimum-idle=5
spring.datasource.hikari.idle-timeout=600000
spring.datasource.hikari.max-lifetime=1800000
```

### **28.3 Caching Strategy**

```java
@Configuration
@EnableCaching
public class CacheConfig {
    
    @Bean
    public CacheManager cacheManager() {
        return new ConcurrentMapCacheManager("products", "users");
    }
}

@Service
public class ProductService {
    
    @Cacheable(value = "products", unless = "#result == null")
    public Product getProduct(Long id) {
        return productRepository.findById(id).orElse(null);
    }
}
```

### **28.4 Async Processing**

```java
@Configuration
@EnableAsync
public class AsyncConfig {
    
    @Bean(name = "taskExecutor")
    public Executor taskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(5);
        executor.setMaxPoolSize(10);
        executor.setQueueCapacity(100);
        executor.setThreadNamePrefix("async-");
        executor.initialize();
        return executor;
    }
}

@Service
public class EmailService {
    
    @Async
    public CompletableFuture<Boolean> sendEmail(String to, String subject, String body) {
        // Long operation
        return CompletableFuture.completedFuture(true);
    }
}
```

### **28.5 Compression**

```properties
# Enable response compression
server.compression.enabled=true
server.compression.mime-types=application/json,application/xml,text/html,text/plain
server.compression.min-response-size=1024
```

### **28.6 HTTP/2**

```properties
# Enable HTTP/2
server.http2.enabled=true
server.port=8443
server.ssl.enabled=true
server.ssl.key-store=classpath:keystore.p12
server.ssl.key-store-password=password
server.ssl.key-store-type=PKCS12
```

---

## **29. COMMON INTERVIEW QUESTIONS**

### **Basic Level **

| Question | Answer |
|----------|--------|
| **What is Spring Boot?** | Framework that simplifies Spring application development with auto-configuration, embedded servers, and starters  |
| **What are the advantages of Spring Boot?** | Auto-configuration, standalone applications, production-ready features, microservices-friendly, reduced boilerplate  |
| **What is @SpringBootApplication?** | Combination of @Configuration, @EnableAutoConfiguration, and @ComponentScan  |
| **What are Spring Boot Starters?** | Dependency descriptors that bundle common dependencies for specific functionalities  |
| **What is Spring Initializr?** | Web tool to bootstrap Spring Boot projects with selected dependencies  |
| **What is Spring Boot DevTools?** | Development tools providing automatic restart, live reload, and faster development  |

### **Intermediate Level **

| Question | Answer |
|----------|--------|
| **How does auto-configuration work?** | Scans classpath, applies @Conditional annotations, configures beans based on dependencies present  |
| **What is Spring Boot Actuator?** | Module providing monitoring and management endpoints (health, metrics, env, etc.)  |
| **How to disable specific auto-configuration?** | Using `@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class})` or properties  |
| **What are Profiles?** | Environment-specific configurations (dev, test, prod) using profile-specific property files  |
| **Difference between @RestController and @Controller?** | @RestController = @Controller + @ResponseBody; returns JSON/XML directly  |
| **How to read custom properties?** | Using @Value or @ConfigurationProperties  |

### **Advanced Level **

| Question | Answer |
|----------|--------|
| **How to create a custom starter?** | Auto-configuration class + META-INF/spring/...AutoConfiguration.imports file  |
| **Explain Spring Boot's auto-configuration process** | Based on condition annotations, scanning classpath for libraries, and applying default configurations  |
| **How to secure a Spring Boot application?** | Using Spring Security, configure SecurityFilterChain, UserDetailsService, PasswordEncoder  |
| **How to handle exceptions globally?** | @ControllerAdvice with @ExceptionHandler methods  |
| **How to implement caching?** | @EnableCaching, @Cacheable, @CacheEvict, @CachePut annotations  |
| **What's new in Spring Boot 3.x?** | Java 17 baseline, Jakarta EE 9+, native images, improved observability  |
| **How to monitor Spring Boot applications?** | Actuator endpoints, Micrometer, Prometheus, Grafana integration  |

---

## **30. QUICK REFERENCE CHEAT SHEET**

```java
// ========== APPLICATION ==========
@SpringBootApplication
public class App { 
    public static void main(String[] args) {
        SpringApplication.run(App.class, args);
    }
}

// ========== ANNOTATIONS ==========
@RestController
@RequestMapping("/api/users")
public class UserController {
    @Autowired private UserService service;
    
    @GetMapping("/{id}")
    public User get(@PathVariable Long id) { }
    
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public User create(@RequestBody @Valid User user) { }
}

// ========== DEPENDENCY INJECTION ==========
@Service
public class UserService {
    private final UserRepository repo;
    
    public UserService(UserRepository repo) { this.repo = repo; }
    
    @Value("${app.name}")
    private String appName;
}

// ========== JPA ==========
@Entity
public class User {
    @Id @GeneratedValue private Long id;
    @Column(unique = true) private String email;
}

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
}

// ========== PROPERTIES ==========
@ConfigurationProperties(prefix = "app")
public class AppProperties {
    private String name;
    private String version;
}

// ========== SECURITY ==========
@Bean
public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    return http.authorizeHttpRequests(auth -> auth
        .requestMatchers("/public/**").permitAll()
        .anyRequest().authenticated())
        .build();
}

// ========== TESTING ==========
@SpringBootTest
@AutoConfigureMockMvc
class ControllerTest {
    @Autowired private MockMvc mockMvc;
    @MockBean private UserService userService;
}

// ========== EXCEPTION HANDLING ==========
@ControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(ResourceNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ErrorResponse handleNotFound(ResourceNotFoundException ex) { }
}

// ========== CACHING ==========
@Cacheable(value = "users", key = "#id")
public User getUser(Long id) { }

@CacheEvict(value = "users", key = "#id")
public void deleteUser(Long id) { }

// ========== SCHEDULING ==========
@Scheduled(cron = "0 0 * * * ?")
public void hourlyTask() { }

// ========== ACTUATOR ENDPOINTS ==========
// /actuator/health
// /actuator/info
// /actuator/metrics
// /actuator/env
// /actuator/beans
```

---

## **📝 KEY TAKEAWAYS**

1. **Auto-Configuration** – Spring Boot configures beans automatically based on dependencies
2. **Starters** – Simplify dependency management for common use cases
3. **Embedded Servers** – Run applications standalone without external servers
4. **Actuator** – Production-ready monitoring and management
5. **Profiles** – Environment-specific configurations
6. **Testing** – Comprehensive support with @SpringBootTest, @WebMvcTest, @DataJpaTest
7. **Security** – Spring Security for authentication and authorization
8. **Data Access** – Spring Data JPA simplifies database operations
9. **REST APIs** – Easy creation with @RestController and annotations
10. **Microservices Ready** – Built for distributed systems with Spring Cloud

---

*Good luck with your Spring Boot interview! 🍃🎉*