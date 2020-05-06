---
layout: documentation
title: Join Ordering Strategies
major_category: Internals
---

In this page we list the available join ordering strategies. The join ordering strategy is responsible for selecting the way through processing components for each incoming tuple. Ideally, the selected way generates the least intermediate results of all available alternatives.


## Materialization Tree Strategies

This family of optimization strategies combines inputs in a n-ary tree form. Each input is a leaf of the tree, and each inner node is a materialization of the join of all inputs below. The root of the tree is not materialized, but represents the final output. All parent nodes (i.e., the inner nodes and the root) are realized using the MultiStream operator.

### FlatTheta

This strategy creates tree with a root node where all children are leaves, thus the term flat. Because it does not materialize any intermediate result, its storage consumption is minimal. That comes at the cost of needing to re-construct intermediate results.
