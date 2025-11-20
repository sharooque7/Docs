# Operating System Implementation of Process Management System Calls

This document summarizes the implementation details of key process management system calls (fork, exec, wait, exit) in the xv6 operating system.

## Fork System Call Implementation

The fork system call creates a new child process. In xv6, this involves:

1. **Process Control Block (PCB) Creation**
   - xv6 defines PCB as a `struct proc`
   - All processes are stored in a `ptable` (array of proc structures)
   - Size of array is `NPROC` (maximum number of concurrent processes)

2. **Implementation Steps**:
   - Call `allocproc()` to find an unused proc structure in ptable
   - Set state to `EMBRYO` and assign a new PID
   - Allocate kernel stack for the child process
   - Call `copyuvm()` to copy parent's page directory to child
   - Copy parameters from parent to child:
     - Most importantly, copy parent's trapframe to child's trapframe
     - Set child's eax register to 0 (return value)
     - Copy executable name, current working directory, file pointers
   - Change state from `EMBRYO` to `RUNNABLE`
   - Return child's PID to parent process

3. **Register Modifications**:
   - Child process has identical register values to parent, except:
     - `eax` register (set to 0 in child for return value)
     - `eip` (instruction pointer) set to `forkret` function

## Exit System Call Implementation

When a process invokes the exit system call:

1. Decrement usage count of all open files (close if count reaches 0)
2. Drop references for all in-memory inodes
3. Send wakeup signal to parent process (makes parent runnable if sleeping)
4. Make init process adopt all children of the exiting process
5. Set exiting process state to `ZOMBIE`
6. Force a context switch in the scheduler

## Wait System Call Implementation

The wait system call blocks until a child process exits:

1. Parse through the ptable looking for child processes
2. For each child process:
   - If child is in `ZOMBIE` state:
     - Free kernel stack
     - Free page directory
     - Set state to `UNUSED`
     - Set PID to 0
     - Return child's PID to parent
   - If no child is in `ZOMBIE` state, put parent to sleep until awakened
3. If no children found, return -1

## Exec System Call Implementation

The exec system call loads a program into memory and executes it:

1. **ELF Format Processing**:
   - ELF (Executable Linker Format) is the standard format for executables
   - ELF Header contains:
     - Identifier (magic number to identify ELF files)
     - Type (executable, relocatable, shared object)
     - Machine details (architecture compatibility)
     - Entry point (virtual address where execution begins)
     - Pointers to program and section headers

2. **Implementation Steps**:
   - Get pointer to inode of executable
   - Read ELF header from inode
   - Verify ELF magic number (`0x7FELF`)
   - Setup kernel page tables
   - Read program headers
   - Load code and data segments from ELF image into RAM
   - Create user stack space:
     - Allocate two contiguous pages (one for stack, one guard page)
     - Guard page is made inaccessible to protect against stack overflow
   - Fill user stack with command line arguments:
     - Arguments (arg0 to argN, null termination)
     - Pointers to arguments (forms argv)
     - argc (count of arguments)
     - Dummy return location for main
   - Set trapframe values:
     - `eip` = elf.entry (pointer to main function)
     - `esp` = stack pointer value
   - When exec returns, execution begins at main() with proper stack setup

## Memory Layout

After exec completes:
- Kernel code and data in upper half of virtual address space
- User code, data, and stack in lower half
- Kernel stack dedicated to the process

This implementation ensures proper process creation, execution, and termination while maintaining memory isolation between processes.