### Virutal Memory

* Entire RAM is split into equal size partitions called Page frames
* Each Page Frame is 4KB each
* Process split into equal block sixe
* block size = page frame size
![alt text](image-9.png)
![alt text](image-10.png)
![alt text](image-11.png)
![alt text](image-12.png)
![alt text](image-13.png)
![alt text](image-14.png)
![alt text](image-15.png)
![alt text](image-16.png)

### Mapping Virtual Memory and RAM

![alt text](image-17.png)
* ./a.out will create a process for us
* Process is represented by what is know as Virtual Memory
* VM is contigous address space starting from 0 and MAX_SIZE
![alt text](image-19.png)
* Processor will put VM on it's BUS
![alt text](image-20.png)
![alt text](image-21.png)

### MMU Mapping
Virtual address comprised of two parts (Table Index and offset)
![alt text](image-22.png)
### MMU in 32 bit system
max process size is 2^32 = 4G
![alt text](image-23.png)
![alt text](image-24.png)
### Working of VM (Steps)
![alt text](image-25.png)
![alt text](image-26.png)
![alt text](image-27.png)
![alt text](image-28.png)
![alt text](image-29.png)
![alt text](image-30.png)

*   When user run program triggers process page table in RAM
* Transfer the control to main function
* The processor will execute the main function. So the instruction of the main method will be present in text area od the process. So that will send the virtual memory to the bus.
* The MMA wil receive the address.The check the process page. Checks If the block is present in memory.The P in process table will let us know. 
* If not present in table will trigger a page fault interupt.  
