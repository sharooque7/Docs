### Time Complexity 

* Time complexity of recursion =
(number of recursive calls) × (work done per call)

### Space complexity 
#### Auxiliary (working) space

* (space used by recursion & temporary variables)

* Each Recursion hold the variables and function stack frame. Maximum depth of recursion represents the maximum auxillary space. As at any point in recursion calls would not cross the mark. But only keeps calling and removing the stack again and again
* Depth of recursion = Auxillary Space


#### Output space
* This is outside the recursion calls.
* (space required to store the result)

### Why depth × branching = exponential


* Depth	- n, (target / m(min candidates))
* Branching	- 2 choices per call
* Result	- 2 ^ (target / min)
>* Depth alone → linear
>* Branching alone → constant
>* Depth + branching → exponential
>* Exponential time happens when recursion both goes deep and branches at each level


### Brancing

* Branching = the number of recursive calls made from a single function call
* 1 recursive call → no branching
* 2 recursive calls → binary branching
* k recursive calls → k-way branching
