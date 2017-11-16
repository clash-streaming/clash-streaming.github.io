---
layout: default
---

# Logical Query Plans


A logical plan is a rooted n-way plan which consists of operators.
Each operator consumes n streams and emits 1 stream.

They are located in the package `query_plan.lqp`.

A logical query plan (LQP) roughly determines operator ordering and is where e.g. predicate-pushdown happens.

The class hierarchy for the tree consists of interfaces and classes and can be found in `query_plan.lqp.tree`. 

## Type Hierarchy

There are a couple of marker interfaces:

{% plantuml %}
interface Operator
interface MaterializingOperator
interface NonMaterializingOperator
interface JoinOperator

Operator <|-down- MaterializingOperator
Operator <|-down- NonMaterializingOperator
Operator <|-down- JoinOperator
{% endplantuml %}

The operators implement the according interfaces and--if meaningful--form sub hierarchies (some classes left out for clarity):

{% plantuml %}
interface JoinOperator
interface Operator

class SourceStream
class MatSourceStream
class NonMatSourceStream

SourceStream -up-|> Operator
MatSourceStream -up-|> SourceStream
NonMatSourceStream -up-|> SourceStream

class MultiStream
class MatMultiStream
class NonMatMultistream

MultiStream -up-|> JoinOperator
MatMultiStream -up-|> MultiStream
NonMatMultistream -up-|> MultiStream

class HypercubeJoin
HypercubeJoin -up-|> JoinOperator
{% endplantuml %}

Also, the `Mat*` resp. `NonMat*` classes implement the `MaterializingOperator` resp. `NonMaterializingOperator` interfaces.


## Cost Models

A cost model assigns a query plan a cost.



