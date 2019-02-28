




def fibo(n):
    if n <= 1:
        return n
    t = fibo(n-1) + fibo(n-2)
    print(t)
n= int(input('Enter a number'))

for l in range(n):
    fibo(n)

print(fibo(10))


