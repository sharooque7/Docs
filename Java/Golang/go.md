# Complete Golang Guide - The Ultimate Interview Reference 🐹

*Your comprehensive go-to reference for all Go (Golang) concepts with brief explanations and code examples*

---

## **📋 TABLE OF CONTENTS**

1. [What is Go?](#1-what-is-go)
2. [Go vs Other Languages](#2-go-vs-other-languages)
3. [Installation and Setup](#3-installation-and-setup)
4. [Basic Syntax](#4-basic-syntax)
5. [Variables and Data Types](#5-variables-and-data-types)
6. [Control Structures](#6-control-structures)
7. [Functions](#7-functions)
8. [Arrays and Slices](#8-arrays-and-slices)
9. [Maps](#9-maps)
10. [Structs](#10-structs)
11. [Interfaces](#11-interfaces)
12. [Pointers](#12-pointers)
13. [Methods](#13-methods)
14. [Packages and Modules](#14-packages-and-modules)
15. [Error Handling](#15-error-handling)
16. [Defer, Panic, Recover](#16-defer-panic-recover)
17. [Goroutines](#17-goroutines)
18. [Channels](#18-channels)
19. [Select Statement](#19-select-statement)
20. [Mutexes and Sync Package](#20-mutexes-and-sync-package)
21. [Context Package](#21-context-package)
22. [Concurrency Patterns](#22-concurrency-patterns)
23. [File I/O](#23-file-io)
24. [JSON Handling](#24-json-handling)
25. [HTTP Server and Client](#25-http-server-and-client)
26. [Testing and Benchmarking](#26-testing-and-benchmarking)
27. [Reflection](#27-reflection)
28. [Generics (Go 1.18+)](#28-generics-go-118)
29. [Common Interview Questions](#29-common-interview-questions)
30. [Quick Reference Cheat Sheet](#30-quick-reference-cheat-sheet)

---

## **1. WHAT IS GO?**

> **Concept:** Go (Golang) is a statically typed, compiled programming language designed at Google by Robert Griesemer, Rob Pike, and Ken Thompson. It was publicly announced in 2009 and emphasizes simplicity, efficiency, and built-in concurrency. 

```go
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
```

### **Key Features :**

| Feature | Description |
|---------|-------------|
| **Simplicity** | Minimalistic syntax, easy to learn |
| **Concurrency** | Built-in goroutines and channels |
| **Static Typing** | Type safety with type inference |
| **Garbage Collection** | Automatic memory management |
| **Fast Compilation** | Compiles quickly to a single binary |
| **Cross-Platform** | Compile for any OS/architecture |
| **Rich Standard Library** | Extensive built-in packages |

---

## **2. GO VS OTHER LANGUAGES **

> **Concept:** Go is often compared with Java, Python, and other languages due to its unique features and performance characteristics.

| Feature | Go | Java | Python |
|---------|-----|------|--------|
| **Type System** | Statically typed | Statically typed | Dynamically typed |
| **Concurrency Model** | Goroutines (CSP) | Threads | AsyncIO/Threads |
| **Memory Footprint** | Low (2KB per goroutine) | Higher (1MB per thread) | Moderate |
| **Compilation** | Fast, native binary | JVM bytecode | Interpreted |
| **Performance** | Excellent | Excellent | Moderate |
| **Learning Curve** | Gentle | Steep | Gentle |
| **Typical Use Cases** | Cloud infra, APIs | Enterprise, Android | Scripting, Data Science |

**Performance Insights :**
- JSON serialization: Go is 1.8x faster than Java
- Memory usage: Go programs use 40% less memory than equivalent Java programs
- Startup time: Go apps start in milliseconds, Java apps in seconds

---

## **3. INSTALLATION AND SETUP **

> **Concept:** Go installation and workspace setup.

```bash
# Download from https://go.dev/dl/
# Verify installation
go version

# Set up workspace (Go modules replace GOPATH)
go mod init myproject

# Common commands
go build        # Compile package
go run main.go  # Run program
go test         # Run tests
go fmt          # Format code
go get          # Download dependencies
go mod tidy     # Clean up dependencies
```

---

## **4. BASIC SYNTAX **

> **Concept:** Go has a clean, minimal syntax with few keywords.

```go
package main

import (
    "fmt"
    "math"
)

// Constants
const Pi = 3.14159

// Global variable
var appName = "MyApp"

func main() {
    // Local variable with type inference
    message := "Hello, Go!"
    
    // Multiple return values
    sum, product := calculate(5, 3)
    
    fmt.Println(message)
    fmt.Printf("Sum: %d, Product: %d\n", sum, product)
}

func calculate(a, b int) (int, int) {
    return a + b, a * b
}
```

---

## **5. VARIABLES AND DATA TYPES **

> **Concept:** Go supports various data types and variable declaration styles.

### **Basic Data Types**

| Type | Description | Zero Value |
|------|-------------|------------|
| `bool` | Boolean | `false` |
| `string` | String | `""` (empty string) |
| `int`, `int8`, `int16`, `int32`, `int64` | Signed integers | `0` |
| `uint`, `uint8`, `uint16`, `uint32`, `uint64` | Unsigned integers | `0` |
| `float32`, `float64` | Floating point | `0.0` |
| `complex64`, `complex128` | Complex numbers | `0+0i` |
| `byte` | Alias for uint8 | `0` |
| `rune` | Alias for int32 (Unicode) | `0` |

### **Variable Declaration **

```go
// 1. Using var (package or function level)
var name string = "John"
var age = 30  // Type inferred
var isActive bool  // Zero value: false

// 2. Multiple variables
var x, y int = 1, 2
var (
    firstName = "Jane"
    lastName  = "Doe"
    salary    float64
)

// 3. Short declaration (inside functions only) 
username := "alice"
count, err := processData()

// 4. Zero values 
var (
    i int       // 0
    f float64   // 0.0
    b bool      // false
    s string    // ""
    p *int      // nil
)
```

---

## **6. CONTROL STRUCTURES**

> **Concept:** Go has minimal control structures but they're powerful and expressive.

### **If-Else **

```go
if x > 0 {
    fmt.Println("Positive")
} else if x < 0 {
    fmt.Println("Negative")
} else {
    fmt.Println("Zero")
}

// With statement (variable scoped to if block)
if err := process(); err != nil {
    fmt.Println("Error:", err)
}
```

### **For Loop (Go's only loop keyword) **

```go
// Traditional for
for i := 0; i < 10; i++ {
    fmt.Println(i)
}

// While loop
sum := 1
for sum < 1000 {
    sum += sum
}

// Infinite loop
for {
    // break to exit
}

// Range loop
nums := []int{2, 4, 6, 8}
for index, value := range nums {
    fmt.Printf("Index: %d, Value: %d\n", index, value)
}

// Range with map
for key, value := range myMap {
    fmt.Println(key, value)
}
```

### **Switch **

```go
// Basic switch (no break needed)
switch day {
case "Monday", "Tuesday":
    fmt.Println("Weekday")
case "Saturday", "Sunday":
    fmt.Println("Weekend")
default:
    fmt.Println("Invalid day")
}

// Switch with expression
score := 85
switch {
case score >= 90:
    fmt.Println("A")
case score >= 80:
    fmt.Println("B")
case score >= 70:
    fmt.Println("C")
default:
    fmt.Println("F")
}

// Type switch
var i interface{} = "hello"
switch v := i.(type) {
case int:
    fmt.Println("Integer:", v)
case string:
    fmt.Println("String:", v)
default:
    fmt.Println("Unknown type")
}
```

---

## **7. FUNCTIONS **

> **Concept:** Functions are first-class citizens in Go.

```go
// Basic function
func add(a int, b int) int {
    return a + b
}

// Parameter type shorthand
func multiply(a, b int) int {
    return a * b
}

// Multiple return values
func divide(a, b float64) (float64, error) {
    if b == 0 {
        return 0, errors.New("division by zero")
    }
    return a / b, nil
}

// Named return values
func split(sum int) (x, y int) {
    x = sum * 4 / 9
    y = sum - x
    return // naked return
}

// Variadic functions
func sum(nums ...int) int {
    total := 0
    for _, n := range nums {
        total += n
    }
    return total
}

// Function as value
func compute(fn func(float64, float64) float64) float64 {
    return fn(3, 4)
}

// Anonymous function
func main() {
    func(msg string) {
        fmt.Println(msg)
    }("Hello")
}
```

---

## **8. ARRAYS AND SLICES **

### **Arrays **
> Fixed size, determined at compile time.

```go
// Declaration
var arr1 [5]int
arr2 := [3]int{1, 2, 3}
arr3 := [...]int{4, 5, 6, 7} // Compiler counts elements

// Access
fmt.Println(arr2[1]) // 2

// Length
len(arr1) // 5
```

### **Slices **
> Dynamically-sized, flexible view into arrays. Most common collection type.

```go
// Creating slices
var s []int                     // nil slice
s1 := []int{1, 2, 3}           // literal
s2 := make([]int, 5)            // length 5, capacity 5
s3 := make([]int, 3, 5)         // length 3, capacity 5

// From array
arr := [5]int{1, 2, 3, 4, 5}
slice := arr[1:4] // [2, 3, 4]

// Operations 
s := []int{1, 2, 3}
s = append(s, 4)        // [1, 2, 3, 4]
s = append(s, 5, 6, 7)  // [1, 2, 3, 4, 5, 6, 7]

// Copy
src := []int{1, 2, 3}
dst := make([]int, len(src))
copy(dst, src)

// Slice tricks
s = append(s, 0)        // Add element
s = s[:len(s)-1]        // Remove last
s = append(s[:i], s[i+1:]...) // Remove element at index i
```

### **Slice Internals**

```
┌──────────────┐
│ Slice Header │
├──────────────┤
│ ptr ──────┐  │
│ len: 3    │  │
│ cap: 5    │  │
└──────────────┘
      │
      ▼
┌───┬───┬───┬───┬───┐
│ 1 │ 2 │ 3 │ 4 │ 5 │  Underlying array
└───┴───┴───┴───┴───┘
```

---

## **9. MAPS **

> **Concept:** Built-in hash table data structure (key-value pairs).

```go
// Declaration
var m1 map[string]int           // nil map (cannot add to)
m2 := make(map[string]int)       // empty map
m3 := map[string]int{
    "apple": 5,
    "pear":  3,
}

// Operations
m := make(map[string]int)
m["key"] = 42           // Insert/update
value := m["key"]       // Get
delete(m, "key")        // Delete

// Check existence
value, exists := m["key"]
if exists {
    fmt.Println("Value:", value)
}

// Iteration
for key, value := range m {
    fmt.Printf("%s: %d\n", key, value)
}

// Map concurrency 
// Maps are not safe for concurrent use. Use sync.Mutex or sync.Map
var mu sync.Mutex
mu.Lock()
m["key"] = 42
mu.Unlock()
```

**Zero Value**: `nil` (reading returns zero value, writing causes panic) 

---

## **10. STRUCTS **

> **Concept:** Collection of fields, similar to classes in other languages (but without inheritance).

```go
// Definition
type Person struct {
    Name    string
    Age     int
    Email   string
}

// Initialization 
p1 := Person{"Alice", 30, "alice@example.com"}
p2 := Person{Name: "Bob", Age: 25}  // Email gets zero value
p3 := new(Person)                    // Pointer with zero values

// Field access
fmt.Println(p1.Name)
p1.Age = 31

// Struct embedding (composition, not inheritance)
type Employee struct {
    Person
    EmployeeID string
    Salary     float64
}

// Methods on structs
func (p Person) Greet() string {
    return "Hello, I'm " + p.Name
}

// Pointer receivers (to modify)
func (p *Person) Birthday() {
    p.Age++
}

// Tags (for serialization, validation)
type User struct {
    ID    int    `json:"id" db:"user_id"`
    Name  string `json:"name" validate:"required"`
    Email string `json:"email" validate:"email"`
}
```

---

## **11. INTERFACES **

> **Concept:** Interfaces define behavior through method sets. Go interfaces are satisfied implicitly.

```go
// Definition
type Writer interface {
    Write([]byte) (int, error)
}

type Reader interface {
    Read([]byte) (int, error)
}

type ReadWriter interface {
    Reader
    Writer
}

// Implementation (implicit)
type File struct {
    name string
}

func (f *File) Write(data []byte) (int, error) {
    fmt.Println("Writing to", f.name)
    return len(data), nil
}

func (f *File) Read(data []byte) (int, error) {
    fmt.Println("Reading from", f.name)
    return len(data), nil
}

// Using interfaces
func processData(rw ReadWriter) {
    data := []byte("hello")
    rw.Write(data)
    rw.Read(data)
}

// Empty interface (any type) 
var anything interface{}
anything = 42
anything = "hello"
anything = Person{Name: "Alice"}

// Type assertion 
value, ok := anything.(string)
if ok {
    fmt.Println("It's a string:", value)
}

// Type switch 
switch v := anything.(type) {
case int:
    fmt.Println("int:", v)
case string:
    fmt.Println("string:", v)
default:
    fmt.Println("unknown type")
}
```

**Key Point**: "A type implements an interface by implementing its methods. There is no explicit declaration of intent, no "implements" keyword." 

---

## **12. POINTERS **

> **Concept:** Pointers hold memory addresses of values.

```go
// Declaration
var ptr *int
i := 42
ptr = &i  // ptr points to i

// Dereferencing
fmt.Println(*ptr) // 42
*ptr = 21         // i becomes 21

// Pointer to pointer
pptr := &ptr
fmt.Println(**pptr) // 21

// Function with pointer receiver
func zeroValue(val int) {
    val = 0  // modifies copy
}

func zeroPointer(ptr *int) {
    *ptr = 0  // modifies original
}

// Use cases :
// 1. Modify values in functions
// 2. Avoid copying large structs
// 3. Indicate optional parameters (nil pointer)
```

---

## **13. METHODS **

> **Concept:** Functions with a special receiver argument.

```go
type Rectangle struct {
    Width, Height float64
}

// Value receiver (doesn't modify)
func (r Rectangle) Area() float64 {
    return r.Width * r.Height
}

// Pointer receiver (can modify)
func (r *Rectangle) Scale(factor float64) {
    r.Width *= factor
    r.Height *= factor
}

// Method on non-struct type
type MyInt int

func (m MyInt) IsEven() bool {
    return m%2 == 0
}

// Usage
rect := Rectangle{10, 5}
area := rect.Area()
rect.Scale(2)  // Go automatically converts to (&rect).Scale(2)
```

**Method Receivers Table:**

| Receiver Type | Can Modify | Called on Value | Called on Pointer |
|--------------|-------------|-----------------|-------------------|
| Value (T)    | No          | ✅ (copy)       | ✅ (dereferenced) |
| Pointer (*T) | Yes         | ✅ (takes addr)  | ✅               |

---

## **14. PACKAGES AND MODULES **

> **Concept:** Packages organize code, modules manage dependencies.

### **Packages **

```go
// mypackage/mypackage.go
package mypackage

// Exported (capitalized)
var PublicVar = "accessible from other packages"

// Unexported (lowercase)
var privateVar = "only accessible within package"

// Exported function
func PublicFunc() {
    fmt.Println("This is public")
}

// Unexported function
func privateFunc() {
    fmt.Println("This is private")
}

// init function (runs when package is imported) 
func init() {
    fmt.Println("Package initialized")
}
```

### **Modules **

```bash
# Create a new module
go mod init github.com/user/project

# Add dependencies
go get github.com/gorilla/mux

# Update dependencies
go get -u

# Clean up dependencies
go mod tidy

# go.mod file
module github.com/user/project

go 1.21

require (
    github.com/gorilla/mux v1.8.0
    github.com/lib/pq v1.10.0
)
```

### **Importing **

```go
// Single import
import "fmt"

// Multiple imports
import (
    "fmt"
    "math/rand"
    "time"
    
    // Third-party
    "github.com/gorilla/mux"
    
    // Aliased import
    myfmt "mylib/fmt"
)

// Dot import (not recommended)
import . "fmt"
Println("Hello")  // no package prefix

// Blank import (for side effects)
import _ "image/png"
```

---

## **15. ERROR HANDLING **

> **Concept:** Go handles errors explicitly by returning error values, not exceptions.

```go
// Basic error handling
f, err := os.Open("file.txt")
if err != nil {
    log.Fatal(err)  // Handle error
}
defer f.Close()

// Custom errors
type ValidationError struct {
    Field string
    Value interface{}
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("invalid value %v for field %s", e.Value, e.Field)
}

// Returning errors
func validateAge(age int) error {
    if age < 0 {
        return &ValidationError{Field: "age", Value: age}
    }
    if age > 150 {
        return fmt.Errorf("age %d is too high", age)
    }
    return nil  // nil means no error
}

// Error inspection (Go 1.13+) 
var valErr *ValidationError
if errors.As(err, &valErr) {
    fmt.Printf("Validation failed: %s\n", valErr.Field)
}

if errors.Is(err, os.ErrNotExist) {
    fmt.Println("File doesn't exist")
}

// Sentinel errors
var ErrNotFound = errors.New("item not found")

func findItem(id int) (*Item, error) {
    // ...
    return nil, ErrNotFound
}
```

**Error Handling Patterns :**

| Pattern | Description |
|---------|-------------|
| **Return error** | Functions return error as last value |
| **Check immediately** | Always check err != nil after call |
| **Wrap errors** | Add context with fmt.Errorf("... %w", err) |
| **Custom types** | Create custom error types for more context |
| **Sentinel errors** | Define package-level error variables |

---

## **16. DEFER, PANIC, RECOVER **

### **Defer **
> Schedules function call to run just before function returns.

```go
func readFile(filename string) error {
    f, err := os.Open(filename)
    if err != nil {
        return err
    }
    defer f.Close()  // Executes when function returns
    
    // Do work...
    return nil
}

// Multiple defers (LIFO order)
func example() {
    defer fmt.Println("1")
    defer fmt.Println("2")
    defer fmt.Println("3")
    // Prints: 3, 2, 1
}

// Defer with function arguments (evaluated immediately)
func count() int {
    i := 0
    defer fmt.Println(i)  // prints 0, not 1
    i++
    return i
}
```

### **Panic **
> Unrecoverable error that stops normal execution.

```go
func process(data []byte) {
    if len(data) == 0 {
        panic("empty data")  // Unrecoverable
    }
    // ...
}
```

### **Recover **
> Regain control after panic (only useful in deferred functions).

```go
func safeCall() {
    defer func() {
        if r := recover(); r != nil {
            fmt.Println("Recovered from:", r)
        }
    }()
    
    mightPanic()  // If this panics, we recover
}
```

**When to use panic :**
- **Unrecoverable errors** (program cannot continue)
- **Programmer errors** (array index out of bounds)
- **Initialization failures** (cannot start without config)

**When NOT to use panic:**
- Expected errors (file not found, validation failures)

---

## **17. GOROUTINES **

> **Concept:** Lightweight threads managed by Go runtime. A goroutine starts with only 2KB of stack (vs 1MB+ for OS threads). 

```go
// Start a goroutine
go func() {
    fmt.Println("Running concurrently")
}()

// Function as goroutine
func process(id int) {
    fmt.Printf("Worker %d starting\n", id)
    time.Sleep(time.Second)
    fmt.Printf("Worker %d done\n", id)
}

func main() {
    for i := 1; i <= 5; i++ {
        go process(i)  // All 5 run concurrently
    }
    
    time.Sleep(2 * time.Second)  // Wait for goroutines
}
```

### **Goroutine vs OS Thread **

| Feature | Goroutine | OS Thread |
|---------|-----------|-----------|
| **Stack Size** | 2KB (grows) | ~1MB |
| **Creation Cost** | ~2KB memory | ~1MB memory |
| **Scheduling** | Go runtime | OS kernel |
| **Context Switch** | ~200ns | ~1-2µs |
| **Concurrency** | Thousands | Hundreds |

### **Synchronization Primitives**

```go
// WaitGroup 
var wg sync.WaitGroup

for i := 1; i <= 5; i++ {
    wg.Add(1)
    go func(id int) {
        defer wg.Done()
        fmt.Printf("Worker %d\n", id)
    }(i)
}

wg.Wait()  // Wait for all goroutines
fmt.Println("All done")
```

---

## **18. CHANNELS **

> **Concept:** Typed conduits for communication between goroutines. "Don't communicate by sharing memory; share memory by communicating."

### **Channel Types **

| Type | Description | Declaration |
|------|-------------|-------------|
| **Unbuffered** | Synchronous (send/receive block) | `make(chan int)` |
| **Buffered** | Asynchronous up to capacity | `make(chan int, 10)` |

### **Basic Operations **

```go
// Create channels
unbuffered := make(chan string)
buffered := make(chan int, 5)

// Send
ch <- value

// Receive
value := <-ch

// Close
close(ch)

// Check if closed
value, ok := <-ch  // ok is false if closed and empty
```

### **Examples**

```go
// Unbuffered channel (synchronous)
func worker(done chan bool) {
    fmt.Print("working...")
    time.Sleep(time.Second)
    fmt.Println("done")
    done <- true  // Send signal
}

func main() {
    done := make(chan bool)
    go worker(done)
    <-done  // Wait for worker
}

// Buffered channel
ch := make(chan int, 3)
ch <- 1
ch <- 2
ch <- 3
// ch <- 4  // Would block (buffer full)

fmt.Println(<-ch)  // 1
fmt.Println(<-ch)  // 2
fmt.Println(<-ch)  // 3

// Range over channel
ch := make(chan int)
go func() {
    for i := 0; i < 5; i++ {
        ch <- i
    }
    close(ch)
}()

for value := range ch {
    fmt.Println(value)
}

// Worker pool pattern 
func worker(id int, jobs <-chan int, results chan<- int) {
    for job := range jobs {
        fmt.Printf("worker %d processing job %d\n", id, job)
        time.Sleep(time.Second)
        results <- job * 2
    }
}

func main() {
    jobs := make(chan int, 100)
    results := make(chan int, 100)
    
    // Start workers
    for w := 1; w <= 3; w++ {
        go worker(w, jobs, results)
    }
    
    // Send jobs
    for j := 1; j <= 5; j++ {
        jobs <- j
    }
    close(jobs)
    
    // Collect results
    for r := 1; r <= 5; r++ {
        <-results
    }
}
```

---

## **19. SELECT STATEMENT **

> **Concept:** Lets a goroutine wait on multiple channel operations.

```go
// Basic select
select {
case msg1 := <-ch1:
    fmt.Println("Received from ch1:", msg1)
case msg2 := <-ch2:
    fmt.Println("Received from ch2:", msg2)
case ch3 <- 42:
    fmt.Println("Sent to ch3")
default:
    fmt.Println("No channel ready")
}

// Timeout pattern 
select {
case res := <-result:
    fmt.Println(res)
case <-time.After(1 * time.Second):
    fmt.Println("Timeout")
}

// Non-blocking send/receive
select {
case msg := <-ch:
    fmt.Println("Received:", msg)
default:
    fmt.Println("No message waiting")
}

// Infinite loop with select
for {
    select {
    case msg := <-incoming:
        process(msg)
    case <-stop:
        fmt.Println("Stopping")
        return
    }
}
```

### **Select Rules **
- If multiple cases ready, picks one pseudo-randomly
- If none ready, blocks unless `default` present
- `nil` channels are never ready
- Closed channel always ready (returns zero value)

---

## **20. MUTEXES AND SYNC PACKAGE **

> **Concept:** Traditional locking for shared memory access.

```go
// Mutex 
type Counter struct {
    mu    sync.Mutex
    value int
}

func (c *Counter) Increment() {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.value++
}

func (c *Counter) Value() int {
    c.mu.Lock()
    defer c.mu.Unlock()
    return c.value
}

// RWMutex (reader/writer locks)
type Cache struct {
    mu    sync.RWMutex
    data  map[string]string
}

func (c *Cache) Get(key string) string {
    c.mu.RLock()
    defer c.mu.RUnlock()
    return c.data[key]
}

func (c *Cache) Set(key, value string) {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.data[key] = value
}

// Once (run exactly once)
var once sync.Once
var config *Config

func getConfig() *Config {
    once.Do(func() {
        config = loadConfig()  // Runs only once
    })
    return config
}

// Pool (object pooling) 
var bufPool = sync.Pool{
    New: func() interface{} {
        return make([]byte, 1024)
    },
}

func processRequest() {
    buf := bufPool.Get().([]byte)
    defer bufPool.Put(buf)
    // Use buffer...
}
```

### **Mutex vs Channel **

| Approach | Use When |
|----------|----------|
| **Mutex** | Protecting shared data, simple state |
| **Channel** | Communication, passing ownership, coordination |

---

## **21. CONTEXT PACKAGE **

> **Concept:** Manages deadlines, cancellation signals, and request-scoped values across API boundaries.

```go
// Creating contexts
ctx := context.Background()      // Empty root context
ctx := context.TODO()             // When unsure which context to use
ctx := context.WithCancel(parent)
ctx := context.WithTimeout(parent, 5*time.Second)
ctx := context.WithDeadline(parent, time.Now().Add(5*time.Second))
ctx := context.WithValue(parent, key, value)  // For request-scoped values

// Cancellation example 
func longRunningTask(ctx context.Context) error {
    select {
    case <-time.After(10 * time.Second):
        return nil  // Completed
    case <-ctx.Done():
        return ctx.Err()  // Cancelled or timed out
    }
}

func main() {
    ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
    defer cancel()  // Important: always call cancel
    
    err := longRunningTask(ctx)
    if err == context.DeadlineExceeded {
        fmt.Println("Task timed out")
    }
}

// HTTP server with context
func handler(w http.ResponseWriter, r *http.Request) {
    ctx := r.Context()
    
    // Do work with context
    select {
    case <-time.After(5 * time.Second):
        fmt.Fprintln(w, "Done")
    case <-ctx.Done():
        // Client disconnected
        return
    }
}

// WithValue (for request-scoped data)
type contextKey string

const userIDKey = contextKey("userID")

func middleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        userID := extractUserID(r)
        ctx := context.WithValue(r.Context(), userIDKey, userID)
        next.ServeHTTP(w, r.WithContext(ctx))
    })
}

func handler(w http.ResponseWriter, r *http.Request) {
    userID := r.Context().Value(userIDKey).(string)
    fmt.Fprintf(w, "Hello %s", userID)
}
```

### **Context Rules **
- Always call cancel to release resources
- Don't store contexts in structs
- Use WithValue only for request-scoped data (not optional parameters)
- Contexts are safe for concurrent use

---

## **22. CONCURRENCY PATTERNS **

> **Concept:** Common patterns using goroutines and channels.

### **Pipeline Pattern **

```go
func generate(nums ...int) <-chan int {
    out := make(chan int)
    go func() {
        for _, n := range nums {
            out <- n
        }
        close(out)
    }()
    return out
}

func square(in <-chan int) <-chan int {
    out := make(chan int)
    go func() {
        for n := range in {
            out <- n * n
        }
        close(out)
    }()
    return out
}

func main() {
    for n := range square(generate(1, 2, 3, 4)) {
        fmt.Println(n)  // 1, 4, 9, 16
    }
}
```

### **Fan-out/Fan-in Pattern **

```go
func fanOut(in <-chan int, workers int) []<-chan int {
    channels := make([]<-chan int, workers)
    for i := 0; i < workers; i++ {
        ch := make(chan int)
        channels[i] = ch
        go func(out chan int) {
            for val := range in {
                out <- val * val  // Process
            }
            close(out)
        }(ch)
    }
    return channels
}

func fanIn(channels []<-chan int) <-chan int {
    out := make(chan int)
    var wg sync.WaitGroup
    for _, ch := range channels {
        wg.Add(1)
        go func(c <-chan int) {
            for val := range c {
                out <- val
            }
            wg.Done()
        }(ch)
    }
    go func() {
        wg.Wait()
        close(out)
    }()
    return out
}
```

### **Worker Pool Pattern **

```go
func workerPool(jobs <-chan int, results chan<- int, size int) {
    var wg sync.WaitGroup
    for i := 0; i < size; i++ {
        wg.Add(1)
        go func() {
            defer wg.Done()
            for job := range jobs {
                results <- job * 2  // Process
            }
        }()
    }
    go func() {
        wg.Wait()
        close(results)
    }()
}
```

### **Rate Limiting Pattern **

```go
// Token bucket rate limiter
func rateLimit(requests <-chan int, limit time.Duration) <-chan int {
    ticker := time.NewTicker(limit)
    results := make(chan int)
    
    go func() {
        for req := range requests {
            <-ticker.C  // Wait for next token
            results <- req
        }
        ticker.Stop()
        close(results)
    }()
    return results
}
```

### **Supervisor Pattern **

```go
func supervisor(worker func() error, restarts int) {
    for i := 0; i <= restarts; i++ {
        done := make(chan error)
        go func() {
            done <- worker()
        }()
        
        select {
        case err := <-done:
            if err != nil {
                fmt.Printf("Worker failed (attempt %d): %v\n", i, err)
                continue  // Restart
            }
            return  // Success
        case <-time.After(5 * time.Second):
            fmt.Printf("Worker timed out (attempt %d)\n", i)
            continue  // Restart
        }
    }
    fmt.Println("Worker exhausted all restarts")
}
```

---

## **23. FILE I/O **

> **Concept:** Reading from and writing to files using the os package.

```go
// Read entire file
data, err := os.ReadFile("file.txt")
if err != nil {
    log.Fatal(err)
}
fmt.Println(string(data))

// Write entire file
err := os.WriteFile("output.txt", []byte("Hello World"), 0644)

// Open file for reading
f, err := os.Open("file.txt")
if err != nil {
    log.Fatal(err)
}
defer f.Close()

// Read with buffer
buf := make([]byte, 1024)
n, err := f.Read(buf)
fmt.Printf("Read %d bytes: %s\n", n, string(buf[:n]))

// Create file for writing
f, err := os.Create("output.txt")
if err != nil {
    log.Fatal(err)
}
defer f.Close()

_, err = f.WriteString("Hello, World!\n")
_, err = f.Write([]byte("Another line\n"))

// Buffered I/O
f, err := os.Open("large.txt")
if err != nil {
    log.Fatal(err)
}
defer f.Close()

r := bufio.NewReader(f)
for {
    line, err := r.ReadString('\n')
    if err == io.EOF {
        break
    }
    fmt.Print(line)
}

// Scanner (line by line)
f, err := os.Open("file.txt")
if err != nil {
    log.Fatal(err)
}
defer f.Close()

scanner := bufio.NewScanner(f)
for scanner.Scan() {
    fmt.Println(scanner.Text())
}
if err := scanner.Err(); err != nil {
    log.Fatal(err)
}
```

---

## **24. JSON HANDLING **

> **Concept:** Encoding and decoding JSON data.

```go
// Struct with JSON tags
type Person struct {
    Name    string   `json:"name"`
    Age     int      `json:"age"`
    Email   string   `json:"email,omitempty"`  // Omit if empty
    Tags    []string `json:"tags,omitempty"`
    private string   `json:"-"`  // Always omit
}

// Marshal (struct → JSON)
p := Person{
    Name: "Alice",
    Age:  30,
    Tags: []string{"go", "programmer"},
}

jsonData, err := json.Marshal(p)
if err != nil {
    log.Fatal(err)
}
fmt.Println(string(jsonData))  // {"name":"Alice","age":30,"tags":["go","programmer"]}

// MarshalIndent (pretty print)
jsonData, _ = json.MarshalIndent(p, "", "  ")

// Unmarshal (JSON → struct)
jsonStr := `{"name":"Bob","age":25}`
var p2 Person
err := json.Unmarshal([]byte(jsonStr), &p2)

// Map for dynamic JSON
var result map[string]interface{}
jsonStr := `{"name":"Alice","age":30,"active":true}`
json.Unmarshal([]byte(jsonStr), &result)

name := result["name"].(string)
age := result["age"].(float64)  // JSON numbers become float64

// Streaming JSON
type Record struct {
    ID   int    `json:"id"`
    Name string `json:"name"`
}

// Decode from file
f, _ := os.Open("data.json")
defer f.Close()
decoder := json.NewDecoder(f)

for decoder.More() {
    var r Record
    if err := decoder.Decode(&r); err != nil {
        log.Fatal(err)
    }
    fmt.Printf("Record: %+v\n", r)
}

// Encode to file
f, _ := os.Create("output.json")
encoder := json.NewEncoder(f)
encoder.SetIndent("", "  ")

for _, r := range records {
    if err := encoder.Encode(r); err != nil {
        log.Fatal(err)
    }
}
```

---

## **25. HTTP SERVER AND CLIENT **

> **Concept:** Built-in HTTP server and client in net/http package.

### **HTTP Server**

```go
// Simple handler
func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello, %s!", r.URL.Path[1:])
}

func main() {
    http.HandleFunc("/", handler)
    log.Fatal(http.ListenAndServe(":8080", nil))
}

// Custom handler type
type HelloHandler struct {
    greeting string
}

func (h *HelloHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "%s, %s!", h.greeting, r.URL.Path[1:])
}

// Multiple handlers
func main() {
    hello := &HelloHandler{greeting: "Hello"}
    hola := &HelloHandler{greeting: "Hola"}
    
    http.Handle("/hello/", hello)
    http.Handle("/hola/", hola)
    
    // Using DefaultServeMux
    http.HandleFunc("/api/users", usersHandler)
    http.HandleFunc("/api/products", productsHandler)
    
    // Custom server configuration
    server := &http.Server{
        Addr:         ":8080",
        ReadTimeout:  10 * time.Second,
        WriteTimeout: 10 * time.Second,
        Handler:      myHandler,
    }
    server.ListenAndServe()
}

// Middleware pattern
func loggingMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        log.Printf("%s %s", r.Method, r.URL.Path)
        next.ServeHTTP(w, r)
    })
}

func authMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        token := r.Header.Get("Authorization")
        if token == "" {
            http.Error(w, "Unauthorized", http.StatusUnauthorized)
            return
        }
        next.ServeHTTP(w, r)
    })
}

// Using middleware
http.Handle("/", loggingMiddleware(http.HandlerFunc(handler)))
```

### **HTTP Client **

```go
// Simple GET
resp, err := http.Get("https://api.example.com/users")
if err != nil {
    log.Fatal(err)
}
defer resp.Body.Close()

body, err := io.ReadAll(resp.Body)
fmt.Println(string(body))

// GET with headers
req, _ := http.NewRequest("GET", "https://api.example.com/users", nil)
req.Header.Set("Authorization", "Bearer token")
req.Header.Set("Accept", "application/json")

client := &http.Client{}
resp, err := client.Do(req)

// POST with JSON
data := map[string]interface{}{
    "name": "Alice",
    "age":  30,
}
jsonData, _ := json.Marshal(data)

resp, err := http.Post(
    "https://api.example.com/users",
    "application/json",
    bytes.NewBuffer(jsonData),
)

// Custom client with timeout
client := &http.Client{
    Timeout: 10 * time.Second,
    Transport: &http.Transport{
        MaxIdleConns:        100,
        MaxIdleConnsPerHost: 10,
        IdleConnTimeout:     90 * time.Second,
    },
}
```

---

## **26. TESTING AND BENCHMARKING **

> **Concept:** Built-in testing package with support for tests, benchmarks, and examples.

### **Unit Tests **

```go
// math.go
package math

func Add(a, b int) int {
    return a + b
}

// math_test.go
package math

import "testing"

// Test function
func TestAdd(t *testing.T) {
    result := Add(2, 3)
    expected := 5
    
    if result != expected {
        t.Errorf("Add(2,3) = %d; want %d", result, expected)
    }
}

// Table-driven tests 
func TestAddTable(t *testing.T) {
    tests := []struct {
        name     string
        a, b     int
        expected int
    }{
        {"positive", 2, 3, 5},
        {"negative", -1, -2, -3},
        {"mixed", 5, -3, 2},
        {"zero", 0, 0, 0},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := Add(tt.a, tt.b)
            if result != tt.expected {
                t.Errorf("Add(%d,%d) = %d; want %d", 
                         tt.a, tt.b, result, tt.expected)
            }
        })
    }
}

// Test helpers 
func assertEqual(t *testing.T, got, want interface{}) {
    t.Helper()  // Mark as helper (failure reported at caller)
    if got != want {
        t.Errorf("got %v, want %v", got, want)
    }
}
```

### **Benchmarks **

```go
func BenchmarkAdd(b *testing.B) {
    for i := 0; i < b.N; i++ {
        Add(2, 3)
    }
}

func BenchmarkAddParallel(b *testing.B) {
    b.RunParallel(func(pb *testing.PB) {
        for pb.Next() {
            Add(2, 3)
        }
    })
}
```

### **Example Tests **

```go
// Example function (shown in godoc)
func ExampleAdd() {
    sum := Add(2, 3)
    fmt.Println(sum)
    // Output: 5
}
```

### **Running Tests**

```bash
# Run all tests
go test

# Verbose output
go test -v

# Run specific test
go test -run TestAdd

# Benchmark
go test -bench=.

# With memory stats
go test -bench=. -benchmem

# Coverage
go test -cover
go test -coverprofile=coverage.out
go tool cover -html=coverage.out
```

---

## **27. REFLECTION **

> **Concept:** Runtime type introspection using the reflect package.

```go
import "reflect"

func inspect(v interface{}) {
    t := reflect.TypeOf(v)
    fmt.Println("Type:", t.Name())
    fmt.Println("Kind:", t.Kind())
    
    // For structs
    if t.Kind() == reflect.Struct {
        for i := 0; i < t.NumField(); i++ {
            field := t.Field(i)
            fmt.Printf("Field %d: %s (%s)\n", 
                i, field.Name, field.Type)
            
            // Get tag
            tag := field.Tag.Get("json")
            if tag != "" {
                fmt.Printf("  JSON tag: %s\n", tag)
            }
        }
    }
}

// Reading values
func printValues(v interface{}) {
    val := reflect.ValueOf(v)
    
    // Dereference pointer
    if val.Kind() == reflect.Ptr {
        val = val.Elem()
    }
    
    switch val.Kind() {
    case reflect.Struct:
        for i := 0; i < val.NumField(); i++ {
            field := val.Field(i)
            fmt.Printf("Field %d: %v\n", i, field.Interface())
        }
    case reflect.Slice:
        for i := 0; i < val.Len(); i++ {
            fmt.Printf("[%d]: %v\n", i, val.Index(i).Interface())
        }
    }
}

// Setting values
func setField(obj interface{}, name string, value interface{}) error {
    val := reflect.ValueOf(obj).Elem()
    field := val.FieldByName(name)
    
    if !field.IsValid() {
        return fmt.Errorf("field %s not found", name)
    }
    if !field.CanSet() {
        return fmt.Errorf("field %s cannot be set", name)
    }
    
    field.Set(reflect.ValueOf(value))
    return nil
}

// Create instance from type
func createInstance(t reflect.Type) interface{} {
    return reflect.New(t).Interface()
}

// Example
p := Person{Name: "Alice", Age: 30}
inspect(p)
printValues(p)
setField(&p, "Age", 31)
```

**Use Cases:**
- JSON serialization (struct tags)
- ORM (mapping structs to database)
- Generic utilities
- Testing frameworks

---

## **28. GENERICS (GO 1.18+) **

> **Concept:** Type parameters for functions and types, introduced in Go 1.18.

```go
// Generic function
func Map[T any, U any](s []T, f func(T) U) []U {
    result := make([]U, len(s))
    for i, v := range s {
        result[i] = f(v)
    }
    return result
}

// Usage
nums := []int{1, 2, 3, 4}
doubled := Map(nums, func(x int) int { return x * 2 })
strings := Map(nums, func(x int) string { return fmt.Sprintf("%d", x) })

// Generic type
type Stack[T any] struct {
    items []T
}

func (s *Stack[T]) Push(item T) {
    s.items = append(s.items, item)
}

func (s *Stack[T]) Pop() T {
    if len(s.items) == 0 {
        var zero T
        return zero
    }
    item := s.items[len(s.items)-1]
    s.items = s.items[:len(s.items)-1]
    return item
}

// Interface constraint
type Number interface {
    int | int64 | float64
}

func Sum[T Number](values []T) T {
    var sum T
    for _, v := range values {
        sum += v
    }
    return sum
}

// Comparable constraint
func Contains[T comparable](slice []T, item T) bool {
    for _, v := range slice {
        if v == item {
            return true
        }
    }
    return false
}
```

### **Predeclared Constraints**

| Constraint | Description |
|------------|-------------|
| `any` | Any type (alias for `interface{}`) |
| `comparable` | Types that support `==` and `!=` |
| `~int` | Any type whose underlying type is int |

---

## **29. COMMON INTERVIEW QUESTIONS**

### **Fundamentals **

| Question | Answer |
|----------|--------|
| **What is Go?** | Statically typed, compiled language by Google with built-in concurrency and simplicity |
| **What are goroutines?** | Lightweight threads managed by Go runtime (2KB stack vs 1MB for OS threads)  |
| **What are channels?** | Typed conduits for communication between goroutines |
| **Difference between := and = ?** | := declares and assigns; = assigns to existing variable  |
| **What is defer?** | Schedules function call to run just before function returns  |
| **What is the zero value?** | Default value: 0 for numbers, "" for strings, nil for pointers/slices/maps  |
| **Array vs Slice?** | Array: fixed size; Slice: dynamic, more flexible  |
| **Exported vs unexported?** | Uppercase = exported (public); lowercase = unexported (private)  |

### **Concurrency **

| Question | Answer |
|----------|--------|
| **Goroutine vs Thread?** | Goroutine: user-space, 2KB stack; Thread: kernel-space, 1MB+ stack  |
| **Unbuffered vs Buffered channel?** | Unbuffered: synchronous (send/receive block); Buffered: asynchronous up to capacity  |
| **What is select?** | Waits on multiple channel operations, picks one at random  |
| **How to prevent data race?** | Mutex, channels, atomic operations |
| **What is context?** | Carries deadlines, cancellation, request-scoped values  |
| **How to wait for multiple goroutines?** | sync.WaitGroup  |
| **What is worker pool pattern?** | Fixed number of goroutines processing tasks from a channel  |

### **Error Handling **

| Question | Answer |
|----------|--------|
| **How does Go handle errors?** | Functions return error as last value, checked explicitly |
| **Difference between error and panic?** | error: expected problems; panic: unexpected/unrecoverable |
| **What is errors.Is and errors.As?** | Check/wrap error chains for specific errors or types |
| **When to use panic?** | Only for truly exceptional conditions (startup failures, programmer errors) |

### **Performance **

| Question | Answer |
|----------|--------|
| **How to optimize Go programs?** | Use pprof, avoid allocations, use sync.Pool, proper goroutine management |
| **What is escape analysis?** | Compiler determines if variable can be allocated on stack vs heap |
| **How to reduce allocations?** | Use object pooling, reuse buffers, avoid unnecessary conversions |
| **Go vs Java performance?** | Go: better for I/O, JSON; Java: better for CPU-intensive (JIT)  |

---

## **30. QUICK REFERENCE CHEAT SHEET**

```go
// ========== VARIABLES ==========
var name string = "John"
age := 30
var x, y int = 1, 2

// ========== CONTROL FLOW ==========
if err != nil { }
for i := 0; i < 10; i++ { }
for key, value := range map { }
switch day { case "Mon": }

// ========== FUNCTIONS ==========
func add(a, b int) int { return a + b }
func divide(a, b int) (int, error) { }

// ========== SLICES ==========
s := make([]int, 5)
s = append(s, 1, 2, 3)

// ========== MAPS ==========
m := make(map[string]int)
m["key"] = 42
value, ok := m["key"]
delete(m, "key")

// ========== STRUCTS ==========
type Person struct { Name string; Age int }
p := Person{Name: "Alice", Age: 30}

// ========== INTERFACES ==========
type Writer interface { Write([]byte) (int, error) }

// ========== GOROUTINES ==========
go func() { fmt.Println("Hello") }()

// ========== CHANNELS ==========
ch := make(chan int)
ch <- 42
value := <-ch

// ========== SELECT ==========
select {
case v := <-ch1:
case ch2 <- 42:
default:
}

// ========== DEFER ==========
defer file.Close()

// ========== ERROR HANDLING ==========
if err != nil { return err }
return fmt.Errorf("wrap: %w", err)

// ========== CONTEXT ==========
ctx, cancel := context.WithTimeout(parent, time.Second)
defer cancel()

// ========== SYNC ==========
var mu sync.Mutex
mu.Lock(); defer mu.Unlock()

var wg sync.WaitGroup
wg.Add(1); defer wg.Done(); wg.Wait()

// ========== FILE I/O ==========
data, _ := os.ReadFile("file.txt")
os.WriteFile("out.txt", data, 0644)

// ========== JSON ==========
json.Marshal(v)
json.Unmarshal(data, &v)

// ========== HTTP ==========
http.HandleFunc("/", handler)
http.ListenAndServe(":8080", nil)

// ========== TESTING ==========
func TestX(t *testing.T) { }
func BenchmarkX(b *testing.B) { }
```

---

## **📝 KEY TAKEAWAYS**

1. **Simplicity** – Go has minimal syntax, few keywords, focuses on readability
2. **Concurrency** – Goroutines and channels are built-in, lightweight, and powerful 
3. **Performance** – Compiled to native code, fast execution, low memory footprint 
4. **Error Handling** – Explicit error returns, no exceptions
5. **Interfaces** – Implicit satisfaction, powerful abstraction
6. **No Inheritance** – Composition over inheritance
7. **Standard Library** – Rich, well-designed, covers most needs
8. **Tooling** – Built-in formatting, testing, profiling
9. **Static Typing** – Type safety with type inference
10. **Garbage Collection** – Automatic memory management, low latency 

---

*Good luck with your Go interview! 🐹🎉*