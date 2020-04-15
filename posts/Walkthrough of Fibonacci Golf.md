---
title: "Walkthrough of Fibonacci Golf"
date: 2018-01-13
tags: [CheckIO, Python]
---

##题目需求
题目的原意可以总结为：以尽量简洁的方式，完成各种类Fibonacci计算。
提到的类型有：

```
fibonacci:
f(0)=0, f(1)=1, f(n)=f(n-1)+f(n-2)
tribonacci:
f(0)=0, f(1)=1, f(2)=1, f(n)=f(n-1)+f(n-2)+f(n-3)
lucas:
f(0)=2, f(1)=1, f(n)=f(n-1)+f(n-2)
jacobsthal:
f(0)=0, f(1)=1, f(n)=f(n-1)+2*f(n-2)
pell:
f(0)=0, f(1)=1, f(n)=2*f(n-1)+f(n-2)
perrin:
f(0)=3, f(1)=0, f(2)=2, f(n)=f(n-2)+f(n-3)
padovan:
f(0)=0, f(1)=1, f(2)=1, f(n)=f(n-2)+f(n-3)
```

题目的原始代码非常简单：

```python
def fibgolf(type, num):
    return 0

if __name__ == '__main__':
    assert fibgolf('fibonacci', 10) == 55
    assert fibgolf('tribonacci', 10) == 149
    assert fibgolf('lucas', 10) == 123
    assert fibgolf('jacobsthal', 10) == 341
    assert fibgolf('pell', 10) == 2378
    assert fibgolf('perrin', 10) == 17
    assert fibgolf('padovan', 10) == 9
```

##思路

其实从题目给出的例子来看，各种数列在计算方式上都是高度类似的。我们只需要将计算方式和初始数值确定，就能确定各种f(n)的值。

为什么要出这样一个题目，在题目最下面的解释中也有详细的说明：
>How it is used: This mission teaches you the driving idea behind the Don’t Repeat Yourself (DRY) principle of software development. The principle is as follows: “Every piece of knowledge must have a single, unambiguous, authoritative representation within a system.” This principle allows you to make changes to your code with uniformly predictable results. This principle stands in contrast to the “Write Everything Twice” (WET) principle, which is sometimes also known as the “We Enjoy Typing” principle.

我的想法是直接给出一个dict来存放各种数列的值和计算方式。同时，由于已经有了起始数值，我打算正向的来计算f(n)的值，直到第n个。（递归是倒着计算，我是正向计算）：

```python
fib = {'fibonacci': ([0, 1], lambda n,v: v[n-1]+v[n-2]),
       'tribonacci': ([0, 1, 1], lambda n,v: v[n-1]+v[n-2]+v[n-3]),
       'lucas': ([2, 1], lambda n,v: v[n-1]+v[n-2]),
       'jacobsthal': ([0, 1], lambda n,v: v[n-1]+2*v[n-2]),
       'pell': ([0, 1], lambda n,v: 2*v[n-1]+v[n-2]),
       'perrin': ([3, 0, 2], lambda n,v: v[n-2]+v[n-3]),
       'padovan': ([0, 1, 1], lambda n,v: v[n-2]+v[n-3])
       }

def fibgolf(type, num):
    v, f = fib[type]
    for i in range(num + 1):
        if i + 1 > len(v):
            v.append(f(i,v))
    return v[num]
```

测试一下能不能通过：

```python
assert fibgolf('fibonacci', 10) == 55
assert fibgolf('tribonacci', 10) == 149
assert fibgolf('lucas', 10) == 123
assert fibgolf('jacobsthal', 10) == 341
assert fibgolf('pell', 10) == 2378
assert fibgolf('perrin', 10) == 17
assert fibgolf('padovan', 10) == 9
```
看来一切正常！提交到checkio看看解答能排名在哪里，也准备受打击看看差第一名多少

```
Your code is correct, but this compiled code is too long (1658) for any points
```

下面开始鬼畜缩减……

## 缩减
先缩减空格

