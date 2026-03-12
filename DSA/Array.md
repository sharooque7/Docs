* Input: [1,2 3]

```
arr  = [1,2 3]
for i in range(len(arr)):
    for j in range(i, len(arr)):
        print(arr[i:j+1])
```
### SubArray 

* A subarray is a contiguous part of the array.

```
Subarrays of [1,2,3]

[1]
[1,2]
[1,2,3]
[2]
[2,3]
[3]

```

```
Key Points

* Order matters

* Must be continuous

* Total subarrays = n * (n + 1) / 2

* For n = 3 → 3 * 4 / 2 = 6
```

### ONE GOLDEN RULE (memorize this)

1. If two prefix sums are equal → the subarray between them sums to 0
2. If two prefix sums differ by K → the subarray between them sums to K

### Direct Sum
1. ARR = [10 9 8 -2 2]
2. PREFIX_SUM = [10 19 27 25 27]

### Indirect Sum
1. ARR = [10 9 8 -2 2]
2. PREFIX_SUM = [10 19 27 25 27]
3. 27 is duplicate so subarray


### Target
> 0
> * x + {0} = x

> 1
> * x + k = curr_sum
> * x = curr_sum - k

### Return Types
* Return Boolean
* Return Count ++
* Return start and end
* Return length of subArray




Notes
* Brute Force. Find all subArray. TC: O(n ^ 3)


### Subset

* A subset can pick any elements, contiguous or not.
```
Subsets of [1,2,3]

[]
[1]
[2]
[3]
[1,2]
[1,3]
[2,3]
[1,2,3]

```

```

Key Points

* Order does NOT matter

* Not necessarily continuous

* Total subsets = 2^n

* For n = 3 → 2³ = 8
```



### Notes
* Subarrays are contiguous; subsets are not.

* Subarray problems → sliding window, prefix sum, Kadane

* Subset problems → recursion, backtracking, bitmasking, DP