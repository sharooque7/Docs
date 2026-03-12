# **📚 LINKED LIST - COMPLETE REVISION NOTES**

## **1. BASIC STRUCTURE**
```
Node Structure:
+----------------+
| data | next    |
+----------------+
    ↓ points to next node
```

## **2. TYPES OF LINKED LISTS**
- **Singly Linked List**: One direction
- **Doubly Linked List**: Two directions (prev & next)
- **Circular Linked List**: Last node points to first

## **3. CORE OPERATIONS**

### **Traversal**
- Start from head, follow `next` pointers until `NULL`
- Time: O(n)

### **Insertion**
**At beginning**: O(1)
```text
newNode->next = head
head = newNode
```

**At end**: O(n) (unless you maintain tail pointer)
```text
traverse to last node
last->next = newNode
newNode->next = NULL
```

**At position**: O(n) worst case

### **Deletion**
**From beginning**: O(1)
```text
temp = head
head = head->next
delete temp
```

**From end**: O(n) (need previous pointer)

**By value**: O(n) (search + delete)

## **4. COMMON PATTERNS & TECHNIQUES**

### **Two Pointer Techniques**
1. **Slow-Fast (Floyd's Cycle Detection)**
   - Detect cycles
   - Find middle node
   - Find nth from end

2. **Middle of Linked List**
```text
slow = fast = head
while fast and fast->next:
    slow = slow->next
    fast = fast->next->next
# slow is at middle
```

3. **Nth Node from End**
```text
main = ref = head
move ref N nodes ahead
then move both until ref reaches end
main will be at (length-N)th node
```

### **Reversal Techniques**
**Iterative reversal**: O(n) time, O(1) space
```text
prev = NULL
curr = head
while curr:
    next = curr->next
    curr->next = prev
    prev = curr
    curr = next
head = prev
```

**Recursive reversal**: O(n) time, O(n) stack space

## **5. CYCLE RELATED PROBLEMS**

### **Cycle Detection** (Floyd's Algorithm)
- Slow moves 1 step, fast moves 2 steps
- If they meet → cycle exists
- If fast reaches NULL → no cycle

### **Find Cycle Start Node**
1. Detect meeting point (using Floyd's)
2. Move one pointer to head
3. Move both one step until they meet → cycle start

### **Cycle Length**
- After detecting meeting point
- Keep one pointer fixed, move other one step at a time
- Count steps until they meet again

## **6. MERGE OPERATIONS**

### **Merge Two Sorted Lists**
- Use dummy node approach
- Compare nodes, link smaller one
- O(n+m) time

### **Merge K Sorted Lists**
- Use priority queue (min-heap)
- Or divide and conquer (merge pairs)

## **7. SPECIAL OPERATIONS**

### **Palindrome Check**
1. Find middle
2. Reverse second half
3. Compare both halves
4. Re-reverse to restore

### **Intersection Point of Two Lists**
1. Find lengths of both lists
2. Move longer list's pointer ahead by difference
3. Move both together until they meet

### **Rotate List**
1. Connect last node to head (make circular)
2. Find new tail at (length - k)th position
3. Break connection

## **8. DOUBLY LINKED LIST SPECIFICS**
- Has `prev` pointer
- Can traverse backwards
- Deletion is easier (no need to track previous)
- More memory (extra pointer per node)

## **9. COMMON MISTAKES TO AVOID**
- Not handling empty list case
- Forgetting to update multiple pointers
- Memory leaks (not freeing deleted nodes)
- Infinite loops in cycle detection
- Off-by-one errors in position-based operations
- Not checking `NULL` before dereferencing

## **10. TIME COMPLEXITY SUMMARY**
| Operation | Singly LL | Doubly LL |
|-----------|-----------|-----------|
| Access | O(n) | O(n) |
| Search | O(n) | O(n) |
| Insert at head | O(1) | O(1) |
| Insert at tail | O(n) or O(1)* | O(1) with tail |
| Delete at head | O(1) | O(1) |
| Delete at tail | O(n) | O(1) |

*With tail pointer

## **11. VS ARRAY COMPARISON**
| Aspect | Array | Linked List |
|--------|-------|-------------|
| Memory | Contiguous | Non-contiguous |
| Access | O(1) | O(n) |
| Insert at start | O(n) | O(1) |
| Insert at end | O(1) amortized | O(n) or O(1) |
| Dynamic size | Fixed/Resize needed | Dynamic |
| Memory overhead | None | Pointer overhead |

## **12. REAL-WORLD APPLICATIONS**
- **Undo/Redo** (doubly linked list)
- **Browser history** (doubly linked list)
- **Music playlist**
- **Hash table chaining**
- **Memory allocation**
- **Implementation of stacks/queues**

---

**Quick Mnemonic for Cycle Detection:**  
"Slow and steady wins the race, but fast catches the loop!"

**Remember:** Always draw diagrams when solving LL problems. Visualizing pointers helps avoid mistakes!