```python
b={'fibonacci':([0,1],lambda n,v:v[n-1]+v[n-2]),'tribonacci':([0,1,1],lambda n,v:v[n-1]+v[n-2]+v[n-3]),'lucas':([2,1],lambda n,v:v[n-1]+v[n-2]),'jacobsthal':([0,1], lambda n,v:v[n-1]+2*v[n-2]),'pell':([0,1],lambda n,v:2*v[n-1]+v[n-2]),'perrin':([3,0,2],lambda n,v:v[n-2]+v[n-3]),'padovan':([0,1,1],lambda n,v:v[n-2]+v[n-3])}
def fibgolf(p,u):
    v,f=b[p]
    for i in range(u):
        if i+1>len(v):v.append(f(i,v))
    return f(u,v)
if __name__ == '__main__':
    assert fibgolf('fibonacci', 10) == 55
    assert fibgolf('tribonacci', 10) == 149
    assert fibgolf('lucas', 10) == 123
    assert fibgolf('jacobsthal', 10) == 341
    assert fibgolf('pell', 10) == 2378
    assert fibgolf('perrin', 10) == 17
    assert fibgolf('padovan', 10) == 9
```

结果是
```
Your code is correct, but this compiled code is too long (1388) for any points
```

把本地测试去掉（反正能不能通过是不靠这些）:

```python
b={'fibonacci':([0,1],lambda n,v:v[n-1]+v[n-2]),'tribonacci':([0,1,1],lambda n,v:v[n-1]+v[n-2]+v[n-3]),'lucas':([2,1],lambda n,v:v[n-1]+v[n-2]),'jacobsthal':([0,1], lambda n,v:v[n-1]+2*v[n-2]),'pell':([0,1],lambda n,v:2*v[n-1]+v[n-2]),'perrin':([3,0,2],lambda n,v:v[n-2]+v[n-3]),'padovan':([0,1,1],lambda n,v:v[n-2]+v[n-3])}
def fibgolf(p,u):
    v,f=b[p]
    for i in range(u):
        if i+1>len(v):v.append(f(i,v))
    return f(u,v)
```

结果是
```
Your code is correct, but this compiled code is too long (1343) for any points
```
继续缩减，改变一些语句的写法:

```python
b={'fibonacci':([0,1],lambda n,v:v[n-1]+v[n-2]),'tribonacci':([0,1,1],lambda n,v:v[n-1]+v[n-2]+v[n-3]),'lucas':([2,1],lambda n,v:v[n-1]+v[n-2]),'jacobsthal':([0,1], lambda n,v:v[n-1]+2*v[n-2]),'pell':([0,1],lambda n,v:2*v[n-1]+v[n-2]),'perrin':([3,0,2],lambda n,v:v[n-2]+v[n-3]),'padovan':([0,1,1],lambda n,v:v[n-2]+v[n-3])}
def fibgolf(p,u):
    v,f=b[p];i=len(v)
    while i<u:
        v+=[f(i,v)];i+=1
    return f(u,v)

Your code is correct, but this compiled code is too long (1317) for any points
```

虽然比开始少了很多，但是还没进入1000的限定最大长度。哇～～～～～～～～～～～

把dict放到里面去！

```python
def fibgolf(p,u):
    v,f={'fibonacci':([0,1],lambda n,v:v[n-1]+v[n-2]),'tribonacci':([0,1,1],lambda n,v:v[n-1]+v[n-2]+v[n-3]),'lucas':([2,1],lambda n,v:v[n-1]+v[n-2]),'jacobsthal':([0,1], lambda n,v:v[n-1]+2*v[n-2]),'pell':([0,1],lambda n,v:2*v[n-1]+v[n-2]),'perrin':([3,0,2],lambda n,v:v[n-2]+v[n-3]),'padovan':([0,1,1],lambda n,v:v[n-2]+v[n-3])}[p];i=len(v)
    while i<=u:v+=[f(i,v)];i+=1
    return v[u]

Your code is correct, but this compiled code is too long (1304) for any points
```

#思路v2

我突然注意到compiled code，不是原始code。所以，原来的思路是需要调整的。用纯粹的加减法来尝试完成这个题目:

