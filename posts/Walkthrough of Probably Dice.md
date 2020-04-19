---
title: Walkthrough of Probably Dice
date: 2018-01-13
tags: [Python, CheckIO]
---

![cover](https://raw.githubusercontent.com/KenMercusLai/kenmercuslai.github.io/pics/uPic/coverdice.jpg)

## 题目需求

题目的原意可以总结为：求N个M面骰子（骰子点数为1-M）掷出X点数的概率。

其中，N，M，X依次为我们需要编写的函数的三个参数。返回值是0～1的一个数字，需要4舍5入保留四位小数。

这是题目的原始代码：

```python
def probability(dice_number, sides, target):
    return 0.0
if __name__ == '__main__':
    #These are only used for self-checking and are not necessary for auto-testing
    def almost_equal(checked, correct, significant_digits=4):
        precision = 0.1 ** significant_digits
        return correct - precision < checked < correct + precision

    assert(almost_equal(probability(2, 6, 3), 0.0556)), "Basic example"
    assert(almost_equal(probability(2, 6, 4), 0.0833)), "More points"
    assert(almost_equal(probability(2, 6, 7), 0.1667)), "Maximum for two 6-sided dice"
    assert(almost_equal(probability(2, 3, 5), 0.2222)), "Small dice"
    assert(almost_equal(probability(2, 3, 7), 0.0000)), "Never!"
    assert(almost_equal(probability(3, 6, 7), 0.0694)), "Three dice"
    assert(almost_equal(probability(10, 10, 50), 0.0375)), "Many dice, many sides"
```

## 思路

其实从这个问题来看，我们有一个很直观的思路就是组合出所有的可能，然后筛选出符合要求的组合，然后进行计数即可。有了符合要求的组合数量，除以总的组合数即可得到答案。

我们先把问题分开来看，然后再将各个碎片组合起来。

产生dice_number个，数字是1~sides的list:

```python
[range(1, sides + 1)] * dice_number
```

我们测试一下，两个6面骰子：

```python
>>> [range(1, 6 + 1)] * 2

[[1, 2, 3, 4, 5, 6], [1, 2, 3, 4, 5, 6]]
```

<div class="output_wrapper"><div class="output"><div class="output_area"><div class="prompt output_prompt">Out[4]:</div><div class="output_text output_subarea output_pyout">[[1, 2, 3, 4, 5, 6], [1, 2, 3, 4, 5, 6]]</div></div></div></div>

我们现在来试着得出所有的组合。

不过需要注意的是，这里可不能用permutations来实现。原因是：

- 我们生成的是包含两个子list的list。也就是说，里面只包含两个元素；

```python
>>> import itertools
>>> [i for i in itertools.permutations([range(1, 6 + 1)] * 2)]

[([1, 2, 3, 4, 5, 6], [1, 2, 3, 4, 5, 6]),
 ([1, 2, 3, 4, 5, 6], [1, 2, 3, 4, 5, 6])]
```

- 既是我们将列表做成一个包含12个元素的list，permutation会导致每个合理的组合出现两次。因为permutations并不区分两个dice，所以我们希望只得到(第一个骰子点数，第二个骰子点数)的情况，在permutations会出现（第二个骰子点数，第一个骰子点数）的情况。（千万不要直接运行，一共是12!个排列！）

```python
[i for i in itertools.permutations(range(1, 6 + 1) * 2)]
```

其实我们两个创建两个子list包含相同的元素，是为了模拟第一个骰子点数和第二个点数，正确的做法是

```python
[i for i in itertools.product(*([range(1, 6 + 1)] * 2))]

[(1, 1),
 (1, 2),
 (1, 3),
 (1, 4),
 (1, 5),
 (1, 6),
 (2, 1),
 (2, 2),
 (2, 3),
 (2, 4),
 (2, 5),
 (2, 6),
 (3, 1),
 (3, 2),
 (3, 3),
 (3, 4),
 (3, 5),
 (3, 6),
 (4, 1),
 (4, 2),
 (4, 3),
 (4, 4),
 (4, 5),
 (4, 6),
 (5, 1),
 (5, 2),
 (5, 3),
 (5, 4),
 (5, 5),
 (5, 6),
 (6, 1),
 (6, 2),
 (6, 3),
 (6, 4),
 (6, 5),
 (6, 6)]
```
到此我们算是解决了一个直观上最重要的问题——如何得出两个骰子的组合。剩下的就是把每个组合求和看看是不是我们需要的点数。这样我们得到了第一个版本的解答：

```python
from itertools import product
def probability(dice_number, sides, target):
    combinations = [i
                    for i in product(*([range(1, sides + 1)] * dice_number))
                    if sum(i) == target]
    return round(len(combinations) / (sides ** dice_number), 4)
```

我们来测试以下结果：

```python
from __future__ import division
def almost_equal(checked, correct, significant_digits=4):
    precision = 0.1 ** significant_digits
    return correct - precision < checked < correct + precision

%time assert(almost_equal(probability(2, 6, 3), 0.0556)), "Basic example"
%time assert(almost_equal(probability(2, 6, 4), 0.0833)), "More points"
%time assert(almost_equal(probability(2, 6, 7), 0.1667)), "Maximum for two 6-sided dice"
%time assert(almost_equal(probability(2, 3, 5), 0.2222)), "Small dice"
%time assert(almost_equal(probability(2, 3, 7), 0.0000)), "Never!"
%time assert(almost_equal(probability(3, 6, 7), 0.0694)), "Three dice"
CPU times: user 45 µs, sys: 1 µs, total: 46 µs
Wall time: 52 µs
CPU times: user 45 µs, sys: 1 µs, total: 46 µs
Wall time: 51 µs
CPU times: user 44 µs, sys: 1 µs, total: 45 µs
Wall time: 49.8 µs
CPU times: user 32 µs, sys: 1 µs, total: 33 µs
Wall time: 38.9 µs
CPU times: user 21 µs, sys: 1e+03 ns, total: 22 µs
Wall time: 26 µs
CPU times: user 97 µs, sys: 1e+03 ns, total: 98 µs
Wall time: 103 µs
```

看来都动过了，而且用时都很短。不过不知道你有没有注意到，我少了最后一个测试。原因是什么呢？

现在的这种方法，总共需要测试 sides**dice_number 这么多次。最后一个测试就将有10**10=100亿！所以最后一项测试可以预计到将话费大量的时间。具体我就不测试了。我们需要的是另外一种更优化的算法。

## 思路v2

既然我们主要话费时间的地方在遍历所有的组合情况，那么我们就在这上面进行优化。

以第一个测试为例——两个6面骰子，目标点数为3。稍微思考一下就会发现，组合的方法是(1, 2)和(2, 1)。如果目标点数是4，那么合理的组合是(1, 3)，(2, 2)，(3, 1)。到这里，我们是不是嗅到了一些优化的可能呢？：）当然是可以的！因为加法中各个数是没有顺序要求的，如果可以打乱骰子的顺序，得出的点数组合是有重复情况的。我们就可以先求出数字的组合，再来求出每种组合可能的排列数即可。

由于是需要求出各个骰子的点数组合情况，所以点数是可以重复的。这时我们直接用combinations_with_replacement这个函数就可以了。而且可以粗略的计算出，这种时候需要遍历的数量就极具减少到了 C(sides+dice_number-1, dice_number)。

当求出这些组合方式之后，我们需要判断一共有多少种唯一的排列方式——比如(1, 3)可以变成(3, 1)；但(2, 2)就没有其他唯一的排列方式了。

起始这也比较简单，详细的信息见 [这里](http://www.mathwarehouse.com/probability/permutations-repeated-items.php)

```python
from math import factorial
from itertools import combinations_with_replacement, groupby
def probability(dice_number, sides, target):
    counter = 0
    for i in combinations_with_replacement(range(1, sides + 1), dice_number):
        if sum(i) == target:
            itemCount = [len([k for k in j]) for _, j in groupby(i)]
            counter += factorial(len(i)) / reduce(lambda x, y: x * y,
                                                  map(factorial, itemCount))
    return round(counter / (sides ** dice_number), 4)
```

我们还是测试一下:

```
%time assert(almost_equal(probability(2, 6, 3), 0.0556)), "Basic example"
%time assert(almost_equal(probability(2, 6, 4), 0.0833)), "More points"
%time assert(almost_equal(probability(2, 6, 7), 0.1667)), "Maximum for two 6-sided dice"
%time assert(almost_equal(probability(2, 3, 5), 0.2222)), "Small dice"
%time assert(almost_equal(probability(2, 3, 7), 0.0000)), "Never!"
%time assert(almost_equal(probability(3, 6, 7), 0.0694)), "Three dice"
%time assert(almost_equal(probability(10, 10, 50), 0.0375)), "Many dice, many sides"
CPU times: user 66 µs, sys: 12 µs, total: 78 µs
Wall time: 83.9 µs
CPU times: user 52 µs, sys: 1 µs, total: 53 µs
Wall time: 57.9 µs
CPU times: user 56 µs, sys: 0 ns, total: 56 µs
Wall time: 62 µs
CPU times: user 31 µs, sys: 1e+03 ns, total: 32 µs
Wall time: 301 µs
CPU times: user 19 µs, sys: 1 µs, total: 20 µs
Wall time: 23.8 µs
CPU times: user 83 µs, sys: 1e+03 ns, total: 84 µs
Wall time: 88 µs
CPU times: user 74.7 ms, sys: 8.61 ms, total: 83.3 ms
Wall time: 98.5 ms
```

我们把所有的碎片稍微整理一下就得到了完整的解答：(checkio不支持import future，所以我们要去掉这个，然后修改一下除法)

```python
from math import factorial
from itertools import combinations_with_replacement, groupby

def probability(dice_number, sides, target):
    counter = 0
    for i in combinations_with_replacement(range(1, sides + 1), dice_number):
        if sum(i) == target:
            itemCount = [len([k for k in j]) for _, j in groupby(i)]
            counter += factorial(len(i)) * 1.0 / reduce(lambda x, y: x * y,
                                                        map(factorial,
                                                            itemCount))
    return round(counter * 1.0 / (sides ** dice_number), 4)
if __name__ == '__main__':
    # These are only used for self-checking and are not necessary for
    # auto-testing
    def almost_equal(checked, correct, significant_digits=4):
        precision = 0.1 ** significant_digits
        return correct - precision < checked < correct + precision
    assert(almost_equal(probability(2, 6, 3), 0.0556)), "Basic example"
    assert(almost_equal(probability(2, 6, 4), 0.0833)), "More points"
    assert(almost_equal(probability(2, 6, 7), 0.1667)
           ), "Maximum for two 6-sided dice"
    assert(almost_equal(probability(2, 3, 5), 0.2222)), "Small dice"
    assert(almost_equal(probability(2, 3, 7), 0.0000)), "Never!"
    assert(almost_equal(probability(3, 6, 7), 0.0694)), "Three dice"
    assert(almost_equal(probability(10, 10, 50), 0.0375)
           ), "Many dice, many sides"
```

PS: 题目的链接：[http://www.checkio.org/mission/probably-dice/](http://www.checkio.org/mission/probably-dice/)
