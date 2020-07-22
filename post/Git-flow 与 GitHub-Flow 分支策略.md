---
title: "Git-flow 与 GitHub-Flow 分支策略"
date: 2020-07-22
tags: [Development, Git]
---

Git 自身丰富的功能可以满足各种不同的需求，但是通常会让人对于怎么有效使用它感到困惑。除了功能上需要细究的地方之外，最常见的无非就是如何有效的管理分支。

Git 的分支管理并没有一个统一的“最佳方法”。每一种方法都有自己的优点和缺点，所以适应不同的场景。不过最常见到的无非 Git-flow和GitHub-flow

# Git-flow

如果在网上搜素git分支策略，可能最常见的就是[Vincent在2010年写的Git-flow](https://nvie.com/posts/a-successful-git-branching-model/)。这个方法出名到很多git工具对它都有快捷操作的支持，比如sourcetree和fork。

Git-flow中有一条主线——develop分支，其他所有的分支都可以视作这个分支上的派生。在develop分支上派生的feature分支顾名思义是用来开发新功能的，在每个新功能开发完成后合并到develop分支。

一般默认的master分支在git-flow中被用来作为发布稳定版本，与由develop分支派生的release分支不同，release是一个版本的“准备”发布阶段，其中可能存在一些bug，而在一个版本进入release之后，通常只对其进行修复bug的工作。直到认为release中的版本足够稳定，那么这个版本则会进入master。当然，如果master版本中有任何问题需要修复，也可以通过hotfix分支来修复。

Git-flow本身对feature分支没有任何的规定，所以合并频率也是无法预估的。同时也没有对develop分支的健康程度有定义，所以这个分支的代码健康程度完全取决于开发团队的管理。不过git-flow本身有release分支来看，develop分支本身并不是release-ready。

正如Vincent后来写到的一样，git-flow适用于需要同时维护多个版本的情况。这点我个人感觉和SVN的方式其实非常像。

# Github-flow

git-flow虽然非常出名，但是本身的管理策略还是非常复杂，而且在一些情况下并不实用。随着GitHub的流行，[Scott在他的博客中描述了另一种策略: GitHub flow](http://scottchacon.com/2011/08/31/github-flow.html)。

与git-flow不同的是，GitHub Flow假定主分支只有一个release-ready的版本，而且主分支会以比较高的频率接收其他分支的合并。在这样的假设下，Github Flow就不再需要release分支，同时因为合并频率高，bug会和feature分支一样的模式进行修复，hotfix也再没有必要。这种策略极大的简化了分支的结构，只留下了主分支和功能分支。

开发人员都在不同的feature分支下进行开发，有可能是一行代码，也有可能是大量的更新。但这些分支最终都在开发完成后合并进master主分支。