```python
def fibgolf(sequence, u):
    if sequence == 'fibonacci':
        i = 2
        a = 0
        b = 1
        while True:
            nxt = a + b
            if i == u: return nxt
            a = b
            b = nxt
            i += 1
    if sequence == 'tribonacci':
        i = 3
        a = 0
        b = 1
        c = 1
        while True:
            nxt = a + b + c
            if i == u: return nxt
            a = b
            b = c
            c = nxt
            i += 1
    if sequence == 'lucas':
        i = 2
        a = 2
        b = 1
        while True:
            nxt = a + b
            if i == u: return nxt
            a = b
            b = nxt
            i += 1
    if sequence == 'jacobsthal':
        i = 2
        a = 0
        b = 1
        while True:
            nxt = 2 * a + b
            if i == u: return nxt
            a = b
            b = nxt
            i += 1
    if sequence == 'pell':
        i = 2
        a = 0
        b = 1
        while True:
            nxt = a + 2 * b
            if i == u: return nxt
            a = b
            b = nxt
            i += 1
    if sequence == 'perrin':
        i = 3
        a = 3
        b = 0
        c = 2
        while True:
            nxt = a + b
            if i == u: return nxt
            a = b
            b = c
            c = nxt
            i += 1
    if sequence == 'padovan':
        i = 3
        a = 0
        b = 1
        c = 1
        while True:
            nxt = a + b
            if i == u: return nxt
            a = b
            b = c
            c = nxt
            i += 1

Your code is correct, but this compiled code is too long (1174) for any points
```

马上就缩减到了1174的长度。看来整个的调整思路是完全正确的。继续简化现在的版本！

先把一些重复的部分进行合并:

```python
def fibgolf(s, u):
    if s == 'fibonacci' or s == 'lucas':
        if s == 'lucas':
            a = 2
        else:
            a = 0
        i = 2
        b = 1
        while True:
            nxt = a + b
            if i == u:
                return nxt
            a = b
            b = nxt
            i += 1
    if s == 'jacobsthal':
        i = 2
        a = 0
        b = 1
        while True:
            nxt = 2 * a + b
            if i == u:
                return nxt
            a = b
            b = nxt
            i += 1
    if s == 'pell':
        i = 2
        a = 0
        b = 1
        while True:
            nxt = a + 2 * b
            if i == u:
                return nxt
            a = b
            b = nxt
            i += 1
    if s == 'perrin' or s == 'padovan':
        if s == 'perrin':
            a = 3
            b = 0
            c = 2
        else:
            a = 0
            b = 1
            c = 1
        i = 3
        while True:
            nxt = a + b
            if i == u:
                return nxt
            a = b
            b = c
            c = nxt
            i += 1
    else:
        i = 3
        a = 0
        b = 1
        c = 1
        while True:
            nxt = a + b + c
            if i == u:
                return nxt
            a = b
            b = c
            c = nxt
            i += 1

Personal best:2, Place: 36th
```

终于进入排名了！继续合并:

```python
def fibgolf(s, u):
    if s == 'fibonacci' or s == 'lucas':
        if s == 'lucas':
            a = 2
        else:
            a = 0
        i = 2
        b = 1
        while True:
            nxt = a + b
            if i == u:
                return nxt
            a = b
            b = nxt
            i += 1
    if s == 'jacobsthal' or s == 'pell':
        i = 2
        a = 0
        b = 1
        while True:
            if s == 'pell':
                nxt = a + 2 * b
            else:
                nxt = 2 * a + b
            if i == u:
                return nxt
            a = b
            b = nxt
            i += 1
    else:
        if s == 'perrin':
            a = 3
            b = 0
            c = 2
        else:
            a = 0
            b = 1
            c = 1
        i = 3
        while True:
            if s == 'perrin' or s == 'padovan':
                nxt = a + b
            else:
                nxt = a + b + c
            if i == u:
                return nxt
            a = b
            b = c
            c = nxt
            i += 1
Personal best: 166, Place: 25th
```

再化简一点！！！把字符串短的放在条件中去，节省compiled后的代码长度。

```python
def fibgolf(s, u):
    if s == 'perrin' or s == 'tribonacci' or s == 'padovan':
        if s == 'perrin':
            a = 3
            b = 0
            c = 2
        else:
            a = 0
            b = 1
            c = 1
        i = 3
        while True:
            n = a + b
            if s == 'tribonacci':
                n += c
            if i == u:
                return n
            a = b
            b = c
            c = n
            i += 1
    else:
        if s == 'lucas':
            a = 2
        else:
            a = 0
        b = 1
        i = 2
        while True:
            n = a + b
            if s == 'pell':
                n += b
            elif s == 'jacobsthal':
                n += a
            if i == u:
                return n
            a = b
            b = n
            i += 1

Personal best: 271, Place: 18th
```

到此，我已经想不出还有什么方法可以缩减代码了。暂时就这样，以后有了新想法再化简。

PS: 这次的题目要求的是编译后代码的长度，而不是以前做过题目中所要求的原始代码长度。以后一定要注意！浪费时间化简了半天…… !-_-
