from copy import deepcopy

def demonstrate_issues():
    # Immutable types
    x = 42
    y = x  # Copy by reference, but integers are immutable
    y += 1
    print("Integer:", x, y)  # x is unaffected

    z = 3.14
    w = z  # Same for floats
    w += 1.0
    print("Float:", z, w)

    c = 2 + 3j
    d = c  # Complex numbers are immutable
    d += 1
    print("Complex:", c, d)

    # Mutable types
    lst = [1, 2, 3]
    lst_copy = lst  # Shallow copy, shared reference
    lst_copy[0] = 42
    print("List:", lst, lst_copy)  # Both are modified

    dct = {"key": "value"}
    dct_copy = dct  # Shallow copy, shared reference
    dct_copy["key"] = "new_value"
    print("Dict:", dct, dct_copy)

    st = {1, 2, 3}
    st_copy = st  # Shallow copy, shared reference
    st_copy.add(42)
    print("Set:", st, st_copy)


demonstrate_issues()

def modify_list(input_list):
    input_list[0] = 42

original_list = [1, 2, 3]

# Pass a copy instead
modify_list(deepcopy(original_list))

print("Original List:", original_list)  # Original list remains unchanged
