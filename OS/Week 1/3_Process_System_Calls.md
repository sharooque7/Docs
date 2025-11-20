Here's a summarized breakdown of the key points from the **Operating Systems: Introduction to Processes and System Calls** lecture transcript:

---

## 📘 **Introduction to Processes and System Calls**

### 🧠 What is a Process?
- A **process** is a **program under execution**.
- Stored and executed **from RAM**.
- Created when you run an executable (e.g., `./a.out`).
- Defined as:  
  > "Program under execution comprising Text (code), Stack, Heap, Data, and State."

---

### 🗂️ **Process Memory Map**
Each process is divided into segments:

1. **Text Section** – Program instructions (e.g., `main()`, other functions).
2. **Data Section** – Global/static variables (split into initialized & uninitialized).
3. **Heap** – Dynamically allocated memory (`malloc()`).
4. **Stack** – Local variables, function calls, recursion data.
5. **State** – Hidden part maintained by OS (e.g., registers, open file list).

---

### 📏 **MAX SIZE & Kernel Mapping**
- **MAX SIZE**: Defines the upper limit of process memory.
  - In 32-bit Linux: `0xc0000000`.
  - In xv6 OS: `0x80000000`.
- Beyond MAX SIZE:
  - Reserved for **Kernel** (OS code, device memory, OS heap, etc.).
- **User process** can only access memory below MAX SIZE.
- **Kernel** can access both user & kernel space.

---

### 🔄 **Multiple Processes**
- Each has its **own memory** for text, data, heap, stack.
- **Kernel memory** (above MAX SIZE) is **shared** across all processes.
- Memory below MAX SIZE varies by process.

---

## 🔌 **System Calls: Communication with the OS**

### 🔧 What is a System Call?
- Interface for user processes to **request services from the OS**.
- Triggers **mode switch** from user mode to **kernel mode**.
- Returns back to user mode after execution.

### 📝 Example: `printf` Flow
```text
printf() –> write() in libc –> write system call –> Kernel handles screen output
```

- `write()` system call triggers a **trap** (software interrupt).
- Kernel executes `Trap Handler` → Executes system-level write.

---

### ⚙️ **System Call vs Function Call**
| Feature                     | Function Call                | System Call                           |
|----------------------------|------------------------------|----------------------------------------|
| Instruction Used           | `CALL`                       | `TRAP` / `int 0x80` (software interrupt) |
| Execution Mode             | Stays in user mode           | Switches to kernel mode               |
| Address Resolution         | Relocatable (dynamic)        | Fixed (determined by processor)       |
| Flexibility                | More flexible (within process) | Rigid, secure entry into kernel       |

---

### ❓ Why Do We Need System Calls?
- User programs **cannot directly access hardware or kernel memory**.
- OS must expose **safe entry points** (system calls) for:
  - I/O (read, write)
  - Process creation (fork, exec)
  - Memory allocation
  - File manipulation
  - Communication (pipes, sockets)

---

Let me know if you'd like this as a **PDF summary**, **diagram**, or **flashcards** for revision!