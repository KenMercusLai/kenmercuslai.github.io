---
title: "Walkthrough of Text Holes Golf"
date: 2014-08-30
tags: [CheckIO, Python]
---

冲分的时候又到了！！
# 题目要求

题目要求一如既往的简单明了：

```
统计一段文字中，有多少空格满足周围都不是空格字符的数量
```

而原始代码嘛……

```python
def golf(text):
    return 0
```

# 思路

我还是先用普通的方式来实现，然后再简化程序。
 第一行、最后一行、第一列和最后一列不可能有满足条件的空格，所以在代码里面就直接忽略了。

```python
def golf(t):
    c = 0
    for r in range(1, len(t) - 1):
        for i in range(1, len(t[r]) - 1):
            try:
                if (t[r][i] == ' 'and t[r][i - 1] != ' 'and t[r][i + 1] != ' 'and t[r - 1][i] != ' 'and t[r + 1][i] != ' 'and t[r + 1][i+1] != ' 'and t[r-1][i-1] != ' 'and t[r + 1][i-1] != ' 'and t[r-1][i+1] != ' '):
                    c += 1
            except:
                pass
    return c
```

当然，不出意外的。我们的代码太长了：

```
Your code is correct, but this is too long (414) for any points
```


# 简化

简单的将空格去掉后再测试，结果是：

```
Your code is correct, but this is too long (355) for any points
```

再把判断周围一圈的判断代码改成not in这样：

```python
def golf(t):
    c=0
    for r in range(1,len(t)-1):
        for i in range(1,len(t[r])-1):
            try:
                if t[r][i]==' 'and' 'not in[t[r][i-1],t[r][i+1],t[r-1][i],t[r+1][i],t[r+1][i+1],t[r-1][i-1],t[r+1][i-1],t[r-1][i+1]]:
                    c+=1
            except:pass
    return c
```

这样改动后，结果是：Points: 46, Place: 57th

虽然简化了很多，但是可以发现，代码太长主要是亮点：
1. 两层for循环
2. 判断语句太长

我们现在要想办法来简化这两个地方。首先想到的是能不能简化判断语句。如果我们每次取出一个3×3的方块，然后保证中间是空格，其他不是就可以了。也就是说，对于这样的一个方块

```python
a='1fji "9br'
```

我们只要判断
```python
a.count(' ')==1 and a[5]==' '
```
即可。这样相对原来的长度就短了很多。

第二部就是如何产生这个方块。我们假设如下的字符串

```python
a="How are you doing?"
b="I'm fine. OK."
c="Lorem Ipsum?"
```

那么我们可以用如下的方法得到我们需要的东西：

```python
a="How are you doing?"
b="I'm fine. OK."
c="Lorem Ipsum?"
[(a[i:i+3], b[i:i+3], c[i:i+3]) for i in range(0, min(len(a), len(b), len(c)))]

[('How', "I'm", 'Lor'),
 ('ow ', "'m ", 'ore'),
 ('w a', 'm f', 'rem'),
 (' ar', ' fi', 'em '),
 ('are', 'fin', 'm I'),
 ('re ', 'ine', ' Ip'),
 ('e y', 'ne.', 'Ips'),
 (' yo', 'e. ', 'psu'),
 ('you', '. O', 'sum'),
 ('ou ', ' OK', 'um?'),
 ('u d', 'OK.', 'm?'),
 (' do', 'K.', '?')]
```

把上两个进行组合一下：

```python
[1
 for i in range(0, min(len(a), len(b), len(c)))
 if b[i+1]==' ' and (a[i:i+3]+b[i:i+3]+c[i:i+3]).count(' ')==1]
```

有一个空格满足条件，这个我们可以手动进行验证。那么现在就是让a, b, c这三个变量能够变化起来。新的代码如下：

```python
def golf(t):
    c = 0
    for j in range(0, len(t) - 2):
        c+= sum([1
                 for i in range(0, min(len(t[j]), len(t[j + 1]), len(t[j + 2])) - 1)
                 if t[j + 1][i + 1] == ' ' and (t[j][i:i + 3] + t[j + 1][i:i + 3] + t[j + 2][i:i + 3]).count(' ') == 1 and len(t[j][i:i + 3] + t[j + 1][i:i + 3] + t[j + 2][i:i + 3])==9])

Personal best: 75, Place: 55th
```

再简化一点，同时把缩进改成1个空格:

```python
def golf(t):
 c=0
 for j in range(0,len(t)-2):
  x,y,z=t[j:j+3]
  for i in range(0,min(len(x),len(y),len(z))-1):
   u=x[i:i+3]+y[i:i+3]+z[i:i+3]
   if y[i+1]==' 'and u.count(' ')==1 and len(u)==9:c+=1
 return c

Personal best: 140, Place: 42nd
```

再小修改一下：

```python
def golf(t):
 c=0
 for j in range(0,len(t)-2):
  for i in range(0,min(map(len,t[j:j+3]))-1):
   x,y,z=t[j:j+3];u=x[i:i+3]+y[i:i+3]+z[i:i+3]
   if all([y[i+1]==' ',u.count(' ')*9==len(u)]):c+=1
 return c

Personal best: 148, Place: 40th
```

虽然觉得还是有很大的提升空间，但是暂时想不出如何优化。暂时就此打住，以后有心的想法再修改。
