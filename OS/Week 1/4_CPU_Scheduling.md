# Operating System Resource Management: CPU Scheduling

## Introduction
- Operating systems manage limited hardware resources efficiently
- CPU is one of the most critical resources to manage
- Modern systems have multiple CPUs (4, 8, or 16), while older systems (1990s-early 2000s) had single processors
- Multiple applications must share CPU resources

## Evolution of CPU Resource Management

### 1. Simple Sequential Execution (e.g., MS-DOS)
- Applications execute one after another
- Each application runs until completion before the next can start
- **Problem**: CPU remains idle during wait states (e.g., when an application waits for user input)
- Results in inefficient CPU utilization

### 2. Multiprogramming
- Application runs until it requires an external event (becomes "blocked")
- CPU switches to another application while the first waits
- When the event occurs (e.g., user input received), the blocked application is added to a queue
- The application resumes from where it stopped when it gets CPU time again
- **Advantage**: Prevents CPU from being idle
- **Problem**: An application with an infinite loop can monopolize the CPU, causing starvation of other applications

### 3. Multitasking/Time Sharing
- CPU time is divided into small time slices (quanta)
- Each process executes during its assigned time slice
- A process stops executing when either:
  - Its time slice completes (another process gets the CPU)
  - It needs to wait for an event
  - It terminates
- Processes resume execution from where they stopped when given CPU time again
- **Advantages**:
  - No starvation - all processes get CPU time
  - From user's perspective, all applications appear to run concurrently
  - Improved overall system performance
  - Small time slices make delays virtually unnoticeable to users

## Multiprocessor Systems

### Architecture
- Multiple CPU chips with multiple cores per chip
- Each core can run multiple threads via Symmetric Multithreading (SMT)
  - In Intel terminology: Hyper-threading
- Example: System with 2 chips, 2 cores per chip, 2 threads per core

### Parallelism
- Multiple applications can execute simultaneously on different processors
- Each processor can still implement time slicing
- OS must schedule applications across available processing units

## Resource Management Challenges

### Race Conditions
- Occur when multiple applications simultaneously request access to a shared resource
- Examples of shared resources: files, printers, keyboards, RAM, disks, networks
- Can lead to data corruption or inconsistent states

### Synchronization
- Solution to race conditions
- Uses "locks" associated with resources
- Process must acquire the lock before accessing the resource
- Only one process can hold the lock at a time
- After usage, process releases (unlocks) the resource
- Other processes must wait until the resource is unlocked
- Ensures serialized access to resources

## CPU Scheduling

### Scheduler
- Component within OS that decides which application runs next
- Design requirements:
  - Fairness: Every application gets a share of CPU time
  - Prioritization: Some applications need more CPU time than others
  - High-priority applications should:
    - Get more CPU time
    - Experience minimal waiting time
  - Example: A monitoring application (high priority) vs. a compiler (low priority)

## Operating System Security & Isolation

### Isolation Requirements
- Protect applications from each other
- Prevent data visibility between applications
- Protect against malicious applications (viruses, Trojans)
- Isolate kernel (OS) from applications

### Protection Rings (Intel Platforms)
- Ring 0: Most privileged, where the OS kernel executes
- Ring 3: Least privileged, where user applications run
- Applications must use system calls to access resources
- Each application is isolated from others in user space

### Security Features
- Access control mechanisms
- User authentication (passwords, biometrics)
- Cryptography

### Access Control Matrix
- Assigns permissions for each user to each resource
- Permissions include: read, write, execute
- Ensures users can only access authorized resources

### Security Assessment
- Mathematical analysis
- Manual/semi-automated verification
- Critical systems undergo rigorous security assessments