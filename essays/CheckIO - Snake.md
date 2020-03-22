---
title: CheckIO - Snake
date: 2013-9-12
tags: [[CHECKIO, PYTHON, Programming]]
---
# CheckIO - Snake

[http://www.checkio.org/mission/task/info/snake/python-27/](http://www.checkio.org/mission/task/info/snake/python-27/)

呀〜贪吃蛇啊……

和其他的task不同的是，这个是一次multicall。不过我其实完全可以不考虑这点，每次给出当前map，然后程序给出走法。而寻路的方式，我还是选用A*。虽然每次都会完整的计算一次完整路径，不过我到认为这是免得撞车的好方法。

首先还是需要实现puzzle，不过还是很简单啦。

```python
class AnagramsPuzzle(AStar):
    """ description """
    def __init__(self, goal):
        super(AnagramsPuzzle, self).__init__(goal)

    def heuristic(self, node):
        return abs(self.goal[0]-node.status[0]) + abs(self.goal[1]-node.status[1])

    def get_result(self, node):
        #only care about the first step
        return node.comment
```

而且我们还只关心第一步，后面的都不用管，交给下个call来就行。现在到了node了。

```python
    class AnagramsPuzzleNode(AStarNode):
        """ description """
        def __init__(self, status, G, parent):
            super(AnagramsPuzzleNode, self).__init__(status, G, parent)
                
        def possible_next_nodes(self):
            result = []
            # get current position
            position_zero = divmod([j for i in self.status for j in i].index('0'),
                len(self.status[0]))
            position_one = divmod([j for i in self.status for j in i].index('1'),
                len(self.status[0]))
            snake_length = int(max([j for i in self.status for j in i if j>='0' and j        
            snake_map = [chr(i) for i in range(48, 48+snake_length)]
            snake_map.append('.')
            
            # find possible moves
            if (position_zero[0] > 0 and
                (self.status[position_zero[0]-1][position_zero[1]] == '.' or
                    self.status[position_zero[0]-1, position_zero[1]] == 'C')):
                temp = deepcopy(self.status)
                # update map
                flat_map = [j if j not in snake_map[:-1] 
            else: 
                snake_map = [snake_map.index(j)+1] for i in temp for j in i]
                temp = [''.join(flat_map[i:i+10]) for i in range(0, len(flat_map[0]), len(temp[0]))]
                temp[position_zero[0]-1][position_zero[1]] = 0
                
                new_node = AnagramsPuzzleNode(temp, self.G + 1, self)
                new_node.comment = '10'
                result.append(new_node)
            return result
```

好像很麻烦啊！〰

****

Sep 13, 2013, 11:49

等等！先不要往后写，这里有个问题——我们相当于要自己实现整个游戏，判断蛇的长度，而且尾巴的位置可能多种多样，最终结果可能存在多种结果。

我可不想这么做，找个取巧的方法吧——只考虑蛇头，把后面的身体全部当成树。这样我们就把问题简化成了把蛇头移动到cherry，然后只考虑把第一步移动的方向翻译出来就行了。

```python
    class AnagramsPuzzleNode(AStarNode):
        """ description """
        def __init__(self, status, G, parent):
            super(AnagramsPuzzleNode, self).__init__(status, G, parent)
            
        def possible_next_nodes(self):
            result = []
            # get current position
            position_zero = divmod([j for i in self.status for j in i].index('0'),
                len(self.status[0]))
                
            # find possible moves
            if (position_zero[0] > 0 and
                (self.status[position_zero[0]-1][position_zero[1]] == '.' or self.status[position_zero[0]-1][position_zero[1]] == 'C')):
                temp = deepcopy(self.status)
                # update map
                temp[position_zero[0]-1] = temp[position_zero[0]-1][:position_zero[1]] + '0' + temp[position_zero[0]-1][position_zero[1]+1:]
                temp[position_zero[0]] =  temp[position_zero[0]][:position_zero[1]] + '.' + temp[position_zero[0]][position_zero[1]+1:]
                new_node = AnagramsPuzzleNode(temp, self.G + 1, self)
                new_node.comment = 'UP'
                result.append(new_node)
            if (position_zero[0]             (self.status[position_zero[0]+1][position_zero[1]] == '.' or
                    self.status[position_zero[0]+1][position_zero[1]] == 'C')):
                temp = deepcopy(self.status)
                # update map
                temp[position_zero[0]+1] = temp[position_zero[0]+1][:position_zero[1]]+'0'+temp[position_zero[0]+1][position_zero[1]+1:]
                temp[position_zero[0]] = temp[position_zero[0]][:position_zero[1]]+'.'+temp[position_zero[0]][position_zero[1]+1:]
                new_node = AnagramsPuzzleNode(temp, self.G + 1, self)
                new_node.comment = 'DOWN'
                result.append(new_node)
            if (position_zero[1] > 0 and
                (self.status[position_zero[0]][position_zero[1]-1] == '.' or
                    self.status[position_zero[0]][position_zero[1]-1] == 'C')):
                temp = deepcopy(self.status)
                # update map
                temp[position_zero[0]] = temp[position_zero[0]][:position_zero[1]-1]+'0'+temp[position_zero[0]][position_zero[1]:]
                temp[position_zero[0]] = temp[position_zero[0]][:position_zero[1]]+'.'+temp[position_zero[0]][position_zero[1]+1:]
                new_node = AnagramsPuzzleNode(temp, self.G + 1, self)
                new_node.comment = 'LEFT'
                result.append(new_node)
            if (position_zero[1]             (self.status[position_zero[0]][position_zero[1]+1] == '.' or
                    self.status[position_zero[0]][position_zero[1]+1] == 'C')):
                temp = deepcopy(self.status)
                # update map
                temp[position_zero[0]] = temp[position_zero[0]][:position_zero[1]+1]+'0'+temp[position_zero[0]][position_zero[1]+2:]
                temp[position_zero[0]] = temp[position_zero[0]][:position_zero[1]]+'.'+temp[position_zero[0]][position_zero[1]+1:]
                new_node = AnagramsPuzzleNode(temp, self.G + 1, self)
                new_node.comment = 'RIGHT'
                result.append(new_node)
            return result
```

****

Sep 13, 2013, 13:02

现在我们就等着翻译结果就行了。翻译无非就是注意方向不要搞错了。完整代码如下：

{% gist 6546873 %}