# **Complete Java IO - The Ultimate Interview Guide** 📚

*Your comprehensive go-to reference for all Java IO concepts with brief explanations and code examples*

---

## **📋 TABLE OF CONTENTS**

1. [Java IO Overview](#1-java-io-overview)
2. [Byte Streams (InputStream/OutputStream)](#2-byte-streams)
3. [Character Streams (Reader/Writer)](#3-character-streams)
4. [File Class](#4-file-class)
5. [RandomAccessFile](#5-randomaccessfile)
6. [Buffered Streams](#6-buffered-streams)
7. [Data Streams](#7-data-streams)
8. [Object Streams (Serialization)](#8-object-streams-serialization)
9. [ByteArray Streams](#9-bytearray-streams)
10. [Piped Streams](#10-piped-streams)
11. [SequenceInputStream](#11-sequenceinputstream)
12. [PrintStream / PrintWriter](#12-printstream--printwriter)
13. [Pushback Streams](#13-pushback-streams)
14. [LineNumberReader](#14-linenumberreader)
15. [StreamTokenizer](#15-streamtokenizer)
16. [Console Class](#16-console-class)
17. [Scanner Class](#17-scanner-class)
18. [Java NIO (New IO)](#18-java-nio-new-io)
19. [Java NIO.2 (File System API)](#19-java-nio2-file-system-api)
20. [File Locking](#20-file-locking)
21. [Memory-Mapped Files](#21-memory-mapped-files)
22. [Compressed Streams (ZIP/GZIP)](#22-compressed-streams-zipgzip)
23. [Readers for Different Encodings](#23-readers-for-different-encodings)
24. [Standard Streams (System.in/out/err)](#24-standard-streams-systeminouterr)
25. [IO vs NIO Comparison](#25-io-vs-nio-comparison)
26. [Common Interview Questions](#26-common-interview-questions)
27. [Quick Reference Cheat Sheet](#27-quick-reference-cheat-sheet)

---

## **1. JAVA IO OVERVIEW**

> **Concept:** Java IO (Input/Output) provides APIs for reading and writing data from various sources (files, network, memory, console).

### **IO Stream Categories**

| Category | Base Classes | Data Type |
|----------|--------------|-----------|
| **Byte Streams** | `InputStream`, `OutputStream` | Binary data (8-bit bytes) |
| **Character Streams** | `Reader`, `Writer` | Text data (16-bit Unicode) |

### **Stream Direction**

```
Source (File, Memory, Keyboard) → InputStream/Reader → Program
Program → OutputStream/Writer → Destination (File, Console, Network)
```

```java
// Simple example - reading from file
try (FileInputStream fis = new FileInputStream("input.txt")) {
    int data;
    while ((data = fis.read()) != -1) {
        System.out.print((char) data);
    }
} catch (IOException e) {
    e.printStackTrace();
}
```

---

## **2. BYTE STREAMS**

> **Concept:** Handle I/O of raw binary data (8-bit bytes). Base classes: `InputStream` and `OutputStream`.

### **InputStream Hierarchy**

```
                    InputStream (abstract)
                    ┌───────┴───────┐
                    │               │
         ┌──────────▼────┐    ┌─────▼──────────┐
         │ FileInputStream│    │FilterInputStream│
         └────────────────┘    └───────┬────────┘
                                       │
              ┌──────────┬───────┴───────┬──────────┬──────────┐
         ┌────▼─────┐┌───▼────┐┌────▼─────┐┌───▼────┐┌───▼────┐
         │Buffered- ││Data-   ││Pushback- ││LineNum-││Object- │
         │InputStream││InputStream││InputStream││berInput-││InputStream│
         └──────────┘└────────┘└──────────┘│Stream   │└────────┘
                                           └─────────┘
                   
         ┌──────────▼────┐    ┌─────▼──────────┐
         │ByteArrayInput-│    │PipedInputStream│
         │Stream         │    └─────────────────┘
         └───────────────┘
         
         ┌──────────▼────┐    ┌─────▼──────────┐
         │SequenceInput- │    │AudioInputStream│
         │Stream         │    └─────────────────┘
         └───────────────┘
```

### **2.1 FileInputStream**

> **Concept:** Reads bytes from a file.

```java
// Reading byte by byte
try (FileInputStream fis = new FileInputStream("file.txt")) {
    int byteData;
    while ((byteData = fis.read()) != -1) {
        System.out.print((char) byteData);
    }
} catch (IOException e) {
    e.printStackTrace();
}

// Reading with buffer (more efficient)
try (FileInputStream fis = new FileInputStream("file.txt")) {
    byte[] buffer = new byte[1024];
    int bytesRead;
    while ((bytesRead = fis.read(buffer)) != -1) {
        System.out.print(new String(buffer, 0, bytesRead));
    }
} catch (IOException e) {
    e.printStackTrace();
}

// Getting file size
File file = new File("file.txt");
try (FileInputStream fis = new FileInputStream(file)) {
    long size = file.length();
    byte[] allBytes = new byte[(int) size];
    fis.read(allBytes);
}

// Skip bytes
try (FileInputStream fis = new FileInputStream("file.txt")) {
    fis.skip(10);  // Skip first 10 bytes
    int data = fis.read();  // Reads 11th byte
}
```

### **2.2 FileOutputStream**

> **Concept:** Writes bytes to a file.

```java
// Write bytes to file
try (FileOutputStream fos = new FileOutputStream("output.txt")) {
    fos.write(65);  // Writes 'A'
    fos.write(66);  // Writes 'B'
} catch (IOException e) {
    e.printStackTrace();
}

// Write byte array
try (FileOutputStream fos = new FileOutputStream("output.txt")) {
    String data = "Hello World";
    fos.write(data.getBytes());
} catch (IOException e) {
    e.printStackTrace();
}

// Append to existing file
try (FileOutputStream fos = new FileOutputStream("output.txt", true)) {
    fos.write("Appended text".getBytes());
} catch (IOException e) {
    e.printStackTrace();
}

// Write with offset and length
byte[] data = {65, 66, 67, 68, 69, 70};  // A,B,C,D,E,F
try (FileOutputStream fos = new FileOutputStream("output.txt")) {
    fos.write(data, 2, 3);  // Write C,D,E (index 2, length 3)
} catch (IOException e) {
    e.printStackTrace();
}
```

### **2.3 ByteArrayInputStream**

> **Concept:** Reads bytes from a byte array in memory.

```java
byte[] data = {65, 66, 67, 68, 69};  // A,B,C,D,E

// Basic usage
try (ByteArrayInputStream bais = new ByteArrayInputStream(data)) {
    int b;
    while ((b = bais.read()) != -1) {
        System.out.print((char) b);  // ABCDE
    }
} catch (IOException e) {
    e.printStackTrace();
}

// With offset and length
try (ByteArrayInputStream bais = new ByteArrayInputStream(data, 2, 3)) {
    int b;
    while ((b = bais.read()) != -1) {
        System.out.print((char) b);  // CDE
    }
}

// Available bytes
ByteArrayInputStream bais = new ByteArrayInputStream(data);
int available = bais.available();  // 5
bais.read();
available = bais.available();  // 4

// Mark and reset
bais.mark(0);  // Mark current position
bais.read();   // Reads A
bais.read();   // Reads B
bais.reset();  // Go back to marked position
int val = bais.read();  // Reads A again
```

### **2.4 ByteArrayOutputStream**

> **Concept:** Writes bytes to a byte array in memory (grows automatically).

```java
// Basic usage
try (ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
    baos.write(65);  // A
    baos.write(66);  // B
    baos.write("Hello".getBytes());
    
    byte[] result = baos.toByteArray();  // Get all bytes
    String str = baos.toString();         // Convert to string
    System.out.println(str);
} catch (IOException e) {
    e.printStackTrace();
}

// With initial size
ByteArrayOutputStream baos = new ByteArrayOutputStream(32);  // Start with 32 bytes

// Write to multiple outputs
ByteArrayOutputStream baos = new ByteArrayOutputStream();
baos.write("Hello".getBytes());
baos.writeTo(new FileOutputStream("output.txt"));  // Write to file
baos.writeTo(System.out);                           // Write to console

// Reset
baos.reset();  // Clear for reuse
baos.write("New data".getBytes());

// Size
int size = baos.size();  // Current number of bytes
```

### **2.5 PipedInputStream / PipedOutputStream**

> **Concept:** Connected streams for inter-thread communication. Data written to PipedOutputStream is read from PipedInputStream.

```java
// Producer thread
class Producer extends Thread {
    private PipedOutputStream pos;
    
    public Producer(PipedOutputStream pos) {
        this.pos = pos;
    }
    
    public void run() {
        try {
            String data = "Hello from producer";
            pos.write(data.getBytes());
            pos.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

// Consumer thread
class Consumer extends Thread {
    private PipedInputStream pis;
    
    public Consumer(PipedInputStream pis) {
        this.pis = pis;
    }
    
    public void run() {
        try {
            int data;
            while ((data = pis.read()) != -1) {
                System.out.print((char) data);
            }
            pis.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

// Connect and use
PipedOutputStream pos = new PipedOutputStream();
PipedInputStream pis = new PipedInputStream(pos);  // Connect

// Or connect later
// PipedInputStream pis = new PipedInputStream();
// pis.connect(pos);

Producer producer = new Producer(pos);
Consumer consumer = new Consumer(pis);

producer.start();
consumer.start();

// Alternative: connect using constructor
PipedInputStream pis2 = new PipedInputStream(1024);  // With buffer size
PipedOutputStream pos2 = new PipedOutputStream(pis2);
```

### **2.6 SequenceInputStream**

> **Concept:** Concatenates multiple input streams, reading from them sequentially as if they were one stream.

```java
// Concatenate two files
try (FileInputStream fis1 = new FileInputStream("file1.txt");
     FileInputStream fis2 = new FileInputStream("file2.txt");
     SequenceInputStream sis = new SequenceInputStream(fis1, fis2)) {
    
    int data;
    while ((data = sis.read()) != -1) {
        System.out.print((char) data);  // Reads file1 then file2
    }
} catch (IOException e) {
    e.printStackTrace();
}

// Concatenate multiple files using Enumeration
Vector<InputStream> streams = new Vector<>();
streams.add(new FileInputStream("file1.txt"));
streams.add(new FileInputStream("file2.txt"));
streams.add(new FileInputStream("file3.txt"));

Enumeration<InputStream> en = streams.elements();

try (SequenceInputStream sis = new SequenceInputStream(en)) {
    byte[] buffer = new byte[1024];
    int bytesRead;
    while ((bytesRead = sis.read(buffer)) != -1) {
        System.out.print(new String(buffer, 0, bytesRead));
    }
} catch (IOException e) {
    e.printStackTrace();
}

// Practical: Merge multiple log files
List<InputStream> logStreams = Arrays.asList(
    new FileInputStream("log1.txt"),
    new FileInputStream("log2.txt"),
    new FileInputStream("log3.txt")
);

Enumeration<InputStream> logEnum = Collections.enumeration(logStreams);
try (SequenceInputStream merged = new SequenceInputStream(logEnum)) {
    // Process merged logs
}
```

### **2.7 BufferedInputStream**

> **Concept:** Adds buffering to an input stream, reducing physical reads and improving performance.

```java
// Basic usage
try (BufferedInputStream bis = new BufferedInputStream(
        new FileInputStream("largefile.bin"))) {
    
    byte[] buffer = new byte[8192];
    int bytesRead;
    while ((bytesRead = bis.read(buffer)) != -1) {
        // Process chunk
    }
} catch (IOException e) {
    e.printStackTrace();
}

// Custom buffer size
BufferedInputStream bis = new BufferedInputStream(
    new FileInputStream("file.bin"), 16384);  // 16KB buffer

// Mark and reset support
if (bis.markSupported()) {
    bis.mark(100);  // Mark current position, can read up to 100 bytes
    bis.read();     // Read some bytes
    bis.reset();    // Go back to marked position
}

// Available bytes (including buffer)
int available = bis.available();  // Bytes available without blocking

// Skip bytes
bis.skip(1000);  // Skip 1000 bytes
```

### **2.8 BufferedOutputStream**

> **Concept:** Adds buffering to an output stream, reducing physical writes and improving performance.

```java
// Basic usage
try (BufferedOutputStream bos = new BufferedOutputStream(
        new FileOutputStream("output.bin"))) {
    
    byte[] data = "Hello World".getBytes();
    bos.write(data);
    bos.flush();  // Force write from buffer to disk
} catch (IOException e) {
    e.printStackTrace();
}

// Custom buffer size
BufferedOutputStream bos = new BufferedOutputStream(
    new FileOutputStream("output.bin"), 16384);  // 16KB buffer

// Write without flushing - data stays in buffer
bos.write(data);
// Data not written to file until buffer full or flush/close called

// Always flush critical data
bos.write(importantData);
bos.flush();  // Ensure data is written
```

### **2.9 DataInputStream**

> **Concept:** Reads primitive Java data types (int, float, boolean, etc.) in a portable binary format.

```java
// Writing data first (DataOutputStream)
try (DataOutputStream dos = new DataOutputStream(
        new FileOutputStream("data.bin"))) {
    
    dos.writeInt(42);
    dos.writeDouble(3.14159);
    dos.writeBoolean(true);
    dos.writeUTF("Hello World");  // Modified UTF-8
    dos.writeChar('A');
    dos.writeLong(123456789L);
    dos.writeFloat(2.5f);
    dos.writeShort((short) 100);
    dos.writeByte(10);
} catch (IOException e) {
    e.printStackTrace();
}

// Reading data (must read in SAME ORDER!)
try (DataInputStream dis = new DataInputStream(
        new FileInputStream("data.bin"))) {
    
    int i = dis.readInt();           // 42
    double d = dis.readDouble();     // 3.14159
    boolean b = dis.readBoolean();   // true
    String s = dis.readUTF();        // "Hello World"
    char c = dis.readChar();         // 'A'
    long l = dis.readLong();         // 123456789L
    float f = dis.readFloat();       // 2.5f
    short sh = dis.readShort();      // 100
    byte by = dis.readByte();        // 10
    
    System.out.println(i + ", " + d + ", " + b + ", " + s);
} catch (IOException e) {
    e.printStackTrace();
}

// Reading all available bytes
try (DataInputStream dis = new DataInputStream(
        new FileInputStream("data.bin"))) {
    
    while (dis.available() > 0) {
        // Determine type based on protocol
        byte type = dis.readByte();
        switch (type) {
            case 1: int val = dis.readInt(); break;
            case 2: double dval = dis.readDouble(); break;
        }
    }
}
```

### **2.10 DataOutputStream**

> **Concept:** Writes primitive Java data types in a portable binary format.

```java
// Writing primitives
try (DataOutputStream dos = new DataOutputStream(
        new FileOutputStream("data.bin"))) {
    
    dos.writeInt(100);
    dos.writeUTF("Text");
    dos.writeBoolean(false);
    dos.writeDouble(99.99);
    
    // Get number of bytes written
    int bytesWritten = dos.size();  // Returns current count
    
} catch (IOException e) {
    e.printStackTrace();
}

// File format (binary):
// [int: 100][UTF length][UTF chars][boolean][double]
// This format is platform-independent
```

### **2.11 ObjectInputStream**

> **Concept:** Reads Java objects that were previously written using ObjectOutputStream (deserialization).

```java
// First, a serializable class
class Person implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private String name;
    private int age;
    private transient String password;  // Won't be serialized
    
    public Person(String name, int age, String password) {
        this.name = name;
        this.age = age;
        this.password = password;
    }
    
    @Override
    public String toString() {
        return name + " (" + age + ")";
    }
}

// Reading objects
try (ObjectInputStream ois = new ObjectInputStream(
        new FileInputStream("person.ser"))) {
    
    // Read objects in same order they were written
    Person p = (Person) ois.readObject();  // Cast needed
    String note = (String) ois.readObject();
    
    System.out.println(p);
    // password is null (transient)
    
} catch (IOException | ClassNotFoundException e) {
    e.printStackTrace();
}

// Reading multiple objects
try (ObjectInputStream ois = new ObjectInputStream(
        new FileInputStream("people.ser"))) {
    
    List<Person> people = new ArrayList<>();
    try {
        while (true) {
            people.add((Person) ois.readObject());
        }
    } catch (EOFException e) {
        // End of stream reached
    }
    
    System.out.println("Read " + people.size() + " people");
} catch (IOException | ClassNotFoundException e) {
    e.printStackTrace();
}

// Custom deserialization
class SecurePerson implements Serializable {
    private String name;
    private transient String password;
    
    // Custom deserialization
    private void readObject(ObjectInputStream ois) 
            throws IOException, ClassNotFoundException {
        ois.defaultReadObject();  // Read non-transient fields
        this.password = decrypt((String) ois.readObject());  // Read encrypted
    }
    
    private String decrypt(String encrypted) {
        return "decrypted_" + encrypted;  // Simple example
    }
}
```

### **2.12 ObjectOutputStream**

> **Concept:** Writes Java objects to a stream (serialization).

```java
// Writing objects
try (ObjectOutputStream oos = new ObjectOutputStream(
        new FileOutputStream("person.ser"))) {
    
    Person p = new Person("Alice", 30, "secret123");
    oos.writeObject(p);
    oos.writeObject("Some note");
    
    // Flush to ensure data is written
    oos.flush();
    
} catch (IOException e) {
    e.printStackTrace();
}

// Writing multiple objects
List<Person> people = Arrays.asList(
    new Person("Alice", 30, "pass1"),
    new Person("Bob", 25, "pass2")
);

try (ObjectOutputStream oos = new ObjectOutputStream(
        new FileOutputStream("people.ser"))) {
    
    for (Person p : people) {
        oos.writeObject(p);
    }
} catch (IOException e) {
    e.printStackTrace();
}

// Custom serialization
class SecurePerson implements Serializable {
    private String name;
    private transient String password;
    
    // Custom serialization
    private void writeObject(ObjectOutputStream oos) throws IOException {
        oos.defaultWriteObject();  // Write non-transient fields
        oos.writeObject(encrypt(password));  // Write encrypted
    }
    
    private String encrypt(String plain) {
        return "encrypted_" + plain;
    }
}

// Using writeReplace for object substitution
class Person implements Serializable {
    private String name;
    
    // Replace this object with another during serialization
    private Object writeReplace() throws ObjectStreamException {
        return new PersonProxy(name);  // Proxy pattern
    }
}

// Ensuring version compatibility
private static final long serialVersionUID = 123456789L;
```

---

## **3. CHARACTER STREAMS**

> **Concept:** Handle I/O of text data (16-bit Unicode characters). Base classes: `Reader` and `Writer`.

### **Reader Hierarchy**

```
                    Reader (abstract)
                    ┌───────┴───────┐
                    │               │
         ┌──────────▼────┐    ┌─────▼──────────┐
         │ InputStreamReader│   │BufferedReader  │
         └──────────┬─────┘    └───────┬────────┘
                    │                  │
         ┌──────────▼────┐    ┌────────▼────────┐
         │ FileReader    │    │ LineNumberReader│
         └───────────────┘    └─────────────────┘
         
         ┌──────────▼────┐    ┌─────▼──────────┐
         │ CharArrayReader│    │ PipedReader    │
         └────────────────┘    └────────────────┘
         
         ┌──────────▼────┐    ┌─────▼──────────┐
         │ StringReader  │    │ FilterReader    │
         └────────────────┘    └───────┬────────┘
                                       │
                                 ┌─────▼─────┐
                                 │Pushback-  │
                                 │Reader     │
                                 └───────────┘
```

### **3.1 FileReader**

> **Concept:** Convenience class for reading character files (uses default encoding).

```java
// Basic FileReader
try (FileReader fr = new FileReader("text.txt")) {
    int charData;
    while ((charData = fr.read()) != -1) {
        System.out.print((char) charData);
    }
} catch (IOException e) {
    e.printStackTrace();
}

// Reading with char array
try (FileReader fr = new FileReader("text.txt")) {
    char[] buffer = new char[1024];
    int charsRead;
    while ((charsRead = fr.read(buffer)) != -1) {
        System.out.print(new String(buffer, 0, charsRead));
    }
} catch (IOException e) {
    e.printStackTrace();
}

// Java 11+ with charset
try (FileReader fr = new FileReader("text.txt", Charset.forName("UTF-8"))) {
    // Read with specified encoding
}

// Note: FileReader uses platform default encoding
// Better to use InputStreamReader with specified charset
try (InputStreamReader isr = new InputStreamReader(
        new FileInputStream("text.txt"), StandardCharsets.UTF_8)) {
    // More control over encoding
}
```

### **3.2 FileWriter**

> **Concept:** Convenience class for writing character files (uses default encoding).

```java
// Basic FileWriter
try (FileWriter fw = new FileWriter("output.txt")) {
    fw.write("Hello World");
    fw.write(65);  // Writes 'A'
    fw.write("Another line");
} catch (IOException e) {
    e.printStackTrace();
}

// Append mode
try (FileWriter fw = new FileWriter("output.txt", true)) {
    fw.write("Appended text");
} catch (IOException e) {
    e.printStackTrace();
}

// Write char array
char[] chars = {'H', 'e', 'l', 'l', 'o'};
try (FileWriter fw = new FileWriter("output.txt")) {
    fw.write(chars);
    fw.write(chars, 2, 3);  // Write 'l', 'l', 'o' from index 2
} catch (IOException e) {
    e.printStackTrace();
}

// Java 11+ with charset
try (FileWriter fw = new FileWriter("output.txt", StandardCharsets.UTF_8)) {
    fw.write("Hello with UTF-8");
}
```

### **3.3 BufferedReader**

> **Concept:** Reads text from a character stream with buffering, provides efficient reading of lines.

```java
// Basic BufferedReader
try (BufferedReader br = new BufferedReader(new FileReader("text.txt"))) {
    String line;
    while ((line = br.readLine()) != null) {
        System.out.println(line);
    }
} catch (IOException e) {
    e.printStackTrace();
}

// With custom buffer size
BufferedReader br = new BufferedReader(new FileReader("large.txt"), 16384);

// Reading from keyboard
BufferedReader console = new BufferedReader(new InputStreamReader(System.in));
System.out.print("Enter name: ");
String name = console.readLine();

// Mark and reset
if (br.markSupported()) {
    br.mark(1000);  // Mark current position
    String line1 = br.readLine();
    br.reset();      // Go back to mark
    String line2 = br.readLine();  // Reads same line again
}

// Skip characters
br.skip(10);  // Skip 10 characters

// Ready
if (br.ready()) {
    // Stream is ready to be read
}

// Java 8+ lines() - stream of lines
try (BufferedReader br = new BufferedReader(new FileReader("data.txt"))) {
    br.lines()
      .filter(l -> l.contains("ERROR"))
      .forEach(System.out::println);
} catch (IOException e) {
    e.printStackTrace();
}
```

### **3.4 BufferedWriter**

> **Concept:** Writes text to a character stream with buffering, provides newLine() method.

```java
// Basic BufferedWriter
try (BufferedWriter bw = new BufferedWriter(new FileWriter("output.txt"))) {
    bw.write("First line");
    bw.newLine();  // Platform-independent line separator
    bw.write("Second line");
    bw.newLine();
    bw.write("Third line");
} catch (IOException e) {
    e.printStackTrace();
}

// With custom buffer size
BufferedWriter bw = new BufferedWriter(new FileWriter("large.txt"), 16384);

// Append
bw.append("More text");
bw.append(' ');

// Write multiple parts
bw.write("Part1");
bw.write("Part2");
bw.flush();  // Force write to disk

// Flush strategy
bw.write("Important data");
bw.flush();  // Ensure it's written immediately
```

### **3.5 InputStreamReader**

> **Concept:** Bridge from byte streams to character streams. Reads bytes and decodes them to characters using specified charset.

```java
// Basic InputStreamReader
try (InputStreamReader isr = new InputStreamReader(
        new FileInputStream("file.txt"))) {
    int charData;
    while ((charData = isr.read()) != -1) {
        System.out.print((char) charData);
    }
} catch (IOException e) {
    e.printStackTrace();
}

// With specific charset
try (InputStreamReader isr = new InputStreamReader(
        new FileInputStream("file.txt"), StandardCharsets.UTF_8)) {
    // Read UTF-8 encoded file
}

// Multiple charsets
Charset utf8 = StandardCharsets.UTF_8;
Charset utf16 = StandardCharsets.UTF_16;
Charset iso8859 = StandardCharsets.ISO_8859_1;

try (InputStreamReader isr = new InputStreamReader(
        new FileInputStream("file.txt"), utf8)) {
    // Process file
}

// Getting encoding
String encoding = isr.getEncoding();

// Reading with buffer
try (BufferedReader br = new BufferedReader(
        new InputStreamReader(new FileInputStream("file.txt"), "UTF-8"))) {
    String line;
    while ((line = br.readLine()) != null) {
        System.out.println(line);
    }
}
```

### **3.6 OutputStreamWriter**

> **Concept:** Bridge from character streams to byte streams. Encodes characters to bytes using specified charset.

```java
// Basic OutputStreamWriter
try (OutputStreamWriter osw = new OutputStreamWriter(
        new FileOutputStream("output.txt"))) {
    osw.write("Hello World");
    osw.write('A');
    osw.write("More text", 0, 4);  // Write "More"
} catch (IOException e) {
    e.printStackTrace();
}

// With specific charset
try (OutputStreamWriter osw = new OutputStreamWriter(
        new FileOutputStream("output.txt"), StandardCharsets.UTF_8)) {
    osw.write("UTF-8 encoded text");
}

// With buffering
try (BufferedWriter bw = new BufferedWriter(
        new OutputStreamWriter(new FileOutputStream("out.txt"), "UTF-8"))) {
    bw.write("Hello");
    bw.newLine();
    bw.write("World");
}

// Getting encoding
String encoding = osw.getEncoding();

// Flush
osw.flush();
```

### **3.7 CharArrayReader**

> **Concept:** Reads characters from a character array in memory.

```java
char[] data = {'H', 'e', 'l', 'l', 'o', ' ', 'W', 'o', 'r', 'l', 'd'};

// Basic usage
try (CharArrayReader car = new CharArrayReader(data)) {
    int ch;
    while ((ch = car.read()) != -1) {
        System.out.print((char) ch);
    }
} catch (IOException e) {
    e.printStackTrace();
}

// With offset and length
try (CharArrayReader car = new CharArrayReader(data, 6, 5)) {
    int ch;
    while ((ch = car.read()) != -1) {
        System.out.print((char) ch);  // Reads "World"
    }
}

// Mark and reset
CharArrayReader car = new CharArrayReader(data);
car.mark(0);
car.read();  // H
car.read();  // e
car.reset(); // Go back to mark
int ch = car.read();  // H again
```

### **3.8 CharArrayWriter**

> **Concept:** Writes characters to a character array in memory (grows automatically).

```java
// Basic usage
try (CharArrayWriter caw = new CharArrayWriter()) {
    caw.write('H');
    caw.write('e');
    caw.write("llo");
    caw.write(" World", 0, 6);  // Write " World"
    
    char[] result = caw.toCharArray();  // Get char array
    String str = caw.toString();         // Get string
    
    System.out.println(str);  // "Hello World"
} catch (IOException e) {
    e.printStackTrace();
}

// Initial size
CharArrayWriter caw = new CharArrayWriter(32);

// Write to multiple destinations
caw.write("Hello");
caw.writeTo(new FileWriter("output.txt"));
caw.writeTo(System.out);

// Reset
caw.reset();  // Clear for reuse

// Size
int size = caw.size();  // Current number of chars
```

### **3.9 PipedReader / PipedWriter**

> **Concept:** Connected character streams for inter-thread communication.

```java
// Producer thread
class Producer extends Thread {
    private PipedWriter pw;
    
    public Producer(PipedWriter pw) {
        this.pw = pw;
    }
    
    public void run() {
        try {
            pw.write("Hello from producer");
            pw.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

// Consumer thread
class Consumer extends Thread {
    private PipedReader pr;
    
    public Consumer(PipedReader pr) {
        this.pr = pr;
    }
    
    public void run() {
        try {
            int data;
            while ((data = pr.read()) != -1) {
                System.out.print((char) data);
            }
            pr.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

// Connect and use
PipedWriter pw = new PipedWriter();
PipedReader pr = new PipedReader(pw);  // Connect

Producer producer = new Producer(pw);
Consumer consumer = new Consumer(pr);

producer.start();
consumer.start();

// Alternative connection
PipedReader pr2 = new PipedReader(1024);  // With buffer size
PipedWriter pw2 = new PipedWriter(pr2);
```

### **3.10 StringReader**

> **Concept:** Reads characters from a String.

```java
String text = "Hello World\nThis is a test\nLine 3";

// Basic usage
try (StringReader sr = new StringReader(text)) {
    int ch;
    while ((ch = sr.read()) != -1) {
        System.out.print((char) ch);
    }
} catch (IOException e) {
    e.printStackTrace();
}

// With buffer
try (StringReader sr = new StringReader(text);
     BufferedReader br = new BufferedReader(sr)) {
    
    String line;
    while ((line = br.readLine()) != null) {
        System.out.println(line);
    }
} catch (IOException e) {
    e.printStackTrace();
}

// Mark and reset
StringReader sr = new StringReader("Hello");
sr.mark(0);
sr.read();  // H
sr.read();  // e
sr.reset(); // Go back
char c = (char) sr.read();  // H again
```

### **3.11 StringWriter**

> **Concept:** Writes characters to a StringBuffer (grows automatically).

```java
// Basic usage
try (StringWriter sw = new StringWriter()) {
    sw.write('H');
    sw.write('e');
    sw.write("llo");
    sw.write(" World");
    
    String result = sw.toString();  // "Hello World"
    StringBuffer buffer = sw.getBuffer();  // Get underlying StringBuffer
    
    System.out.println(result);
} catch (IOException e) {
    e.printStackTrace();
}

// Initial size
StringWriter sw = new StringWriter(32);

// Append
sw.append("Hello");
sw.append(' ');

// Reset
StringBuffer buf = sw.getBuffer();
buf.setLength(0);  // Clear
```

### **3.12 PrintWriter**

> **Concept:** Prints formatted representations of objects to a text-output stream.

```java
// To file
try (PrintWriter pw = new PrintWriter(new FileWriter("output.txt"))) {
    pw.println("Hello World");
    pw.printf("Age: %d, Name: %s%n", 30, "Alice");
    pw.print("No newline");
    pw.print(123);
    pw.println(true);
} catch (IOException e) {
    e.printStackTrace();
}

// To console
PrintWriter console = new PrintWriter(System.out, true);  // auto-flush
console.println("Message");
console.printf("Value: %.2f%n", 3.14159);

// With auto-flush
PrintWriter pw = new PrintWriter(new FileWriter("log.txt"), true);  // auto-flush on println

// Formatting
PrintWriter pw = new PrintWriter(System.out);
pw.format("Hex: %x, Oct: %o, Float: %.2f", 255, 255, 3.14159);
pw.println();

// Check for errors
if (pw.checkError()) {
    System.err.println("Error occurred");
}

// PrintWriter vs PrintStream
// PrintWriter handles all characters properly (Unicode)
// PrintStream may have encoding issues

// Common methods
pw.print(Object o);
pw.println(Object o);
pw.printf(format, args);
pw.format(format, args);
pw.append(char c);
```

### **3.13 LineNumberReader**

> **Concept:** Buffered character stream that keeps track of line numbers.

```java
// Basic usage
try (LineNumberReader lnr = new LineNumberReader(
        new FileReader("text.txt"))) {
    
    String line;
    while ((line = lnr.readLine()) != null) {
        int lineNumber = lnr.getLineNumber();  // Current line number (1-based)
        System.out.println(lineNumber + ": " + line);
    }
} catch (IOException e) {
    e.printStackTrace();
}

// Set line number
LineNumberReader lnr = new LineNumberReader(new FileReader("text.txt"));
lnr.setLineNumber(10);  // Start counting from 10

// Skip lines and track
lnr.readLine();  // Line 11
lnr.readLine();  // Line 12
int current = lnr.getLineNumber();  // 12

// Mark and reset with line numbers
lnr.mark(1000);
lnr.readLine();  // Line 13
lnr.reset();     // Go back to marked position