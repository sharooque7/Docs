# Complete Design Patterns Guide - The Ultimate Interview Reference 🏗️

*Your comprehensive go-to reference for all Design Patterns with brief explanations and code examples*

---

## **📋 TABLE OF CONTENTS**

1. [What are Design Patterns?](#1-what-are-design-patterns)
2. [Classification of Patterns](#2-classification-of-patterns)
3. [Creational Patterns](#3-creational-patterns)
   - [Singleton](#31-singleton)
   - [Factory Method](#32-factory-method)
   - [Abstract Factory](#33-abstract-factory)
   - [Builder](#34-builder)
   - [Prototype](#35-prototype)
4. [Structural Patterns](#4-structural-patterns)
   - [Adapter](#41-adapter)
   - [Bridge](#42-bridge)
   - [Composite](#43-composite)
   - [Decorator](#44-decorator)
   - [Facade](#45-facade)
   - [Flyweight](#46-flyweight)
   - [Proxy](#47-proxy)
5. [Behavioral Patterns](#5-behavioral-patterns)
   - [Chain of Responsibility](#51-chain-of-responsibility)
   - [Command](#52-command)
   - [Interpreter](#53-interpreter)
   - [Iterator](#54-iterator)
   - [Mediator](#55-mediator)
   - [Memento](#56-memento)
   - [Observer](#57-observer)
   - [State](#58-state)
   - [Strategy](#59-strategy)
   - [Template Method](#510-template-method)
   - [Visitor](#511-visitor)
6. [J2EE Patterns](#6-j2ee-patterns)
7. [SOLID Principles](#7-solid-principles)
8. [Pattern Comparison](#8-pattern-comparison)
9. [Common Interview Questions](#9-common-interview-questions)
10. [Quick Reference Cheat Sheet](#10-quick-reference-cheat-sheet)

---

## **1. WHAT ARE DESIGN PATTERNS?**

> **Concept:** Design patterns are reusable solutions to commonly occurring problems in software design. They represent best practices evolved over time by experienced developers.

### **Why Use Design Patterns?**

| Benefit | Description |
|---------|-------------|
| **Reusability** | Solutions can be applied to multiple problems |
| **Standardization** | Common vocabulary for developers |
| **Maintainability** | Well-structured, easier to maintain |
| **Scalability** | Proven solutions that scale |
| **Documentation** | Self-documenting architecture |

### **Pattern Elements**

| Element | Description |
|---------|-------------|
| **Pattern Name** | Describes the problem in 1-2 words |
| **Problem** | When to apply the pattern |
| **Solution** | Elements that make up the design |
| **Consequences** | Results and trade-offs |

---

## **2. CLASSIFICATION OF PATTERNS**

```
                    ┌──────────────────┐
                    │  Design Patterns │
                    └────────┬─────────┘
                             │
         ┌───────────────────┼───────────────────┐
         │                   │                   │
    ┌────▼────┐        ┌─────▼─────┐       ┌─────▼─────┐
    │Creational│        │Structural │       │Behavioral │
    └────┬────┘        └─────┬─────┘       └─────┬─────┘
         │                   │                   │
    ┌────▼─────────┐   ┌─────▼──────────┐  ┌─────▼──────────┐
    │• Singleton   │   │• Adapter       │  │• Chain of Resp │
    │• Factory     │   │• Bridge        │  │• Command       │
    │• Abstract    │   │• Composite     │  │• Interpreter   │
    │• Builder     │   │• Decorator     │  │• Iterator      │
    │• Prototype   │   │• Facade        │  │• Mediator      │
    └──────────────┘   │• Flyweight     │  │• Memento       │
                       │• Proxy         │  │• Observer      │
                       └────────────────┘  │• State         │
                                           │• Strategy      │
                                           │• Template      │
                                           │• Visitor       │
                                           └────────────────┘
```

### **Pattern Categories**

| Category | Purpose | Focus |
|----------|---------|-------|
| **Creational** | Object creation mechanisms | How objects are created |
| **Structural** | Class and object composition | How objects are assembled |
| **Behavioral** | Object interaction and responsibility | How objects communicate |

---

## **3. CREATIONAL PATTERNS**

### **3.1 Singleton**

> **Purpose:** Ensure a class has exactly one instance and provide a global point of access to it.

#### **When to Use**
- When exactly one instance is needed
- For shared resources (database connections, thread pools)
- Configuration settings, logging

#### **Implementation**

```java
// 1. Classic Singleton (not thread-safe)
public class ClassicSingleton {
    private static ClassicSingleton instance;
    
    private ClassicSingleton() {
        // Private constructor
    }
    
    public static ClassicSingleton getInstance() {
        if (instance == null) {
            instance = new ClassicSingleton();
        }
        return instance;
    }
}

// 2. Thread-Safe Singleton (synchronized)
public class ThreadSafeSingleton {
    private static ThreadSafeSingleton instance;
    
    private ThreadSafeSingleton() {}
    
    public static synchronized ThreadSafeSingleton getInstance() {
        if (instance == null) {
            instance = new ThreadSafeSingleton();
        }
        return instance;
    }
}

// 3. Double-Checked Locking
public class DoubleCheckedSingleton {
    private static volatile DoubleCheckedSingleton instance;
    
    private DoubleCheckedSingleton() {}
    
    public static DoubleCheckedSingleton getInstance() {
        if (instance == null) {
            synchronized (DoubleCheckedSingleton.class) {
                if (instance == null) {
                    instance = new DoubleCheckedSingleton();
                }
            }
        }
        return instance;
    }
}

// 4. Bill Pugh Singleton (Initialization on Demand Holder)
public class BillPughSingleton {
    private BillPughSingleton() {}
    
    private static class SingletonHelper {
        private static final BillPughSingleton INSTANCE = new BillPughSingleton();
    }
    
    public static BillPughSingleton getInstance() {
        return SingletonHelper.INSTANCE;
    }
}

// 5. Enum Singleton (Most robust)
public enum EnumSingleton {
    INSTANCE;
    
    public void doSomething() {
        System.out.println("Singleton method");
    }
}

// 6. Spring Singleton (Bean scope)
@Component
@Scope("singleton")  // Default scope
public class SpringSingleton {
    // Spring manages single instance
}
```

#### **Real-World Example: Database Connection Pool**

```java
public class DatabaseConnectionPool {
    private static volatile DatabaseConnectionPool instance;
    private List<Connection> connectionPool;
    private static final int MAX_CONNECTIONS = 10;
    
    private DatabaseConnectionPool() {
        connectionPool = new ArrayList<>();
        initializeConnections();
    }
    
    public static DatabaseConnectionPool getInstance() {
        if (instance == null) {
            synchronized (DatabaseConnectionPool.class) {
                if (instance == null) {
                    instance = new DatabaseConnectionPool();
                }
            }
        }
        return instance;
    }
    
    private void initializeConnections() {
        for (int i = 0; i < MAX_CONNECTIONS; i++) {
            connectionPool.add(createConnection());
        }
    }
    
    public Connection getConnection() {
        // Return available connection
        return connectionPool.remove(0);
    }
    
    public void releaseConnection(Connection conn) {
        connectionPool.add(conn);
    }
}
```

#### **Pros & Cons**

| ✅ Advantages | ❌ Disadvantages |
|--------------|-----------------|
| Controlled access to single instance | Can be overused |
| Reduced namespace pollution | Difficult to unit test |
| Permits refinement of operations | Not suitable for multiple instances |
| Lazy initialization possible | Violates Single Responsibility |

---

### **3.2 Factory Method**

> **Purpose:** Define an interface for creating an object, but let subclasses decide which class to instantiate.

#### **When to Use**
- When a class can't anticipate the class of objects it must create
- When subclasses should specify the objects
- To delegate instantiation to subclasses

#### **Implementation**

```java
// Product interface
interface Product {
    void use();
}

// Concrete Products
class ConcreteProductA implements Product {
    @Override
    public void use() {
        System.out.println("Using Product A");
    }
}

class ConcreteProductB implements Product {
    @Override
    public void use() {
        System.out.println("Using Product B");
    }
}

// Creator abstract class
abstract class Creator {
    // Factory method
    public abstract Product factoryMethod();
    
    // Operation that uses factory method
    public void someOperation() {
        Product product = factoryMethod();
        product.use();
    }
}

// Concrete Creators
class ConcreteCreatorA extends Creator {
    @Override
    public Product factoryMethod() {
        return new ConcreteProductA();
    }
}

class ConcreteCreatorB extends Creator {
    @Override
    public Product factoryMethod() {
        return new ConcreteProductB();
    }
}
```

#### **Real-World Example: Document Creator**

```java
// Document interface
interface Document {
    void open();
    void close();
    void save();
}

// Concrete Documents
class PDFDocument implements Document {
    @Override
    public void open() { System.out.println("Opening PDF"); }
    @Override
    public void close() { System.out.println("Closing PDF"); }
    @Override
    public void save() { System.out.println("Saving PDF"); }
}

class WordDocument implements Document {
    @Override
    public void open() { System.out.println("Opening Word"); }
    @Override
    public void close() { System.out.println("Closing Word"); }
    @Override
    public void save() { System.out.println("Saving Word"); }
}

// Creator
abstract class DocumentCreator {
    public abstract Document createDocument();
    
    public void processDocument() {
        Document doc = createDocument();
        doc.open();
        doc.save();
        doc.close();
    }
}

// Concrete Creators
class PDFCreator extends DocumentCreator {
    @Override
    public Document createDocument() {
        return new PDFDocument();
    }
}

class WordCreator extends DocumentCreator {
    @Override
    public Document createDocument() {
        return new WordDocument();
    }
}

// Usage
public class Application {
    public static void main(String[] args) {
        DocumentCreator creator = getCreator(args[0]);
        creator.processDocument();
    }
    
    private static DocumentCreator getCreator(String type) {
        if (type.equals("pdf")) {
            return new PDFCreator();
        } else if (type.equals("word")) {
            return new WordCreator();
        }
        throw new IllegalArgumentException("Unknown type");
    }
}
```

#### **Pros & Cons**

| ✅ Advantages | ❌ Disadvantages |
|--------------|-----------------|
| Single Responsibility Principle | More classes to maintain |
| Open/Closed Principle | Complexity increases |
| Loose coupling | May require inheritance |
| Consistent object creation | Can be overkill for simple cases |

---

### **3.3 Abstract Factory**

> **Purpose:** Provide an interface for creating families of related or dependent objects without specifying their concrete classes.

#### **When to Use**
- When system should be independent of how products are created
- When working with multiple product families
- When products must be used together

#### **Implementation**

```java
// Abstract Products
interface Button {
    void render();
    void onClick();
}

interface Checkbox {
    void render();
    void toggle();
}

// Concrete Products for Windows
class WindowsButton implements Button {
    @Override
    public void render() { System.out.println("Windows Button"); }
    @Override
    public void onClick() { System.out.println("Windows Click"); }
}

class WindowsCheckbox implements Checkbox {
    @Override
    public void render() { System.out.println("Windows Checkbox"); }
    @Override
    public void toggle() { System.out.println("Windows Toggle"); }
}

// Concrete Products for Mac
class MacButton implements Button {
    @Override
    public void render() { System.out.println("Mac Button"); }
    @Override
    public void onClick() { System.out.println("Mac Click"); }
}

class MacCheckbox implements Checkbox {
    @Override
    public void render() { System.out.println("Mac Checkbox"); }
    @Override
    public void toggle() { System.out.println("Mac Toggle"); }
}

// Abstract Factory
interface GUIFactory {
    Button createButton();
    Checkbox createCheckbox();
}

// Concrete Factories
class WindowsFactory implements GUIFactory {
    @Override
    public Button createButton() {
        return new WindowsButton();
    }
    
    @Override
    public Checkbox createCheckbox() {
        return new WindowsCheckbox();
    }
}

class MacFactory implements GUIFactory {
    @Override
    public Button createButton() {
        return new MacButton();
    }
    
    @Override
    public Checkbox createCheckbox() {
        return new MacCheckbox();
    }
}

// Client
class Application {
    private Button button;
    private Checkbox checkbox;
    
    public Application(GUIFactory factory) {
        button = factory.createButton();
        checkbox = factory.createCheckbox();
    }
    
    public void render() {
        button.render();
        checkbox.render();
    }
}

// Usage
public class Demo {
    public static void main(String[] args) {
        GUIFactory factory;
        
        String os = System.getProperty("os.name").toLowerCase();
        if (os.contains("win")) {
            factory = new WindowsFactory();
        } else {
            factory = new MacFactory();
        }
        
        Application app = new Application(factory);
        app.render();
    }
}
```

#### **Real-World Example: Database Connection Factory**

```java
// Abstract Products
interface Connection {
    void connect();
    void disconnect();
}

interface Command {
    void execute(String query);
}

// Concrete Products for MySQL
class MySQLConnection implements Connection {
    @Override
    public void connect() { System.out.println("MySQL Connected"); }
    @Override
    public void disconnect() { System.out.println("MySQL Disconnected"); }
}

class MySQLCommand implements Command {
    @Override
    public void execute(String query) { 
        System.out.println("MySQL executing: " + query);
    }
}

// Concrete Products for PostgreSQL
class PostgreSQLConnection implements Connection {
    @Override
    public void connect() { System.out.println("PostgreSQL Connected"); }
    @Override
    public void disconnect() { System.out.println("PostgreSQL Disconnected"); }
}

class PostgreSQLCommand implements Command {
    @Override
    public void execute(String query) { 
        System.out.println("PostgreSQL executing: " + query);
    }
}

// Abstract Factory
interface DatabaseFactory {
    Connection createConnection();
    Command createCommand();
}

// Concrete Factories
class MySQLFactory implements DatabaseFactory {
    @Override
    public Connection createConnection() {
        return new MySQLConnection();
    }
    
    @Override
    public Command createCommand() {
        return new MySQLCommand();
    }
}

class PostgreSQLFactory implements DatabaseFactory {
    @Override
    public Connection createConnection() {
        return new PostgreSQLConnection();
    }
    
    @Override
    public Command createCommand() {
        return new PostgreSQLCommand();
    }
}
```

#### **Pros & Cons**

| ✅ Advantages | ❌ Disadvantages |
|--------------|-----------------|
| Consistent product families | Complex to implement |
| Loose coupling | Hard to add new product types |
| Open/Closed Principle | Many interfaces and classes |
| Easier to exchange families | Can become over-engineered |

---

### **3.4 Builder**

> **Purpose:** Separate the construction of a complex object from its representation, allowing the same construction process to create different representations.

#### **When to Use**
- When objects have many optional parameters
- When construction involves multiple steps
- When different representations of same object needed

#### **Implementation**

```java
// Product
class Computer {
    // Required parameters
    private String cpu;
    private String ram;
    
    // Optional parameters
    private String storage;
    private String graphicsCard;
    private String bluetooth;
    
    private Computer(Builder builder) {
        this.cpu = builder.cpu;
        this.ram = builder.ram;
        this.storage = builder.storage;
        this.graphicsCard = builder.graphicsCard;
        this.bluetooth = builder.bluetooth;
    }
    
    // Builder class
    public static class Builder {
        // Required parameters
        private String cpu;
        private String ram;
        
        // Optional parameters - initialized to defaults
        private String storage = "256GB SSD";
        private String graphicsCard = "Integrated";
        private String bluetooth = "No";
        
        public Builder(String cpu, String ram) {
            this.cpu = cpu;
            this.ram = ram;
        }
        
        public Builder setStorage(String storage) {
            this.storage = storage;
            return this;
        }
        
        public Builder setGraphicsCard(String graphicsCard) {
            this.graphicsCard = graphicsCard;
            return this;
        }
        
        public Builder setBluetooth(String bluetooth) {
            this.bluetooth = bluetooth;
            return this;
        }
        
        public Computer build() {
            return new Computer(this);
        }
    }
    
    @Override
    public String toString() {
        return String.format("Computer [CPU=%s, RAM=%s, Storage=%s, Graphics=%s, Bluetooth=%s]",
            cpu, ram, storage, graphicsCard, bluetooth);
    }
}

// Usage
public class Demo {
    public static void main(String[] args) {
        Computer gamingPC = new Computer.Builder("Intel i9", "32GB")
            .setStorage("1TB SSD")
            .setGraphicsCard("RTX 4090")
            .setBluetooth("Yes")
            .build();
            
        Computer officePC = new Computer.Builder("Intel i5", "16GB")
            .setBluetooth("Yes")
            .build();
            
        System.out.println(gamingPC);
        System.out.println(officePC);
    }
}
```

#### **Real-World Example: Order Builder**

```java
class Order {
    private final long orderId;
    private final String customerName;
    private final List<String> items;
    private final String shippingAddress;
    private final String paymentMethod;
    private final String discountCode;
    private final boolean giftWrap;
    private final String deliveryInstructions;
    
    private Order(Builder builder) {
        this.orderId = builder.orderId;
        this.customerName = builder.customerName;
        this.items = builder.items;
        this.shippingAddress = builder.shippingAddress;
        this.paymentMethod = builder.paymentMethod;
        this.discountCode = builder.discountCode;
        this.giftWrap = builder.giftWrap;
        this.deliveryInstructions = builder.deliveryInstructions;
    }
    
    public static class Builder {
        // Required
        private final long orderId;
        private final String customerName;
        
        // Optional
        private List<String> items = new ArrayList<>();
        private String shippingAddress = "";
        private String paymentMethod = "Cash";
        private String discountCode = "";
        private boolean giftWrap = false;
        private String deliveryInstructions = "";
        
        public Builder(long orderId, String customerName) {
            this.orderId = orderId;
            this.customerName = customerName;
        }
        
        public Builder addItem(String item) {
            this.items.add(item);
            return this;
        }
        
        public Builder setShippingAddress(String address) {
            this.shippingAddress = address;
            return this;
        }
        
        public Builder setPaymentMethod(String method) {
            this.paymentMethod = method;
            return this;
        }
        
        public Builder applyDiscount(String code) {
            this.discountCode = code;
            return this;
        }
        
        public Builder withGiftWrap() {
            this.giftWrap = true;
            return this;
        }
        
        public Builder setDeliveryInstructions(String instructions) {
            this.deliveryInstructions = instructions;
            return this;
        }
        
        public Order build() {
            return new Order(this);
        }
    }
}

// Usage
Order order = new Order.Builder(12345, "John Doe")
    .addItem("Laptop")
    .addItem("Mouse")
    .setShippingAddress("123 Main St")
    .setPaymentMethod("Credit Card")
    .applyDiscount("SAVE10")
    .withGiftWrap()
    .setDeliveryInstructions("Leave at front door")
    .build();
```

#### **Pros & Cons**

| ✅ Advantages | ❌ Disadvantages |
|--------------|-----------------|
| Immutable objects | Requires builder class |
| Readable object creation | Can be verbose |
| Validates construction | Complex for simple objects |
| Flexible object creation | Duplication of fields |

---

### **3.5 Prototype**

> **Purpose:** Specify the kinds of objects to create using a prototypical instance, and create new objects by copying this prototype.

#### **When to Use**
- When object creation is expensive
- When objects have similar configurations
- To avoid subclassing

#### **Implementation**

```java
// Prototype interface
interface Prototype extends Cloneable {
    Prototype clone();
}

// Concrete prototype
class Employee implements Prototype {
    private String name;
    private String department;
    private double salary;
    private List<String> skills;
    private Address address;
    
    public Employee(String name, String department, double salary, 
                    List<String> skills, Address address) {
        this.name = name;
        this.department = department;
        this.salary = salary;
        this.skills = skills;
        this.address = address;
    }
    
    // Shallow copy
    @Override
    public Employee clone() {
        try {
            return (Employee) super.clone();
        } catch (CloneNotSupportedException e) {
            return null;
        }
    }
    
    // Deep copy
    public Employee deepClone() {
        Employee cloned = this.clone();
        cloned.skills = new ArrayList<>(this.skills);
        cloned.address = this.address.clone();
        return cloned;
    }
}

// Support class
class Address implements Cloneable {
    String street;
    String city;
    
    @Override
    protected Address clone() {
        try {
            return (Address) super.clone();
        } catch (CloneNotSupportedException e) {
            return null;
        }
    }
}
```

#### **Real-World Example: Document Template**

```java
// Prototype registry
class DocumentPrototypeRegistry {
    private static Map<String, Document> prototypes = new HashMap<>();
    
    static {
        // Initialize with default templates
        Report report = new Report();
        report.setTitle("Monthly Report");
        report.setHeader("Company Confidential");
        report.setFooter("Page {page}");
        prototypes.put("report", report);
        
        Invoice invoice = new Invoice();
        invoice.setTitle("Invoice");
        invoice.setCompanyLogo("default.png");
        invoice.setFooter("Thank you for your business!");
        prototypes.put("invoice", invoice);
    }
    
    public static Document getPrototype(String type) {
        Document proto = prototypes.get(type);
        return proto != null ? proto.clone() : null;
    }
    
    public static void addPrototype(String key, Document prototype) {
        prototypes.put(key, prototype);
    }
}

// Abstract prototype
abstract class Document implements Cloneable {
    protected String title;
    protected String header;
    protected String footer;
    
    public abstract void render();
    
    @Override
    public Document clone() {
        try {
            return (Document) super.clone();
        } catch (CloneNotSupportedException e) {
            return null;
        }
    }
    
    // Getters and setters
}

// Concrete prototypes
class Report extends Document {
    private String[] sections;
    
    @Override
    public void render() {
        System.out.println("Rendering Report: " + title);
    }
    
    @Override
    public Report clone() {
        Report cloned = (Report) super.clone();
        cloned.sections = this.sections.clone(); // Deep copy
        return cloned;
    }
}

class Invoice extends Document {
    private String companyLogo;
    private List<LineItem> items;
    
    @Override
    public void render() {
        System.out.println("Rendering Invoice: " + title);
    }
    
    @Override
    public Invoice clone() {
        Invoice cloned = (Invoice) super.clone();
        cloned.items = new ArrayList<>(this.items); // Deep copy
        return cloned;
    }
}

// Usage
public class DocumentEditor {
    public static void main(String[] args) {
        // Create from prototype
        Document report = DocumentPrototypeRegistry.getPrototype("report");
        report.setTitle("2024 Sales Report");
        
        Document invoice = DocumentPrototypeRegistry.getPrototype("invoice");
        invoice.setTitle("INV-2024-001");
        
        report.render();
        invoice.render();
    }
}
```

#### **Pros & Cons**

| ✅ Advantages | ❌ Disadvantages |
|--------------|-----------------|
| Less object creation overhead | Complex deep copy |
| Reduces subclassing | Clone not always easy |
| Dynamic configuration | Circular references |
| Can add/remove at runtime | Clone method may fail |

---

## **4. STRUCTURAL PATTERNS**

### **4.1 Adapter**

> **Purpose:** Convert the interface of a class into another interface clients expect. Adapter lets classes work together that couldn't otherwise because of incompatible interfaces.

#### **When to Use**
- When you want to use an existing class but its interface doesn't match
- When you need to create a reusable class that cooperates with unrelated classes
- When integrating legacy code

#### **Implementation**

```java
// Target interface - what client expects
interface MediaPlayer {
    void play(String audioType, String fileName);
}

// Adaptee - existing class with different interface
class AdvancedMediaPlayer {
    public void playVlc(String fileName) {
        System.out.println("Playing vlc file: " + fileName);
    }
    
    public void playMp4(String fileName) {
        System.out.println("Playing mp4 file: " + fileName);
    }
}

// Adapter
class MediaAdapter implements MediaPlayer {
    private AdvancedMediaPlayer advancedMusicPlayer;
    
    public MediaAdapter(String audioType) {
        advancedMusicPlayer = new AdvancedMediaPlayer();
    }
    
    @Override
    public void play(String audioType, String fileName) {
        if (audioType.equalsIgnoreCase("vlc")) {
            advancedMusicPlayer.playVlc(fileName);
        } else if (audioType.equalsIgnoreCase("mp4")) {
            advancedMusicPlayer.playMp4(fileName);
        }
    }
}

// Concrete class using adapter
class AudioPlayer implements MediaPlayer {
    private MediaAdapter mediaAdapter;
    
    @Override
    public void play(String audioType, String fileName) {
        // Built-in support for mp3
        if (audioType.equalsIgnoreCase("mp3")) {
            System.out.println("Playing mp3 file: " + fileName);
        }
        // Use adapter for other formats
        else if (audioType.equalsIgnoreCase("vlc") || 
                 audioType.equalsIgnoreCase("mp4")) {
            mediaAdapter = new MediaAdapter(audioType);
            mediaAdapter.play(audioType, fileName);
        } else {
            System.out.println("Invalid media type: " + audioType);
        }
    }
}
```

#### **Real-World Example: Payment Gateway Integration**

```java
// Target interface - our application's payment interface
interface PaymentProcessor {
    void pay(double amount);
}

// Adaptee 1 - PayPal's API
class PayPalAPI {
    public void makePayment(double amount, String currency) {
        System.out.println("PayPal processing: $" + amount + " " + currency);
    }
}

// Adaptee 2 - Stripe's API
class StripeAPI {
    public void charge(double amountInCents, String description) {
        System.out.println("Stripe charging: $" + amountInCents/100 + " for " + description);
    }
}

// Adapter for PayPal
class PayPalAdapter implements PaymentProcessor {
    private PayPalAPI payPalAPI;
    
    public PayPalAdapter(PayPalAPI payPalAPI) {
        this.payPalAPI = payPalAPI;
    }
    
    @Override
    public void pay(double amount) {
        payPalAPI.makePayment(amount, "USD");
    }
}

// Adapter for Stripe
class StripeAdapter implements PaymentProcessor {
    private StripeAPI stripeAPI;
    
    public StripeAdapter(StripeAPI stripeAPI) {
        this.stripeAPI = stripeAPI;
    }
    
    @Override
    public void pay(double amount) {
        stripeAPI.charge((long)(amount * 100), "Product purchase");
    }
}

// Client
class CheckoutService {
    private PaymentProcessor paymentProcessor;
    
    public CheckoutService(PaymentProcessor processor) {
        this.paymentProcessor = processor;
    }
    
    public void checkout(double amount) {
        paymentProcessor.pay(amount);
    }
}

// Usage
public class Store {
    public static void main(String[] args) {
        // Using PayPal
        PaymentProcessor paypal = new PayPalAdapter(new PayPalAPI());
        CheckoutService service1 = new CheckoutService(paypal);
        service1.checkout(99.99);
        
        // Using Stripe
        PaymentProcessor stripe = new StripeAdapter(new StripeAPI());
        CheckoutService service2 = new CheckoutService(stripe);
        service2.checkout(149.99);
    }
}
```

#### **Class vs Object Adapter**

| Type | Implementation | When to Use |
|------|----------------|-------------|
| **Class Adapter** | Multiple inheritance | When adapter needs to override behavior |
| **Object Adapter** | Composition | When you need to adapt multiple adaptees |

```java
// Class Adapter (multiple inheritance in languages that support it)
class PayPalClassAdapter extends PayPalAPI implements PaymentProcessor {
    @Override
    public void pay(double amount) {
        makePayment(amount, "USD");
    }
}

// Object Adapter (composition - more flexible)
class PayPalObjectAdapter implements PaymentProcessor {
    private PayPalAPI payPalAPI;
    
    public PayPalObjectAdapter(PayPalAPI payPalAPI) {
        this.payPalAPI = payPalAPI;
    }
    
    @Override
    public void pay(double amount) {
        payPalAPI.makePayment(amount, "USD");
    }
}
```

#### **Pros & Cons**

| ✅ Advantages | ❌ Disadvantages |
|--------------|-----------------|
| Single Responsibility Principle | Can increase complexity |
| Open/Closed Principle | Multiple adapters needed |
| Reusable adapters | May not fit all situations |

---

### **4.2 Bridge**

> **Purpose:** Decouple an abstraction from its implementation so that the two can vary independently.

#### **When to Use**
- When you want to avoid permanent binding between abstraction and implementation
- When both abstractions and implementations should be extensible by subclassing
- When changes in implementation shouldn't affect clients

#### **Implementation**

```java
// Implementor interface
interface Device {
    void turnOn();
    void turnOff();
    void setVolume(int percent);
}

// Concrete Implementors
class TV implements Device {
    @Override
    public void turnOn() {
        System.out.println("TV turning on");
    }
    
    @Override
    public void turnOff() {
        System.out.println("TV turning off");
    }
    
    @Override
    public void setVolume(int percent) {
        System.out.println("TV volume set to " + percent);
    }
}

class Radio implements Device {
    @Override
    public void turnOn() {
        System.out.println("Radio turning on");
    }
    
    @Override
    public void turnOff() {
        System.out.println("Radio turning off");
    }
    
    @Override
    public void setVolume(int percent) {
        System.out.println("Radio volume set to " + percent);
    }
}

// Abstraction
abstract class RemoteControl {
    protected Device device;
    
    public RemoteControl(Device device) {
        this.device = device;
    }
    
    public abstract void togglePower();
    public abstract void volumeUp();
    public abstract void volumeDown();
}

// Refined Abstractions
class BasicRemote extends RemoteControl {
    private boolean isOn = false;
    private int volume = 10;
    
    public BasicRemote(Device device) {
        super(device);
    }
    
    @Override
    public void togglePower() {
        if (isOn) {
            device.turnOff();
            isOn = false;
        } else {
            device.turnOn();
            isOn = true;
        }
    }
    
    @Override
    public void volumeUp() {
        volume = Math.min(100, volume + 10);
        device.setVolume(volume);
    }
    
    @Override
    public void volumeDown() {
        volume = Math.max(0, volume - 10);
        device.setVolume(volume);
    }
}

class AdvancedRemote extends BasicRemote {
    public AdvancedRemote(Device device) {
        super(device);
    }
    
    public void mute() {
        System.out.println("Muting device");
        device.setVolume(0);
    }
    
    public void setChannel(int channel) {
        System.out.println("Setting channel to " + channel);
    }
}

// Usage
public class BridgeDemo {
    public static void main(String[] args) {
        Device tv = new TV();
        RemoteControl remote = new BasicRemote(tv);
        remote.togglePower();
        remote.volumeUp();
        
        Device radio = new Radio();
        AdvancedRemote advancedRemote = new AdvancedRemote(radio);
        advancedRemote.togglePower();
        advancedRemote.mute();
    }
}
```

#### **Real-World Example: Message Sending**

```java
// Implementor
interface MessageSender {
    void sendMessage(String message, String recipient);
}

// Concrete Implementors
class EmailSender implements MessageSender {
    @Override
    public void sendMessage(String message, String recipient) {
        System.out.println("Sending email to " + recipient + ": " + message);
    }
}

class SMSSender implements MessageSender {
    @Override
    public void sendMessage(String message, String recipient) {
        System.out.println("Sending SMS to " + recipient + ": " + message);
    }
}

class SlackSender implements MessageSender {
    @Override
    public void sendMessage(String message, String recipient) {
        System.out.println("Sending Slack to " + recipient + ": " + message);
    }
}

// Abstraction
abstract class Message {
    protected MessageSender sender;
    
    public Message(MessageSender sender) {
        this.sender = sender;
    }
    
    public abstract void send(String message, String recipient);
}

// Refined Abstractions
class TextMessage extends Message {
    public TextMessage(MessageSender sender) {
        super(sender);
    }
    
    @Override
    public void send(String message, String recipient) {
        sender.sendMessage(message, recipient);
    }
}

class EncryptedMessage extends Message {
    public EncryptedMessage(MessageSender sender) {
        super(sender);
    }
    
    @Override
    public void send(String message, String recipient) {
        String encrypted = encrypt(message);
        sender.sendMessage(encrypted, recipient);
    }
    
    private String encrypt(String message) {
        return "ENCRYPTED(" + message + ")";
    }
}

class UrgentMessage extends Message {
    public UrgentMessage(MessageSender sender) {
        super(sender);
    }
    
    @Override
    public void send(String message, String recipient) {
        sender.sendMessage("[URGENT] " + message, recipient);
    }
}

// Usage
public class MessagingApp {
    public static void main(String[] args) {
        // Different combinations of messages and senders
        Message emailMsg = new TextMessage(new EmailSender());
        emailMsg.send("Hello", "john@example.com");
        
        Message encryptedSMS = new EncryptedMessage(new SMSSender());
        encryptedSMS.send("Secret", "+1234567890");
        
        Message urgentSlack = new UrgentMessage(new SlackSender());
        urgentSlack.send("Meeting now", "team-channel");
    }
}
```

#### **Pros & Cons**

| ✅ Advantages | ❌ Disadvantages |
|--------------|-----------------|
| Decouples interface from implementation | Complexity increases |
| Open/Closed Principle | Need to understand both hierarchies |
| Single Responsibility Principle | More planning required |
| Can extend independently | May be overkill for simple cases |

---

### **4.3 Composite**

> **Purpose:** Compose objects into tree structures to represent part-whole hierarchies. Composite lets clients treat individual objects and compositions uniformly.

#### **When to Use**
- When you need to represent hierarchical structures
- When clients should treat individual and composite objects uniformly
- When tree structures are natural

#### **Implementation**

```java
// Component
interface Employee {
    void showDetails();
    double getSalary();
    void add(Employee employee);
    void remove(Employee employee);
    List<Employee> getChildren();
}

// Leaf
class Developer implements Employee {
    private String name;
    private double salary;
    
    public Developer(String name, double salary) {
        this.name = name;
        this.salary = salary;
    }
    
    @Override
    public void showDetails() {
        System.out.println("Developer: " + name + ", Salary: $" + salary);
    }
    
    @Override
    public double getSalary() {
        return salary;
    }
    
    // Leaf doesn't support these operations
    @Override
    public void add(Employee employee) {
        throw new UnsupportedOperationException();
    }
    
    @Override
    public void remove(Employee employee) {
        throw new UnsupportedOperationException();
    }
    
    @Override
    public List<Employee> getChildren() {
        throw new UnsupportedOperationException();
    }
}

// Another Leaf
class Manager implements Employee {
    private String name;
    private double salary;
    
    public Manager(String name, double salary) {
        this.name = name;
        this.salary = salary;
    }
    
    @Override
    public void showDetails() {
        System.out.println("Manager: " + name + ", Salary: $" + salary);
    }
    
    @Override
    public double getSalary() {
        return salary;
    }
    
    @Override
    public void add(Employee employee) {
        throw new UnsupportedOperationException();
    }
    
    @Override
    public void remove(Employee employee) {
        throw new UnsupportedOperationException();
    }
    
    @Override
    public List<Employee> getChildren() {
        throw new UnsupportedOperationException();
    }
}

// Composite
class Department implements Employee {
    private String name;
    private List<Employee> employees = new ArrayList<>();
    
    public Department(String name) {
        this.name = name;
    }
    
    @Override
    public void showDetails() {
        System.out.println("Department: " + name);
        for (Employee emp : employees) {
            emp.showDetails();
        }
    }
    
    @Override
    public double getSalary() {
        double total = 0;
        for (Employee emp : employees) {
            total += emp.getSalary();
        }
        return total;
    }
    
    @Override
    public void add(Employee employee) {
        employees.add(employee);
    }
    
    @Override
    public void remove(Employee employee) {
        employees.remove(employee);
    }
    
    @Override
    public List<Employee> getChildren() {
        return employees;
    }
}

// Usage
public class Company {
    public static void main(String[] args) {
        // Create leaf employees
        Employee dev1 = new Developer("John", 80000);
        Employee dev2 = new Developer("Jane", 85000);
        Employee manager1 = new Manager("Bob", 120000);
        
        // Create department and add employees
        Department engineering = new Department("Engineering");
        engineering.add(dev1);
        engineering.add(dev2);
        engineering.add(manager1);
        
        // Create another department
        Employee dev3 = new Developer("Alice", 82000);
        Employee manager2 = new Manager("Charlie", 130000);
        
        Department qa = new Department("QA");
        qa.add(dev3);
        qa.add(manager2);
        
        // Create root department
        Department company = new Department("Company");
        company.add(engineering);
        company.add(qa);
        
        // Show entire hierarchy
        company.showDetails();
        
        // Calculate total salary
        System.out.println("Total salary expense: $" + company.getSalary());
    }
}
```

#### **Real-World Example: File System**

```java
// Component
interface FileSystemComponent {
    void display(String indent);
    long getSize();
    void add(FileSystemComponent component);
    void remove(FileSystemComponent component);
}

// Leaf
class File implements FileSystemComponent {
    private String name;
    private long size;
    
    public File(String name, long size) {
        this.name = name;
        this.size = size;
    }
    
    @Override
    public void display(String indent) {
        System.out.println(indent + "File: " + name + " (" + size + " bytes)");
    }
    
    @Override
    public long getSize() {
        return size;
    }
    
    @Override
    public void add(FileSystemComponent component) {
        throw new UnsupportedOperationException();
    }
    
    @Override
    public void remove(FileSystemComponent component) {
        throw new UnsupportedOperationException();
    }
}

// Composite
class Directory implements FileSystemComponent {
    private String name;
    private List<FileSystemComponent> components = new ArrayList<>();
    
    public Directory(String name) {
        this.name = name;
    }
    
    @Override
    public void display(String indent) {
        System.out.println(indent + "Directory: " + name + "/");
        for (FileSystemComponent component : components) {
            component.display(indent + "  ");
        }
    }
    
    @Override
    public long getSize() {
        long total = 0;
        for (FileSystemComponent component : components) {
            total += component.getSize();
        }
        return total;
    }
    
    @Override
    public void add(FileSystemComponent component) {
        components.add(component);
    }
    
    @Override
    public void remove(FileSystemComponent component) {
        components.remove(component);
    }
}

// Usage
public class FileSystemDemo {
    public static void main(String[] args) {
        // Create files
        FileSystemComponent file1 = new File("document.txt", 1024);
        FileSystemComponent file2 = new File("image.jpg", 2048);
        FileSystemComponent file3 = new File("video.mp4", 10240);
        
        // Create directories
        Directory documents = new Directory("Documents");
        Directory images = new Directory("Images");
        Directory root = new Directory("root");
        
        // Build tree structure
        documents.add(file1);
        images.add(file2);
        root.add(documents);
        root.add(images);
        root.add(file3);
        
        // Display file system
        root.display("");
        System.out.println("Total size: " + root.getSize() + " bytes");
    }
}
```

#### **Pros & Cons**

| ✅ Advantages | ❌ Disadvantages |
|--------------|-----------------|
| Uniform treatment of objects | May make design overly general |
| Easy to add new component types | Hard to restrict component types |
| Flexible hierarchical structures | Can be difficult to debug |

---

### **4.4 Decorator**

> **Purpose:** Attach additional responsibilities to an object dynamically. Decorators provide a flexible alternative to subclassing for extending functionality.

#### **When to Use**
- When you need to add responsibilities dynamically
- When subclassing would lead to explosion of classes
- When you want to extend a class without inheritance

#### **Implementation**

```java
// Component interface
interface Coffee {
    String getDescription();
    double getCost();
}

// Concrete Component
class SimpleCoffee implements Coffee {
    @Override
    public String getDescription() {
        return "Simple coffee";
    }
    
    @Override
    public double getCost() {
        return 2.0;
    }
}

// Decorator base
abstract class CoffeeDecorator implements Coffee {
    protected Coffee decoratedCoffee;
    
    public CoffeeDecorator(Coffee coffee) {
        this.decoratedCoffee = coffee;
    }
    
    @Override
    public String getDescription() {
        return decoratedCoffee.getDescription();
    }
    
    @Override
    public double getCost() {
        return decoratedCoffee.getCost();
    }
}

// Concrete Decorators
class MilkDecorator extends CoffeeDecorator {
    public MilkDecorator(Coffee coffee) {
        super(coffee);
    }
    
    @Override
    public String getDescription() {
        return super.getDescription() + ", milk";
    }
    
    @Override
    public double getCost() {
        return super.getCost() + 0.5;
    }
}

class SugarDecorator extends CoffeeDecorator {
    public SugarDecorator(Coffee coffee) {
        super(coffee);
    }
    
    @Override
    public String getDescription() {
        return super.getDescription() + ", sugar";
    }
    
    @Override
    public double getCost() {
        return super.getCost() + 0.2;
    }
}

class WhippedCreamDecorator extends CoffeeDecorator {
    public WhippedCreamDecorator(Coffee coffee) {
        super(coffee);
    }
    
    @Override
    public String getDescription() {
        return super.getDescription() + ", whipped cream";
    }
    
    @Override
    public double getCost() {
        return super.getCost() + 0.7;
    }
}

// Usage
public class CoffeeShop {
    public static void main(String[] args) {
        Coffee coffee = new SimpleCoffee();
        System.out.println(coffee.getDescription() + " $" + coffee.getCost());
        
        Coffee milkCoffee = new MilkDecorator(new SimpleCoffee());
        System.out.println(milkCoffee.getDescription() + " $" + milkCoffee.getCost());
        
        Coffee fancyCoffee = new WhippedCreamDecorator(
            new MilkDecorator(new SugarDecorator(new SimpleCoffee()))
        );
        System.out.println(fancyCoffee.getDescription() + " $" + fancyCoffee.getCost());
    }
}
```

#### **Real-World Example: Pizza Ordering**

```java
// Component
interface Pizza {
    String getDescription();
    double getPrice();
}

// Concrete Components
class Margherita implements Pizza {
    @Override
    public String getDescription() {
        return "Margherita (tomato, mozzarella)";
    }
    
    @Override
    public double getPrice() {
        return 8.99;
    }
}

class Pepperoni implements Pizza {
    @Override
    public String getDescription() {
        return "Pepperoni (pepperoni, cheese)";
    }
    
    @Override
    public double getPrice() {
        return 10.99;
    }
}

// Base Decorator
abstract class ToppingDecorator implements Pizza {
    protected Pizza pizza;
    
    public ToppingDecorator(Pizza pizza) {
        this.pizza = pizza;
    }
    
    @Override
    public String getDescription() {
        return pizza.getDescription();
    }
    
    @Override
    public double getPrice() {
        return pizza.getPrice();
    }
}

// Concrete Decorators
class ExtraCheese extends ToppingDecorator {
    public ExtraCheese(Pizza pizza) {
        super(pizza);
    }
    
    @Override
    public String getDescription() {
        return pizza.getDescription() + ", extra cheese";
    }
    
    @Override
    public double getPrice() {
        return pizza.getPrice() + 1.50;
    }
}

class Mushrooms extends ToppingDecorator {
    public Mushrooms(Pizza pizza) {
        super(pizza);
    }
    
    @Override
    public String getDescription() {
        return pizza.getDescription() + ", mushrooms";
    }
    
    @Override
    public double getPrice() {
        return pizza.getPrice() + 1.00;
    }
}

class Olives extends ToppingDecorator {
    public Olives(Pizza pizza) {
        super(pizza);
    }
    
    @Override
    public String getDescription() {
        return pizza.getDescription() + ", olives";
    }
    
    @Override
    public double getPrice() {
        return pizza.getPrice() + 0.75;
    }
}

// Usage
public class PizzaShop {
    public static void main(String[] args) {
        Pizza pizza = new Margherita();
        System.out.println(pizza.getDescription() + " = $" + pizza.getPrice());
        
        Pizza customPizza = new ExtraCheese(
            new Mushrooms(new Olives(new Margherita()))
        );
        System.out.println(customPizza.getDescription() + " = $" + customPizza.getPrice());
        
        Pizza meatLovers = new ExtraCheese(
            new ExtraCheese(new Pepperoni())
        );
        System.out.println(meatLovers.getDescription() + " = $" + meatLovers.getPrice());
    }
}
```

#### **Pros & Cons**

| ✅ Advantages | ❌ Disadvantages |
|--------------|-----------------|
| More flexible than inheritance | Many small classes |
| Avoids feature-packed classes | Complex debugging |
| Open/Closed Principle | Can be confusing |
| Can combine decorators | Similar objects in stack |

---

### **4.5 Facade**

> **Purpose:** Provide a unified interface to a set of interfaces in a subsystem. Facade defines a higher-level interface that makes the subsystem easier to use.

#### **When to Use**
- When you want to provide a simple interface to a complex subsystem
- When you want to decouple clients from subsystem
- When you want to layer your subsystems

#### **Implementation**

```java
// Complex subsystem classes
class CPU {
    public void freeze() { System.out.println("CPU: freeze"); }
    public void jump(long position) { System.out.println("CPU: jump to " + position); }
    public void execute() { System.out.println("CPU: execute"); }
}

class Memory {
    public void load(long position, byte[] data) {
        System.out.println("Memory: loading data at " + position);
    }
}

class HardDrive {
    public byte[] read(long lba, int size) {
        System.out.println("HardDrive: reading " + size + " bytes from LBA " + lba);
        return new byte[size];
    }
}

// Facade
class ComputerFacade {
    private CPU cpu;
    private Memory memory;
    private HardDrive hardDrive;
    
    public ComputerFacade() {
        this.cpu = new CPU();
        this.memory = new Memory();
        this.hardDrive = new HardDrive();
    }
    
    public void start() {
        System.out.println("=== Starting Computer ===");
        cpu.freeze();
        memory.load(0, hardDrive.read(0, 1024));
        cpu.jump(0);
        cpu.execute();
        System.out.println("=== Computer Started ===");
    }
    
    public void shutdown() {
        System.out.println("Shutting down...");
        // Complex shutdown logic
    }
}
```

#### **Real-World Example: Home Theater System**

```java
// Complex subsystem classes
class Amplifier {
    public void on() { System.out.println("Amplifier on"); }
    public void off() { System.out.println("Amplifier off"); }
    public void setVolume(int level) { System.out.println("Volume set to " + level); }
}

class DVDPlayer {
    public void on() { System.out.println("DVD Player on"); }
    public void off() { System.out.println("DVD Player off"); }
    public void play(String movie) { System.out.println("Playing " + movie); }
    public void stop() { System.out.println("Stopping DVD"); }
}

class Projector {
    public void on() { System.out.println("Projector on"); }
    public void off() { System.out.println("Projector off"); }
    public void wideScreenMode() { System.out.println("Projector in widescreen mode"); }
}

class Lights {
    public void dim(int level) { System.out.println("Lights dimmed to " + level + "%"); }
    public void on() { System.out.println("Lights on"); }
}

class Screen {
    public void down() { System.out.println("Screen down"); }
    public void up() { System.out.println("Screen up"); }
}

// Facade
class HomeTheaterFacade {
    private Amplifier amp;
    private DVDPlayer dvd;
    private Projector projector;
    private Lights lights;
    private Screen screen;
    
    public HomeTheaterFacade(Amplifier amp, DVDPlayer dvd, Projector projector,
                             Lights lights, Screen screen) {
        this.amp = amp;
        this.dvd = dvd;
        this.projector = projector;
        this.lights = lights;
        this.screen = screen;
    }
    
    public void watchMovie(String movie) {
        System.out.println("\n=== Get ready to watch a movie ===");
        lights.dim(10);
        screen.down();
        projector.on();
        projector.wideScreenMode();
        amp.on();
        amp.setVolume(5);
        dvd.on();
        dvd.play(movie);
    }
    
    public void endMovie() {
        System.out.println("\n=== Shutting down theater ===");
        lights.on();
        screen.up();
        projector.off();
        amp.off();
        dvd.stop();
        dvd.off();
    }
}

// Usage
public class HomeTheaterTest {
    public static void main(String[] args) {
        // Create subsystems
        Amplifier amp = new Amplifier();
        DVDPlayer dvd = new DVDPlayer();
        Projector projector = new Projector();
        Lights lights = new Lights();
        Screen screen = new Screen();
        
        // Create facade
        HomeTheaterFacade theater = new HomeTheaterFacade(amp, dvd, projector, lights, screen);
        
        // Use simple interface
        theater.watchMovie("Inception");
        theater.endMovie();
    }
}
```

#### **Pros & Cons**

| ✅ Advantages | ❌ Disadvantages |
|--------------|-----------------|
| Simplifies client usage | Can become god object |
| Decouples clients from subsystem | Hides important functionality |
| Reduces dependencies | Additional layer |
| Promotes layering | May not be appropriate for all clients |

---

### **4.6 Flyweight**

> **Purpose:** Use sharing to support large numbers of fine-grained objects efficiently.

#### **When to Use**
- When you have many similar objects
- When memory is a concern
- When object state can be externalized

#### **Implementation**

```java
// Flyweight
interface Character {
    void display(int size, String color);  // extrinsic state
}

// Concrete Flyweight
class CharacterImpl implements Character {
    private char symbol;  // intrinsic state (shared)
    
    public CharacterImpl(char symbol) {
        this.symbol = symbol;
    }
    
    @Override
    public void display(int size, String color) {
        System.out.println("Character: " + symbol + 
                          ", Size: " + size + 
                          ", Color: " + color);
    }
}

// Flyweight Factory
class CharacterFactory {
    private Map<Character, CharacterImpl> characters = new HashMap<>();
    
    public Character getCharacter(char symbol) {
        CharacterImpl character = characters.get(symbol);
        if (character == null) {
            character = new CharacterImpl(symbol);
            characters.put(symbol, character);
            System.out.println("Creating new character: " + symbol);
        }
        return character;
    }
    
    public int getTotalCharacters() {
        return characters.size();
    }
}

// Usage
public class TextEditor {
    public static void main(String[] args) {
        CharacterFactory factory = new CharacterFactory();
        
        // Text: "Hello World"
        String text = "Hello World";
        
        for (char c : text.toCharArray()) {
            Character character = factory.getCharacter(c);
            character.display(12, "black");
        }
        
        System.out.println("Total unique characters created: " + factory.getTotalCharacters());
    }
}
```

#### **Real-World Example: Particle System**

```java
// Flyweight
interface Particle {
    void render(int x, int y, double speed);
}

// Concrete Flyweight - shared intrinsic state
class ParticleImpl implements Particle {
    private String type;          // intrinsic
    private String image;          // intrinsic
    private int defaultSpeed;      // intrinsic
    
    public ParticleImpl(String type, String image, int defaultSpeed) {
        this.type = type;
        this.image = image;
        this.defaultSpeed = defaultSpeed;
    }
    
    @Override
    public void render(int x, int y, double speed) {  // extrinsic
        System.out.println("Rendering " + type + " particle at (" + x + "," + y + 
                          ") with speed " + (speed * defaultSpeed));
    }
}

// Flyweight Factory
class ParticleFactory {
    private Map<String, Particle> particles = new HashMap<>();
    
    public Particle getParticle(String type) {
        Particle particle = particles.get(type);
        if (particle == null) {
            // Load particle data from file
            switch (type) {
                case "explosion":
                    particle = new ParticleImpl("explosion", "explosion.png", 5);
                    break;
                case "smoke":
                    particle = new ParticleImpl("smoke", "smoke.png", 2);
                    break;
                case "spark":
                    particle = new ParticleImpl("spark", "spark.png", 8);
                    break;
                default:
                    throw new IllegalArgumentException("Unknown particle type");
            }
            particles.put(type, particle);
            System.out.println("Created new " + type + " particle type");
        }
        return particle;
    }
    
    public int getParticleTypes() {
        return particles.size();
    }
}

// Usage in game
public class Game {
    public static void main(String[] args) {
        ParticleFactory factory = new ParticleFactory();
        
        // Simulate thousands of particles
        Random random = new Random();
        for (int i = 0; i < 10000; i++) {
            String type;
            int r = random.nextInt(3);
            if (r == 0) type = "explosion";
            else if (r == 1) type = "smoke";
            else type = "spark";
            
            Particle particle = factory.getParticle(type);
            particle.render(
                random.nextInt(1920),
                random.nextInt(1080),
                random.nextDouble()
            );
        }
        
        System.out.println("Total particle types created: " + factory.getParticleTypes());
        // Only 3 particle types created for 10000 particles!
    }
}
```

#### **Pros & Cons**

| ✅ Advantages | ❌ Disadvantages |
|--------------|-----------------|
| Reduces memory usage | Complexity increases |
| Improves performance | Need to separate state |
| Reduces object count | Thread safety concerns |

---

### **4.7 Proxy**

> **Purpose:** Provide a surrogate or placeholder for another object to control access to it.

#### **When to Use**
- For lazy loading (virtual proxy)
- For access control (protection proxy)
- For logging/monitoring
- For remote communication

#### **Implementation**

```java
// Subject interface
interface Image {
    void display();
}

// Real Subject
class RealImage implements Image {
    private String filename;
    
    public RealImage(String filename) {
        this.filename = filename;
        loadFromDisk();
    }
    
    private void loadFromDisk() {
        System.out.println("Loading image: " + filename);
    }
    
    @Override
    public void display() {
        System.out.println("Displaying image: " + filename);
    }
}

// Proxy
class ProxyImage implements Image {
    private RealImage realImage;
    private String filename;
    
    public ProxyImage(String filename) {
        this.filename = filename;
    }
    
    @Override
    public void display() {
        if (realImage == null) {
            realImage = new RealImage(filename);
        }
        realImage.display();
    }
}

// Usage
public class ImageViewer {
    public static void main(String[] args) {
        Image image1 = new ProxyImage("photo1.jpg");
        Image image2 = new ProxyImage("photo2.jpg");
        
        // Image only loaded when displayed
        image1.display();  // Loads and displays
        image1.display();  // Only displays (already loaded)
        image2.display();  // Loads and displays
    }
}
```

#### **Real-World Example: Protection Proxy**

```java
// Subject
interface BankAccount {
    void withdraw(double amount);
    double getBalance();
}

// Real Subject
class RealBankAccount implements BankAccount {
    private double balance;
    
    public RealBankAccount(double initialBalance) {
        this.balance = initialBalance;
    }
    
    @Override
    public void withdraw(double amount) {
        if (balance >= amount) {
            balance -= amount;
            System.out.println("Withdrew: $" + amount + ", New balance: $" + balance);
        } else {
            System.out.println("Insufficient funds");
        }
    }
    
    @Override
    public double getBalance() {
        return balance;
    }
}

// Protection Proxy
class BankAccountProxy implements BankAccount {
    private RealBankAccount realAccount;
    private String userRole;
    
    public BankAccountProxy(double initialBalance, String userRole) {
        this.realAccount = new RealBankAccount(initialBalance);
        this.userRole = userRole;
    }
    
    @Override
    public void withdraw(double amount) {
        if (userRole.equals("ADMIN")) {
            realAccount.withdraw(amount);
        } else {
            System.out.println("Access denied: Only admin can withdraw");
        }
    }
    
    @Override
    public double getBalance() {
        if (userRole.equals("ADMIN") || userRole.equals("USER")) {
            return realAccount.getBalance();
        } else {
            System.out.println("Access denied");
            return 0;
        }
    }
}

// Virtual Proxy Example
class LazyDocumentLoader {
    private String filename;
    private String content;
    
    public LazyDocumentLoader(String filename) {
        this.filename = filename;
    }
    
    public String getContent() {
        if (content == null) {
            // Load only when needed
            content = loadFromDisk();
        }
        return content;
    }
    
    private String loadFromDisk() {
        System.out.println("Loading document: " + filename);
        return "Document content of " + filename;
    }
}

// Remote Proxy Example
interface WeatherService {
    String getWeather(String city);
}

class RemoteWeatherServiceProxy implements WeatherService {
    private HttpClient client;
    private String apiKey;
    private Map<String, String> cache = new HashMap<>();
    
    public RemoteWeatherServiceProxy(String apiKey) {
        this.client = HttpClient.newHttpClient();
        this.apiKey = apiKey;
    }
    
    @Override
    public String getWeather(String city) {
        // Check cache first
        if (cache.containsKey(city)) {
            System.out.println("Returning cached weather for " + city);
            return cache.get(city);
        }
        
        // Simulate remote call
        System.out.println("Calling remote weather API for " + city);
        String weather = callRemoteAPI(city);
        cache.put(city, weather);
        return weather;
    }
    
    private String callRemoteAPI(String city) {
        // Actual HTTP call would go here
        return "Sunny, 25°C";
    }
}
```

#### **Proxy Types**

| Type | Purpose |
|------|---------|
| **Virtual Proxy** | Lazy loading |
| **Protection Proxy** | Access control |
| **Remote Proxy** | Remote communication |
| **Smart Proxy** | Additional logic (logging, caching) |

#### **Pros & Cons**

| ✅ Advantages | ❌ Disadvantages |
|--------------|-----------------|
| Controlled access | Additional layer |
| Lazy loading | Performance overhead |
| Logging/monitoring | Complexity |
| Security | Can mask real object |

---

## **5. BEHAVIORAL PATTERNS**

### **5.1 Chain of Responsibility**

> **Purpose:** Avoid coupling the sender of a request to its receiver by giving more than one object a chance to handle the request. Chain the receiving objects and pass the request along the chain until an object handles it.

#### **When to Use**
- When multiple objects can handle a request
- When you don't want to specify handler explicitly
- When you want to dynamically set handlers

#### **Implementation**

```java
// Handler
abstract class Logger {
    public static int INFO = 1;
    public static int DEBUG = 2;
    public static int ERROR = 3;
    
    protected int level;
    protected Logger nextLogger;
    
    public void setNextLogger(Logger nextLogger) {
        this.nextLogger = nextLogger;
    }
    
    public void logMessage(int level, String message) {
        if (this.level <= level) {
            write(message);
        }
        if (nextLogger != null) {
            nextLogger.logMessage(level, message);
        }
    }
    
    protected abstract void write(String message);
}

// Concrete Handlers
class ConsoleLogger extends Logger {
    public ConsoleLogger(int level) {
        this.level = level;
    }
    
    @Override
    protected void write(String message) {
        System.out.println("Console::Logger: " + message);
    }
}

class FileLogger extends Logger {
    public FileLogger(int level) {
        this.level = level;
    }
    
    @Override
    protected void write(String message) {
        System.out.println("File::Logger: " + message);
    }
}

class ErrorLogger extends Logger {
    public ErrorLogger(int level) {
        this.level = level;
    }
    
    @Override
    protected void write(String message) {
        System.out.println("Error::Logger: " + message);
    }
}

// Usage
public class ChainPatternDemo {
    private static Logger getChainOfLoggers() {
        Logger errorLogger = new ErrorLogger(Logger.ERROR);
        Logger fileLogger = new FileLogger(Logger.DEBUG);
        Logger consoleLogger = new ConsoleLogger(Logger.INFO);
        
        errorLogger.setNextLogger(fileLogger);
        fileLogger.setNextLogger(consoleLogger);
        
        return errorLogger;
    }
    
    public static void main(String[] args) {
        Logger loggerChain = getChainOfLoggers();
        
        loggerChain.logMessage(Logger.INFO, "This is information");
        loggerChain.logMessage(Logger.DEBUG, "This is debug");
        loggerChain.logMessage(Logger.ERROR, "This is error");
    }
}
```

#### **Real-World Example: ATM Dispenser**

```java
// Handler
interface DispenseChain {
    void setNextChain(DispenseChain nextChain);
    void dispense(Currency currency);
}

class Currency {
    private int amount;
    
    public Currency(int amount) {
        this.amount = amount;
    }
    
    public int getAmount() {
        return amount;
    }
}

// Concrete Handlers
class Dollar50Dispenser implements DispenseChain {
    private DispenseChain chain;
    
    @Override
    public void setNextChain(DispenseChain nextChain) {
        this.chain = nextChain;
    }
    
    @Override
    public void dispense(Currency currency) {
        if (currency.getAmount() >= 50) {
            int num = currency.getAmount() / 50;
            int remainder = currency.getAmount() % 50;
            System.out.println("Dispensing " + num + " 50$ notes");
            if (remainder != 0) {
                this.chain.dispense(new Currency(remainder));
            }
        } else {
            this.chain.dispense(currency);
        }
    }
}

class Dollar20Dispenser implements DispenseChain {
    private DispenseChain chain;
    
    @Override
    public void setNextChain(DispenseChain nextChain) {
        this.chain = nextChain;
    }
    
    @Override
    public void dispense(Currency currency) {
        if (currency.getAmount() >= 20) {
            int num = currency.getAmount() / 20;
            int remainder = currency.getAmount() % 20;
            System.out.println("Dispensing " + num + " 20$ notes");
            if (remainder != 0) {
                this.chain.dispense(new Currency(remainder));
            }
        } else {
            this.chain.dispense(currency);
        }
    }
}

class Dollar10Dispenser implements DispenseChain {
    private DispenseChain chain;
    
    @Override
    public void setNextChain(DispenseChain nextChain) {
        this.chain = nextChain;
    }
    
    @Override
    public void dispense(Currency currency) {
        if (currency.getAmount() >= 10) {
            int num = currency.getAmount() / 10;
            int remainder = currency.getAmount() % 10;
            System.out.println("Dispensing " + num + " 10$ notes");
            if (remainder != 0) {
                this.chain.dispense(new Currency(remainder));
            }
        } else {
            this.chain.dispense(currency);
        }
    }
}

// Usage
public class ATMDispenser {
    private DispenseChain chain;
    
    public ATMDispenser() {
        // Create chain
        chain = new Dollar50Dispenser();
        DispenseChain c2 = new Dollar20Dispenser();
        DispenseChain c3 = new Dollar10Dispenser();
        
        // Set chain
        chain.setNextChain(c2);
        c2.setNextChain(c3);
    }
    
    public void dispense(int amount) {
        if (amount % 10 != 0) {
            System.out.println("Amount should be multiple of 10");
            return;
        }
        chain.dispense(new Currency(amount));
    }
    
    public static void main(String[] args) {
        ATMDispenser atm = new ATMDispenser();
        atm.dispense(130);
        atm.dispense(70);
        atm.dispense(25); // Invalid
    }
}
```

#### **Pros & Cons**

| ✅ Advantages | ❌ Disadvantages |
|--------------|-----------------|
| Decouples sender and receiver | No guarantee of handling |
| Dynamic chain management | Can be hard to debug |
| Open/Closed Principle | Chain may be ignored |
| Flexible responsibility assignment | Performance overhead |

---

### **5.2 Command**

> **Purpose:** Encapsulate a request as an object, thereby letting you parameterize clients with different requests, queue or log requests, and support undoable operations.

#### **When to Use**
- When you need to parameterize objects with actions
- When you need to queue or log requests
- When you need undo/redo functionality

#### **Implementation**

```java
// Command interface
interface Command {
    void execute();
    void undo();
}

// Receiver
class Light {
    private boolean isOn = false;
    
    public void turnOn() {
        isOn = true;
        System.out.println("Light is ON");
    }
    
    public void turnOff() {
        isOn = false;
        System.out.println("Light is OFF");
    }
    
    public boolean isOn() {
        return isOn;
    }
}

// Concrete Commands
class LightOnCommand implements Command {
    private Light light;
    
    public LightOnCommand(Light light) {
        this.light = light;
    }
    
    @Override
    public void execute() {
        light.turnOn();
    }
    
    @Override
    public void undo() {
        light.turnOff();
    }
}

class LightOffCommand implements Command {
    private Light light;
    
    public LightOffCommand(Light light) {
        this.light = light;
    }
    
    @Override
    public void execute() {
        light.turnOff();
    }
    
    @Override
    public void undo() {
        light.turnOn();
    }
}

// Invoker
class RemoteControl {
    private Command command;
    private Command lastCommand;
    
    public void setCommand(Command command) {
        this.command = command;
    }
    
    public void pressButton() {
        if (command != null) {
            command.execute();
            lastCommand = command;
        }
    }
    
    public void pressUndo() {
        if (lastCommand != null) {
            lastCommand.undo();
        }
    }
}
```

#### **Real-World Example: Text Editor with Undo**

```java
// Receiver
class TextDocument {
    private StringBuilder text = new StringBuilder();
    private List<String> history = new ArrayList<>();
    
    public void write(String words) {
        history.add(words);
        text.append(words);
    }
    
    public void delete(int length) {
        if (text.length() >= length) {
            String deleted = text.substring(text.length() - length);
            history.add("DELETE:" + deleted);
            text.setLength(text.length() - length);
        }
    }
    
    public String getText() {
        return text.toString();
    }
    
    public String getLastAction() {
        return history.isEmpty() ? null : history.get(history.size() - 1);
    }
    
    public void removeLastAction() {
        if (!history.isEmpty()) {
            history.remove(history.size() - 1);
        }
    }
}

// Command interface
interface TextCommand {
    void execute();
    void undo();
}

// Concrete Commands
class WriteCommand implements TextCommand {
    private TextDocument document;
    private String text;
    
    public WriteCommand(TextDocument document, String text) {
        this.document = document;
        this.text = text;
    }
    
    @Override
    public void execute() {
        document.write(text);
    }
    
    @Override
    public void undo() {
        document.delete(text.length());
    }
}

class DeleteCommand implements TextCommand {
    private TextDocument document;
    private int length;
    private String deletedText;
    
    public DeleteCommand(TextDocument document, int length) {
        this.document = document;
        this.length = length;
    }
    
    @Override
    public void execute() {
        String lastAction = document.getLastAction();
        if (lastAction != null && !lastAction.startsWith("DELETE:")) {
            deletedText = lastAction;
            document.delete(length);
        }
    }
    
    @Override
    public void undo() {
        if (deletedText != null) {
            document.write(deletedText);
            document.removeLastAction(); // Remove the delete from history
        }
    }
}

// Invoker
class TextEditor {
    private Stack<TextCommand> commandHistory = new Stack<>();
    private TextDocument document = new TextDocument();
    
    public void type(String text) {
        WriteCommand command = new WriteCommand(document, text);
        command.execute();
        commandHistory.push(command);
    }
    
    public void delete(int length) {
        DeleteCommand command = new DeleteCommand(document, length);
        command.execute();
        commandHistory.push(command);
    }
    
    public void undo() {
        if (!commandHistory.isEmpty()) {
            TextCommand command = commandHistory.pop();
            command.undo();
        }
    }
    
    public void showText() {
        System.out.println("Document: " + document.getText());
    }
}

// Usage
public class TextEditorDemo {
    public static void main(String[] args) {
        TextEditor editor = new TextEditor();
        
        editor.type("Hello ");
        editor.type("World");
        editor.showText();
        
        editor.delete(5);
        editor.showText();
        
        editor.undo();
        editor.showText();
        
        editor.undo();
        editor.showText();
    }
}
```

#### **Pros & Cons**

| ✅ Advantages | ❌ Disadvantages |
|--------------|-----------------|
| Decouples invoker from receiver | Many command classes |
| Supports undo/redo | Complexity |
| Command queuing | Additional layer |
| Composite commands | |

---

### **5.3 Interpreter**

> **Purpose:** Given a language, define a representation for its grammar along with an interpreter that uses the representation to interpret sentences in the language.

#### **When to Use**
- When you have a simple grammar to interpret
- When efficiency is not critical
- When you need to parse expressions

#### **Implementation**

```java
// Context
class Context {
    private Map<String, Integer> variables = new HashMap<>();
    
    public void setVariable(String name, int value) {
        variables.put(name, value);
    }
    
    public int getVariable(String name) {
        return variables.getOrDefault(name, 0);
    }
}

// Abstract Expression
interface Expression {
    int interpret(Context context);
}

// Terminal Expressions
class NumberExpression implements Expression {
    private int number;
    
    public NumberExpression(int number) {
        this.number = number;
    }
    
    @Override
    public int interpret(Context context) {
        return number;
    }
}

class VariableExpression implements Expression {
    private String name;
    
    public VariableExpression(String name) {
        this.name = name;
    }
    
    @Override
    public int interpret(Context context) {
        return context.getVariable(name);
    }
}

// Non-terminal Expressions
class AddExpression implements Expression {
    private Expression left;
    private Expression right;
    
    public AddExpression(Expression left, Expression right) {
        this.left = left;
        this.right = right;
    }
    
    @Override
    public int interpret(Context context) {
        return left.interpret(context) + right.interpret(context);
    }
}

class SubtractExpression implements Expression {
    private Expression left;
    private Expression right;
    
    public SubtractExpression(Expression left, Expression right) {
        this.left = left;
        this.right = right;
    }
    
    @Override
    public int interpret(Context context) {
        return left.interpret(context) - right.interpret(context);
    }
}

class MultiplyExpression implements Expression {
    private Expression left;
    private Expression right;
    
    public MultiplyExpression(Expression left, Expression right) {
        this.left = left;
        this.right = right;
    }
    
    @Override
    public int interpret(Context context) {
        return left.interpret(context) * right.interpret(context);
    }
}

// Parser
class ExpressionParser {
    public static Expression parse(String expression, Context context) {
        // Simple parser for expressions like "a + b * c"
        String[] tokens = expression.split(" ");
        return buildExpression(tokens, 0);
    }
    
    private static Expression buildExpression(String[] tokens, int index) {
        // Simplified parser logic
        return null;
    }
}

// Usage
public class InterpreterDemo {
    public static void main(String[] args) {
        Context context = new Context();
        context.setVariable("x", 10);
        context.setVariable("y", 5);
        
        // Build expression: (x + y) * 2
        Expression expression = new MultiplyExpression(
            new AddExpression(
                new VariableExpression("x"),
                new VariableExpression("y")
            ),
            new NumberExpression(2)
        );
        
        int result = expression.interpret(context);
        System.out.println("Result: " + result); // (10 + 5) * 2 = 30
    }
}
```

#### **Real-World Example: Boolean Expression Evaluator**

```java
// Boolean expression interpreter
interface BooleanExpression {
    boolean evaluate(Context context);
}

// Terminal expressions
class ConstantExpression implements BooleanExpression {
    private boolean value;
    
    public ConstantExpression(boolean value) {
        this.value = value;
    }
    
    @Override
    public boolean evaluate(Context context) {
        return value;
    }
}

class VariableExpression implements BooleanExpression {
    private String name;
    
    public VariableExpression(String name) {
        this.name = name;
    }
    
    @Override
    public boolean evaluate(Context context) {
        return context.getBoolean(name);
    }
}

// Non-terminal expressions
class AndExpression implements BooleanExpression {
    private BooleanExpression left;
    private BooleanExpression right;
    
    public AndExpression(BooleanExpression left, BooleanExpression right) {
        this.left = left;
        this.right = right;
    }
    
    @Override
    public boolean evaluate(Context context) {
        return left.evaluate(context) && right.evaluate(context);
    }
}

class OrExpression implements BooleanExpression {
    private BooleanExpression left;
    private BooleanExpression right;
    
    public OrExpression(BooleanExpression left, BooleanExpression right) {
        this.left = left;
        this.right = right;
    }
    
    @Override
    public boolean evaluate(Context context) {
        return left.evaluate(context) || right.evaluate(context);
    }
}

class NotExpression implements BooleanExpression {
    private BooleanExpression expr;
    
    public NotExpression(BooleanExpression expr) {
        this.expr = expr;
    }
    
    @Override
    public boolean evaluate(Context context) {
        return !expr.evaluate(context);
    }
}

// Context
class Context {
    private Map<String, Boolean> variables = new HashMap<>();
    
    public void setBoolean(String name, boolean value) {
        variables.put(name, value);
    }
    
    public boolean getBoolean(String name) {
        return variables.getOrDefault(name, false);
    }
}

// Usage in rule engine
public class RuleEngine {
    public static void main(String[] args) {
        Context context = new Context();
        context.setBoolean("isActive", true);
        context.setBoolean("hasPermission", true);
        context.setBoolean("isAdmin", false);
        
        // Rule: isActive AND (hasPermission OR isAdmin)
        BooleanExpression rule = new AndExpression(
            new VariableExpression("isActive"),
            new OrExpression(
                new VariableExpression("hasPermission"),
                new VariableExpression("isAdmin")
            )
        );
        
        boolean result = rule.evaluate(context);
        System.out.println("Access granted: " + result);
    }
}
```

#### **Pros & Cons**

| ✅ Advantages | ❌ Disadvantages |
|--------------|-----------------|
| Easy to change grammar | Complex grammar difficult |
| Good for simple languages | Performance overhead |
| Easy to extend | Many classes for complex grammars |

---

### **5.4 Iterator**

> **Purpose:** Provide a way to access the elements of an aggregate object sequentially without exposing its underlying representation.

#### **When to Use**
- When you need to access collection elements uniformly
- When you need multiple traversals
- When you want to hide collection structure

#### **Implementation**

```java
// Iterator interface
interface Iterator<T> {
    boolean hasNext();
    T next();
}

// Container interface
interface Container<T> {
    Iterator<T> createIterator();
}

// Concrete Aggregate
class NameRepository implements Container<String> {
    private String[] names = {"John", "Jane", "Bob", "Alice"};
    
    @Override
    public Iterator<String> createIterator() {
        return new NameIterator();
    }
    
    // Concrete Iterator
    private class NameIterator implements Iterator<String> {
        private int index;
        
        @Override
        public boolean hasNext() {
            return index < names.length;
        }
        
        @Override
        public String next() {
            if (hasNext()) {
                return names[index++];
            }
            return null;
        }
    }
}

// Usage
public class IteratorDemo {
    public static void main(String[] args) {
        NameRepository repository = new NameRepository();
        
        for (Iterator<String> it = repository.createIterator(); it.hasNext(); ) {
            String name = it.next();
            System.out.println("Name: " + name);
        }
    }
}
```

#### **Real-World Example: Custom Collection**

```java
// Generic Iterator
interface Iterator<T> {
    boolean hasNext();
    T next();
    void reset();
}

// Concrete Iterator for array
class ArrayIterator<T> implements Iterator<T> {
    private T[] array;
    private int position = 0;
    
    public ArrayIterator(T[] array) {
        this.array = array;
    }
    
    @Override
    public boolean hasNext() {
        return position < array.length;
    }
    
    @Override
    public T next() {
        if (!hasNext()) {
            throw new NoSuchElementException();
        }
        return array[position++];
    }
    
    @Override
    public void reset() {
        position = 0;
    }
}

// Concrete Iterator for list
class ListIterator<T> implements Iterator<T> {
    private List<T> list;
    private int position = 0;
    
    public ListIterator(List<T> list) {
        this.list = list;
    }
    
    @Override
    public boolean hasNext() {
        return position < list.size();
    }
    
    @Override
    public T next() {
        if (!hasNext()) {
            throw new NoSuchElementException();
        }
        return list.get(position++);
    }
    
    @Override
    public void reset() {
        position = 0;
    }
}

// Tree node
class TreeNode<T> {
    T value;
    TreeNode<T> left;
    TreeNode<T> right;
    
    public TreeNode(T value) {
        this.value = value;
    }
}

// In-order tree iterator
class TreeIterator<T> implements Iterator<T> {
    private Stack<TreeNode<T>> stack = new Stack<>();
    
    public TreeIterator(TreeNode<T> root) {
        pushLeft(root);
    }
    
    private void pushLeft(TreeNode<T> node) {
        while (node != null) {
            stack.push(node);
            node = node.left;
        }
    }
    
    @Override
    public boolean hasNext() {
        return !stack.isEmpty();
    }
    
    @Override
    public T next() {
        if (!hasNext()) {
            throw new NoSuchElementException();
        }
        TreeNode<T> node = stack.pop();
        pushLeft(node.right);
        return node.value;
    }
    
    @Override
    public void reset() {
        // Not implemented for simplicity
    }
}

// Usage
public class IteratorPatternDemo {
    public static void main(String[] args) {
        // Array
        String[] arr = {"A", "B", "C"};
        Iterator<String> arrayIt = new ArrayIterator<>(arr);
        while (arrayIt.hasNext()) {
            System.out.println(arrayIt.next());
        }
        
        // Tree
        TreeNode<Integer> root = new TreeNode<>(5);
        root.left = new TreeNode<>(3);
        root.right = new TreeNode<>(8);
        root.left.left = new TreeNode<>(1);
        root.left.right = new TreeNode<>(4);
        
        Iterator<Integer> treeIt = new TreeIterator<>(root);
        while (treeIt.hasNext()) {
            System.out.println(treeIt.next());
        }
    }
}
```

#### **Pros & Cons**

| ✅ Advantages | ❌ Disadvantages |
|--------------|-----------------|
| Encapsulates traversal | Overkill for simple collections |
| Multiple traversal types | Extra object creation |
| Uniform interface | Can't modify during iteration |
| Supports variations | |

---

### **5.5 Mediator**

> **Purpose:** Define an object that encapsulates how a set of objects interact. Mediator promotes loose coupling by keeping objects from referring to each other explicitly.

#### **When to Use**
- When objects communicate in complex ways
- When you want to reuse objects independently
- When interactions vary but objects remain stable

#### **Implementation**

```java
// Mediator interface
interface ChatMediator {
    void sendMessage(String message, User user);
    void addUser(User user);
}

// Concrete Mediator
class ChatRoom implements ChatMediator {
    private List<User> users = new ArrayList<>();
    
    @Override
    public void addUser(User user) {
        users.add(user);
    }
    
    @Override
    public void sendMessage(String message, User user) {
        for (User u : users) {
            // Don't send to self
            if (u != user) {
                u.receive(message);
            }
        }
    }
}

// Colleague
abstract class User {
    protected ChatMediator mediator;
    protected String name;
    
    public User(ChatMediator mediator, String name) {
        this.mediator = mediator;
        this.name = name;
    }
    
    public abstract void send(String message);
    public abstract void receive(String message);
}

// Concrete Colleague
class ChatUser extends User {
    public ChatUser(ChatMediator mediator, String name) {
        super(mediator, name);
    }
    
    @Override
    public void send(String message) {
        System.out.println(name + " sends: " + message);
        mediator.sendMessage(message, this);
    }
    
    @Override
    public void receive(String message) {
        System.out.println(name + " receives: " + message);
    }
}
```

#### **Real-World Example: Air Traffic Control**

```java
// Mediator
interface AirTrafficControl {
    void registerAircraft(Aircraft aircraft);
    void sendWarning(Aircraft sender, String message);
    void requestLanding(Aircraft aircraft);
    void requestTakeoff(Aircraft aircraft);
}

// Concrete Mediator
class ControlTower implements AirTrafficControl {
    private List<Aircraft> aircrafts = new ArrayList<>();
    private List<String> availableRunways = new ArrayList<>();
    private Map<Aircraft, String> runwayAssignments = new HashMap<>();
    
    public ControlTower() {
        availableRunways.add("RWY-27L");
        availableRunways.add("RWY-27R");
        availableRunways.add("RWY-09L");
    }
    
    @Override
    public void registerAircraft(Aircraft aircraft) {
        aircrafts.add(aircraft);
        System.out.println(aircraft.getCallSign() + " registered with tower");
    }
    
    @Override
    public void sendWarning(Aircraft sender, String message) {
        for (Aircraft aircraft : aircrafts) {
            if (aircraft != sender) {
                aircraft.receiveWarning(sender.getCallSign() + ": " + message);
            }
        }
    }
    
    @Override
    public void requestLanding(Aircraft aircraft) {
        if (!availableRunways.isEmpty()) {
            String runway = availableRunways.remove(0);
            runwayAssignments.put(aircraft, runway);
            System.out.println(aircraft.getCallSign() + " cleared to land on " + runway);
        } else {
            System.out.println(aircraft.getCallSign() + " hold pattern - no available runways");
        }
    }
    
    @Override
    public void requestTakeoff(Aircraft aircraft) {
        String runway = runwayAssignments.remove(aircraft);
        if (runway != null) {
            availableRunways.add(runway);
            System.out.println(aircraft.getCallSign() + " cleared for takeoff from " + runway);
        }
    }
}

// Colleague
abstract class Aircraft {
    protected AirTrafficControl tower;
    protected String callSign;
    
    public Aircraft(AirTrafficControl tower, String callSign) {
        this.tower = tower;
        this.callSign = callSign;
        tower.registerAircraft(this);
    }
    
    public String getCallSign() {
        return callSign;
    }
    
    public abstract void sendWarning(String message);
    public abstract void receiveWarning(String message);
    public abstract void land();
    public abstract void takeoff();
}

// Concrete Colleague
class CommercialAircraft extends Aircraft {
    private int altitude;
    
    public CommercialAircraft(AirTrafficControl tower, String callSign, int altitude) {
        super(tower, callSign);
        this.altitude = altitude;
    }
    
    @Override
    public void sendWarning(String message) {
        tower.sendWarning(this, message);
    }
    
    @Override
    public void receiveWarning(String message) {
        System.out.println(callSign + " received warning: " + message);
    }
    
    @Override
    public void land() {
        tower.requestLanding(this);
    }
    
    @Override
    public void takeoff() {
        tower.requestTakeoff(this);
    }
}

// Usage
public class AirTrafficDemo {
    public static void main(String[] args) {
        ControlTower tower = new ControlTower();
        
        Aircraft flight1 = new CommercialAircraft(tower, "BA123", 35000);
        Aircraft flight2 = new CommercialAircraft(tower, "AA456", 30000);
        Aircraft flight3 = new CommercialAircraft(tower, "DL789", 32000);
        
        flight1.sendWarning("Turbulence ahead");
        flight2.land();
        flight3.land();
        flight2.takeoff();
    }
}
```

#### **Pros & Cons**

| ✅ Advantages | ❌ Disadvantages |
|--------------|-----------------|
| Decouples components | Mediator can become complex |
| Centralized control | Single point of failure |
| Easier to maintain | May become god object |
| Reduces subclassing | |

---

### **5.6 Memento**

> **Purpose:** Without violating encapsulation, capture and externalize an object's internal state so that the object can be restored to this state later.

#### **When to Use**
- When you need to implement undo/redo
- When you need to save/restore state without exposing internals
- When state capture shouldn't violate encapsulation

#### **Implementation**

```java
// Originator
class TextEditor {
    private StringBuilder content = new StringBuilder();
    private int cursorPosition = 0;
    
    public void write(String text) {
        content.append(text);
        cursorPosition = content.length();
    }
    
    public void delete() {
        if (content.length() > 0) {
            content.deleteCharAt(content.length() - 1);
            cursorPosition = content.length();
        }
    }
    
    public Memento save() {
        return new Memento(content.toString(), cursorPosition);
    }
    
    public void restore(Memento memento) {
        content = new StringBuilder(memento.getContent());
        cursorPosition = memento.getCursorPosition();
    }
    
    @Override
    public String toString() {
        return "Content: '" + content + "', Cursor: " + cursorPosition;
    }
    
    // Memento (nested class to access private fields)
    static class Memento {
        private final String content;
        private final int cursorPosition;
        
        private Memento(String content, int cursorPosition) {
            this.content = content;
            this.cursorPosition = cursorPosition;
        }
        
        private String getContent() {
            return content;
        }
        
        private int getCursorPosition() {
            return cursorPosition;
        }
    }
}

// Caretaker
class History {
    private Stack<TextEditor.Memento> undoStack = new Stack<>();
    private Stack<TextEditor.Memento> redoStack = new Stack<>();
    
    public void saveState(TextEditor editor) {
        undoStack.push(editor.save());
        redoStack.clear();
    }
    
    public void undo(TextEditor editor) {
        if (!undoStack.isEmpty()) {
            redoStack.push(editor.save());
            editor.restore(undoStack.pop());
        }
    }
    
    public void redo(TextEditor editor) {
        if (!redoStack.isEmpty()) {
            undoStack.push(editor.save());
            editor.restore(redoStack.pop());
        }
    }
}
```

#### **Real-World Example: Game Save System**

```java
// Originator
class GameCharacter {
    private String name;
    private int health;
    private int mana;
    private int level;
    private int experience;
    private List<String> inventory;
    
    public GameCharacter(String name) {
        this.name = name;
        this.health = 100;
        this.mana = 50;
        this.level = 1;
        this.experience = 0;
        this.inventory = new ArrayList<>();
    }
    
    public void fight(Monster monster) {
        System.out.println(name + " fights " + monster.getName());
        health -= monster.getDamage();
        experience += 50;
        
        if (experience >= 100) {
            level++;
            experience -= 100;
            health += 20;
            mana += 10;
            System.out.println(name + " leveled up to " + level + "!");
        }
    }
    
    public void addItem(String item) {
        inventory.add(item);
    }
    
    // Save state
    public CharacterMemento save() {
        return new CharacterMemento(name, health, mana, level, experience, 
                                    new ArrayList<>(inventory));
    }
    
    // Restore state
    public void restore(CharacterMemento memento) {
        this.name = memento.getName();
        this.health = memento.getHealth();
        this.mana = memento.getMana();
        this.level = memento.getLevel();
        this.experience = memento.getExperience();
        this.inventory = new ArrayList<>(memento.getInventory());
    }
    
    @Override
    public String toString() {
        return String.format("%s: HP=%d, MP=%d, Level=%d, XP=%d, Items=%s",
            name, health, mana, level, experience, inventory);
    }
    
    // Memento
    static class CharacterMemento {
        private final String name;
        private final int health;
        private final int mana;
        private final int level;
        private final int experience;
        private final List<String> inventory;
        
        public CharacterMemento(String name, int health, int mana, int level, 
                                int experience, List<String> inventory) {
            this.name = name;
            this.health = health;
            this.mana = mana;
            this.level = level;
            this.experience = experience;
            this.inventory = inventory;
        }
        
        // Getters for originator to restore state
        public String getName() { return name; }
        public int getHealth() { return health; }
        public int getMana() { return mana; }
        public int getLevel() { return level; }
        public int getExperience() { return experience; }
        public List<String> getInventory() { return inventory; }
    }
}

// Caretaker
class SaveManager {
    private Map<String, GameCharacter.CharacterMemento> saves = new HashMap<>();
    
    public void saveGame(String slot, GameCharacter character) {
        saves.put(slot, character.save());
        System.out.println("Game saved to slot: " + slot);
    }
    
    public void loadGame(String slot, GameCharacter character) {
        GameCharacter.CharacterMemento memento = saves.get(slot);
        if (memento != null) {
            character.restore(memento);
            System.out.println("Game loaded from slot: " + slot);
        } else {
            System.out.println("No save found in slot: " + slot);
        }
    }
    
    public void listSaves() {
        System.out.println("Available saves: " + saves.keySet());
    }
}

// Usage
public class GameDemo {
    public static void main(String[] args) {
        GameCharacter hero = new GameCharacter("Hero");
        SaveManager saveManager = new SaveManager();
        
        System.out.println("Initial: " + hero);
        hero.fight(new Monster("Goblin"));
        hero.fight(new Monster("Orc"));
        hero.addItem("Sword");
        System.out.println("After fighting: " + hero);
        
        saveManager.saveGame("slot1", hero);
        
        hero.fight(new Monster("Dragon"));
        hero.addItem("Shield");
        System.out.println("After more fighting: " + hero);
        
        saveManager.loadGame("slot1", hero);
        System.out.println("After loading: " + hero);
    }
}
```

#### **Pros & Cons**

| ✅ Advantages | ❌ Disadvantages |
|--------------|-----------------|
| Preserves encapsulation | Can be memory intensive |
| Simplifies originator | Caretaker management overhead |
| Easy undo/redo | Memento might be large |
| State restoration | |

---

### **5.7 Observer**

> **Purpose:** Define a one-to-many dependency between objects so that when one object changes state, all its dependents are notified and updated automatically.

#### **When to Use**
- When state changes need to be propagated
- When you have multiple dependent objects
- When you want loose coupling between subjects and observers

#### **Implementation**

```java
// Observer interface
interface Observer {
    void update(String message);
}

// Subject
class Subject {
    private List<Observer> observers = new ArrayList<>();
    private String state;
    
    public void attach(Observer observer) {
        observers.add(observer);
    }
    
    public void detach(Observer observer) {
        observers.remove(observer);
    }
    
    public void notifyObservers() {
        for (Observer observer : observers) {
            observer.update(state);
        }
    }
    
    public void setState(String state) {
        this.state = state;
        notifyObservers();
    }
}

// Concrete Observers
class ConcreteObserverA implements Observer {
    private String name;
    
    public ConcreteObserverA(String name) {
        this.name = name;
    }
    
    @Override
    public void update(String message) {
        System.out.println(name + " received: " + message);
    }
}

class ConcreteObserverB implements Observer {
    private String name;
    
    public ConcreteObserverB(String name) {
        this.name = name;
    }
    
    @Override
    public void update(String message) {
        System.out.println(name + " received: " + message.toUpperCase());
    }
}
```

#### **Real-World Example: Stock Market**

```java
// Observer
interface StockObserver {
    void update(String stockSymbol, double price);
}

// Subject
class StockMarket {
    private Map<String, Double> stocks = new HashMap<>();
    private List<StockObserver> observers = new ArrayList<>();
    
    public void registerObserver(StockObserver observer) {
        observers.add(observer);
    }
    
    public void unregisterObserver(StockObserver observer) {
        observers.remove(observer);
    }
    
    private void notifyObservers(String symbol, double price) {
        for (StockObserver observer : observers) {
            observer.update(symbol, price);
        }
    }
    
    public void setStockPrice(String symbol, double price) {
        stocks.put(symbol, price);
        notifyObservers(symbol, price);
    }
    
    public double getStockPrice(String symbol) {
        return stocks.getOrDefault(symbol, 0.0);
    }
}

// Concrete Observers
class MobileApp implements StockObserver {
    private String appName;
    
    public MobileApp(String appName) {
        this.appName = appName;
    }
    
    @Override
    public void update(String stockSymbol, double price) {
        System.out.println(appName + " notification: " + stockSymbol + " is now $" + price);
    }
}

class EmailNotifier implements StockObserver {
    private String email;
    
    public EmailNotifier(String email) {
        this.email = email;
    }
    
    @Override
    public void update(String stockSymbol, double price) {
        System.out.println("Sending email to " + email + ": " + stockSymbol + " price changed to $" + price);
    }
}

class TradingBot implements StockObserver {
    private double threshold;
    
    public TradingBot(double threshold) {
        this.threshold = threshold;
    }
    
    @Override
    public void update(String stockSymbol, double price) {
        if (price > threshold) {
            System.out.println("Bot selling " + stockSymbol + " at $" + price);
        } else if (price < threshold) {
            System.out.println("Bot buying " + stockSymbol + " at $" + price);
        }
    }
}

// Usage
public class StockMarketDemo {
    public static void main(String[] args) {
        StockMarket market = new StockMarket();
        
        // Create observers
        MobileApp app = new MobileApp("StockTracker");
        EmailNotifier email = new EmailNotifier("trader@example.com");
        TradingBot bot = new TradingBot(150.0);
        
        // Register observers
        market.registerObserver(app);
        market.registerObserver(email);
        market.registerObserver(bot);
        
        // Price changes
        market.setStockPrice("AAPL", 145.50);
        market.setStockPrice("AAPL", 152.75);
        market.setStockPrice("GOOGL", 2800.00);
        
        // Unregister email
        market.unregisterObserver(email);
        market.setStockPrice("AAPL", 148.25);
    }
}
```

#### **Java Built-in Support**

```java
// Using java.util.Observable (legacy)
class WeatherData extends Observable {
    private float temperature;
    private float humidity;
    
    public void setMeasurements(float temperature, float humidity) {
        this.temperature = temperature;
        this.humidity = humidity;
        setChanged();
        notifyObservers();
    }
    
    public float getTemperature() { return temperature; }
    public float getHumidity() { return humidity; }
}

class Display implements Observer {
    private String name;
    
    public Display(String name) {
        this.name = name;
    }
    
    @Override
    public void update(Observable o, Object arg) {
        if (o instanceof WeatherData) {
            WeatherData wd = (WeatherData) o;
            System.out.println(name + " - Temp: " + wd.getTemperature() + 
                              ", Humidity: " + wd.getHumidity());
        }
    }
}
```

#### **Event Listener Pattern**

```java
// Event classes
class PropertyChangeEvent {
    private String propertyName;
    private Object oldValue;
    private Object newValue;
    
    // constructor, getters
}

interface PropertyChangeListener {
    void propertyChanged(PropertyChangeEvent event);
}

class ObservableProperty {
    private List<PropertyChangeListener> listeners = new ArrayList<>();
    private Object value;
    private String name;
    
    public ObservableProperty(String name, Object initialValue) {
        this.name = name;
        this.value = initialValue;
    }
    
    public void addListener(PropertyChangeListener listener) {
        listeners.add(listener);
    }
    
    public void setValue(Object newValue) {
        if (!value.equals(newValue)) {
            Object oldValue = value;
            value = newValue;
            fireEvent(new PropertyChangeEvent(name, oldValue, newValue));
        }
    }
    
    private void fireEvent(PropertyChangeEvent event) {
        for (PropertyChangeListener listener : listeners) {
            listener.propertyChanged(event);
        }
    }
}
```

#### **Pros & Cons**

| ✅ Advantages | ❌ Disadvantages |
|--------------|-----------------|
| Loose coupling | Unexpected updates |
| Broadcast communication | Memory leaks if not unregistered |
| Dynamic relationships | Ordering issues |
| Open/Closed Principle | Complex chains |

---

### **5.8 State**

> **Purpose:** Allow an object to alter its behavior when its internal state changes. The object will appear to change its class.

#### **When to Use**
- When behavior depends on state
- When state changes frequently
- When state-specific behavior belongs in separate classes

#### **Implementation**

```java
// State interface
interface State {
    void doAction(Context context);
}

// Concrete States
class StartState implements State {
    @Override
    public void doAction(Context context) {
        System.out.println("System is in start state");
        context.setState(this);
    }
    
    @Override
    public String toString() {
        return "Start State";
    }
}

class StopState implements State {
    @Override
    public void doAction(Context context) {
        System.out.println("System is in stop state");
        context.setState(this);
    }
    
    @Override
    public String toString() {
        return "Stop State";
    }
}

// Context
class Context {
    private State state;
    
    public Context() {
        state = null;
    }
    
    public void setState(State state) {
        this.state = state;
    }
    
    public State getState() {
        return state;
    }
}
```

#### **Real-World Example: Document Workflow**

```java
// State interface
interface DocumentState {
    void publish(Document doc);
    void review(Document doc);
    void reject(Document doc);
    void archive(Document doc);
    String getStatus();
}

// Context
class Document {
    private DocumentState state;
    private String title;
    private String content;
    
    public Document(String title) {
        this.title = title;
        this.state = new DraftState(); // Initial state
    }
    
    public void setState(DocumentState state) {
        this.state = state;
        System.out.println("Document moved to: " + state.getStatus());
    }
    
    public void publish() { state.publish(this); }
    public void review() { state.review(this); }
    public void reject() { state.reject(this); }
    public void archive() { state.archive(this); }
    
    public String getStatus() { return state.getStatus(); }
}

// Concrete States
class DraftState implements DocumentState {
    @Override
    public void publish(Document doc) {
        System.out.println("Cannot publish directly from draft");
    }
    
    @Override
    public void review(Document doc) {
        System.out.println("Document submitted for review");
        doc.setState(new ReviewState());
    }
    
    @Override
    public void reject(Document doc) {
        System.out.println("Cannot reject draft");
    }
    
    @Override
    public void archive(Document doc) {
        System.out.println("Document archived");
        doc.setState(new ArchivedState());
    }
    
    @Override
    public String getStatus() { return "DRAFT"; }
}

class ReviewState implements DocumentState {
    @Override
    public void publish(Document doc) {
        System.out.println("Document approved and published");
        doc.setState(new PublishedState());
    }
    
    @Override
    public void review(Document doc) {
        System.out.println("Document already in review");
    }
    
    @Override
    public void reject(Document doc) {
        System.out.println("Document rejected, returning to draft");
        doc.setState(new DraftState());
    }
    
    @Override
    public void archive(Document doc) {
        System.out.println("Cannot archive while in review");
    }
    
    @Override
    public String getStatus() { return "IN_REVIEW"; }
}

class PublishedState implements DocumentState {
    @Override
    public void publish(Document doc) {
        System.out.println("Document already published");
    }
    
    @Override
    public void review(Document doc) {
        System.out.println("Document is published, cannot review");
    }
    
    @Override
    public void reject(Document doc) {
        System.out.println("Cannot reject published document");
    }
    
    @Override
    public void archive(Document doc) {
        System.out.println("Document archived after publication");
        doc.setState(new ArchivedState());
    }
    
    @Override
    public String getStatus() { return "PUBLISHED"; }
}

class ArchivedState implements DocumentState {
    @Override
    public void publish(Document doc) {
        System.out.println("Cannot publish archived document");
    }
    
    @Override
    public void review(Document doc) {
        System.out.println("Cannot review archived document");
    }
    
    @Override
    public void reject(Document doc) {
        System.out.println("Cannot reject archived document");
    }
    
    @Override
    public void archive(Document doc) {
        System.out.println("Document already archived");
    }
    
    @Override
    public String getStatus() { return "ARCHIVED"; }
}

// Usage
public class DocumentWorkflow {
    public static void main(String[] args) {
        Document doc = new Document("Design Patterns");
        
        System.out.println("Current status: " + doc.getStatus());
        
        doc.review();
        doc.publish();
        doc.review(); // Try to review after publish
        doc.archive();
        doc.review(); // Try to review after archive
    }
}
```

#### **State vs Strategy**

| State | Strategy |
|-------|----------|
| State changes dynamically | Strategy selected by client |
| Behavior changes with state | Behavior fixed once chosen |
| Context knows state | Context doesn't know strategy |
| Multiple states per object | One strategy per object |

#### **Pros & Cons**

| ✅ Advantages | ❌ Disadvantages |
|--------------|-----------------|
| Localizes state-specific behavior | More classes |
| Easy to add new states | State transitions can be complex |
| Eliminates conditionals | Context may have many states |
| Clear state transitions | Can be overkill |

---

### **5.9 Strategy**

> **Purpose:** Define a family of algorithms, encapsulate each one, and make them interchangeable. Strategy lets the algorithm vary independently from clients that use it.

#### **When to Use**
- When you have multiple algorithms for a specific task
- When you want to avoid conditionals
- When algorithms should be interchangeable

#### **Implementation**

```java
// Strategy interface
interface PaymentStrategy {
    void pay(double amount);
}

// Concrete Strategies
class CreditCardPayment implements PaymentStrategy {
    private String cardNumber;
    private String name;
    
    public CreditCardPayment(String cardNumber, String name) {
        this.cardNumber = cardNumber;
        this.name = name;
    }
    
    @Override
    public void pay(double amount) {
        System.out.println(amount + " paid with credit card ending in " + 
                          cardNumber.substring(cardNumber.length() - 4));
    }
}

class PayPalPayment implements PaymentStrategy {
    private String email;
    
    public PayPalPayment(String email) {
        this.email = email;
    }
    
    @Override
    public void pay(double amount) {
        System.out.println(amount + " paid using PayPal account " + email);
    }
}

class CryptoPayment implements PaymentStrategy {
    private String walletAddress;
    
    public CryptoPayment(String walletAddress) {
        this.walletAddress = walletAddress;
    }
    
    @Override
    public void pay(double amount) {
        System.out.println(amount + " paid in crypto to wallet " + walletAddress);
    }
}

// Context
class ShoppingCart {
    private List<Item> items = new ArrayList<>();
    private PaymentStrategy paymentStrategy;
    
    public void addItem(Item item) {
        items.add(item);
    }
    
    public void setPaymentStrategy(PaymentStrategy strategy) {
        this.paymentStrategy = strategy;
    }
    
    public double calculateTotal() {
        return items.stream().mapToDouble(Item::getPrice).sum();
    }
    
    public void checkout() {
        double amount = calculateTotal();
        paymentStrategy.pay(amount);
    }
}
```

#### **Real-World Example: Compression Strategies**

```java
// Strategy
interface CompressionStrategy {
    void compress(String inputFile, String outputFile);
}

// Concrete Strategies
class ZipCompression implements CompressionStrategy {
    @Override
    public void compress(String inputFile, String outputFile) {
        System.out.println("Compressing " + inputFile + " to " + outputFile + " using ZIP");
        // ZIP compression logic
    }
}

class GzipCompression implements CompressionStrategy {
    @Override
    public void compress(String inputFile, String outputFile) {
        System.out.println("Compressing " + inputFile + " to " + outputFile + " using GZIP");
        // GZIP compression logic
    }
}

class SevenZipCompression implements CompressionStrategy {
    @Override
    public void compress(String inputFile, String outputFile) {
        System.out.println("Compressing " + inputFile + " to " + outputFile + " using 7-Zip");
        // 7-Zip compression logic
    }
}

// Context
class FileCompressor {
    private CompressionStrategy strategy;
    
    public void setStrategy(CompressionStrategy strategy) {
        this.strategy = strategy;
    }
    
    public void compressFile(String inputFile, String outputFile) {
        strategy.compress(inputFile, outputFile);
    }
}

// Usage with factory
class CompressionFactory {
    public static CompressionStrategy getStrategy(String type) {
        switch (type.toLowerCase()) {
            case "zip": return new ZipCompression();
            case "gzip": return new GzipCompression();
            case "7z": return new SevenZipCompression();
            default: throw new IllegalArgumentException("Unknown compression type");
        }
    }
}

// Sorting strategies example
interface SortingStrategy {
    <T extends Comparable<T>> void sort(List<T> list);
}

class BubbleSort implements SortingStrategy {
    @Override
    public <T extends Comparable<T>> void sort(List<T> list) {
        System.out.println("Using bubble sort");
        for (int i = 0; i < list.size() - 1; i++) {
            for (int j = 0; j < list.size() - i - 1; j++) {
                if (list.get(j).compareTo(list.get(j + 1)) > 0) {
                    Collections.swap(list, j, j + 1);
                }
            }
        }
    }
}

class QuickSort implements SortingStrategy {
    @Override
    public <T extends Comparable<T>> void sort(List<T> list) {
        System.out.println("Using quicksort");
        quickSort(list, 0, list.size() - 1);
    }
    
    private <T extends Comparable<T>> void quickSort(List<T> list, int low, int high) {
        if (low < high) {
            int pi = partition(list, low, high);
            quickSort(list, low, pi - 1);
            quickSort(list, pi + 1, high);
        }
    }
    
    private <T extends Comparable<T>> int partition(List<T> list, int low, int high) {
        T pivot = list.get(high);
        int i = low - 1;
        for (int j = low; j < high; j++) {
            if (list.get(j).compareTo(pivot) < 0) {
                i++;
                Collections.swap(list, i, j);
            }
        }
        Collections.swap(list, i + 1, high);
        return i + 1;
    }
}

// Validation strategies
interface ValidationStrategy {
    boolean validate(String input);
}

class EmailValidation implements ValidationStrategy {
    private static final String EMAIL_PATTERN = 
        "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
    
    @Override
    public boolean validate(String input) {
        return input != null && input.matches(EMAIL_PATTERN);
    }
}

class PhoneValidation implements ValidationStrategy {
    private static final String PHONE_PATTERN = "^\\d{10}$";
    
    @Override
    public boolean validate(String input) {
        return input != null && input.matches(PHONE_PATTERN);
    }
}
```

#### **Pros & Cons**

| ✅ Advantages | ❌ Disadvantages |
|--------------|-----------------|
| Encapsulates algorithms | Client must know strategies |
| Open/Closed Principle | More classes |
| Eliminates conditionals | Strategy communication overhead |
| Strategy can be changed | |

---

### **5.10 Template Method**

> **Purpose:** Define the skeleton of an algorithm in an operation, deferring some steps to subclasses. Template Method lets subclasses redefine certain steps without changing the algorithm's structure.

#### **When to Use**
- When you have invariant algorithm parts
- When common behavior should be in a base class
- When you want to control subclass extensions

#### **Implementation**

```java
// Abstract class with template method
abstract class DataProcessor {
    // Template method - defines algorithm skeleton
    public final void process() {
        loadData();
        processData();
        saveData();
        if (customerWantsReport()) {
            generateReport();
        }
    }
    
    // Common implementation
    private void loadData() {
        System.out.println("Loading data...");
    }
    
    private void saveData() {
        System.out.println("Saving processed data...");
    }
    
    // Steps to be implemented by subclasses
    protected abstract void processData();
    
    // Hook method - can be overridden
    protected boolean customerWantsReport() {
        return true;
    }
    
    protected void generateReport() {
        System.out.println("Generating default report");
    }
}

// Concrete classes
class CSVDataProcessor extends DataProcessor {
    @Override
    protected void processData() {
        System.out.println("Processing CSV data");
    }
}

class XMLDataProcessor extends DataProcessor {
    @Override
    protected void processData() {
        System.out.println("Processing XML data");
    }
    
    @Override
    protected boolean customerWantsReport() {
        return false; // No report for XML
    }
}
```

#### **Real-World Example: Build Process**

```java
// Abstract builder
abstract class ProjectBuilder {
    // Template method
    public final void build() {
        if (checkDependencies()) {
            compile();
            runTests();
            if (testsPassed()) {
                package();
                if (shouldDeploy()) {
                    deploy();
                }
            }
        }
    }
    
    // Common methods
    protected boolean checkDependencies() {
        System.out.println("Checking dependencies...");
        return true;
    }
    
    protected boolean testsPassed() {
        System.out.println("All tests passed");
        return true;
    }
    
    // Abstract methods
    protected abstract void compile();
    protected abstract void runTests();
    protected abstract void package();
    
    // Hook methods
    protected boolean shouldDeploy() {
        return true;
    }
    
    protected void deploy() {
        System.out.println("Deploying application...");
    }
}

// Concrete builders
class JavaProjectBuilder extends ProjectBuilder {
    @Override
    protected void compile() {
        System.out.println("Compiling Java source code with javac");
    }
    
    @Override
    protected void runTests() {
        System.out.println("Running JUnit tests");
    }
    
    @Override
    protected void package() {
        System.out.println("Creating JAR file");
    }
    
    @Override
    protected boolean shouldDeploy() {
        return false; // Don't auto-deploy Java projects
    }
}

class WebProjectBuilder extends ProjectBuilder {
    @Override
    protected void compile() {
        System.out.println("Compiling TypeScript to JavaScript");
        System.out.println("Bundling assets with webpack");
    }
    
    @Override
    protected void runTests() {
        System.out.println("Running Jest tests");
    }
    
    @Override
    protected void package() {
        System.out.println("Creating production build");
    }
    
    @Override
    protected void deploy() {
        System.out.println("Deploying to AWS S3");
    }
}

// Game development example
abstract class Game {
    // Template method
    public final void play() {
        initialize();
        startGame();
        playRound();
        if (isGameOver()) {
            endGame();
            showResults();
        } else {
            nextRound();
        }
    }
    
    protected abstract void initialize();
    protected abstract void startGame();
    protected abstract void playRound();
    protected abstract boolean isGameOver();
    protected abstract void nextRound();
    
    protected void endGame() {
        System.out.println("Game over");
    }
    
    protected void showResults() {
        System.out.println("Showing results");
    }
}

class Chess extends Game {
    @Override
    protected void initialize() {
        System.out.println("Setting up chess board");
    }
    
    @Override
    protected void startGame() {
        System.out.println("White starts");
    }
    
    @Override
    protected void playRound() {
        System.out.println("Players make moves");
    }
    
    @Override
    protected boolean isGameOver() {
        return Math.random() > 0.7; // Simulate random end
    }
    
    @Override
    protected void nextRound() {
        System.out.println("Next turn");
    }
}
```

#### **Template Method vs Strategy**

| Template Method | Strategy |
|-----------------|----------|
| Inheritance-based | Composition-based |
| Algorithm skeleton in base class | Complete algorithm encapsulated |
| Steps can be overridden | Whole algorithm replaced |
| Fixed algorithm structure | Algorithms interchangeable |

#### **Pros & Cons**

| ✅ Advantages | ❌ Disadvantages |
|--------------|-----------------|
| Code reuse | Limited by inheritance |
| Framework control | Hard to change structure |
| Consistent algorithm | Can violate LSP |
| Hook methods for flexibility | |

---

### **5.11 Visitor**

> **Purpose:** Represent an operation to be performed on elements of an object structure. Visitor lets you define a new operation without changing the classes of the elements on which it operates.

#### **When to Use**
- When you need many distinct operations on an object structure
- When you want to separate operations from object structure
- When operations change frequently

#### **Implementation**

```java
// Element interface
interface Element {
    void accept(Visitor visitor);
}

// Concrete Elements
class Book implements Element {
    private String title;
    private double price;
    private double weight;
    
    public Book(String title, double price, double weight) {
        this.title = title;
        this.price = price;
        this.weight = weight;
    }
    
    public String getTitle() { return title; }
    public double getPrice() { return price; }
    public double getWeight() { return weight; }
    
    @Override
    public void accept(Visitor visitor) {
        visitor.visit(this);
    }
}

class Electronics implements Element {
    private String name;
    private double price;
    private double weight;
    
    public Electronics(String name, double price, double weight) {
        this.name = name;
        this.price = price;
        this.weight = weight;
    }
    
    public String getName() { return name; }
    public double getPrice() { return price; }
    public double getWeight() { return weight; }
    
    @Override
    public void accept(Visitor visitor) {
        visitor.visit(this);
    }
}

// Visitor interface
interface Visitor {
    void visit(Book book);
    void visit(Electronics electronics);
}

// Concrete Visitors
class PriceVisitor implements Visitor {
    private double totalPrice = 0;
    
    @Override
    public void visit(Book book) {
        totalPrice += book.getPrice();
    }
    
    @Override
    public void visit(Electronics electronics) {
        totalPrice += electronics.getPrice();
    }
    
    public double getTotalPrice() {
        return totalPrice;
    }
}

class WeightVisitor implements Visitor {
    private double totalWeight = 0;
    
    @Override
    public void visit(Book book) {
        totalWeight += book.getWeight();
    }
    
    @Override
    public void visit(Electronics electronics) {
        totalWeight += electronics.getWeight();
    }
    
    public double getTotalWeight() {
        return totalWeight;
    }
}
```

#### **Real-World Example: Shopping Cart with Different Item Types**

```java
// Element hierarchy
interface ShoppingItem {
    void accept(ShoppingCartVisitor visitor);
}

class GroceryItem implements ShoppingItem {
    private String name;
    private double pricePerKg;
    private double weight;
    private boolean isOrganic;
    
    public GroceryItem(String name, double pricePerKg, double weight, boolean isOrganic) {
        this.name = name;
        this.pricePerKg = pricePerKg;
        this.weight = weight;
        this.isOrganic = isOrganic;
    }
    
    public String getName() { return name; }
    public double getPricePerKg() { return pricePerKg; }
    public double getWeight() { return weight; }
    public boolean isOrganic() { return isOrganic; }
    
    @Override
    public void accept(ShoppingCartVisitor visitor) {
        visitor.visit(this);
    }
}

class ClothingItem implements ShoppingItem {
    private String name;
    private double price;
    private String size;
    private String material;
    
    public ClothingItem(String name, double price, String size, String material) {
        this.name = name;
        this.price = price;
        this.size = size;
        this.material = material;
    }
    
    public String getName() { return name; }
    public double getPrice() { return price; }
    public String getSize() { return size; }
    public String getMaterial() { return material; }
    
    @Override
    public void accept(ShoppingCartVisitor visitor) {
        visitor.visit(this);
    }
}

class ElectronicsItem implements ShoppingItem {
    private String name;
    private double price;
    private boolean hasBattery;
    private String brand;
    
    public ElectronicsItem(String name, double price, boolean hasBattery, String brand) {
        this.name = name;
        this.price = price;
        this.hasBattery = hasBattery;
        this.brand = brand;
    }
    
    public String getName() { return name; }
    public double getPrice() { return price; }
    public boolean isHasBattery() { return hasBattery; }
    public String getBrand() { return brand; }
    
    @Override
    public void accept(ShoppingCartVisitor visitor) {
        visitor.visit(this);
    }
}

// Visitor interface
interface ShoppingCartVisitor {
    double visit(GroceryItem item);
    double visit(ClothingItem item);
    double visit(ElectronicsItem item);
}

// Concrete Visitor - Price Calculator with different tax rates
class PriceCalculatorVisitor implements ShoppingCartVisitor {
    private static final double GROCERY_TAX = 0.02;  // 2% tax
    private static final double CLOTHING_TAX = 0.08; // 8% tax
    private static final double ELECTRONICS_TAX = 0.18; // 18% tax
    private static final double ORGANIC_PREMIUM = 0.10; // 10% extra for organic
    
    @Override
    public double visit(GroceryItem item) {
        double basePrice = item.getPricePerKg() * item.getWeight();
        double organicExtra = item.isOrganic() ? basePrice * ORGANIC_PREMIUM : 0;
        double tax = (basePrice + organicExtra) * GROCERY_TAX;
        double total = basePrice + organicExtra + tax;
        
        System.out.printf("Grocery: %s (%.2f kg @ $%.2f/kg) = $%.2f (organic: %b)%n",
            item.getName(), item.getWeight(), item.getPricePerKg(), total, item.isOrganic());
        
        return total;
    }
    
    @Override
    public double visit(ClothingItem item) {
        double tax = item.getPrice() * CLOTHING_TAX;
        double total = item.getPrice() + tax;
        
        System.out.printf("Clothing: %s (%s, %s) = $%.2f%n",
            item.getName(), item.getSize(), item.getMaterial(), total);
        
        return total;
    }
    
    @Override
    public double visit(ElectronicsItem item) {
        double basePrice = item.getPrice();
        double tax = basePrice * ELECTRONICS_TAX;
        double total = basePrice + tax;
        
        System.out.printf("Electronics: %s (%s, battery: %b) = $%.2f%n",
            item.getName(), item.getBrand(), item.isHasBattery(), total);
        
        return total;
    }
}

// Another Visitor - Shipping Cost Calculator
class ShippingCostVisitor implements ShoppingCartVisitor {
    private static final double BASE_SHIPPING = 5.0;
    
    @Override
    public double visit(GroceryItem item) {
        // Groceries need special handling
        double cost = BASE_SHIPPING + (item.getWeight() * 2.0);
        System.out.printf("Shipping for %s: $%.2f%n", item.getName(), cost);
        return cost;
    }
    
    @Override
    public double visit(ClothingItem item) {
        // Standard shipping
        double cost = BASE_SHIPPING;
        System.out.printf("Shipping for %s: $%.2f%n", item.getName(), cost);
        return cost;
    }
    
    @Override
    public double visit(ElectronicsItem item) {
        // Electronics need extra packaging for batteries
        double cost = BASE_SHIPPING * 2.5;
        if (item.isHasBattery()) {
            cost += 5.0; // Hazardous material fee
        }
        System.out.printf("Shipping for %s: $%.2f%n", item.getName(), cost);
        return cost;
    }
}

// Usage
public class ShoppingCartDemo {
    public static void main(String[] args) {
        List<ShoppingItem> items = Arrays.asList(
            new GroceryItem("Apples", 3.99, 2.5, true),
            new GroceryItem("Bread", 2.49, 1.0, false),
            new ClothingItem("Jeans", 59.99, "32", "Denim"),
            new ElectronicsItem("Laptop", 899.99, true, "Dell")
        );
        
        // Calculate prices
        PriceCalculatorVisitor priceCalculator = new PriceCalculatorVisitor();
        double totalPrice = 0;
        for (ShoppingItem item : items) {
            totalPrice += item.accept(priceCalculator);
        }
        System.out.printf("%nTotal Price: $%.2f%n%n", totalPrice);
        
        // Calculate shipping
        ShippingCostVisitor shippingCalculator = new ShippingCostVisitor();
        double totalShipping = 0;
        for (ShoppingItem item : items) {
            totalShipping += item.accept(shippingCalculator);
        }
        System.out.printf("%nTotal Shipping: $%.2f%n", totalShipping);
    }
}
```

#### **Double Dispatch**

```java
// Double dispatch pattern - visitor achieves double dispatch
interface Element {
    void accept(Visitor visitor);
}

interface Visitor {
    void visit(ElementA a);
    void visit(ElementB b);
}

class ElementA implements Element {
    @Override
    public void accept(Visitor visitor) {
        visitor.visit(this); // First dispatch: ElementA calls visitor
    }
}

class ElementB implements Element {
    @Override
    public void accept(Visitor visitor) {
        visitor.visit(this); // First dispatch: ElementB calls visitor
    }
}

class ConcreteVisitor implements Visitor {
    @Override
    public void visit(ElementA a) {
        // Second dispatch: runtime knows we're visiting ElementA
    }
    
    @Override
    public void visit(ElementB b) {
        // Second dispatch: runtime knows we're visiting ElementB
    }
}
```

#### **Pros & Cons**

| ✅ Advantages | ❌ Disadvantages |
|--------------|-----------------|
| Open/Closed Principle | Adding new elements is hard |
| Single Responsibility | Elements must expose internals |
| Related operations grouped | Double dispatch requirement |
| Accumulates state | Can violate encapsulation |

---

## **6. J2EE PATTERNS**

> **Concept:** Patterns specific to Java Enterprise Edition applications.

### **6.1 MVC (Model-View-Controller)**

```java
// Model - data and business logic
class User {
    private String name;
    private String email;
    
    // getters and setters
}

// View - presentation
class UserView {
    public void printUserDetails(String name, String email) {
        System.out.println("User: " + name);
        System.out.println("Email: " + email);
    }
}

// Controller - handles requests
class UserController {
    private User model;
    private UserView view;
    
    public UserController(User model, UserView view) {
        this.model = model;
        this.view = view;
    }
    
    public void setUserName(String name) {
        model.setName(name);
    }
    
    public void setUserEmail(String email) {
        model.setEmail(email);
    }
    
    public void updateView() {
        view.printUserDetails(model.getName(), model.getEmail());
    }
}
```

### **6.2 Front Controller**

```java
// Front Controller - single entry point
@WebServlet("/")
public class FrontController extends HttpServlet {
    private Dispatcher dispatcher = new Dispatcher();
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        dispatcher.dispatch(request, response);
    }
}

// Dispatcher - routes to appropriate handler
class Dispatcher {
    public void dispatch(HttpServletRequest request, HttpServletResponse response) {
        String path = request.getPathInfo();
        
        if (path.startsWith("/users")) {
            new UserController().handle(request, response);
        } else if (path.startsWith("/products")) {
            new ProductController().handle(request, response);
        } else {
            new HomeController().handle(request, response);
        }
    }
}
```

### **6.3 Data Access Object (DAO)**

```java
// DAO interface
interface UserDAO {
    User findById(Long id);
    List<User> findAll();
    void save(User user);
    void update(User user);
    void delete(Long id);
}

// DAO Implementation
class UserDAOImpl implements UserDAO {
    private DataSource dataSource;
    
    @Override
    public User findById(Long id) {
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE id = ?")) {
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    private User mapRow(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getLong("id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        return user;
    }
}
```

### **6.4 Transfer Object (Value Object)**

```java
// Transfer Object
class UserDTO {
    private String name;
    private String email;
    
    public UserDTO(User user) {
        this.name = user.getName();
        this.email = user.getEmail();
    }
    
    // getters only (immutable)
}

// Business Object
class UserService {
    private UserDAO userDAO;
    
    public UserDTO getUser(Long id) {
        User user = userDAO.findById(id);
        return new UserDTO(user);
    }
}
```

---

## **7. SOLID PRINCIPLES**

> **Concept:** Five design principles that make software designs more understandable, flexible, and maintainable.

### **S - Single Responsibility Principle**

> A class should have only one reason to change.

```java
// ❌ Bad - Multiple responsibilities
class Invoice {
    public void calculateTotal() { }
    public void printInvoice() { }
    public void saveToDatabase() { }
    public void sendEmail() { }
}

// ✅ Good - Separate classes
class InvoiceCalculator {
    public void calculateTotal(Invoice invoice) { }
}

class InvoicePrinter {
    public void print(Invoice invoice) { }
}

class InvoiceRepository {
    public void save(Invoice invoice) { }
}

class EmailService {
    public void send(Invoice invoice) { }
}
```

### **O - Open/Closed Principle**

> Software entities should be open for extension, closed for modification.

```java
// ❌ Bad - Adding new shape requires modification
class AreaCalculator {
    public double calculateArea(Object shape) {
        if (shape instanceof Circle) {
            // calculate circle area
        } else if (shape instanceof Rectangle) {
            // calculate rectangle area
        }
        // Need to modify for new shapes
    }
}

// ✅ Good - Extensible
interface Shape {
    double calculateArea();
}

class Circle implements Shape {
    private double radius;
    public double calculateArea() {
        return Math.PI * radius * radius;
    }
}

class Rectangle implements Shape {
    private double width, height;
    public double calculateArea() {
        return width * height;
    }
}

class AreaCalculator {
    public double calculateArea(Shape shape) {
        return shape.calculateArea();
    }
}
```

### **L - Liskov Substitution Principle**

> Derived classes must be substitutable for their base classes.

```java
// ❌ Bad - Square breaks rectangle behavior
class Rectangle {
    protected int width, height;
    public void setWidth(int width) { this.width = width; }
    public void setHeight(int height) { this.height = height; }
    public int getArea() { return width * height; }
}

class Square extends Rectangle {
    @Override
    public void setWidth(int width) {
        super.setWidth(width);
        super.setHeight(width);
    }
    
    @Override
    public void setHeight(int height) {
        super.setWidth(height);
        super.setHeight(height);
    }
}

// ✅ Good - Separate abstractions
interface Shape {
    int getArea();
}

class Rectangle implements Shape {
    private int width, height;
    public Rectangle(int width, int height) {
        this.width = width;
        this.height = height;
    }
    public int getArea() { return width * height; }
}

class Square implements Shape {
    private int side;
    public Square(int side) { this.side = side; }
    public int getArea() { return side * side; }
}
```

### **I - Interface Segregation Principle**

> Clients should not be forced to depend on interfaces they do not use.

```java
// ❌ Bad - Fat interface
interface Worker {
    void work();
    void eat();
    void sleep();
    void attendMeeting();
}

class Robot implements Worker {
    public void work() { /* works */ }
    public void eat() { /* robots don't eat */ } // Forced
    public void sleep() { /* robots don't sleep */ } // Forced
    public void attendMeeting() { /* can't attend */ } // Forced
}

// ✅ Good - Segregated interfaces
interface Workable {
    void work();
}

interface Eatable {
    void eat();
}

interface Sleepable {
    void sleep();
}

interface MeetingAttendable {
    void attendMeeting();
}

class Human implements Workable, Eatable, Sleepable, MeetingAttendable {
    // implements all
}

class Robot implements Workable {
    // only implements work
}
```

### **D - Dependency Inversion Principle**

> Depend on abstractions, not concretions.

```java
// ❌ Bad - High-level module depends on low-level module
class EmailService {
    public void sendEmail(String message) { }
}

class NotificationService {
    private EmailService emailService = new EmailService(); // Direct dependency
    
    public void notify(String message) {
        emailService.sendEmail(message);
    }
}

// ✅ Good - Depend on abstraction
interface MessageService {
    void send(String message);
}

class EmailService implements MessageService {
    public void send(String message) { }
}

class SMSService implements MessageService {
    public void send(String message) { }
}

class NotificationService {
    private MessageService messageService; // Dependency on abstraction
    
    public NotificationService(MessageService messageService) {
        this.messageService = messageService;
    }
    
    public void notify(String message) {
        messageService.send(message);
    }
}
```

---

## **8. PATTERN COMPARISON**

### **Creational Patterns Comparison**

| Pattern | When to Use | Key Feature |
|---------|-------------|-------------|
| **Singleton** | Exactly one instance needed | Global access point |
| **Factory Method** | Object creation delegated to subclasses | Virtual constructor |
| **Abstract Factory** | Families of related objects | Product families |
| **Builder** | Complex object construction | Step-by-step building |
| **Prototype** | Object cloning for performance | Cloning |

### **Structural Patterns Comparison**

| Pattern | When to Use | Key Feature |
|---------|-------------|-------------|
| **Adapter** | Incompatible interfaces | Interface conversion |
| **Bridge** | Abstraction and implementation vary | Decouple abstraction |
| **Composite** | Tree structures | Part-whole hierarchy |
| **Decorator** | Dynamic responsibility addition | Wrapping |
| **Facade** | Complex subsystem simplification | Simplified interface |
| **Flyweight** | Many fine-grained objects | Object sharing |
| **Proxy** | Controlled access | Surrogate |

### **Behavioral Patterns Comparison**

| Pattern | When to Use | Key Feature |
|---------|-------------|-------------|
| **Chain of Responsibility** | Multiple handlers | Request passing |
| **Command** | Request encapsulation | Undo/Redo |
| **Interpreter** | Simple grammar interpretation | Grammar evaluation |
| **Iterator** | Sequential access | Collection traversal |
| **Mediator** | Complex interactions | Centralized control |
| **Memento** | State restoration | Undo/Redo |
| **Observer** | State change propagation | Publish-Subscribe |
| **State** | State-dependent behavior | State objects |
| **Strategy** | Interchangeable algorithms | Algorithm encapsulation |
| **Template Method** | Algorithm skeleton | Code reuse |
| **Visitor** | Operations on object structure | Double dispatch |

---

## **9. COMMON INTERVIEW QUESTIONS**

### **Fundamental Questions**

| Question | Answer |
|----------|--------|
| **What are design patterns?** | Reusable solutions to common software design problems |
| **Why use design patterns?** | Reusability, standardization, maintainability, communication |
| **What are the three categories?** | Creational, Structural, Behavioral |
| **What is the most important pattern?** | Depends on context, but Singleton and Factory are most common |

### **Creational Pattern Questions**

| Question | Answer |
|----------|--------|
| **When to use Singleton?** | Exactly one instance needed, global access point |
| **Singleton vs Static Class?** | Singleton can be lazy loaded, implement interfaces, be extended |
| **How to make Singleton thread-safe?** | Double-checked locking, Bill Pugh, Enum |
| **Factory Method vs Abstract Factory?** | Factory Method: single product; Abstract Factory: product families |
| **Builder vs Factory?** | Builder for complex objects step-by-step; Factory for one-step creation |

### **Structural Pattern Questions**

| Question | Answer |
|----------|--------|
| **Adapter vs Bridge?** | Adapter makes things work after design; Bridge designed upfront |
| **Decorator vs Proxy?** | Decorator adds behavior; Proxy controls access |
| **Composite vs Decorator?** | Composite for tree structures; Decorator for wrapping |
| **Facade vs Mediator?** | Facade simplifies subsystem; Mediator coordinates colleagues |

### **Behavioral Pattern Questions**

| Question | Answer |
|----------|--------|
| **Observer vs Mediator?** | Observer for broadcast; Mediator for complex coordination |
| **Strategy vs State?** | Strategy selected by client; State changes automatically |
| **Command vs Strategy?** | Command encapsulates request; Strategy encapsulates algorithm |
| **Template Method vs Strategy?** | Template Method uses inheritance; Strategy uses composition |
| **Visitor pattern use cases?** | When you need many operations on an object structure |

### **Scenario-Based Questions**

**Q: How would you implement undo/redo?**
> A: Command pattern with Memento pattern for state capture.

**Q: How to handle different file formats?**
> A: Strategy pattern for compression algorithms.

**Q: How to design a logging system?**
> A: Singleton for logger instance, Chain of Responsibility for log levels, Observer for log listeners.

**Q: How to create a UI framework?**
> A: Composite for component hierarchy, Visitor for operations, Observer for events.

---

## **10. QUICK REFERENCE CHEAT SHEET**

```java
// ========== CREATIONAL PATTERNS ==========
// Singleton
class Singleton {
    private static volatile Singleton instance;
    private Singleton() {}
    public static Singleton getInstance() {
        if (instance == null) {
            synchronized(Singleton.class) {
                if (instance == null) instance = new Singleton();
            }
        }
        return instance;
    }
}

// Factory Method
interface Product {}
class ProductA implements Product {}
class Factory {
    public Product createProduct(String type) {
        if (type.equals("A")) return new ProductA();
        return null;
    }
}

// Builder
class Product {
    static class Builder {
        private String part1;
        public Builder setPart1(String part1) { this.part1 = part1; return this; }
        public Product build() { return new Product(this); }
    }
}

// ========== STRUCTURAL PATTERNS ==========
// Adapter
interface Target { void request(); }
class Adaptee { void specificRequest() {} }
class Adapter implements Target {
    private Adaptee adaptee;
    public void request() { adaptee.specificRequest(); }
}

// Decorator
interface Component { void operation(); }
class ConcreteComponent implements Component { public void operation() {} }
abstract class Decorator implements Component {
    protected Component component;
    public Decorator(Component c) { component = c; }
    public void operation() { component.operation(); }
}

// Proxy
interface Subject { void request(); }
class RealSubject implements Subject { public void request() {} }
class Proxy implements Subject {
    private RealSubject subject;
    public void request() {
        if (subject == null) subject = new RealSubject();
        subject.request();
    }
}

// ========== BEHAVIORAL PATTERNS ==========
// Observer
interface Observer { void update(); }
class Subject {
    private List<Observer> observers = new ArrayList<>();
    public void attach(Observer o) { observers.add(o); }
    public void notifyObservers() { observers.forEach(Observer::update); }
}

// Strategy
interface Strategy { void execute(); }
class Context {
    private Strategy strategy;
    public void setStrategy(Strategy s) { strategy = s; }
    public void execute() { strategy.execute(); }
}

// Template Method
abstract class Template {
    public final void templateMethod() {
        step1(); step2(); hook();
    }
    protected abstract void step1();
    protected abstract void step2();
    protected void hook() {} // Optional
}

// Command
interface Command { void execute(); }
class Invoker {
    private Command command;
    public void setCommand(Command c) { command = c; }
    public void executeCommand() { command.execute(); }
}
```

---

## **📝 KEY TAKEAWAYS**

1. **Creational Patterns** – Object creation mechanisms (Singleton, Factory, Builder)
2. **Structural Patterns** – Class and object composition (Adapter, Decorator, Proxy)
3. **Behavioral Patterns** – Object interaction and responsibility (Observer, Strategy, Template)
4. **SOLID Principles** – Foundation of good design
5. **Choose patterns based on problem, not for their own sake**
6. **Patterns are guidelines, not rules** – adapt to your context
7. **Combine patterns** when appropriate
8. **Know the trade-offs** – patterns add complexity
9. **Use patterns to communicate** – common vocabulary
10. **Practice implementation** – real understanding comes from writing code

---

*Good luck with your interview! 🎉*