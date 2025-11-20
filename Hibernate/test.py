nums = [1,1,1,2,2,3]
k = 2

occurance = {}
map_max_val = {}
max_result = []

for num in nums:
    if num not in occurance:
        occurance[num] = 1
    else:
        occurance[num] += 1

# for key, value in occurance.items():
#     map_max_val[value] = key
#     max_result.append(value)




max_values = list(occurance.values())
max_values.sort()
print(max_values)