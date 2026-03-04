# Complete Java OOPs Concepts - The Ultimate Interview Guide 🏗️

*Your comprehensive go-to reference for all Object-Oriented Programming concepts with brief explanations and code examples*

---

## **📋 TABLE OF CONTENTS**

1. [What is OOP?](#1-what-is-oop)
2. [Benefits of OOP](#2-benefits-of-oop)
3. [Class and Object](#3-class-and-object)
4. [Four Pillars of OOP](#4-four-pillars-of-oop)
5. [Encapsulation](#5-encapsulation)
6. [Inheritance](#6-inheritance)
7. [Polymorphism](#7-polymorphism)
8. [Abstraction](#8-abstraction)
9. [Association, Aggregation, Composition](#9-association-aggregation-composition)
10. [Constructors](#10-constructors)
11. [This Keyword](#11-this-keyword)
12. [Static Keyword](#12-static-keyword)
13. [Final Keyword](#13-final-keyword)
14. [Access Modifiers](#14-access-modifiers)
15. [Interfaces](#15-interfaces)
16. [Abstract Classes vs Interfaces](#16-abstract-classes-vs-interfaces)
17. [Method Overloading](#17-method-overloading)
18. [Method Overriding](#18-method-overriding)
19. [Covariant Return Types](#19-covariant-return-types)
20. [Object Class Methods](#20-object-class-methods)
21. [Instanceof Operator](#21-instanceof-operator)
22. [Packages](#22-packages)
23. [SOLID Principles](#23-solid-principles)
24. [Design Patterns Overview](#24-design-patterns-overview)
25. [Common Interview Questions](#25-common-interview-questions)
26. [Quick Reference Cheat Sheet](#26-quick-reference-cheat-sheet)

---

## **1. WHAT IS OOP?**

> **Concept:** Object-Oriented Programming is a programming paradigm that organizes software design around objects rather than functions and logic. An object is a self-contained entity that contains both data (attributes) and behavior (methods).

```java
// Procedural approach
String name = "John";
int age = 30;
void displayPerson(String name, int age) {
    System.out.println(name + " is " + age + " years old");
}

// OOP approach
class Person {
    String name;
    int age;
    
    void display() {
        System.out.println(name + " is " + age + " years old");
    }
}

Person person = new Person();
person.name = "John";
person.age = 30;
person.display();
```

---

## **2. BENEFITS OF OOP**

| Benefit | Explanation | Example |
|---------|-------------|---------|
| **Modularity** | Objects are independent, making debugging and maintenance easier | Change one class without affecting others |
| **Reusability** | Code can be reused through inheritance | `Dog extends Animal` reuses Animal code |
| **Flexibility** | Polymorphism allows same interface for different types | `Animal a = new Dog()` |
| **Security** | Encapsulation protects data | Private fields with public getters/setters |
| **Abstraction** | Hide complex implementation details | Interface defines what, not how |

---

## **3. CLASS AND OBJECT**

> **Concept:** A class is a blueprint/template for creating objects. An object is an instance of a class.

```java
// Class definition (blueprint)
class Car {
    // Attributes (state)
    String brand;
    String model;
    int year;
    String color;
    
    // Behaviors (methods)
    void start() {
        System.out.println(brand + " " + model + " is starting");
    }
    
    void accelerate() {
        System.out.println("Car is accelerating");
    }
    
    void brake() {
        System.out.println("Car is braking");
    }
}

// Creating objects (instances)
public class Main {
    public static void main(String[] args) {
        // Object 1
        Car car1 = new Car();
        car1.brand = "Toyota";
        car1.model = "Camry";
        car1.year = 2022;
        car1.color = "Blue";
        car1.start();
        
        // Object 2
        Car car2 = new Car();
        car2.brand = "Honda";
        car2.model = "Civic";
        car2.year = 2023;
        car2.color = "Red";
        car2.accelerate();
        
        // Each object has its own copy of attributes
        System.out.println(car1.brand); // Toyota
        System.out.println(car2.brand); // Honda
    }
}
```

### **Object Memory Allocation**

```java
Car car = new Car();
// car (reference) stored in stack
// new Car() object stored in heap
// car points to the object in heap
```

---

## **4. FOUR PILLARS OF OOP**

```
                    OOP
        ┌───────────┼───────────┐
        │           │           │
   Encapsulation  Inheritance  Polymorphism  Abstraction
        │           │           │           │
   Data Hiding    IS-A       Many Forms   Hide Details
```

---

## **5. ENCAPSULATION**

> **Concept:** Wrapping data and methods within a class and hiding internal details from outside. Achieved by making fields private and providing public getters/setters.

```java
// Without encapsulation (BAD)
class BadBankAccount {
    double balance;  // Public - anyone can change
}

// With encapsulation (GOOD)
class BankAccount {
    private double balance;  // Private - cannot access directly
    private String accountNumber;
    private String ownerName;
    
    // Constructor
    public BankAccount(String accountNumber, String ownerName, double initialDeposit) {
        this.accountNumber = accountNumber;
        this.ownerName = ownerName;
        if (initialDeposit > 0) {
            this.balance = initialDeposit;
        }
    }
    
    // Public getters - controlled access
    public double getBalance() {
        return balance;
    }
    
    public String getAccountNumber() {
        // Mask account number for security
        return "****" + accountNumber.substring(accountNumber.length() - 4);
    }
    
    public String getOwnerName() {
        return ownerName;
    }
    
    // Public methods with validation
    public void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
            System.out.println("Deposited: $" + amount);
        } else {
            System.out.println("Invalid deposit amount");
        }
    }
    
    public void withdraw(double amount) {
        if (amount > 0 && amount <= balance) {
            balance -= amount;
            System.out.println("Withdrawn: $" + amount);
        } else {
            System.out.println("Insufficient funds or invalid amount");
        }
    }
}

// Usage
BankAccount account = new BankAccount("123456789", "John Doe", 1000);
account.deposit(500);      // OK
account.withdraw(200);     // OK
// account.balance = 1000000;  // ❌ Compile error - private
System.out.println(account.getBalance());  // 1300
```

### **Benefits of Encapsulation:**
- **Data hiding** - protect internal state
- **Validation** - ensure data integrity
- **Flexibility** - change internal implementation without affecting clients
- **Maintainability** - isolate changes

---

## **6. INHERITANCE**

> **Concept:** Mechanism where one class acquires properties and behaviors of another class. Represents **IS-A** relationship.

```java
// Parent class (Base class, Super class)
class Animal {
    protected String name;
    protected int age;
    
    public Animal(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    public void eat() {
        System.out.println(name + " is eating");
    }
    
    public void sleep() {
        System.out.println(name + " is sleeping");
    }
    
    public void displayInfo() {
        System.out.println("Name: " + name + ", Age: " + age);
    }
}

// Child class (Derived class, Sub class)
class Dog extends Animal {
    private String breed;
    
    public Dog(String name, int age, String breed) {
        super(name, age);  // Call parent constructor
        this.breed = breed;
    }
    
    // Additional method
    public void bark() {
        System.out.println(name + " is barking");
    }
    
    // Override parent method
    @Override
    public void eat() {
        System.out.println(name + " is eating dog food");
    }
    
    // New method using parent's methods
    public void guard() {
        System.out.println(name + " is guarding the house");
        bark();  // Call own method
        eat();   // Call overridden method
    }
}

class Cat extends Animal {
    public Cat(String name, int age) {
        super(name, age);
    }
    
    public void meow() {
        System.out.println(name + " is meowing");
    }
    
    @Override
    public void eat() {
        System.out.println(name + " is eating cat food");
    }
}

// Usage
public class InheritanceDemo {
    public static void main(String[] args) {
        Dog dog = new Dog("Buddy", 3, "Golden Retriever");
        dog.displayInfo();  // Inherited from Animal
        dog.eat();          // Overridden
        dog.sleep();        // Inherited
        dog.bark();         // Own method
        dog.guard();        // Own method calling others
        
        Cat cat = new Cat("Whiskers", 2);
        cat.displayInfo();
        cat.eat();          // Different implementation from Dog
        cat.meow();
    }
}
```

### **Types of Inheritance in Java**

```java
// 1. Single Inheritance - One class extends another
class A {}
class B extends A {}

// 2. Multilevel Inheritance - Chain of inheritance
class GrandParent {}
class Parent extends GrandParent {}
class Child extends Parent {}

// 3. Hierarchical Inheritance - Multiple classes extend same class
class Vehicle {}
class Car extends Vehicle {}
class Bike extends Vehicle {}
class Truck extends Vehicle {}

// 4. Multiple Inheritance (NOT supported for classes - use interfaces)
// class C extends A, B {}  // ❌ Not allowed!

// 5. Hybrid Inheritance (NOT supported - diamond problem)
```

### **Important Inheritance Rules**
- Java supports only single inheritance for classes
- Multiple inheritance achieved through interfaces
- All classes inherit from `Object` class implicitly
- `final` classes cannot be inherited
- `final` methods cannot be overridden
- Private members are not inherited
- Constructors are not inherited

---

## **7. POLYMORPHISM**

> **Concept:** Ability of an object to take many forms. Same method name but different implementations.

### **7.1 Compile-time Polymorphism (Method Overloading)**

> **Concept:** Multiple methods with same name but different parameters in the same class.

```java
class Calculator {
    // Same method name, different parameters
    
    public int add(int a, int b) {
        return a + b;
    }
    
    public int add(int a, int b, int c) {
        return a + b + c;
    }
    
    public double add(double a, double b) {
        return a + b;
    }
    
    public String add(String a, String b) {
        return a + b;
    }
    
    public int add(int... numbers) {  // Varargs
        int sum = 0;
        for (int num : numbers) {
            sum += num;
        }
        return sum;
    }
}

// Usage
Calculator calc = new Calculator();
System.out.println(calc.add(5, 10));          // 15
System.out.println(calc.add(5, 10, 15));      // 30
System.out.println(calc.add(5.5, 10.5));      // 16.0
System.out.println(calc.add("Hello", "World")); // HelloWorld
System.out.println(calc.add(1, 2, 3, 4, 5));   // 15
```

### **7.2 Runtime Polymorphism (Method Overriding)**

> **Concept:** Subclass provides specific implementation of method already defined in parent class.

```java
// Parent class
class Shape {
    protected String color;
    
    public Shape(String color) {
        this.color = color;
    }
    
    public double area() {
        return 0;  // Default implementation
    }
    
    public void display() {
        System.out.println("This is a " + color + " shape");
    }
}

// Child class 1
class Circle extends Shape {
    private double radius;
    
    public Circle(String color, double radius) {
        super(color);
        this.radius = radius;
    }
    
    @Override
    public double area() {
        return Math.PI * radius * radius;
    }
    
    @Override
    public void display() {
        System.out.println("This is a " + color + " circle with radius " + radius);
    }
}

// Child class 2
class Rectangle extends Shape {
    private double length;
    private double width;
    
    public Rectangle(String color, double length, double width) {
        super(color);
        this.length = length;
        this.width = width;
    }
    
    @Override
    public double area() {
        return length * width;
    }
    
    @Override
    public void display() {
        System.out.println("This is a " + color + " rectangle " + length + "x" + width);
    }
}

// Child class 3
class Triangle extends Shape {
    private double base;
    private double height;
    
    public Triangle(String color, double base, double height) {
        super(color);
        this.base = base;
        this.height = height;
    }
    
    @Override
    public double area() {
        return 0.5 * base * height;
    }
}

// Runtime polymorphism demonstration
public class PolymorphismDemo {
    public static void main(String[] args) {
        // Array of Shape references pointing to different objects
        Shape[] shapes = {
            new Circle("Red", 5),
            new Rectangle("Blue", 4, 6),
            new Triangle("Green", 3, 8),
            new Shape("Yellow")  // Generic shape
        };
        
        // Polymorphic behavior - same method call, different implementations
        for (Shape shape : shapes) {
            shape.display();
            System.out.println("Area: " + shape.area());
            System.out.println("---");
        }
        
        // Another example
        Shape shape1 = new Circle("Red", 5);
        Shape shape2 = new Rectangle("Blue", 4, 6);
        
        // Method accepting Shape type works with any subclass
        printShapeInfo(shape1);
        printShapeInfo(shape2);
    }
    
    public static void printShapeInfo(Shape shape) {
        System.out.println("Shape info:");
        shape.display();
        System.out.println("Area: " + shape.area());
    }
}
```

### **Rules for Method Overriding**
- Method must have same name, return type, parameters
- Access modifier cannot be more restrictive (can be less)
- Cannot override final methods
- Cannot override static methods (they're hidden, not overridden)
- Overriding method cannot throw broader checked exceptions

---

## **8. ABSTRACTION**

> **Concept:** Hiding implementation details and showing only essential features to the user.

### **8.1 Abstract Classes**

```java
// Abstract class - cannot be instantiated
abstract class Vehicle {
    protected String brand;
    protected String model;
    
    public Vehicle(String brand, String model) {
        this.brand = brand;
        this.model = model;
    }
    
    // Concrete method - has implementation
    public void displayInfo() {
        System.out.println("Brand: " + brand + ", Model: " + model);
    }
    
    // Abstract method - no implementation
    public abstract void startEngine();
    
    public abstract void accelerate();
    
    public abstract void brake();
}

// Concrete subclass must implement all abstract methods
class Car extends Vehicle {
    private int doors;
    
    public Car(String brand, String model, int doors) {
        super(brand, model);
        this.doors = doors;
    }
    
    @Override
    public void startEngine() {
        System.out.println(brand + " " + model + " car engine started");
    }
    
    @Override
    public void accelerate() {
        System.out.println("Car is accelerating smoothly");
    }
    
    @Override
    public void brake() {
        System.out.println("Car is braking with disc brakes");
    }
}

class Motorcycle extends Vehicle {
    private boolean hasFairing;
    
    public Motorcycle(String brand, String model, boolean hasFairing) {
        super(brand, model);
        this.hasFairing = hasFairing;
    }
    
    @Override
    public void startEngine() {
        System.out.println(brand + " " + model + " motorcycle engine started");
    }
    
    @Override
    public void accelerate() {
        System.out.println("Motorcycle accelerating fast");
    }
    
    @Override
    public void brake() {
        System.out.println("Motorcycle braking with ABS");
    }
}

// Usage
public class AbstractionDemo {
    public static void main(String[] args) {
        // Vehicle v = new Vehicle("Toyota", "Camry");  // ❌ Cannot instantiate abstract class
        
        Vehicle car = new Car("Toyota", "Camry", 4);
        Vehicle bike = new Motorcycle("Harley", "Sportster", true);
        
        car.displayInfo();
        car.startEngine();
        car.accelerate();
        car.brake();
        
        bike.displayInfo();
        bike.startEngine();
        bike.accelerate();
        bike.brake();
    }
}
```

### **8.2 Interfaces**

```java
// Interface - 100% abstraction (before Java 8)
interface Drawable {
    // public static final by default
    String TYPE = "Drawable";
    
    // public abstract by default
    void draw();
    void resize(double factor);
}

// Another interface
interface Colorable {
    void setColor(String color);
    String getColor();
}

// Java 8+ interfaces can have default and static methods
interface Printable {
    void print();
    
    // Default method - has implementation
    default void printHeader() {
        System.out.println("=== Document Header ===");
    }
    
    // Static method
    static void printFooter() {
        System.out.println("=== Document Footer ===");
    }
}

// Class implementing multiple interfaces
class Circle implements Drawable, Colorable, Printable {
    private double radius;
    private String color;
    
    public Circle(double radius) {
        this.radius = radius;
        this.color = "Black";
    }
    
    // From Drawable
    @Override
    public void draw() {
        System.out.println("Drawing a " + color + " circle of radius " + radius);
    }
    
    @Override
    public void resize(double factor) {
        radius *= factor;
        System.out.println("Circle resized to radius " + radius);
    }
    
    // From Colorable
    @Override
    public void setColor(String color) {
        this.color = color;
    }
    
    @Override
    public String getColor() {
        return color;
    }
    
    // From Printable
    @Override
    public void print() {
        System.out.println("Circle: radius=" + radius + ", color=" + color);
    }
    
    // Can override default method
    @Override
    public void printHeader() {
        System.out.println("=== Circle Details ===");
    }
}

// Usage
public class InterfaceDemo {
    public static void main(String[] args) {
        Circle circle = new Circle(5);
        
        // Using interface references
        Drawable drawable = circle;
        Colorable colorable = circle;
        Printable printable = circle;
        
        drawable.draw();
        drawable.resize(2);
        
        colorable.setColor("Red");
        System.out.println("Color: " + colorable.getColor());
        
        printable.printHeader();
        printable.print();
        Printable.printFooter();  // Static method called on interface
    }
}
```

### **8.3 Functional Interfaces (Java 8+)**

```java
@FunctionalInterface  // Has exactly one abstract method
interface MathOperation {
    int operate(int a, int b);
    
    // Can have default methods
    default void display() {
        System.out.println("Math operation performed");
    }
}

// Usage with lambda
public class FunctionalInterfaceDemo {
    public static void main(String[] args) {
        MathOperation addition = (a, b) -> a + b;
        MathOperation subtraction = (a, b) -> a - b;
        MathOperation multiplication = (a, b) -> a * b;
        MathOperation division = (a, b) -> a / b;
        
        System.out.println(addition.operate(10, 5));      // 15
        System.out.println(subtraction.operate(10, 5));   // 5
        System.out.println(multiplication.operate(10, 5)); // 50
        System.out.println(division.operate(10, 5));      // 2
    }
}
```

---

## **9. ASSOCIATION, AGGREGATION, COMPOSITION**

> **Concept:** Relationships between classes.

### **9.1 Association**

> **Concept:** Relationship where objects have independent lifecycles.

```java
class Driver {
    private String name;
    
    public Driver(String name) {
        this.name = name;
    }
    
    public void drive() {
        System.out.println(name + " is driving");
    }
}

class Car {
    private String model;
    
    public Car(String model) {
        this.model = model;
    }
    
    public void drive(Driver driver) {
        System.out.print(model + " is being driven: ");
        driver.drive();
    }
}

// Usage - independent objects
Driver driver = new Driver("John");
Car car = new Car("Toyota");
car.drive(driver);  // Association
// Both can exist independently
```

### **9.2 Aggregation (Weak Has-A)**

> **Concept:** Child can exist independently of parent.

```java
class Department {
    private String name;
    private List<Professor> professors;
    
    public Department(String name) {
        this.name = name;
        this.professors = new ArrayList<>();
    }
    
    public void addProfessor(Professor professor) {
        professors.add(professor);
    }
    
    public List<Professor> getProfessors() {
        return professors;
    }
}

class Professor {
    private String name;
    
    public Professor(String name) {
        this.name = name;
    }
    
    public String getName() {
        return name;
    }
}

// Usage
Department cs = new Department("Computer Science");
Professor p1 = new Professor("Dr. Smith");
Professor p2 = new Professor("Dr. Johnson");

cs.addProfessor(p1);
cs.addProfessor(p2);

// Professors exist even if department is deleted
```

### **9.3 Composition (Strong Has-A)**

> **Concept:** Child cannot exist independently of parent.

```java
class House {
    private List<Room> rooms;
    private Address address;
    
    public House(Address address) {
        this.address = address;
        this.rooms = new ArrayList<>();
        // Rooms are created with house
        rooms.add(new Room("Living Room"));
        rooms.add(new Room("Bedroom"));
        rooms.add(new Room("Kitchen"));
    }
    
    public void display() {
        System.out.println("House at " + address);
        System.out.println("Rooms:");
        for (Room room : rooms) {
            System.out.println("  - " + room.getName());
        }
    }
    
    // Inner class - strongly tied to House
    class Room {
        private String name;
        
        Room(String name) {
            this.name = name;
        }
        
        String getName() {
            return name;
        }
    }
}

class Address {
    private String street;
    private String city;
    
    public Address(String street, String city) {
        this.street = street;
        this.city = city;
    }
    
    @Override
    public String toString() {
        return street + ", " + city;
    }
}

// Usage
Address address = new Address("123 Main St", "New York");
House house = new House(address);
house.display();
// Rooms cannot exist without house
```

### **Comparison Table**

| Relationship | Lifecycle | Example | Symbol |
|--------------|-----------|---------|--------|
| **Association** | Independent | Driver and Car | Uses |
| **Aggregation** | Independent | Department and Professor | Has-a (weak) |
| **Composition** | Dependent | House and Room | Has-a (strong) |

---

## **10. CONSTRUCTORS**

> **Concept:** Special methods used to initialize objects when created.

```java
class Student {
    private String name;
    private int age;
    private String studentId;
    private static int studentCount = 0;
    
    // 1. Default constructor (provided by compiler if no constructor defined)
    // public Student() { }
    
    // 2. No-arg constructor (explicit)
    public Student() {
        this("Unknown", 0, "N/A");  // Call another constructor
        System.out.println("No-arg constructor called");
    }
    
    // 3. Parameterized constructor
    public Student(String name, int age, String studentId) {
        this.name = name;
        this.age = age;
        this.studentId = studentId;
        studentCount++;
        System.out.println("Parameterized constructor called");
    }
    
    // 4. Copy constructor
    public Student(Student other) {
        this(other.name, other.age, other.studentId);
        System.out.println("Copy constructor called");
    }
    
    // 5. Constructor chaining
    public Student(String name) {
        this(name, 18, "TEMP");  // Calls parameterized constructor
    }
    
    // Getter methods
    public String getName() { return name; }
    public int getAge() { return age; }
    public String getStudentId() { return studentId; }
    public static int getStudentCount() { return studentCount; }
}

// Usage
public class ConstructorDemo {
    public static void main(String[] args) {
        Student s1 = new Student();                    // No-arg
        Student s2 = new Student("Alice", 20, "S123"); // Parameterized
        Student s3 = new Student("Bob");                // Constructor chaining
        Student s4 = new Student(s2);                   // Copy constructor
        
        System.out.println("s2 name: " + s2.getName());
        System.out.println("s3 age: " + s3.getAge());   // 18 (default)
        System.out.println("Total students: " + Student.getStudentCount());
    }
}
```

### **Constructor Rules**
- Same name as class
- No return type (not even void)
- Cannot be abstract, static, final, synchronized
- Can be overloaded
- Can call another constructor using `this()`
- Parent constructor called with `super()`

---

## **11. THIS KEYWORD**

> **Concept:** Refers to current object instance.

```java
class Employee {
    private String name;
    private double salary;
    private String department;
    
    // 1. Distinguish instance variables from parameters
    public Employee(String name, double salary, String department) {
        this.name = name;
        this.salary = salary;
        this.department = department;
    }
    
    // 2. Call another constructor (constructor chaining)
    public Employee(String name) {
        this(name, 50000, "General");  // Calls above constructor
    }
    
    // 3. Return current instance (for method chaining)
    public Employee setName(String name) {
        this.name = name;
        return this;  // Returns current object
    }
    
    public Employee setSalary(double salary) {
        this.salary = salary;
        return this;
    }
    
    public Employee setDepartment(String department) {
        this.department = department;
        return this;
    }
    
    // 4. Pass current object to another method
    public void printEmployee() {
        printDetails(this);  // Pass current object
    }
    
    private void printDetails(Employee emp) {
        System.out.println("Name: " + emp.name);
        System.out.println("Salary: " + emp.salary);
        System.out.println("Dept: " + emp.department);
    }
    
    // 5. Use in inner class to refer to outer class instance
    class Manager {
        private String name;
        
        public Manager(String name) {
            this.name = name;
        }
        
        public void display() {
            System.out.println("Manager: " + this.name);
            System.out.println("Employee: " + Employee.this.name);  // Outer class instance
        }
    }
}

// Usage
public class ThisDemo {
    public static void main(String[] args) {
        // Method chaining using this
        Employee emp = new Employee("John")
            .setSalary(75000)
            .setDepartment("IT");
        
        emp.printEmployee();
        
        // Inner class
        Employee.Manager mgr = emp.new Manager("Alice");
        mgr.display();
    }
}
```

---

## **12. STATIC KEYWORD**

> **Concept:** Members belong to class rather than instances. Shared across all objects.

```java
class University {
    // Static variables - one copy shared by all instances
    private static String universityName = "Global University";
    private static int totalStudents = 0;
    
    // Instance variables - each object has its own copy
    private String studentName;
    private int studentId;
    
    // Static constant
    public static final int MAX_STUDENTS = 10000;
    
    public University(String studentName) {
        this.studentName = studentName;
        this.studentId = ++totalStudents;  // Shared counter
    }
    
    // Static method - can only access static members
    public static String getUniversityName() {
        return universityName;
    }
    
    public static int getTotalStudents() {
        return totalStudents;
    }
    
    // Static method to update university name
    public static void setUniversityName(String name) {
        universityName = name;
    }
    
    // Instance method - can access both static and instance members
    public void displayInfo() {
        System.out.println("University: " + universityName);  // static
        System.out.println("Student: " + studentName);         // instance
        System.out.println("ID: " + studentId);                // instance
        System.out.println("---");
    }
    
    // Static nested class (not inner class)
    static class Department {
        private String deptName;
        
        public Department(String deptName) {
            this.deptName = deptName;
        }
        
        public void display() {
            System.out.println("Department: " + deptName);
            System.out.println("University: " + universityName);  // Can access static
        }
    }
    
    // Static block - runs when class is loaded
    static {
        System.out.println("University class loaded");
        // Initialize static resources
    }
}

// Usage
public class StaticDemo {
    public static void main(String[] args) {
        // Access static members without creating object
        System.out.println(University.getUniversityName());
        System.out.println("Max students: " + University.MAX_STUDENTS);
        
        University.setUniversityName("International University");
        
        // Create objects
        University s1 = new University("Alice");
        University s2 = new University("Bob");
        University s3 = new University("Charlie");
        
        s1.displayInfo();
        s2.displayInfo();
        s3.displayInfo();
        
        System.out.println("Total students: " + University.getTotalStudents());
        
        // Static nested class
        University.Department dept = new University.Department("Computer Science");
        dept.display();
    }
}
```

### **Static vs Instance**

| Feature | Static | Instance |
|---------|--------|----------|
| **Belongs to** | Class | Object |
| **Memory** | Single copy | Separate copy per object |
| **Access** | Class name | Object reference |
| **Can access** | Only static members | Both static and instance |
| **this keyword** | Cannot use | Can use |

---

## **13. FINAL KEYWORD**

> **Concept:** Used to create constants, prevent inheritance, and prevent method overriding.

```java
// 1. Final class - cannot be extended
final class Constants {
    // 2. Final variables - cannot be changed (constants)
    public static final double PI = 3.14159;
    public static final String APP_NAME = "MyApp";
    public static final int MAX_USERS = 1000;
    
    // 3. Final blank variable - initialized in constructor
    private final int id;
    
    public Constants(int id) {
        this.id = id;  // Initialize final variable
    }
    
    // 4. Final method - cannot be overridden
    public final void display() {
        System.out.println("This method cannot be overridden");
    }
}

// ❌ Cannot extend final class
// class ExtendedConstants extends Constants { }

class Parent {
    // Final method - cannot be overridden
    public final void show() {
        System.out.println("Parent show");
    }
    
    // Regular method - can be overridden
    public void display() {
        System.out.println("Parent display");
    }
}

class Child extends Parent {
    // ❌ Cannot override final method
    // public void show() { }  // Compile error!
    
    // ✅ Can override non-final method
    @Override
    public void display() {
        System.out.println("Child display");
    }
}

// Final parameters
class Calculator {
    public int add(final int a, final int b) {
        // a = 10;  // ❌ Cannot modify final parameter
        return a + b;
    }
}

// Final reference - reference cannot change, but object can
class Person {
    private String name;
    
    public Person(String name) {
        this.name = name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
}

public class FinalDemo {
    public static void main(String[] args) {
        // Final primitive
        final int x = 10;
        // x = 20;  // ❌ Cannot reassign
        
        // Final reference
        final Person person = new Person("John");
        // person = new Person("Jane");  // ❌ Cannot reassign reference
        person.setName("Jane");  // ✅ Can modify object's state
        
        // Final method parameter
        Calculator calc = new Calculator();
        System.out.println(calc.add(5, 10));
    }
}
```

### **Final Usage Summary**

| Used with | Effect |
|-----------|--------|
| **Variable** | Value cannot be changed (constant) |
| **Method** | Cannot be overridden by subclasses |
| **Class** | Cannot be extended |
| **Parameter** | Cannot be modified inside method |

---

## **14. ACCESS MODIFIERS**

> **Concept:** Control visibility of classes, methods, and fields.

```java
// Access levels
// ┌─────────────┬───────┬────────┬─────────┬─────────┐
// │ Modifier    │ Class │ Package│ Subclass│ World   │
// ├─────────────┼───────┼────────┼─────────┼─────────┤
// │ private     │ ✓     │ ✗      │ ✗       │ ✗       │
// │ default     │ ✓     │ ✓      │ ✗       │ ✗       │
// │ protected   │ ✓     │ ✓      │ ✓       │ ✗       │
// │ public      │ ✓     │ ✓      │ ✓       │ ✓       │
// └─────────────┴───────┴────────┴─────────┴─────────┘

package com.example;

public class AccessModifiersDemo {
    private int privateVar = 1;           // Only within this class
    int defaultVar = 2;                   // Within package
    protected int protectedVar = 3;        // Package + subclasses
    public int publicVar = 4;              // Everywhere
    
    private void privateMethod() {
        System.out.println("Private method");
    }
    
    void defaultMethod() {
        System.out.println("Default method");
    }
    
    protected void protectedMethod() {
        System.out.println("Protected method");
    }
    
    public void publicMethod() {
        System.out.println("Public method");
        
        // Can access all within same class
        System.out.println(privateVar);
        System.out.println(defaultVar);
        System.out.println(protectedVar);
        System.out.println(publicVar);
        privateMethod();
        defaultMethod();
        protectedMethod();
    }
}

// Same package class
class SamePackageClass {
    public void test() {
        AccessModifiersDemo demo = new AccessModifiersDemo();
        
        // System.out.println(demo.privateVar);   // ❌ Not accessible
        System.out.println(demo.defaultVar);      // ✅ Accessible
        System.out.println(demo.protectedVar);    // ✅ Accessible
        System.out.println(demo.publicVar);       // ✅ Accessible
        
        // demo.privateMethod();    // ❌ Not accessible
        demo.defaultMethod();        // ✅ Accessible
        demo.protectedMethod();      // ✅ Accessible
        demo.publicMethod();         // ✅ Accessible
    }
}

// Different package subclass
package com.other;

import com.example.AccessModifiersDemo;

class SubclassDemo extends AccessModifiersDemo {
    public void test() {
        // System.out.println(privateVar);   // ❌ Not accessible
        // System.out.println(defaultVar);   // ❌ Not accessible (different package)
        System.out.println(protectedVar);     // ✅ Accessible via inheritance
        System.out.println(publicVar);        // ✅ Accessible
        
        // privateMethod();    // ❌
        // defaultMethod();    // ❌
        protectedMethod();      // ✅
        publicMethod();         // ✅
    }
}

// Different package non-subclass
class OtherClass {
    public void test() {
        AccessModifiersDemo demo = new AccessModifiersDemo();
        
        // System.out.println(demo.privateVar);   // ❌
        // System.out.println(demo.defaultVar);   // ❌
        // System.out.println(demo.protectedVar); // ❌
        System.out.println(demo.publicVar);        // ✅ Only public
        
        demo.publicMethod();  // ✅ Only public method accessible
    }
}
```

---

## **15. INTERFACES**

> **Concept:** Contract that defines what a class must do, but not how. (Detailed examples in Abstraction section)

### **15.1 Marker Interfaces**

```java
// Marker interface - no methods
interface Serializable { }  // JVM treats objects specially
interface Cloneable { }      // Allows cloning
interface Remote { }         // For remote objects

class Student implements Serializable, Cloneable {
    private String name;
    private int age;
    
    // Need to override clone from Object
    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}
```

### **15.2 Functional Interfaces (Java 8+)**

```java
@FunctionalInterface
interface Greeting {
    void sayHello(String name);
    
    // Default methods allowed
    default void sayGoodbye(String name) {
        System.out.println("Goodbye " + name);
    }
    
    // Static methods allowed
    static void greet() {
        System.out.println("Greetings!");
    }
}

// Usage with lambda
Greeting greeting = name -> System.out.println("Hello " + name);
greeting.sayHello("Alice");
greeting.sayGoodbye("Alice");
Greeting.greet();
```

---

## **16. ABSTRACT CLASSES VS INTERFACES**

| Feature | Abstract Class | Interface |
|---------|----------------|-----------|
| **Keyword** | `abstract` | `interface` |
| **Multiple inheritance** | No | Yes |
| **Instance variables** | Yes | No (static final only) |
| **Constructors** | Yes | No |
| **Access modifiers** | All | Public (default) |
| **Method implementation** | Can have both abstract and concrete | Abstract (default/static methods Java 8+) |
| **When to use** | Common base with shared code | Contract/capability, multiple roles |

```java
// When to use abstract class
abstract class Bird {
    protected String name;
    
    public Bird(String name) {
        this.name = name;
    }
    
    public void eat() {
        System.out.println(name + " is eating");
    }
    
    public abstract void fly();
}

// When to use interface
interface Flyable {
    void fly();
}

interface Swimmable {
    void swim();
}

// Class can extend one abstract class but implement multiple interfaces
class Duck extends Bird implements Flyable, Swimmable {
    public Duck(String name) {
        super(name);
    }
    
    @Override
    public void fly() {
        System.out.println(name + " is flying");
    }
    
    @Override
    public void swim() {
        System.out.println(name + " is swimming");
    }
}
```

---

## **17. METHOD OVERLOADING**

> **Concept:** Multiple methods with same name but different parameters in same class. (See Polymorphism section)

### **Rules for Overloading**

```java
class OverloadDemo {
    // Different number of parameters
    void display() { }
    void display(int a) { }
    void display(int a, int b) { }
    
    // Different data types
    void show(int a) { }
    void show(double a) { }
    void show(String a) { }
    
    // Different sequence of parameters
    void print(int a, double b) { }
    void print(double a, int b) { }
    
    // Can't overload by return type alone
    // int calculate() { }  
    // void calculate() { }  // ❌ Compile error
    
    // Varargs
    void sum(int... numbers) { }
    void sum(int a, int... numbers) { }  // Valid overloading
}
```

---

## **18. METHOD OVERRIDING**

> **Concept:** Subclass provides specific implementation of parent class method. (See Polymorphism section)

### **Rules for Overriding**

```java
class Parent {
    // Override these
    public void method1() { }
    protected void method2() { }
    public Number method3() { return 0; }
    public void method4() throws IOException { }
    
    // Cannot override these
    private void method5() { }      // Private - not inherited
    public final void method6() { } // Final - cannot override
    public static void method7() { } // Static - hidden, not overridden
}

class Child extends Parent {
    @Override
    public void method1() { }  // OK - same or wider access
    
    @Override
    public void method2() { }  // OK - protected to public (wider)
    
    @Override
    public Integer method3() { return 0; }  // OK - covariant return
    
    @Override
    public void method4() throws FileNotFoundException { }  // OK - narrower exception
    
    // @Override - Cannot override private, final, static
}
```

---

## **19. COVARIANT RETURN TYPES**

> **Concept:** Overriding method can return subtype of original return type.

```java
class Animal {
    protected String name;
    
    public Animal getAnimal() {
        return this;
    }
}

class Dog extends Animal {
    @Override
    public Dog getAnimal() {  // Returns Dog (subtype of Animal)
        return this;
    }
}

class Cat extends Animal {
    @Override
    public Cat getAnimal() {  // Returns Cat (subtype of Animal)
        return this;
    }
}
```

---

## **20. OBJECT CLASS METHODS**

> **Concept:** Every class inherits from Object class. These methods are available in all classes.

```java
class Person implements Cloneable {
    private String name;
    private int age;
    
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    // 1. toString() - string representation
    @Override
    public String toString() {
        return "Person[name=" + name + ", age=" + age + "]";
    }
    
    // 2. equals() - compare objects for equality
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        
        Person person = (Person) obj;
        return age == person.age && 
               Objects.equals(name, person.name);
    }
    
    // 3. hashCode() - must override if equals is overridden
    @Override
    public int hashCode() {
        return Objects.hash(name, age);
    }
    
    // 4. clone() - create copy (must implement Cloneable)
    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();  // Shallow copy
    }
    
    // 5. finalize() - called before garbage collection (deprecated)
    @Override
    protected void finalize() throws Throwable {
        System.out.println("Person object being garbage collected: " + name);
        super.finalize();
    }
}

// Usage
public class ObjectClassDemo {
    public static void main(String[] args) throws Exception {
        Person p1 = new Person("Alice", 30);
        Person p2 = new Person("Alice", 30);
        Person p3 = p1;
        
        // toString
        System.out.println(p1);  // Person[name=Alice, age=30]
        
        // equals
        System.out.println(p1.equals(p2));  // true (content same)
        System.out.println(p1 == p2);       // false (different references)
        System.out.println(p1.equals(p3));  // true (same reference)
        
        // hashCode
        System.out.println(p1.hashCode());
        System.out.println(p2.hashCode());  // Same if equals true
        
        // getClass
        System.out.println(p1.getClass().getName());  // Person
        System.out.println(p1.getClass().getSimpleName());  // Person
        
        // clone
        Person p4 = (Person) p1.clone();
        System.out.println(p4);
        
        // notify, wait - used in threading
    }
}
```

### **equals() and hashCode() Contract**

1. If `a.equals(b)` is true, then `a.hashCode() == b.hashCode()` must be true
2. If `a.hashCode() == b.hashCode()`, `a.equals(b)` may be true or false
3. Equal objects must have equal hash codes

---

## **21. INSTANCEOF OPERATOR**

> **Concept:** Checks if object is instance of specific class or interface.

```java
class Animal { }
class Dog extends Animal { }
class Cat extends Animal { }

public class InstanceOfDemo {
    public static void processAnimal(Animal animal) {
        // Check type before casting
        if (animal instanceof Dog) {
            Dog dog = (Dog) animal;
            System.out.println("Processing dog");
            // dog.bark();
        } else if (animal instanceof Cat) {
            Cat cat = (Cat) animal;
            System.out.println("Processing cat");
            // cat.meow();
        } else {
            System.out.println("Processing generic animal");
        }
        
        // Pattern matching (Java 16+)
        if (animal instanceof Dog dog) {
            System.out.println("Pattern matching: dog");
            // dog.bark();  // dog variable automatically available
        }
        
        // null check
        Animal a = null;
        System.out.println(a instanceof Animal);  // false (null not instance of anything)
    }
    
    public static void main(String[] args) {
        processAnimal(new Dog());
        processAnimal(new Cat());
        processAnimal(new Animal());
    }
}
```

---

## **22. PACKAGES**

> **Concept:** Organize classes into namespaces.

```java
// File: com/company/model/Person.java
package com.company.model;

import java.time.LocalDate;
import java.util.Objects;

public class Person {
    private String name;
    private LocalDate birthDate;
    
    // Constructor, methods
}

// File: com/company/service/PersonService.java
package com.company.service;

import com.company.model.Person;  // Import specific class
import com.company.util.*;       // Import all classes from util package
import static com.company.util.Constants.*;  // Static import

public class PersonService {
    private List<Person> persons = new ArrayList<>();  // Fully qualified: java.util.ArrayList
    
    public void addPerson(Person person) {
        persons.add(person);
    }
    
    public void display() {
        System.out.println(MAX_PERSONS);  // Static import
    }
}

// File: com/company/util/Constants.java
package com.company.util;

public class Constants {
    public static final int MAX_PERSONS = 1000;
    public static final String APP_NAME = "MyApp";
}

// Compile and run
// javac -d . com/company/model/*.java
// javac -d . com/company/util/*.java
// javac -d . com/company/service/*.java
// java com.company.service.PersonService
```

### **Package Naming Convention**

```
com.company.project.module
org.project.framework
edu.university.department
```

---

## **23. SOLID PRINCIPLES**

> **Concept:** Five design principles for maintainable and scalable software.

### **S - Single Responsibility Principle**

> **Concept:** A class should have only one reason to change.

```java
// ❌ BAD - Multiple responsibilities
class Invoice {
    public void calculateTotal() { }
    public void printInvoice() { }
    public void saveToDatabase() { }
    public void sendEmail() { }
}

// ✅ GOOD - Single responsibility each
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

> **Concept:** Classes should be open for extension but closed for modification.

```java
// ❌ BAD - Adding new payment method requires modifying existing code
class PaymentProcessor {
    public void process(String type, double amount) {
        if (type.equals("credit")) {
            // process credit
        } else if (type.equals("paypal")) {
            // process paypal
        }
        // Need to modify for new payment types
    }
}

// ✅ GOOD - Open for extension, closed for modification
interface PaymentMethod {
    void process(double amount);
}

class CreditCardPayment implements PaymentMethod {
    @Override
    public void process(double amount) {
        // process credit card
    }
}

class PayPalPayment implements PaymentMethod {
    @Override
    public void process(double amount) {
        // process paypal
    }
}

class PaymentProcessor {
    public void process(PaymentMethod method, double amount) {
        method.process(amount);  // Works with any new payment method
    }
}
```

### **L - Liskov Substitution Principle**

> **Concept:** Derived classes must be substitutable for their base classes.

```java
// ❌ BAD - Square can't substitute Rectangle
class Rectangle {
    protected int width;
    protected int height;
    
    public void setWidth(int width) { this.width = width; }
    public void setHeight(int height) { this.height = height; }
    public int getArea() { return width * height; }
}

class Square extends Rectangle {
    @Override
    public void setWidth(int width) {
        this.width = width;
        this.height = width;  // Violates LSP - changes behavior
    }
    
    @Override
    public void setHeight(int height) {
        this.width = height;
        this.height = height;  // Violates LSP
    }
}

// ✅ GOOD - Separate abstractions
interface Shape {
    int getArea();
}

class Rectangle implements Shape {
    private int width;
    private int height;
    
    public Rectangle(int width, int height) {
        this.width = width;
        this.height = height;
    }
    
    @Override
    public int getArea() {
        return width * height;
    }
}

class Square implements Shape {
    private int side;
    
    public Square(int side) {
        this.side = side;
    }
    
    @Override
    public int getArea() {
        return side * side;
    }
}
```

### **I - Interface Segregation Principle**

> **Concept:** Don't force clients to depend on interfaces they don't use.

```java
// ❌ BAD - Fat interface
interface Worker {
    void work();
    void eat();
    void sleep();
    void attendMeeting();
}

class Robot implements Worker {
    @Override
    public void work() { }
    
    @Override
    public void eat() { }  // Robot doesn't need this
    
    @Override
    public void sleep() { } // Robot doesn't need this
    
    @Override
    public void attendMeeting() { } // Robot doesn't need this
}

// ✅ GOOD - Segregated interfaces
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
    @Override
    public void work() { }
    
    @Override
    public void eat() { }
    
    @Override
    public void sleep() { }
    
    @Override
    public void attendMeeting() { }
}

class Robot implements Workable {
    @Override
    public void work() { }
    // Robot only implements what it needs
}
```

### **D - Dependency Inversion Principle**

> **Concept:** Depend on abstractions, not concretions.

```java
// ❌ BAD - High-level module depends on low-level module
class EmailService {
    public void sendEmail(String message) {
        // Send email
    }
}

class NotificationService {
    private EmailService emailService = new EmailService();  // Direct dependency
    
    public void notify(String message) {
        emailService.sendEmail(message);
    }
}

// ✅ GOOD - Depend on abstraction
interface MessageService {
    void send(String message);
}

class EmailService implements MessageService {
    @Override
    public void send(String message) {
        // Send email
    }
}

class SMSService implements MessageService {
    @Override
    public void send(String message) {
        // Send SMS
    }
}

class NotificationService {
    private MessageService messageService;  // Depend on abstraction
    
    public NotificationService(MessageService messageService) {
        this.messageService = messageService;  // Dependency injection
    }
    
    public void notify(String message) {
        messageService.send(message);  // Works with any MessageService
    }
}
```

---

## **24. DESIGN PATTERNS OVERVIEW**

> **Concept:** Reusable solutions to common problems.

### **Creational Patterns**

| Pattern | Purpose | Example |
|---------|---------|---------|
| **Singleton** | One instance globally | `Runtime.getRuntime()` |
| **Factory** | Create objects without specifying exact class | `NumberFormat.getInstance()` |
| **Builder** | Construct complex objects step by step | `StringBuilder` |

### **Structural Patterns**

| Pattern | Purpose | Example |
|---------|---------|---------|
| **Adapter** | Convert interface to another | `Arrays.asList()` |
| **Decorator** | Add behavior dynamically | `BufferedReader` |
| **Proxy** | Control access to object | `Proxy classes` |

### **Behavioral Patterns**

| Pattern | Purpose | Example |
|---------|---------|---------|
| **Observer** | Notify dependents of changes | Event listeners |
| **Strategy** | Encapsulate interchangeable algorithms | Comparators |
| **Template** | Define skeleton with customizable steps | Abstract classes |

---

## **25. COMMON INTERVIEW QUESTIONS**

| Question | Answer |
|----------|--------|
| **What is OOP?** | Programming paradigm organizing code around objects containing data and methods |
| **Four pillars of OOP?** | Encapsulation, Inheritance, Polymorphism, Abstraction |
| **Difference between class and object?** | Class is blueprint, object is instance |
| **What is encapsulation?** | Hiding internal state and requiring all interaction through methods |
| **What is inheritance?** | Class acquiring properties of another class (IS-A relationship) |
| **Types of inheritance in Java?** | Single, multilevel, hierarchical (multiple not supported) |
| **What is polymorphism?** | Same method name having different implementations |
| **Overloading vs Overriding?** | Overloading: same class, different params; Overriding: subclass changes parent method |
| **What is abstraction?** | Hiding implementation details, showing only functionality |
| **Abstract class vs Interface?** | Abstract: can have state, constructors; Interface: contract, multiple inheritance |
| **What is coupling?** | Degree of dependency between classes (low coupling good) |
| **What is cohesion?** | Degree to which class elements belong together (high cohesion good) |
| **Can we override static methods?** | No, they're hidden, not overridden |
| **What is method hiding?** | Static method in subclass hides parent static method |
| **What is covariant return type?** | Override method can return subtype of original return type |
| **What is constructor chaining?** | One constructor calling another using this() or super() |
| **What is final keyword?** | Variable: constant; Method: can't override; Class: can't extend |
| **What is static keyword?** | Member belongs to class, not instance |
| **What is this keyword?** | Reference to current object |
| **What is super keyword?** | Reference to parent object |
| **equals() vs == ?** | equals() compares content, == compares references |
| **What is hashCode()?** | Returns integer representation of object for hash-based collections |
| **What is marker interface?** | Interface with no methods (Serializable, Cloneable) |
| **What is functional interface?** | Interface with single abstract method (Runnable, Callable) |
| **SOLID principles?** | Single Responsibility, Open-Closed, Liskov Substitution, Interface Segregation, Dependency Inversion |

---

## **26. QUICK REFERENCE CHEAT SHEET**

```java
// ========== CLASS AND OBJECT ==========
class Car {
    String brand;
    void start() { }
}
Car car = new Car();

// ========== ENCAPSULATION ==========
private int age;
public int getAge() { return age; }
public void setAge(int age) { this.age = age; }

// ========== INHERITANCE ==========
class Dog extends Animal { }

// ========== POLYMORPHISM ==========
// Overloading
void add(int a) { }
void add(int a, int b) { }

// Overriding
@Override void makeSound() { }

// ========== ABSTRACTION ==========
abstract class Shape {
    abstract void draw();
}

interface Drawable {
    void draw();
}

// ========== CONSTRUCTORS ==========
public Person(String name) {
    this.name = name;
}

// ========== STATIC ==========
static int count;
static void method() { }

// ========== FINAL ==========
final int MAX = 100;
final class Constants { }
final void method() { }

// ========== THIS ==========
this.name = name;
return this;

// ========== SUPER ==========
super();  // parent constructor
super.method();  // parent method

// ========== INSTANCEOF ==========
if (obj instanceof Dog dog) {
    dog.bark();
}

// ========== EQUALS & HASHCODE ==========
@Override
public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;
    Person person = (Person) o;
    return age == person.age && Objects.equals(name, person.name);
}

@Override
public int hashCode() {
    return Objects.hash(name, age);
}

// ========== OBJECT METHODS ==========
toString()
equals()
hashCode()
clone()
getClass()
wait()
notify()
notifyAll()
finalize()
```

---

## **📝 KEY TAKEAWAYS**

1. **Encapsulation** - Bundle data and methods, hide internal details
2. **Inheritance** - IS-A relationship, code reuse
3. **Polymorphism** - Many forms (overloading, overriding)
4. **Abstraction** - Hide complexity, show functionality
5. **Class vs Object** - Blueprint vs instance
6. **Abstract vs Interface** - Common state vs contract
7. **Static** - Class-level members
8. **Final** - Constants, prevent inheritance/override
9. **SOLID** - Design principles for maintainable code
10. **Object methods** - Every class inherits from Object

---

*Good luck with your interview! 🎉*