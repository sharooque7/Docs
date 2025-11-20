

Intro 0:07 Hello. INTRODUCTION TO OPERATING SYSTEMS 0:17 In this lecture, we will look at CPU Scheduling Algorithms. We had seen in operating systems that a scheduler present would choose a particular process Which process to choose? 0:29 from the ready queue and that process is assigned to

pasted

I'll summarize the key points from this transcript about CPU scheduling algorithms in operating systems.

Introduction to CPU Scheduling Algorithms
The transcript discusses how operating system schedulers choose which process from the ready queue should be assigned to run on the CPU. This decision-making process is governed by various scheduling algorithms.

Execution Phases of a Process
Processes alternate between two phases:
CPU burst: When the process is actively executing instructions
Idle time/I/O burst: When the process is waiting for I/O operations
Types of Processes
I/O-bound processes: Processes with short CPU bursts and frequent I/O operations
CPU-bound processes: Processes with longer CPU bursts and less frequent I/O
I/O-bound processes typically get higher priority to improve user experience
A process can behave as both I/O-bound and CPU-bound at different times (e.g., Excel when entering data vs. calculating statistics)
Scheduling Criteria
Six main criteria are used to evaluate scheduling algorithms:

CPU Utilization: Maximize CPU usage (minimize idle time)
Throughput: Number of processes completed per unit time
Turnaround Time: Time from process start to completion
Response Time: Time from entry to ready queue until first execution
Waiting Time: Time spent in ready queue
Fairness: Ensuring each process gets a fair share of CPU time
Scheduling Algorithms
1. First Come, First Serve (FCFS)
Simplest algorithm: processes are executed in order of arrival
Non-preemptive: once allocated the CPU, a process runs until completion
Advantages:
Very simple implementation
Fair (all processes eventually run)
Disadvantages:
Waiting time depends heavily on arrival order
"Convoy effect": Short processes stuck waiting behind long processes
Poor average waiting and response times
2. Shortest Job First (SJF)
Process with shortest CPU burst time is executed first
Has two variants:
Non-preemptive: Process runs until completion
Preemptive (also called Shortest Remaining Time First or SRTF)
Advantages:
Optimal algorithm for minimizing average waiting time
Reduced average response time
Disadvantages:
Not practical as burst times are difficult to predict
Long processes may starve (never get CPU time)
3. Shortest Remaining Time First (SRTF)
Preemptive version of SJF
If a new process arrives with shorter burst time than the remaining time of current process, new process gets scheduled
Further reduces average waiting and response times
Same disadvantages as SJF (impractical, potential starvation)
4. Round Robin (RR)
Each process runs for a fixed time slice (quantum)
After time slice expires, process moves to back of ready queue
Implemented using timer interrupts and FIFO queue
Impact of time slice duration:
Short time slice: Better response time but more context switches
Long time slice: Fewer context switches but behaves more like FCFS with poor response times
Typical time slice in modern OS: 10-100 milliseconds
Advantages:
Fair (each process gets CPU time)
Good response time
Good for time-sharing systems
Disadvantages:
Increased context switching overhead
High average wait time when burst times are equal
The lecture also briefly mentions priority-based scheduling algorithms and notes that Xv6 (an educational operating system) uses a variant of Round Robin scheduling.

Please give the same in markdown

CPU Scheduling Algorithms in Operating Systems
Introduction to CPU Scheduling
CPU scheduling is the process of determining which process from the ready queue should be assigned to the CPU for execution. The scheduler is responsible for making this decision based on various algorithms and criteria.

Execution Phases of a Process
Processes alternate between two main phases:

CPU burst: The period when the process is actively executing instructions
I/O burst: The period when the process is waiting for I/O operations to complete
Types of Processes
I/O-bound Processes
Have short CPU bursts and frequent I/O operations
Example: Word processors, interactive applications
Given higher priority to improve user experience
CPU-bound Processes
Have longer CPU bursts and less frequent I/O operations
Example: Compilers, data analysis programs
Can typically tolerate longer wait times
Note: A process can alternate between being I/O-bound and CPU-bound during its lifecycle. For example, Microsoft Excel behaves as I/O-bound when entering data but CPU-bound when computing statistics.

Scheduling Criteria
Six main criteria are used to evaluate scheduling algorithms:

CPU Utilization: Maximize CPU usage by keeping it busy as much as possible
Throughput: Maximize the number of processes completed per unit time
Turnaround Time: Minimize the time taken from submission to completion of a process
Response Time: Minimize the time from submission until the first response is produced
Waiting Time: Minimize the time processes spend waiting in the ready queue
Fairness: Ensure each process gets a fair share of the CPU
Different scheduling algorithms prioritize different criteria based on the system's purpose.

Major Scheduling Algorithms
1. First Come, First Serve (FCFS)
Characteristics:

Simplest scheduling algorithm
Non-preemptive: once a process gets CPU, it keeps it until completion
Processes are executed in order of arrival
Advantages:

Very simple implementation
Fair in the sense that all processes eventually run
Disadvantages:

Performance heavily depends on arrival order
"Convoy effect": Short processes get stuck behind long ones
Poor average waiting and response times
2. Shortest Job First (SJF)
Characteristics:

Process with shortest CPU burst time is selected for execution
Can be non-preemptive or preemptive
Advantages:

Optimal for minimizing average waiting time
Reduced average response time
Disadvantages:

Not practical as CPU burst times are difficult to predict
Potential starvation for processes with long burst times
3. Shortest Remaining Time First (SRTF)
Characteristics:

