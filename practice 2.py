x=0
y=1
print(x)
print(y)

n= int(input('Enter a number'))
for i in range(n):
    temp = x+y
    print(temp)
    x=y
    y=temp

