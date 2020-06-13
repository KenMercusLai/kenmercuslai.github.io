---
title: "CheckIO - The Good Radix"
date: 2013-09-08
Tags: [CHECKIO, PYTHON]
---

[Task描述][1]简单的说就是这样：

* 给出的字符串数字是k进制的
* 这个k进制的数换算成10进制之后，能够被k-1整除。

从题目来看非常的简单，不过第二点在题目里面说的不是很清楚，我研究了例子才明白。至于解法，很简单的做一个循环，尝试转换成10进制的数，然后尝试能不能被k-1整除。

```python
def checkio(number):
    for i in xrange(2, 37):
        try:
            if int(number, i) % (i-1) == 0:
                return i
        except:
            pass
    return 0

#These "asserts" using only for self-checking and not necessary for auto-testing
if __name__ == '__main__':
    assert checkio(u"18") == 10, "Simple decimal"
    assert checkio(u"1010101011") == 2, "Any number is divisible by 1"
    assert checkio(u"222") == 3, "3rd test"
    assert checkio(u"A23B") == 14, "It's not a hex"
    print('Local tests done')
```

比较tricky的地方在于，能不能想到用自带的int函数来判断对于一个给定的k值是否是一个合法的radix。

[1]: http://www.checkio.org/mission/task/info/good-radix/python-27/