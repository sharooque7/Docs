# Process Creation, Execution, and Termination in Operating Systems

## Process Creation: The Fork System Call

### How Fork Works
- **Cloning**: Processes are created by cloning an existing process using the `fork()` system call
- The calling process becomes the parent, and the new process is the child
- The child is an exact duplicate of the parent at the moment of creation
- **Return values**:
  - In parent process: `fork()` returns child's PID (positive value)
  - In child process: `fork()` returns 0
  - If fork fails: returns -1

### Fork Implementation in the OS
1. **Metadata duplication**:
   - Copy the parent's page table for the child
   - Duplicate the parent's kernel stack
   - Create a new Process Control Block (PCB) entry
   
2. **Process state management**:
   - Child process initially set to "NEW" state
   - After metadata initialization, state changes to "READY"
   - "NEW" state indicates PID is taken but process isn't ready to run
   - "READY" state means process can be added to ready queue and scheduled

3. **Memory management**:
   - Initially, both parent and child page tables point to the same physical frames
   - This allows memory sharing until modifications occur

### Copy-on-Write (COW)
- When fork executes, all parent pages are marked as "shared" in both page tables
- When either process attempts to modify shared data:
  - OS intercepts the write operation
  - Creates a copy of only the specific page being modified
  - Updates the page table of the modifying process to point to the new copy
  - Original page remains unchanged for the other process
- **Advantage**: Efficient memory usage as only modified pages require duplication
- Common code (like library functions) remains shared among processes

## Executing a New Program: The Exec System Call

### Fork-Exec Pattern
- Creating a new program is a two-step process:
  1. `fork()` creates a child process (duplicate of parent)
  2. `exec()` replaces the child's memory image with a new program

### Exec Implementation
- Finds the executable file on disk
- Loads required pages into memory on demand
- Updates the child's page table to map to the new pages
- Common functionality between parent and child can still be shared

### Process Tree
- Every process (except the first) is created from a parent process
- Results in a tree-like structure with "init" as the root
- Can be visualized using the `pstree` command
- The first process (init/PID 1) is created by the kernel during boot
  - Located at `/sbin/init` in Unix systems
  - Its main task is to start other processes

## Process Termination

### Voluntary Termination
- Process calls `exit(status)` to terminate itself
- Status code is passed to parent process
- Example: `exit(0)` for normal termination

### Involuntary Termination
- Process is forcefully terminated
- `kill` system call sends termination signals to processes
- Signal types:
  - SIGTERM: Standard termination signal
  - SIGQUIT: Quit signal
  - SIGINT: Interrupt signal (Ctrl+C)
  - SIGHUP: Hangup signal

### Wait System Call
- Called by parent process to wait for child termination
- Causes parent to block until a child exits
- Returns the PID of the terminated child
- Can collect the exit status of the child
- Syntax: `wait(&status)` or `waitpid(pid, &status, options)`

## Special Process States

### Zombie Processes
- Process that has terminated but still has an entry in the process table
- Exists so parent can read exit status through `wait()`
- Removed when parent calls `wait()` (process is "reaped")
- If parent doesn't call `wait()`, zombie entries persist (resource leak)
- "Reaper process" periodically cleans up unreaped zombies

### Orphan Processes
- Process whose parent has terminated before it
- Types:
  - **Unintentional**: Occurs when parent crashes
  - **Intentional** (daemons): Background processes deliberately detached from user session
- Orphaned processes are "adopted" by the init process (PID 1)

## Internal Implementation Details

### Exit System Call Internals
1. Decrement usage count of all open files
   - Close files if count reaches zero
2. Wake up parent process (if sleeping)
3. Transfer children to init process (adoption)
4. Set process state to zombie
5. Page directory and kernel stack remain allocated (for debugging)

### Wait System Call Internals
1. Iterate through process table
2. For each process, check if it's a child of the current process
3. If child found:
   - If child is zombie:
     - Deallocate kernel stack
     - Free page directory
     - Return child's PID
   - If child is not zombie:
     - Parent sleeps (blocks) until notified
4. Return -1 if no children exist