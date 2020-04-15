---
title: "Walkthrough of CheckIO Inside Block"
date: 2015-09-04
tags: [CheckIO, Python]
---

After a long absence, I returned to continue playing CheckIO tasks by a notification mail. The UI had been optimized a lot and the tasks were still as interesting as the before.

[Inside Block](http://www.checkio.org/mission/inside-block/) required checking whether a given point is inside a polygon or not. After some research on google, I found a practical method.


# How to check if a given point is in a polygon

Given a polygon and a point ‘p’, find if ‘p’ lies inside the polygon or not. The points lying on the border are considered inside.
![1](media/15658731990633/1.png)

We can check whether the point is inside or outside by following three simple steps:

1. Draw a horizontal line to the right of each point and extend it to infinity
2. Count the number of times the line intersects with polygon edges.
3. A point is inside the polygon if either count of intersections is odd or point lies on an edge of a polygon. If none of the conditions is true, then point lies outside.

![2](media/15658731990633/2.png)

I do think this approach is simple enough with only one question need to be solved


# How to check if two given line segments intersect?

Given two line segments (p1, q1) and (p2, q2), find if the given line segments intersect with each other.

Before we discuss the solution, let us define the notion of orientation. Orientation of an ordered triplet of points in the plane can be

- counterclockwise
- clockwise
- colinear

The following diagram shows different possible orientations of (a, b, c)
![3](media/15658731990633/3.png)


## How is Orientation useful here?

Two segments (p1,q1) and (p2,q2) intersect if and only if one of the following two conditions is verified

### 1. General Case:

- (p1, q1, p2) and (p1, q1, q2) have different orientations and
- (p2, q2, p1) and (p2, q2, q1) have different orientations

Examples of General Case:
![4](media/15658731990633/4.png)
![5](media/15658731990633/5.png)

### 2. Special Case

- (p1, q1, p2), (p1, q1, q2), (p2, q2, p1), and (p2, q2, q1) are all collinear and
- the x-projections of (p1, q1) and (p2, q2) intersect
- the y-projections of (p1, q1) and (p2, q2) intersect

Examples of Special Case:
![6](media/15658731990633/6.png)

- - - - - -


# One more unexpected

I really thought everything would go smoothly according to the method described above, but an unexpected error showed to me. Considering the following situation:
![7](media/15658731990633/7.png)


The line intersects with the point that connects two segments. This leads the programme considers the there are two intersections and determines the point is outside of the polygon.

To deal with this problem, we could think the line is a half-divider that cut the segment that it intersects into two halves. So every time it intersects a segment, we can double the length of this segment to solve this problem

- - - - - -

I didn’t put the code in the post because I think you can solve it after knowing this method. In case you really want to directly read the code, here is the [link for my checkio solutions repo](https://github.com/KenMercusLai/checkio). Please give me a star if you like it.
