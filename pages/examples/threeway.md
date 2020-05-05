---
layout: default
title: Threeway example
---

This is an example of a PhysicalGraph that can be used for computing a three-way join. The query is `R`, `S`, and `T`, s.t., `R.x = S.x AND S.y = T.y`. We first ignore windows and show how a flat and a left-deep plan look like.

## Flat Plan

We have three stores: `R-store`, `S-store`, `T-store`, and they are partitioned. For partitioning `R` and `T` there is only one option, `R[x]` and `T[y]`, respectively. For `S`, however we can choose to either partition it according to `x` or to `y`. W.l.o.g. we partition `S` according to `[y]`.

With this, we can insert edges and rules in the graph for storing incoming tuples. The input nodes for the three base relations are called `R-stub`, `S-stub`, and `T-stub`. We need the following edges:

* `R-stub` -> `R-store`, `group(R.x)`
* `S-stub` -> `S-store`, `group(S.y)`
* `T-stub` -> `T-store`, `group(T.y)`

And at the stores, we need the following `RelationReceiveRule`s

* R-store: `receive(R)`
* S-store: `receive(S)`
* T-store: `receive(T)`

For the actual join processing, we need to know the probe orders. W.l.o.g. they are `<R, S, T>` `<S, T, R>`, `<T, S, R>`. Based on the partitioning of the stores, we can decide whether to broadcast a tuple or to send it based on an attribute value.

For the first probe order, `<R, S, T>`, we need these edges and rules:

* `R-stub` -> `S-store`, `ALL`, and we register a `IntermediateJoinRule` at the `S-store`.
* `S-store` -> `T-store`, `group(S.y)`, and we register a `JoinResultRule` at the `T-store`

For the second probe order, `<S, T, R>`, we need these edges and rules:

* `S-stub` -> `T-store`, `group(S.y)`, and we register a `IntermediateJoinRule` at the `T-store`.
* `T-store` -> `R-store`, `group(S.x)`, and we register a `JoinResultRule` at the `R-store`

For the third probe order, `<T, S, R>`, we need these edges and rules:

* `T-stub` -> `S-store`, `group(T.y)`, and we register a `IntermediateJoinRule` at the `S-store`.
* `S-store` -> `R-store`, `group(S.x)`, and we register a `JoinResultRule` at the `R-store`



## Left-deep Plan

TODO