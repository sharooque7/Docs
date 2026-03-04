# Spring Boot Lifecycle and Annotations - Complete Interview Guide 🍃

*Your comprehensive reference for Spring Boot's internal workings and all essential annotations*

---

## **📋 TABLE OF CONTENTS**

1. [Spring Boot Application Lifecycle](#1-spring-boot-application-lifecycle)
2. [Application Startup Phases](#2-application-startup-phases)
3. [Bean Lifecycle](#3-bean-lifecycle)
4. [Bean Scopes](#4-bean-scopes)
5. [Core Annotations](#5-core-annotations)
6. [StereoType Annotations](#6-stereotype-annotations)
7. [Dependency Injection Annotations](#7-dependency-injection-annotations)
8. [Configuration Annotations](#8-configuration-annotations)
9. [Conditional Annotations](#9-conditional-annotations)
10. [Web/REST Annotations](#10-web-rest-annotations)
11. [Data Access Annotations](#11-data-access-annotations)
12. [Transaction Annotations](#12-transaction-annotations)
13. [Validation Annotations](#13-validation-annotations)
14. [Testing Annotations](#14-testing-annotations)
15. [Caching Annotations](#15-caching-annotations)
16. [Async Annotations](#16-async-annotations)
17. [Scheduling Annotations](#17-scheduling-annotations)
18. [Profile Annotations](#18-profile-annotations)
19. [Property Source Annotations](#19-property-source-annotations)
20. [Lifecycle Callback Annotations](#20-lifecycle-callback-annotations)
21. [Annotations Cheat Sheet](#21-annotations-cheat-sheet)

---

## **1. SPRING BOOT APPLICATION LIFECYCLE**

> **Concept:** The complete journey from starting the application to its shutdown, including all phases and hooks .

```
┌─────────────────────────────────────────────────────────────────┐
│                    SPRING BOOT APPLICATION LIFECYCLE            │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                          START APPLICATION                       │
│                     SpringApplication.run()                      │
└─────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────┐
│                   1. APPLICATION PREPARATION                     │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ • Detect application type (Servlet/Reactive)                │ │
│  │ • Load initializers and listeners                           │ │
│  │ • Set application context classloader                       │ │
│  │ • Create SpringApplicationRunListeners                      │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────┐
│                   2. ENVIRONMENT PREPARATION                     │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ • Load application.properties/yml                           │ │
│  │ • Parse command line arguments                              │ │
│  │ • Create and configure environment                          │ │
│  │ • Add active profiles                                       │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────┐
│                   3. APPLICATION CONTEXT CREATION                │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ • Create appropriate ApplicationContext                     │ │
│  │   (AnnotationConfigServletWebServerApplicationContext)      │ │
│  │ • Set environment and bean name generator                   │ │
│  │ • Register bean post processors                             │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────┐
│                   4. BEAN DEFINITION LOADING                     │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ • Scan @Component classes                                   │ │
│  │ • Parse @Configuration classes                              │ │
│  │ • Process @Bean methods                                     │ │
│  │ • Register bean definitions                                 │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────┐
│                   5. APPLICATION CONTEXT REFRESH                 │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ • BeanFactoryPostProcessor execution                       │ │
│  │ • BeanPostProcessor registration                           │ │
│  │ • Bean creation and wiring                                 │ │
│  │ • Initialize messages, events, etc.                        │ │
│  │ • Register shutdown hook                                   │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────┐
│                   6. WEB SERVER START                            │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ • Start embedded servlet container (Tomcat/Jetty/Undertow)  │ │
│  │ • Map dispatcher servlet                                    │ │
│  │ • Register filters, listeners                               │ │
│  │ • Open port for requests                                    │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────┐
│                   7. APPLICATION READY                           │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ • Execute ApplicationRunner & CommandLineRunner            │ │
│  │ • ApplicationStartedEvent                                  │ │
│  │ • ApplicationReadyEvent                                    │ │
│  │ • Ready to serve requests                                  │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────┐
│                   8. SHUTDOWN PHASE                              │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ • Application shutdown initiated                           │ │
│  │ • ApplicationClosingEvent                                  │ │
│  │ • ContextClosedEvent                                       │ │
│  │ • Destroy singleton beans                                  │ │
│  │ • Stop web server                                          │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

---

## **2. APPLICATION STARTUP PHASES**

> **Concept:** Detailed breakdown of what happens during application startup .

### **Phase 1: Initialization**

```java
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        // This triggers the entire lifecycle
        SpringApplication.run(Application.class, args);
    }
}

// Customizing the startup
SpringApplication app = new SpringApplication(Application.class);
app.setBannerMode(Banner.Mode.OFF);
app.setDefaultProperties(Collections.singletonMap("server.port", "8083"));
app.addListeners(new CustomApplicationListener());
app.run(args);
```

### **Phase 2: Environment Preparation**

```java
@Component
public class EnvironmentLogger {
    
    @Autowired
    private Environment environment;
    
    @PostConstruct
    public void logEnvironment() {
        System.out.println("Active Profiles: " + 
            Arrays.toString(environment.getActiveProfiles()));
        System.out.println("Server Port: " + 
            environment.getProperty("server.port"));
    }
}
```

### **Phase 3: Application Context Creation**

```java
// Types of ApplicationContext created by Spring Boot
// 1. AnnotationConfigServletWebServerApplicationContext (Servlet web apps)
// 2. AnnotationConfigReactiveWebServerApplicationContext (Reactive web apps)
// 3. AnnotationConfigApplicationContext (Non-web apps)
```

### **Phase 4: Application Runner Hooks**

```java
@Component
public class StartupRunner implements CommandLineRunner {
    
    @Override
    public void run(String... args) throws Exception {
        System.out.println("Application started with args: " + Arrays.toString(args));
        // Initialize data, warm up caches, etc.
    }
}

@Component
public class AnotherRunner implements ApplicationRunner {
    
    @Override
    public void run(ApplicationArguments args) throws Exception {
        System.out.println("Option args: " + args.getOptionNames());
        System.out.println("Non-option args: " + args.getNonOptionArgs());
    }
}
```

### **Phase 5: Application Events**

```java
@Component
public class ApplicationEventListener {
    
    @EventListener(ApplicationStartingEvent.class)
    public void onStarting() {
        System.out.println("1. Application is starting...");
    }
    
    @EventListener(ApplicationEnvironmentPreparedEvent.class)
    public void onEnvironmentPrepared() {
        System.out.println("2. Environment prepared");
    }
    
    @EventListener(ApplicationContextInitializedEvent.class)
    public void onContextInitialized() {
        System.out.println("3. Context initialized");
    }
    
    @EventListener(ApplicationPreparedEvent.class)
    public void onPrepared() {
        System.out.println("4. Application prepared");
    }
    
    @EventListener(ContextRefreshedEvent.class)
    public void onContextRefreshed() {
        System.out.println("5. Context refreshed");
    }
    
    @EventListener(ApplicationStartedEvent.class)
    public void onStarted() {
        System.out.println("6. Application started");
    }
    
    @EventListener(ApplicationReadyEvent.class)
    public void onReady() {
        System.out.println("7. Application ready to serve requests");
    }
    
    @EventListener(ApplicationFailedEvent.class)
    public void onFailed() {
        System.out.println("Application failed to start");
    }
    
    @EventListener(ContextClosedEvent.class)
    public void onClosed() {
        System.out.println("Application context closed");
    }
}
```

---

## **3. BEAN LIFECYCLE**

> **Concept:** Complete lifecycle of a Spring bean from instantiation to destruction .

```
┌─────────────────────────────────────────────────────────────────┐
│                      BEAN LIFECYCLE                              │
└─────────────────────────────────────────────────────────────────┘

                         [Bean Definition]
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                     1. INSTANTIATION                             │
│   • Constructor called                                           │
│   • Memory allocated                                             │
└─────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                  2. POPULATE PROPERTIES                          │
│   • Setter injection                                             │
│   • Field injection (@Autowired)                                 │
└─────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│             3. BEAN NAME AWARE (if implements)                   │
│   • setBeanName() called                                         │
└─────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│             4. BEAN FACTORY AWARE (if implements)                │
│   • setBeanFactory() called                                      │
└─────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│            5. APPLICATION CONTEXT AWARE (if implements)          │
│   • setApplicationContext() called                               │
└─────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                6. BEAN POST PROCESSOR (PRE-INIT)                 │
│   • postProcessBeforeInitialization() called                     │
└─────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                    7. INITIALIZATION                             │
│   • @PostConstruct method called                                 │
│   • afterPropertiesSet() (if InitializingBean)                   │
│   • Custom init-method called                                    │
└─────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                8. BEAN POST PROCESSOR (POST-INIT)                │
│   • postProcessAfterInitialization() called                      │
└─────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                    9. BEAN IS READY                               │
│   • Bean is fully initialized and ready to use                   │
└─────────────────────────────────────────────────────────────────┘
                               │
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                    10. DESTRUCTION                               │
│   • @PreDestroy method called                                    │
│   • destroy() (if DisposableBean)                                │
│   • Custom destroy-method called                                 │
└─────────────────────────────────────────────────────────────────┘
```

### **Complete Bean Lifecycle Example**

```java
@Component
public class LifecycleDemoBean implements BeanNameAware, BeanFactoryAware, 
        ApplicationContextAware, InitializingBean, DisposableBean {
    
    private static final Logger log = LoggerFactory.getLogger(LifecycleDemoBean.class);
    
    private String name;
    
    public LifecycleDemoBean() {
        log.info("1. Constructor: Bean instantiated");
    }
    
    @Autowired
    public void setName(String name) {
        log.info("2. Property population: Setting name = {}", name);
        this.name = name;
    }
    
    @Override
    public void setBeanName(String name) {
        log.info("3. BeanNameAware: setBeanName() called with: {}", name);
    }
    
    @Override
    public void setBeanFactory(BeanFactory beanFactory) {
        log.info("4. BeanFactoryAware: setBeanFactory() called");
    }
    
    @Override
    public void setApplicationContext(ApplicationContext applicationContext) {
        log.info("5. ApplicationContextAware: setApplicationContext() called");
    }
    
    @PostConstruct
    public void postConstruct() {
        log.info("7. @PostConstruct: Initialization callback");
    }
    
    @Override
    public void afterPropertiesSet() throws Exception {
        log.info("8. InitializingBean: afterPropertiesSet() called");
    }
    
    public void customInit() {
        log.info("9. Custom init-method called");
    }
    
    @PreDestroy
    public void preDestroy() {
        log.info("11. @PreDestroy: Destruction callback");
    }
    
    @Override
    public void destroy() throws Exception {
        log.info("12. DisposableBean: destroy() called");
    }
    
    public void customDestroy() {
        log.info("13. Custom destroy-method called");
    }
}

// Bean Post Processor
@Component
public class CustomBeanPostProcessor implements BeanPostProcessor {
    
    private static final Logger log = LoggerFactory.getLogger(CustomBeanPostProcessor.class);
    
    @Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) {
        if (bean instanceof LifecycleDemoBean) {
            log.info("6. BeanPostProcessor: postProcessBeforeInitialization for {}", beanName);
        }
        return bean;
    }
    
    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) {
        if (bean instanceof LifecycleDemoBean) {
            log.info("10. BeanPostProcessor: postProcessAfterInitialization for {}", beanName);
        }
        return bean;
    }
}
```

### **Output Order**

```
1. Constructor: Bean instantiated
2. Property population: Setting name
3. BeanNameAware: setBeanName() called
4. BeanFactoryAware: setBeanFactory() called
5. ApplicationContextAware: setApplicationContext() called
6. BeanPostProcessor: postProcessBeforeInitialization
7. @PostConstruct: Initialization callback
8. InitializingBean: afterPropertiesSet() called
9. Custom init-method called
10. BeanPostProcessor: postProcessAfterInitialization
11. @PreDestroy: Destruction callback
12. DisposableBean: destroy() called
13. Custom destroy-method called
```

### **Configuration for Custom Init/Destroy**

```java
@Configuration
public class BeanLifecycleConfig {
    
    @Bean(initMethod = "customInit", destroyMethod = "customDestroy")
    public LifecycleDemoBean lifecycleDemoBean() {
        return new LifecycleDemoBean();
    }
}

// Or in XML (legacy)
// <bean id="lifecycleDemoBean" class="com.example.LifecycleDemoBean"
//       init-method="customInit" destroy-method="customDestroy"/>
```

---

## **4. BEAN SCOPES**

> **Concept:** Defines the lifecycle and visibility of a bean within the container .

| Scope | Description | Lifetime | Use Case |
|-------|-------------|----------|----------|
| **singleton** (default) | Single instance per Spring IoC container | Container lifetime | Stateless beans, services, repositories |
| **prototype** | New instance each time requested | Created when requested, returned to caller | Stateful beans |
| **request** | Single instance per HTTP request | Request lifetime | Web-specific, request-scoped data |
| **session** | Single instance per HTTP session | Session lifetime | Shopping cart, user session data |
| **application** | Single instance per ServletContext | Web app lifetime | Application-wide data |
| **websocket** | Single instance per WebSocket session | WebSocket session lifetime | WebSocket-scoped data |

### **Singleton Scope (Default)**

```java
@Component  // singleton by default
public class SingletonService {
    private int counter = 0;
    
    public void increment() {
        counter++;
    }
    
    public int getCounter() {
        return counter;
    }
}

// Both references point to same instance
SingletonService s1 = context.getBean(SingletonService.class);
SingletonService s2 = context.getBean(SingletonService.class);
s1.increment();  // counter = 1
System.out.println(s2.getCounter());  // 1 (same instance)
```

### **Prototype Scope**

```java
@Component
@Scope("prototype")
public class PrototypeService {
    private int counter = 0;
    
    public void increment() {
        counter++;
    }
    
    public int getCounter() {
        return counter;
    }
}

// Each getBean returns new instance
PrototypeService p1 = context.getBean(PrototypeService.class);
PrototypeService p2 = context.getBean(PrototypeService.class);
p1.increment();  // p1 counter = 1
System.out.println(p2.getCounter());  // 0 (different instance)
```

### **Web Scopes**

```java
@Component
@Scope(value = WebApplicationContext.SCOPE_REQUEST, proxyMode = ScopedProxyMode.TARGET_CLASS)
public class RequestScopedBean {
    private String requestId = UUID.randomUUID().toString();
    
    public String getRequestId() {
        return requestId;
    }
}

@Component
@Scope(value = WebApplicationContext.SCOPE_SESSION, proxyMode = ScopedProxyMode.TARGET_CLASS)
public class ShoppingCart {
    private List<Item> items = new ArrayList<>();
    
    public void addItem(Item item) {
        items.add(item);
    }
    
    public List<Item> getItems() {
        return items;
    }
}

@Component
@Scope(value = WebApplicationContext.SCOPE_APPLICATION, proxyMode = ScopedProxyMode.TARGET_CLASS)
public class AppCounter {
    private AtomicInteger counter = new AtomicInteger(0);
    
    public int incrementAndGet() {
        return counter.incrementAndGet();
    }
}
```

### **Scope Configuration**

```java
@Configuration
public class ScopeConfig {
    
    @Bean
    @Scope("prototype")
    public PrototypeService prototypeService() {
        return new PrototypeService();
    }
    
    @Bean
    @Scope(value = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
    public AnotherPrototype anotherPrototype() {
        return new AnotherPrototype();
    }
    
    @Bean
    @Scope("request")
    public RequestScopedBean requestScopedBean() {
        return new RequestScopedBean();
    }
}
```

### **Scope Proxy for Injecting Narrower Scopes**

```java
@Component
public class SingletonService {
    
    // Inject request-scoped bean into singleton
    @Autowired
    private RequestScopedBean requestScopedBean;  // Needs proxy
    
    public void process() {
        // Each call gets current request's bean
        String requestId = requestScopedBean.getRequestId();
    }
}

// Without proxy, this would fail as request-scoped bean
// doesn't exist at singleton initialization time
```

---

## **5. CORE ANNOTATIONS**

> **Concept:** Fundamental Spring annotations that form the basis of Spring applications .

| Annotation | Description |
|------------|-------------|
| **@SpringBootApplication** | Main application class annotation (combination of @Configuration, @EnableAutoConfiguration, @ComponentScan) |
| **@Configuration** | Indicates class declares @Bean methods |
| **@ComponentScan** | Configures component scanning directives |
| **@EnableAutoConfiguration** | Enables Spring Boot's auto-configuration |

### **@SpringBootApplication**

```java
@SpringBootApplication  // Equivalent to:
// @Configuration
// @EnableAutoConfiguration
// @ComponentScan
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}

// With exclusion
@SpringBootApplication(exclude = {
    DataSourceAutoConfiguration.class,
    SecurityAutoConfiguration.class
})
public class Application {
    // ...
}
```

### **@Configuration**

```java
@Configuration
public class AppConfig {
    
    @Bean
    public DataSource dataSource() {
        return DataSourceBuilder.create()
            .url("jdbc:mysql://localhost:3306/mydb")
            .username("user")
            .password("password")
            .build();
    }
    
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}
```

### **@ComponentScan**

```java
@Configuration
@ComponentScan(
    basePackages = {"com.example.service", "com.example.repository"},
    basePackageClasses = {Marker.class},
    excludeFilters = @ComponentScan.Filter(
        type = FilterType.REGEX,
        pattern = ".*Test.*"
    ),
    includeFilters = @ComponentScan.Filter(
        type = FilterType.ANNOTATION,
        classes = {Service.class}
    )
)
public class ScanConfig {
}
```

---

## **6. STEREOTYPE ANNOTATIONS**

> **Concept:** Mark classes as Spring-managed components with specific roles .

| Annotation | Description | Typical Use |
|------------|-------------|-------------|
| **@Component** | Generic Spring-managed bean | Any Spring component |
| **@Service** | Service layer bean | Business logic |
| **@Repository** | Data access layer bean | DAO/Repository classes |
| **@Controller** | Web controller bean | Spring MVC controllers |
| **@RestController** | REST API controller | @Controller + @ResponseBody |

### **@Component**

```java
@Component
public class EmailValidator {
    
    public boolean isValid(String email) {
        return email != null && email.contains("@");
    }
}
```

### **@Service**

```java
@Service
public class UserService {
    
    private final UserRepository userRepository;
    private final EmailService emailService;
    
    public UserService(UserRepository userRepository, EmailService emailService) {
        this.userRepository = userRepository;
        this.emailService = emailService;
    }
    
    @Transactional
    public User registerUser(User user) {
        // Business logic
        return userRepository.save(user);
    }
}
```

### **@Repository**

```java
@Repository
public class UserRepository {
    
    @PersistenceContext
    private EntityManager entityManager;
    
    public User findById(Long id) {
        return entityManager.find(User.class, id);
    }
    
    public List<User> findAll() {
        return entityManager.createQuery("FROM User", User.class).getResultList();
    }
}
```

### **@Controller vs @RestController**

```java
@Controller  // Returns view names
public class WebController {
    
    @GetMapping("/home")
    public String home(Model model) {
        model.addAttribute("message", "Welcome!");
        return "home";  // View name
    }
}

@RestController  // Returns data (JSON/XML)
public class ApiController {
    
    @GetMapping("/api/users")
    public List<User> getUsers() {
        return userService.findAll();
    }
}
```

---

## **7. DEPENDENCY INJECTION ANNOTATIONS**

> **Concept:** Annotations for wiring dependencies between beans .

| Annotation | Description |
|------------|-------------|
| **@Autowired** | Inject bean by type |
| **@Qualifier** | Specify bean name when multiple candidates |
| **@Primary** | Mark primary bean when multiple candidates |
| **@Resource** | Java standard injection (by name) |
| **@Inject** | Java standard injection (JSR-330) |
| **@Value** | Inject property values |

### **@Autowired**

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
    
    // Method injection
    @Autowired
    public void init(@Qualifier("cacheService") CacheService cacheService) {
        // ...
    }
}
```

### **@Qualifier**

```java
@Component
@Qualifier("primary")
public class DatabaseService implements DataService {
    // ...
}

@Component
@Qualifier("backup")
public class BackupService implements DataService {
    // ...
}

@Service
public class ClientService {
    
    @Autowired
    @Qualifier("primary")
    private DataService primaryDataService;
    
    @Autowired
    @Qualifier("backup")
    private DataService backupDataService;
}
```

### **@Primary**

```java
@Component
@Primary  // Default when multiple candidates
public class MainDatabaseService implements DataService {
    // ...
}

@Component
public class FallbackDatabaseService implements DataService {
    // ...
}

@Service
public class DataProcessor {
    
    @Autowired
    private DataService dataService;  // Gets MainDatabaseService
}
```

### **@Value**

```java
@Component
public class AppConfig {
    
    @Value("${app.name:DefaultApp}")  // With default
    private String appName;
    
    @Value("${app.version}")
    private String version;
    
    @Value("${server.port}")
    private int port;
    
    @Value("#{2 + 3}")  // SpEL
    private int sum;
    
    @Value("#{systemProperties['user.home']}")
    private String userHome;
    
    @Value("#{T(java.lang.Math).random() * 100}")
    private double randomNumber;
}
```

---

## **8. CONFIGURATION ANNOTATIONS**

> **Concept:** Annotations for defining and managing configuration .

| Annotation | Description |
|------------|-------------|
| **@Configuration** | Class contains @Bean definitions |
| **@Bean** | Declares a Spring bean |
| **@Import** | Import other configuration classes |
| **@ImportResource** | Import XML configuration |
| **@PropertySource** | Load properties file |
| **@PropertySources** | Multiple @PropertySource |

### **@Configuration & @Bean**

```java
@Configuration
@PropertySource("classpath:application.properties")
public class AppConfiguration {
    
    @Bean
    public DataSource dataSource() {
        HikariDataSource dataSource = new HikariDataSource();
        dataSource.setJdbcUrl(environment.getProperty("db.url"));
        dataSource.setUsername(environment.getProperty("db.username"));
        dataSource.setPassword(environment.getProperty("db.password"));
        return dataSource;
    }
    
    @Bean
    public JdbcTemplate jdbcTemplate(DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }
    
    @Bean
    @Scope("prototype")
    public PrototypeBean prototypeBean() {
        return new PrototypeBean();
    }
    
    @Bean(initMethod = "init", destroyMethod = "cleanup")
    public CustomBean customBean() {
        return new CustomBean();
    }
}
```

### **@Import**

```java
@Configuration
@Import({DatabaseConfig.class, SecurityConfig.class, CacheConfig.class})
public class MainConfig {
}

// With ImportSelector
public class MyImportSelector implements ImportSelector {
    @Override
    public String[] selectImports(AnnotationMetadata importingClassMetadata) {
        return new String[]{"com.example.ConfigA", "com.example.ConfigB"};
    }
}
```

### **@PropertySource**

```java
@Configuration
@PropertySource("classpath:database.properties")
@PropertySource(value = "classpath:config-${spring.profiles.active}.properties", 
                ignoreResourceNotFound = true)
public class PropertyConfig {
    
    @Autowired
    private Environment environment;
    
    @Bean
    public DataSource dataSource() {
        String url = environment.getProperty("db.url");
        // ...
    }
}
```

### **@ConfigurationProperties**

```java
@Component
@ConfigurationProperties(prefix = "app")
@Data
public class AppProperties {
    private String name;
    private String version;
    private Security security = new Security();
    private List<String> servers;
    private Map<String, String> mappings;
    
    @Data
    public static class Security {
        private boolean enabled;
        private List<String> allowedOrigins;
        private int timeout;
    }
}

// application.yml
app:
  name: MyApp
  version: 1.0.0
  security:
    enabled: true
    allowed-origins:
      - http://localhost:3000
      - https://example.com
    timeout: 3600
  servers:
    - dev.server.com
    - prod.server.com
  mappings:
    key1: value1
    key2: value2
```

---

## **9. CONDITIONAL ANNOTATIONS**

> **Concept:** Conditionally create beans based on certain conditions .

| Annotation | Condition |
|------------|-----------|
| **@Conditional** | General condition using Condition interface |
| **@ConditionalOnClass** | Class exists in classpath |
| **@ConditionalOnMissingClass** | Class missing from classpath |
| **@ConditionalOnBean** | Bean exists in context |
| **@ConditionalOnMissingBean** | Bean missing from context |
| **@ConditionalOnProperty** | Property has specific value |
| **@ConditionalOnResource** | Resource exists in classpath |
| **@ConditionalOnWebApplication** | Application is web app |
| **@ConditionalOnNotWebApplication** | Application is not web app |
| **@ConditionalOnExpression** | SpEL expression evaluates to true |
| **@ConditionalOnJava** | Java version matches |
| **@ConditionalOnSingleCandidate** | Only one bean of type exists |

### **@ConditionalOnClass**

```java
@Configuration
@ConditionalOnClass(name = "org.postgresql.Driver")
public class PostgresDataSourceConfig {
    
    @Bean
    public DataSource postgresDataSource() {
        // Only created if PostgreSQL driver exists
        return DataSourceBuilder.create()
            .url("jdbc:postgresql://localhost:5432/mydb")
            .build();
    }
}
```

### **@ConditionalOnProperty**

```java
@Configuration
@ConditionalOnProperty(
    name = "app.cache.enabled",
    havingValue = "true",
    matchIfMissing = false
)
public class CacheConfig {
    
    @Bean
    public CacheManager cacheManager() {
        return new ConcurrentMapCacheManager("products");
    }
}

// With specific value
@ConditionalOnProperty(value = "app.environment", havingValue = "production")
public class ProductionConfig {
    // ...
}

// With prefix
@ConditionalOnProperty(prefix = "spring.datasource", name = "url")
public class DataSourceConfig {
    // ...
}
```

### **@ConditionalOnBean**

```java
@Component
@ConditionalOnBean(DataSource.class)
public class JdbcTemplateConfig {
    
    @Bean
    public JdbcTemplate jdbcTemplate(DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }
}

@Component
@ConditionalOnMissingBean(DataService.class)
public class DefaultDataService implements DataService {
    // Created only if no other DataService exists
}
```

### **@ConditionalOnExpression**

```java
@Configuration
@ConditionalOnExpression("'${app.environment}' == 'dev' || '${app.debug}' == 'true'")
public class DevConfig {
    
    @Bean
    public DevTools devTools() {
        return new DevTools();
    }
}

// Complex expression
@ConditionalOnExpression(
    "#{T(java.lang.Runtime).availableProcessors() > 2} && " +
    "'${app.mode}' == 'parallel'"
)
public class ParallelConfig {
    // ...
}
```

### **Custom @Conditional**

```java
// Create custom condition annotation
@Target({ElementType.TYPE, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Conditional(OnMacCondition.class)
public @interface ConditionalOnMac {
}

// Implement Condition
public class OnMacCondition implements Condition {
    
    @Override
    public boolean matches(ConditionContext context, AnnotatedTypeMetadata metadata) {
        return System.getProperty("os.name").toLowerCase().contains("mac");
    }
}

// Usage
@Configuration
@ConditionalOnMac
public class MacSpecificConfig {
    
    @Bean
    public MacService macService() {
        return new MacService();
    }
}
```

---

## **10. WEB/REST ANNOTATIONS**

> **Concept:** Annotations for building web and RESTful applications .

| Annotation | Description |
|------------|-------------|
| **@Controller** | Marks class as web controller |
| **@RestController** | @Controller + @ResponseBody |
| **@RequestMapping** | Maps HTTP requests to handler methods |
| **@GetMapping** | Shortcut for @RequestMapping(method=GET) |
| **@PostMapping** | Shortcut for @RequestMapping(method=POST) |
| **@PutMapping** | Shortcut for @RequestMapping(method=PUT) |
| **@DeleteMapping** | Shortcut for @RequestMapping(method=DELETE) |
| **@PatchMapping** | Shortcut for @RequestMapping(method=PATCH) |
| **@PathVariable** | Bind URI template variable |
| **@RequestParam** | Bind query parameter |
| **@RequestBody** | Bind HTTP request body |
| **@ResponseBody** | Write return value to response body |
| **@ResponseStatus** | Configure HTTP response status |
| **@ExceptionHandler** | Handle exceptions in controller |
| **@ControllerAdvice** | Global exception handling |
| **@RestControllerAdvice** | @ControllerAdvice + @ResponseBody |
| **@CrossOrigin** | Enable CORS on controller/method |

### **@RequestMapping & Variants**

```java
@RestController
@RequestMapping("/api/users")
public class UserController {
    
    @GetMapping
    public List<User> getAllUsers() {
        return userService.findAll();
    }
    
    @GetMapping("/{id}")
    public User getUserById(@PathVariable Long id) {
        return userService.findById(id);
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
    
    @PatchMapping("/{id}")
    public User partialUpdate(@PathVariable Long id, @RequestBody Map<String, Object> updates) {
        return userService.patch(id, updates);
    }
}
```

### **@RequestParam**

```java
@GetMapping("/search")
public List<User> searchUsers(
        @RequestParam(required = false) String name,
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(name = "size", defaultValue = "10") int pageSize,
        @RequestParam MultiValueMap<String, String> allParams) {
    
    // /api/users/search?name=john&page=0&size=20&sort=asc
    return userService.search(name, page, pageSize);
}
```

### **@PathVariable**

```java
@GetMapping("/users/{userId}/orders/{orderId}")
public Order getUserOrder(
        @PathVariable("userId") Long userId,
        @PathVariable Long orderId) {  // Variable name matches
    
    return orderService.findByUserAndOrder(userId, orderId);
}
```

### **@RequestBody & @ResponseBody**

```java
@PostMapping("/users")
public ResponseEntity<User> createUser(@RequestBody @Valid User user) {
    User saved = userService.save(user);
    return ResponseEntity.created(URI.create("/users/" + saved.getId())).body(saved);
}

@GetMapping("/users/{id}")
@ResponseBody
public User getUser(@PathVariable Long id) {
    return userService.findById(id);
}
```

### **@ResponseStatus**

```java
@PostMapping
@ResponseStatus(HttpStatus.CREATED)
public User createUser(@RequestBody User user) {
    return userService.save(user);
}

@DeleteMapping("/{id}")
@ResponseStatus(HttpStatus.NO_CONTENT)
public void deleteUser(@PathVariable Long id) {
    userService.delete(id);
}
```

### **@ExceptionHandler**

```java
@RestController
public class UserController {
    
    @GetMapping("/users/{id}")
    public User getUser(@PathVariable Long id) {
        return userService.findById(id)
            .orElseThrow(() -> new UserNotFoundException(id));
    }
    
    @ExceptionHandler(UserNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ErrorResponse handleUserNotFound(UserNotFoundException ex) {
        return new ErrorResponse("USER_NOT_FOUND", ex.getMessage());
    }
    
    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ValidationErrorResponse handleValidation(MethodArgumentNotValidException ex) {
        // Handle validation errors
    }
}
```

### **@ControllerAdvice / @RestControllerAdvice**

```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(ResourceNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ErrorResponse handleNotFound(ResourceNotFoundException ex) {
        return new ErrorResponse("NOT_FOUND", ex.getMessage());
    }
    
    @ExceptionHandler(AccessDeniedException.class)
    @ResponseStatus(HttpStatus.FORBIDDEN)
    public ErrorResponse handleAccessDenied(AccessDeniedException ex) {
        return new ErrorResponse("ACCESS_DENIED", ex.getMessage());
    }
    
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ErrorResponse handleGeneric(Exception ex) {
        return new ErrorResponse("INTERNAL_ERROR", "An error occurred");
    }
}
```

### **@CrossOrigin**

```java
@RestController
@CrossOrigin(origins = "http://localhost:3000")
public class ApiController {
    
    @GetMapping("/public")
    @CrossOrigin(origins = "*")  // Override for specific method
    public String publicEndpoint() {
        return "Public data";
    }
    
    @GetMapping("/secure")
    @CrossOrigin(origins = {"https://app.com", "https://admin.com"})
    public String secureEndpoint() {
        return "Secure data";
    }
}
```

---

## **11. DATA ACCESS ANNOTATIONS**

> **Concept:** Annotations for JPA and database operations .

| Annotation | Description |
|------------|-------------|
| **@Entity** | Marks class as JPA entity |
| **@Table** | Specifies table name |
| **@Id** | Marks primary key field |
| **@GeneratedValue** | Primary key generation strategy |
| **@Column** | Column mapping |
| **@Transient** | Field not persisted |
| **@OneToOne** | One-to-one relationship |
| **@OneToMany** | One-to-many relationship |
| **@ManyToOne** | Many-to-one relationship |
| **@ManyToMany** | Many-to-many relationship |
| **@JoinColumn** | Specify foreign key column |
| **@JoinTable** | Specify join table |
| **@Enumerated** | Enum mapping |
| **@Temporal** | Date/time mapping |
| **@Lob** | Large object mapping |
| **@Embedded** | Embeddable object |
| **@Embeddable** | Embeddable class |
| **@MappedSuperclass** | Base class for entities |
| **@Query** | Custom JPQL query |
| **@Modifying** | Indicates modifying query |
| **@Param** | Named parameter for query |
| **@Lock** | Pessimistic locking |

### **Entity Annotations**

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
    
    @Column(nullable = false, unique = true, length = 50)
    private String username;
    
    @Column(name = "email_address", nullable = false)
    private String email;
    
    @Transient
    private String temporaryData;
    
    @Enumerated(EnumType.STRING)
    private Role role;
    
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "created_at")
    private Date createdAt;
    
    @Lob
    private byte[] profileImage;
    
    @Embedded
    private Address address;
    
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Order> orders;
}

@Embeddable
@Data
public class Address {
    private String street;
    private String city;
    private String zipCode;
}
```

### **Relationship Annotations**

```java
@Entity
public class Order {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;
    
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL)
    private List<OrderItem> items;
    
    @OneToOne(mappedBy = "order", cascade = CascadeType.ALL)
    private Payment payment;
}

@Entity
public class OrderItem {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "order_id")
    private Order order;
    
    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product product;
}

@Entity
public class Product {
    
    @ManyToMany
    @JoinTable(
        name = "product_category",
        joinColumns = @JoinColumn(name = "product_id"),
        inverseJoinColumns = @JoinColumn(name = "category_id")
    )
    private Set<Category> categories;
}
```

### **Repository Query Annotations**

```java
@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    
    // Derived queries
    Optional<User> findByUsername(String username);
    
    List<User> findByLastNameContainingIgnoreCase(String lastName);
    
    @Query("SELECT u FROM User u WHERE u.email = :email")
    Optional<User> findByEmailAddress(@Param("email") String email);
    
    @Query(value = "SELECT * FROM users WHERE created_at > :date", 
           nativeQuery = true)
    List<User> findRecentUsers(@Param("date") Date date);
    
    @Modifying
    @Query("UPDATE User u SET u.status = :status WHERE u.lastLoginDate < :date")
    int updateStatusForInactiveUsers(@Param("status") String status, 
                                      @Param("date") Date date);
    
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT u FROM User u WHERE u.id = :id")
    Optional<User> findByIdWithLock(@Param("id") Long id);
}
```

---

## **12. TRANSACTION ANNOTATIONS**

> **Concept:** Manage database transactions declaratively .

| Annotation | Description |
|------------|-------------|
| **@Transactional** | Declares transactional boundary |
| **@TransactionalPropagation** | Transaction propagation behavior |
| **@TransactionalIsolation** | Transaction isolation level |
| **@EnableTransactionManagement** | Enable annotation-driven transaction management |

### **@Transactional**

```java
@Service
@Transactional
public class UserService {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private AuditService auditService;
    
    // Default propagation (REQUIRED)
    public User createUser(User user) {
        user = userRepository.save(user);
        auditService.log("User created: " + user.getId());
        return user;
    }
    
    @Transactional(readOnly = true)
    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }
    
    @Transactional(rollbackFor = {BusinessException.class, DataIntegrityViolationException.class},
                   noRollbackFor = {AuditException.class})
    public User updateUser(Long id, User updatedUser) {
        // Business logic
        if (something) {
            throw new BusinessException("Invalid operation");
        }
        return userRepository.save(updatedUser);
    }
    
    @Transactional(timeout = 30)  // Seconds
    public void processBatch(List<User> users) {
        for (User user : users) {
            processUser(user);
        }
    }
}
```

### **Propagation Types**

```java
@Service
public class PaymentService {
    
    @Autowired
    private TransactionLogService logService;
    
    @Transactional(propagation = Propagation.REQUIRED)  // Default
    public void processPayment(Payment payment) {
        // Runs in current transaction, creates new if none exists
        paymentRepository.save(payment);
        logService.logTransaction(payment);
    }
    
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void processCriticalPayment(Payment payment) {
        // Always runs in new transaction, suspends current if exists
        paymentRepository.save(payment);
    }
    
    @Transactional(propagation = Propagation.MANDATORY)
    public void validatePayment(Payment payment) {
        // Must run within existing transaction, throws exception if none
    }
    
    @Transactional(propagation = Propagation.NEVER)
    public void readOnlyOperation() {
        // Must NOT run in transaction, throws exception if exists
    }
    
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    public void nonTransactionalOp() {
        // Suspends current transaction if exists
    }
    
    @Transactional(propagation = Propagation.SUPPORTS)
    public void optionalTransaction() {
        // Runs in transaction if exists, otherwise non-transactional
    }
    
    @Transactional(propagation = Propagation.NESTED)
    public void nestedOperation() {
        // Runs in nested transaction (savepoint)
    }
}

@Service
public class TransactionLogService {
    
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void logTransaction(Payment payment) {
        // Logs in separate transaction, independent of main
        logRepository.save(new TransactionLog(payment));
    }
}
```

### **Isolation Levels**

```java
@Service
public class InventoryService {
    
    @Transactional(isolation = Isolation.READ_COMMITTED)
    public int getStock(Long productId) {
        // Default in most databases
        return inventoryRepository.getStock(productId);
    }
    
    @Transactional(isolation = Isolation.REPEATABLE_READ)
    public void processOrder(Long productId, int quantity) {
        // Prevents non-repeatable reads
        int stock = inventoryRepository.getStock(productId);
        if (stock >= quantity) {
            inventoryRepository.reduceStock(productId, quantity);
        }
    }
    
    @Transactional(isolation = Isolation.SERIALIZABLE)
    public void allocateStock(Long productId, int quantity) {
        // Highest isolation, prevents phantom reads
        // Use for critical operations
    }
}
```

### **EnableTransactionManagement**

```java
@Configuration
@EnableTransactionManagement
public class TransactionConfig {
    
    @Bean
    public PlatformTransactionManager transactionManager(DataSource dataSource) {
        return new DataSourceTransactionManager(dataSource);
    }
}
```

---

## **13. VALIDATION ANNOTATIONS**

> **Concept:** Bean Validation (JSR-303/380) annotations for input validation .

| Annotation | Description |
|------------|-------------|
| **@Valid** | Triggers validation on nested objects |
| **@NotNull** | Value must not be null |
| **@Null** | Value must be null |
| **@NotBlank** | String must not be null or empty (with whitespace) |
| **@NotEmpty** | Collection/string not null or empty |
| **@Size** | Length must be between min and max |
| **@Min** | Value >= specified |
| **@Max** | Value <= specified |
| **@DecimalMin** | Decimal value >= specified |
| **@DecimalMax** | Decimal value <= specified |
| **@Positive** | Value > 0 |
| **@PositiveOrZero** | Value >= 0 |
| **@Negative** | Value < 0 |
| **@NegativeOrZero** | Value <= 0 |
| **@Digits** | Digit count constraints |
| **@Past** | Date must be in the past |
| **@PastOrPresent** | Date must be past or present |
| **@Future** | Date must be in future |
| **@FutureOrPresent** | Date must be future or present |
| **@Pattern** | Must match regex pattern |
| **@Email** | Must be valid email format |
| **@AssertTrue** | Boolean must be true |
| **@AssertFalse** | Boolean must be false |

### **Validation on DTO**

```java
@Data
public class UserRegistrationRequest {
    
    @NotBlank(message = "Username is required")
    @Size(min = 3, max = 20, message = "Username must be between 3 and 20 characters")
    @Pattern(regexp = "^[a-zA-Z0-9_]+$", 
             message = "Username can only contain letters, numbers, and underscore")
    private String username;
    
    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;
    
    @NotBlank(message = "Password is required")
    @Size(min = 8, max = 50, message = "Password must be between 8 and 50 characters")
    @Pattern(regexp = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=]).*$",
             message = "Password must contain at least one digit, lowercase, uppercase, and special character")
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
    
    @AssertTrue(message = "Terms must be accepted")
    private boolean termsAccepted;
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
@Validated  // For method-level validation
public class UserController {
    
    @PostMapping
    public ResponseEntity<User> createUser(
            @Valid @RequestBody UserRegistrationRequest request) {
        User user = userService.register(request);
        return ResponseEntity.ok(user);
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<User> updateUser(
            @PathVariable @Positive(message = "ID must be positive") Long id,
            @Valid @RequestBody UserUpdateRequest request) {
        return ResponseEntity.ok(userService.update(id, request));
    }
    
    @GetMapping("/search")
    public ResponseEntity<List<User>> searchUsers(
            @RequestParam @Size(min = 3, message = "Query must be at least 3 characters") 
            String query,
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
        if (email == null) {
            return true;
        }
        return !userRepository.existsByEmail(email);
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

## **14. TESTING ANNOTATIONS**

> **Concept:** Annotations for testing Spring Boot applications .

| Annotation | Description |
|------------|-------------|
| **@SpringBootTest** | Loads full application context |
| **@WebMvcTest** | Tests only web layer |
| **@DataJpaTest** | Tests only JPA components |
| **@DataMongoTest** | Tests MongoDB components |
| **@DataRedisTest** | Tests Redis components |
| **@RestClientTest** | Tests REST clients |
| **@JsonTest** | Tests JSON serialization |
| **@Test** | JUnit test method |
| **@BeforeEach** | Run before each test |
| **@AfterEach** | Run after each test |
| **@BeforeAll** | Run once before all tests |
| **@AfterAll** | Run once after all tests |
| **@MockBean** | Mock bean in context |
| **@SpyBean** | Spy on bean in context |
| **@Mock** | Mockito mock |
| **@InjectMocks** | Inject mocks into class |
| **@Captor** | Argument captor |
| **@Transactional** | Rollback after test |
| **@Commit** | Commit after test |
| **@Rollback** | Configure rollback |
| **@TestPropertySource** | Properties for test |
| **@Sql** | Execute SQL scripts |
| **@AutoConfigureMockMvc** | Auto-configure MockMvc |
| **@WithMockUser** | Mock authenticated user |

### **Unit Tests**

```java
@ExtendWith(MockitoExtension.class)
class UserServiceTest {
    
    @Mock
    private UserRepository userRepository;
    
    @Mock
    private EmailService emailService;
    
    @InjectMocks
    private UserService userService;
    
    @Captor
    private ArgumentCaptor<User> userCaptor;
    
    @Test
    void createUser_ShouldSaveUserAndSendEmail() {
        // Given
        User user = new User("testuser", "test@example.com");
        when(userRepository.save(any(User.class))).thenReturn(user);
        
        // When
        User result = userService.createUser(user);
        
        // Then
        assertThat(result).isNotNull();
        verify(userRepository).save(user);
        verify(emailService).sendWelcomeEmail(user.getEmail());
    }
}
```

### **Web Layer Tests**

```java
@WebMvcTest(UserController.class)
class UserControllerTest {
    
    @Autowired
    private MockMvc mockMvc;
    
    @MockBean
    private UserService userService;
    
    @Test
    void getUsers_ShouldReturnUserList() throws Exception {
        // Given
        List<User> users = Arrays.asList(new User("john"), new User("jane"));
        when(userService.findAll()).thenReturn(users);
        
        // When/Then
        mockMvc.perform(get("/api/users"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$", hasSize(2)))
            .andExpect(jsonPath("$[0].username").value("john"));
    }
    
    @Test
    @WithMockUser(roles = "ADMIN")
    void createUser_WithAdminRole_ShouldSucceed() throws Exception {
        String userJson = """
            {"username": "newuser", "email": "test@example.com"}
            """;
        
        mockMvc.perform(post("/api/users")
                .contentType(MediaType.APPLICATION_JSON)
                .content(userJson))
            .andExpect(status().isCreated());
    }
}
```

### **Integration Tests**

```java
@SpringBootTest
@AutoConfigureMockMvc
@Transactional  // Rollback after each test
@TestPropertySource(locations = "classpath:test-application.properties")
class UserIntegrationTest {
    
    @Autowired
    private MockMvc mockMvc;
    
    @Autowired
    private UserRepository userRepository;
    
    @Test
    void createUser_ShouldPersistInDatabase() throws Exception {
        // Given
        String userJson = """
            {"username": "integration", "email": "test@test.com"}
            """;
        
        // When
        mockMvc.perform(post("/api/users")
                .contentType(MediaType.APPLICATION_JSON)
                .content(userJson))
            .andExpect(status().isCreated());
        
        // Then
        User savedUser = userRepository.findByUsername("integration").orElseThrow();
        assertThat(savedUser.getEmail()).isEqualTo("test@test.com");
    }
}
```

### **Data JPA Tests**

```java
@DataJpaTest
class UserRepositoryTest {
    
    @Autowired
    private TestEntityManager entityManager;
    
    @Autowired
    private UserRepository userRepository;
    
    @Test
    void findByUsername_ShouldReturnUser() {
        // Given
        User user = new User("testuser", "test@example.com");
        entityManager.persist(user);
        entityManager.flush();
        
        // When
        Optional<User> found = userRepository.findByUsername("testuser");
        
        // Then
        assertThat(found).isPresent();
        assertThat(found.get().getEmail()).isEqualTo("test@example.com");
    }
    
    @Test
    @Sql("/test-data.sql")
    void countActiveUsers_ShouldReturnCorrectCount() {
        long count = userRepository.countByStatus("ACTIVE");
        assertThat(count).isEqualTo(5);
    }
}
```

### **JSON Tests**

```java
@JsonTest
class UserJsonTest {
    
    @Autowired
    private JacksonTester<User> json;
    
    @Test
    void serializeUser_ShouldProduceCorrectJson() throws Exception {
        User user = new User("john", "john@example.com");
        
        String result = json.write(user).getJson();
        
        assertThat(result).isEqualToIgnoringWhitespace(
            "{\"username\":\"john\",\"email\":\"john@example.com\"}"
        );
    }
}
```

---

## **15. CACHING ANNOTATIONS**

> **Concept:** Enable and configure caching in Spring applications .

| Annotation | Description |
|------------|-------------|
| **@EnableCaching** | Enable caching support |
| **@Cacheable** | Cache method result |
| **@CacheEvict** | Remove entries from cache |
| **@CachePut** | Update cache |
| **@Caching** | Combine multiple cache annotations |
| **@CacheConfig** | Class-level cache configuration |

### **@EnableCaching**

```java
@Configuration
@EnableCaching
public class CacheConfig {
    
    @Bean
    public CacheManager cacheManager() {
        SimpleCacheManager cacheManager = new SimpleCacheManager();
        cacheManager.setCaches(Arrays.asList(
            new ConcurrentMapCache("products"),
            new ConcurrentMapCache("users"),
            new ConcurrentMapCache("orders")
        ));
        return cacheManager;
    }
}
```

### **@Cacheable**

```java
@Service
public class ProductService {
    
    @Cacheable(value = "products", key = "#id")
    public Product getProduct(Long id) {
        // Expensive operation
        slowDatabaseCall();
        return productRepository.findById(id).orElse(null);
    }
    
    @Cacheable(value = "products", condition = "#id > 100")
    public Product getExpensiveProduct(Long id) {
        // Only cache if id > 100
        return productRepository.findById(id).orElse(null);
    }
    
    @Cacheable(value = "products", unless = "#result.price > 1000")
    public Product getCheapProduct(Long id) {
        // Don't cache expensive products
        return productRepository.findById(id).orElse(null);
    }
    
    @Cacheable(value = "products", keyGenerator = "customKeyGenerator")
    public Product getProductWithCustomKey(Long id, String currency) {
        return productRepository.findById(id).orElse(null);
    }
}
```

### **@CacheEvict**

```java
@Service
public class ProductService {
    
    @CacheEvict(value = "products", key = "#id")
    public void deleteProduct(Long id) {
        productRepository.deleteById(id);
    }
    
    @CacheEvict(value = "products", allEntries = true)
    public void clearAllProducts() {
        // Clear entire cache
    }
    
    @CacheEvict(value = "products", key = "#id", beforeInvocation = true)
    public void updateProduct(Long id, Product product) {
        // Evict before method execution
        productRepository.save(product);
    }
}
```

### **@CachePut**

```java
@Service
public class ProductService {
    
    @CachePut(value = "products", key = "#product.id")
    public Product updateProduct(Product product) {
        // Always update cache after method execution
        return productRepository.save(product);
    }
}
```

### **@Caching**

```java
@Service
public class ProductService {
    
    @Caching(
        cacheable = @Cacheable(value = "products", key = "#id"),
        evict = @CacheEvict(value = "popular", key = "#id")
    )
    public Product getProductWithSideEffects(Long id) {
        return productRepository.findById(id).orElse(null);
    }
    
    @Caching(evict = {
        @CacheEvict(value = "products", key = "#product.id"),
        @CacheEvict(value = "categories", key = "#product.categoryId")
    })
    public void updateProductWithCascading(Product product) {
        productRepository.save(product);
    }
}
```

### **@CacheConfig**

```java
@Service
@CacheConfig(cacheNames = "products")
public class ProductService {
    
    @Cacheable(key = "#id")
    public Product getProduct(Long id) {
        // Uses "products" cache
        return productRepository.findById(id).orElse(null);
    }
    
    @CacheEvict(key = "#id")
    public void deleteProduct(Long id) {
        productRepository.deleteById(id);
    }
}
```

---

## **16. ASYNC ANNOTATIONS**

> **Concept:** Enable and configure asynchronous method execution .

| Annotation | Description |
|------------|-------------|
| **@EnableAsync** | Enable async processing |
| **@Async** | Method runs asynchronously |
| **@EnableScheduling** | Enable scheduled tasks |

### **@EnableAsync**

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
        executor.setThreadNamePrefix("Async-");
        executor.initialize();
        return executor;
    }
    
    @Bean(name = "customExecutor")
    public Executor customExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(10);
        executor.setMaxPoolSize(20);
        executor.setQueueCapacity(500);
        executor.setThreadNamePrefix("Custom-");
        executor.initialize();
        return executor;
    }
}
```

### **@Async**

```java
@Service
public class EmailService {
    
    @Async
    public CompletableFuture<Boolean> sendEmail(String to, String subject, String body) {
        // Long-running email sending
        try {
            Thread.sleep(2000);  // Simulate
            return CompletableFuture.completedFuture(true);
        } catch (Exception e) {
            return CompletableFuture.completedFuture(false);
        }
    }
    
    @Async("customExecutor")
    public void processBatch(List<String> items) {
        // Uses custom executor
        for (String item : items) {
            processItem(item);
        }
    }
}

@Service
public class NotificationService {
    
    @Async
    public Future<String> sendNotification(String message) {
        return new AsyncResult<>("Notification sent: " + message);
    }
}

@RestController
public class AsyncController {
    
    @Autowired
    private EmailService emailService;
    
    @PostMapping("/send-email")
    public ResponseEntity<String> sendEmail(@RequestBody EmailRequest request) {
        CompletableFuture<Boolean> future = emailService.sendEmail(
            request.getTo(), request.getSubject(), request.getBody()
        );
        
        // Do other work while email sends
        
        return ResponseEntity.accepted().body("Email queued");
    }
}
```

### **Async Exception Handling**

```java
@Configuration
@EnableAsync
public class AsyncExceptionConfig extends AsyncConfigurerSupport {
    
    @Override
    public Executor getAsyncExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(2);
        executor.setMaxPoolSize(5);
        executor.setQueueCapacity(100);
        executor.initialize();
        return executor;
    }
    
    @Override
    public AsyncUncaughtExceptionHandler getAsyncUncaughtExceptionHandler() {
        return new AsyncUncaughtExceptionHandler() {
            @Override
            public void handleUncaughtException(Throwable ex, Method method, Object... params) {
                System.err.println("Async error in method: " + method.getName());
                System.err.println("Exception: " + ex.getMessage());
            }
        };
    }
}
```

---

## **17. SCHEDULING ANNOTATIONS**

> **Concept:** Schedule tasks to run periodically .

| Annotation | Description |
|------------|-------------|
| **@EnableScheduling** | Enable scheduled tasks |
| **@Scheduled** | Mark method as scheduled |
| **@Schedules** | Multiple @Scheduled |

### **@EnableScheduling**

```java
@Configuration
@EnableScheduling
public class SchedulingConfig {
}
```

### **@Scheduled**

```java
@Component
@Slf4j
public class ScheduledTasks {
    
    // Fixed delay - runs after previous completion
    @Scheduled(fixedDelay = 5000)
    public void runWithFixedDelay() {
        log.info("Fixed delay task at {}", LocalDateTime.now());
    }
    
    // Fixed rate - runs regardless of previous completion
    @Scheduled(fixedRate = 10000)
    public void runWithFixedRate() {
        log.info("Fixed rate task at {}", LocalDateTime.now());
    }
    
    // Initial delay before first execution
    @Scheduled(initialDelay = 10000, fixedRate = 5000)
    public void runWithInitialDelay() {
        log.info("Task with initial delay at {}", LocalDateTime.now());
    }
    
    // Cron expression
    @Scheduled(cron = "0 0 2 * * ?")  // Every day at 2 AM
    public void runDaily() {
        log.info("Daily task at {}", LocalDateTime.now());
    }
    
    // Cron with timezone
    @Scheduled(cron = "0 0 9 * * MON-FRI", zone = "America/New_York")
    public void runWeekdays() {
        log.info("Weekday morning task");
    }
    
    // Using properties
    @Scheduled(cron = "${schedule.report.cron}")
    public void generateReport() {
        generateSalesReport();
    }
    
    @Schedules({
        @Scheduled(fixedDelay = 60000),
        @Scheduled(cron = "0 0 * * * ?")
    })
    public void multipleSchedules() {
        // Runs on both schedules
        performHealthCheck();
    }
}
```

### **application.properties**

```properties
# Schedule configuration
schedule.report.cron=0 0 1 * * ?

# Task execution properties
spring.task.scheduling.pool.size=5
spring.task.scheduling.thread-name-prefix=scheduling-
```

---

## **18. PROFILE ANNOTATIONS**

> **Concept:** Enable beans based on active profiles .

| Annotation | Description |
|------------|-------------|
| **@Profile** | Bean active for specific profiles |
| **@ActiveProfiles** | Activate profiles in tests |

### **@Profile**

```java
@Configuration
public class DataSourceConfig {
    
    @Bean
    @Profile("dev")
    public DataSource devDataSource() {
        return DataSourceBuilder.create()
            .url("jdbc:h2:mem:devdb")
            .username("sa")
            .build();
    }
    
    @Bean
    @Profile("prod")
    public DataSource prodDataSource() {
        HikariDataSource dataSource = new HikariDataSource();
        dataSource.setJdbcUrl("jdbc:postgresql://prod-server:5432/proddb");
        dataSource.setUsername(System.getenv("DB_USER"));
        dataSource.setPassword(System.getenv("DB_PASS"));
        return dataSource;
    }
    
    @Bean
    @Profile("test")
    public DataSource testDataSource() {
        return new H2DataSource();
    }
    
    @Bean
    @Profile("!prod")  // Not in prod
    public DevTools devTools() {
        return new DevTools();
    }
}

@Service
@Profile({"dev", "test"})
public class DevEmailService implements EmailService {
    // Only in dev and test
}

@Service
@Profile("prod")
public class ProdEmailService implements EmailService {
    // Only in prod
}
```

### **@ActiveProfiles**

```java
@SpringBootTest
@ActiveProfiles("test")
class UserServiceTest {
    // Uses test profile
}

@SpringBootTest
@ActiveProfiles({"dev", "h2"})
class IntegrationTest {
    // Multiple profiles
}
```

---

## **19. PROPERTY SOURCE ANNOTATIONS**

> **Concept:** Load and manage property sources .

| Annotation | Description |
|------------|-------------|
| **@PropertySource** | Load properties file |
| **@PropertySources** | Multiple property sources |
| **@TestPropertySource** | Properties for tests |

### **@PropertySource**

```java
@Configuration
@PropertySource("classpath:database.properties")
@PropertySource(value = "classpath:config-${spring.profiles.active}.properties", 
                ignoreResourceNotFound = true)
public class PropertyConfig {
    
    @Autowired
    private Environment env;
    
    @Bean
    public DataSource dataSource() {
        String url = env.getProperty("db.url");
        String username = env.getProperty("db.username");
        String password = env.getProperty("db.password");
        // ...
    }
}

@Configuration
@PropertySources({
    @PropertySource("classpath:app.properties"),
    @PropertySource(value = "classpath:secret.properties", ignoreResourceNotFound = true)
})
public class AppConfig {
    // ...
}
```

### **@TestPropertySource**

```java
@SpringBootTest
@TestPropertySource(properties = {
    "spring.datasource.url=jdbc:h2:mem:testdb",
    "app.cache.enabled=false"
})
class IntegrationTest {
    // Properties override application.properties
}

@TestPropertySource(locations = "classpath:test-application.properties")
class AnotherTest {
    // Load properties from file
}
```

---

## **20. LIFECYCLE CALLBACK ANNOTATIONS**

> **Concept:** Annotations for bean lifecycle hooks .

| Annotation | Description |
|------------|-------------|
| **@PostConstruct** | Called after bean initialization |
| **@PreDestroy** | Called before bean destruction |
| **@PostConstruct** and **@PreDestroy** are part of JSR-250 |

### **@PostConstruct / @PreDestroy**

```java
@Component
public class CacheService {
    
    private Map<String, Object> cache;
    
    @PostConstruct
    public void initialize() {
        System.out.println("Initializing cache...");
        cache = new ConcurrentHashMap<>();
        loadInitialData();
    }
    
    @PreDestroy
    public void cleanup() {
        System.out.println("Cleaning up cache...");
        persistToDisk();
        cache.clear();
    }
    
    private void loadInitialData() {
        // Load from disk
    }
    
    private void persistToDisk() {
        // Save cache before shutdown
    }
}
```

---

## **21. ANNOTATIONS CHEAT SHEET**

### **Core Annotations**
| Annotation | Purpose |
|------------|---------|
| `@SpringBootApplication` | Main application class |
| `@Configuration` | Configuration class |
| `@Bean` | Method produces bean |
| `@ComponentScan` | Component scanning |
| `@EnableAutoConfiguration` | Auto-configuration |

### **Stereotype Annotations**
| Annotation | Purpose |
|------------|---------|
| `@Component` | Generic Spring bean |
| `@Service` | Service layer |
| `@Repository` | Data access layer |
| `@Controller` | Web controller |
| `@RestController` | REST controller |

### **Dependency Injection**
| Annotation | Purpose |
|------------|---------|
| `@Autowired` | Inject by type |
| `@Qualifier` | Specify bean name |
| `@Primary` | Primary bean |
| `@Value` | Inject property value |
| `@Resource` | Inject by name |

### **Web/REST**
| Annotation | Purpose |
|------------|---------|
| `@RequestMapping` | Map web requests |
| `@GetMapping` | GET mapping |
| `@PostMapping` | POST mapping |
| `@PutMapping` | PUT mapping |
| `@DeleteMapping` | DELETE mapping |
| `@PatchMapping` | PATCH mapping |
| `@PathVariable` | URI variable |
| `@RequestParam` | Query parameter |
| `@RequestBody` | Request body |
| `@ResponseBody` | Response body |
| `@ResponseStatus` | HTTP status |
| `@ExceptionHandler` | Handle exceptions |
| `@ControllerAdvice` | Global exception handling |

### **Data/JPA**
| Annotation | Purpose |
|------------|---------|
| `@Entity` | JPA entity |
| `@Table` | Table name |
| `@Id` | Primary key |
| `@GeneratedValue` | Key generation |
| `@Column` | Column mapping |
| `@OneToMany` | One-to-many |
| `@ManyToOne` | Many-to-one |
| `@Query` | Custom query |
| `@Transactional` | Transaction management |

### **Validation**
| Annotation | Purpose |
|------------|---------|
| `@Valid` | Validate object |
| `@NotNull` | Not null |
| `@NotBlank` | Not blank string |
| `@Size` | Size constraints |
| `@Min` | Minimum value |
| `@Max` | Maximum value |
| `@Email` | Email format |
| `@Pattern` | Regex pattern |

### **Testing**
| Annotation | Purpose |
|------------|---------|
| `@SpringBootTest` | Full context |
| `@WebMvcTest` | Web layer test |
| `@DataJpaTest` | JPA test |
| `@MockBean` | Mock bean |
| `@SpyBean` | Spy bean |
| `@Test` | Test method |
| `@BeforeEach` | Before each test |
| `@AfterEach` | After each test |

### **Caching**
| Annotation | Purpose |
|------------|---------|
| `@EnableCaching` | Enable caching |
| `@Cacheable` | Cache method result |
| `@CacheEvict` | Remove from cache |
| `@CachePut` | Update cache |

### **Async/Scheduling**
| Annotation | Purpose |
|------------|---------|
| `@EnableAsync` | Enable async |
| `@Async` | Async method |
| `@EnableScheduling` | Enable scheduling |
| `@Scheduled` | Scheduled task |

### **Profile/Conditional**
| Annotation | Purpose |
|------------|---------|
| `@Profile` | Profile-based |
| `@Conditional` | Custom condition |
| `@ConditionalOnProperty` | Property condition |
| `@ConditionalOnClass` | Class condition |

---

## **📝 KEY TAKEAWAYS**

1. **Application Lifecycle** – From `SpringApplication.run()` to `ApplicationReadyEvent`, with multiple phases
2. **Bean Lifecycle** – Instantiation → Population → Initialization → Ready → Destruction
3. **Bean Scopes** – Singleton (default), prototype, request, session, application
4. **Core Annotations** – `@SpringBootApplication` combines `@Configuration` + `@EnableAutoConfiguration` + `@ComponentScan`
5. **Stereotypes** – `@Component`, `@Service`, `@Repository`, `@Controller`, `@RestController`
6. **Dependency Injection** – `@Autowired`, `@Qualifier`, `@Value`, `@Primary`
7. **Web Annotations** – `@RestController`, `@RequestMapping`, HTTP method annotations
8. **Data Annotations** – JPA annotations, `@Transactional`, `@Query`
9. **Validation** – Bean Validation annotations with `@Valid`
10. **Testing** – Slice annotations (`@WebMvcTest`, `@DataJpaTest`) for focused tests

---

*Good luck with your Spring Boot interview! 🍃🎉*