---
title: "CheckIO - CheckSum"
date: 2013-09-08
Tags: [CHECKIO, PYTHON]
---

[题目][1]的描述超级麻烦，不过逻辑很简单，没有什么特别注意的地方，全是非常基础的知识。

```python
def checkio(data):
    sum_of_digits = 0
    data = [i for i in data if ('0'<=i and i<='9') or ('A'<=i and i<='Z')]
    data.reverse()
    # even
    for i in xrange(0, len(data), 2):
        doubling = (ord(data[i]) - 48) * 2
        if len(str(doubling)) > 1:
            map_point = reduce(lambda x, y: int(x)+int(y),
                               [j for j in str(doubling)])
        else:
            map_point = doubling
        sum_of_digits += map_point
    # odd
    for i in xrange(1, len(data), 2):
        sum_of_digits += ord(data[i]) - 48
    if sum_of_digits == 10:
        return ['0', sum_of_digits]
    return [str(10-(sum_of_digits%10)), sum_of_digits]

#These "asserts" using only for self-checking and not necessary for auto-testing
if __name__ == '__main__':
    assert (checkio(u"799 273 9871") == ["3", 67]), "First Test"
    assert (checkio(u"139-MT") == ["8", 52]), "Second Test"
    assert (checkio(u"123") == ["0", 10]), "Test for zero"
    assert (checkio(u"999_999") == ["6", 54]), "Third Test"
    assert (checkio(u"+61 820 9231 55") == ["3", 37]), "Fourth Test"
    assert (checkio(u"VQ/WEWF/NY/8U") == ["9", 201]), "Fifth Test"

    print("OK, done!")
```
[1]: http://www.checkio.org/mission/task/info/check-digit/python-27/