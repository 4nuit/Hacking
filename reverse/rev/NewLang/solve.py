a = [34, 70, 22, 42, 10, 66, 14, 25, 17, 25, 12, 25, 25, 69, 26, 70, 64, 47, 17, 61, 57, 32, 58, 45, 12, 51, 53]
flag = []
for i in range(len(a)):
    if i % 2 == 0:
        flag.append(((a[i]-7) ^ 102) & 0xff)
    else:
        flag.append(((a[i]-7) ^ 77) & 0xff)

flag = flag[::-1]
print(flag)
for _ in flag:
    print(chr(_), end="")