Preemptive version of SJF
If a new process arrives with shorter burst time than remaining time of current process, the new process is scheduled
Advantages:

Further reduces average waiting and response times
Optimal preemptive algorithm
Disadvantages:

Impractical to implement (difficult to know remaining burst time)
More context switches
Potential starvation for longer processes
4. Round Robin (RR)
Characteristics:

Each process gets a small unit of CPU time (time quantum or time slice)
After time quantum expires, the process is preempted and added to the end of the ready queue
Implemented using timer interrupts and FIFO queue
Time Quantum Effects:

Short time quantum:
Better response time
More context switches (overhead)
Long time quantum:
Fewer context switches
Behaves more like FCFS
Typical time quantum in modern OS: 10-100 milliseconds
Advantages:

Fair allocation of CPU
Good for time-sharing systems
Good response time for short processes
Disadvantages:

Increased context switching overhead
Higher average waiting time when burst times are equal
Practical Implementations
The educational operating system Xv6 implements a variant of Round Robin scheduling with a time quantum of 10 milliseconds.

Many modern operating systems use more complex priority-based scheduling algorithms that build upon these basic approaches.





# CPU Scheduling Algorithms in Operating Systems ## Introduction to CPU Scheduling CPU scheduling is the process of determining which process from the ready queue should be assigned to the CPU for execution. The scheduler is responsible for making this decision based on various algorithms and

pasted



Intro 0:07 Hello. INTRODUCTION TO OPERATING SYSTEMS 0:17 In this lecture, we will look at CPU Scheduling Algorithms. We had seen in operating systems that a scheduler present would choose a particular process Which process to choose? 0:29 from the ready queue and that process is assigned to



Pasted content

4.21 KB •116 lines
•
Formatting may be inconsistent from source

# CPU Scheduling Algorithms in Operating Systems

## Introduction to CPU Scheduling

CPU scheduling is the process of determining which process from the ready queue should be assigned to the CPU for execution. The scheduler is responsible for making this decision based on various algorithms and criteria.

## Execution Phases of a Process

Processes alternate between two main phases:
- **CPU burst**: The period when the process is actively executing instructions
- **I/O burst**: The period when the process is waiting for I/O operations to complete

## Types of Processes

### I/O-bound Processes
- Have short CPU bursts and frequent I/O operations
- Example: Word processors, interactive applications
- Given higher priority to improve user experience

### CPU-bound Processes
- Have longer CPU bursts and less frequent I/O operations
- Example: Compilers, data analysis programs
- Can typically tolerate longer wait times

Note: A process can alternate between being I/O-bound and CPU-bound during its lifecycle. For example, Microsoft Excel behaves as I/O-bound when entering data but CPU-bound when computing statistics.

## Scheduling Criteria

Six main criteria are used to evaluate scheduling algorithms:

1. **CPU Utilization**: Maximize CPU usage by keeping it busy as much as possible
2. **Throughput**: Maximize the number of processes completed per unit time
3. **Turnaround Time**: Minimize the time taken from submission to completion of a process
4. **Response Time**: Minimize the time from submission until the first response is produced
5. **Waiting Time**: Minimize the time processes spend waiting in the ready queue
6. **Fairness**: Ensure each process gets a fair share of the CPU

Different scheduling algorithms prioritize different criteria based on the system's purpose.

## Major Scheduling Algorithms

### 1. First Come, First Serve (FCFS)

**Characteristics:**
- Simplest scheduling algorithm
- Non-preemptive: once a process gets CPU, it keeps it until completion
- Processes are executed in order of arrival

**Advantages:**
- Very simple implementation
- Fair in the sense that all processes eventually run

**Disadvantages:**
- Performance heavily depends on arrival order
- "Convoy effect": Short processes get stuck behind long ones
- Poor average waiting and response times

### 2. Shortest Job First (SJF)

**Characteristics:**
- Process with shortest CPU burst time is selected for execution
- Can be non-preemptive or preemptive

**Advantages:**
- Optimal for minimizing average waiting time
- Reduced average response time

**Disadvantages:**
- Not practical as CPU burst times are difficult to predict
- Potential starvation for processes with long burst times

### 3. Shortest Remaining Time First (SRTF)

**Characteristics:**
- Preemptive version of SJF
- If a new process arrives with shorter burst time than remaining time of current process, the new process is scheduled

**Advantages:**
- Further reduces average waiting and response times
- Optimal preemptive algorithm

**Disadvantages:**
- Impractical to implement (difficult to know remaining burst time)
- More context switches
- Potential starvation for longer processes

### 4. Round Robin (RR)

**Characteristics:**
- Each process gets a small unit of CPU time (time quantum or time slice)
- After time quantum expires, the process is preempted and added to the end of the ready queue
- Implemented using timer interrupts and FIFO queue

**Time Quantum Effects:**
- Short time quantum:
  - Better response time
  - More context switches (overhead)
- Long time quantum:
  - Fewer context switches
  - Behaves more like FCFS
- Typical time quantum in modern OS: 10-100 milliseconds

**Advantages:**
- Fair allocation of CPU
- Good for time-sharing systems
- Good response time for short processes

**Disadvantages:**
- Increased context switching overhead
- Higher average waiting time when burst times are equal

## Practical Implementations

The educational operating system Xv6 implements a variant of Round Robin scheduling with a time quantum of 10 milliseconds.

Many modern operating systems use more complex priority-based scheduling algorithms that build upon these basic approaches.