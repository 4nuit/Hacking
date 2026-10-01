grid = [[0] * 3] * 3
assert(grid == [[0,0,0],[0,0,0],[0,0,0]])

# The inner lists are all references to the same object in memory.
print("hex addresses of grid")
for e in grid:
    for i in range(3):
        print(id(e[i]))

"""
123629688787728
123629688787728
123629688787728
123629688787728
123629688787728
123629688787728
123629688787728
123629688787728
123629688787728
"""

grid[0][0] = 3
assert(grid == [[3, 0, 0], [3, 0, 0], [3, 0, 0]])
# How to avoid: grid = [[0] * 3 for _ in range(3)]  # This creates separate lists for each row

print("grid after grid[0][0] = 3")
for e in grid:
    for i in range(3):
        print(id(e[i]))

"""
123629688787824
123629688787728
123629688787728
123629688787824
123629688787728
123629688787728
123629688787824
123629688787728
123629688787728
"""

grid[2][1] = 4
assert(grid == [[3, 4, 0], [3, 4, 0], [3, 4, 0]])

print("grid after grid[2][1] = 4")
for e in grid:
    for i in range(3):
        print(id(e[i]))
"""
123629688787824
123629688787856
123629688787728
123629688787824
123629688787856
123629688787728
123629688787824
123629688787856
123629688787728
"""
