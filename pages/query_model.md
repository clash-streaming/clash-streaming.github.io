---
layout: default
title: Queries and Relations
---

Queries in Clash are declarative. The user is in principle only allowed to explain **what** they want to have and Clash decides **how** this result is produced.

## Syntax

The syntax of queries is a subset of SQL. For example, these two are Clash queries:

```sql
SELECT s.name, s.address
FROM students s
WHERE s.semester > 10
```

```sql
SELECT a.foo
FROM topic a('sliding', '4', 'hours')
```

We are currently restricted to simple select-from-where-queries without nested subqueries or aggregations.

## Definitions

In this project we (try to) consistently use the terms explained in this section. Consider the following query:

```sql
SELECT a.x, b.y
FROM alice a, bob b
WHERE a.q = 1 AND a.r = b.s
```

* **Input**: the name of an input relation. In the example, `alice` and `bob` are inputs. The system has to know how to get real data from these inputs, which is an orthogonal task to formulating a query.
* **Alias**: the name of inputs used in the rest of the queries. In this case, `a` and `b`.
* **Attribute**: Attributes of the relations, e.g. `x`, `y`, `q`, `r` and `s`. In order to avoid naming clashes, it is forbidden to use attributes without a qualifying alias.
* **AttributeAccess**: The pair of alias and attribute, e.g. `('a', 'q')` in the predicate `a.q = 1`.
* **UnaryPredicate**: A predicate with a single input, e.g. `a.q = 1`. These can be evaluated at ingestion of the inputs or maybe even pushed down into the data sources.
* **BinaryPredicate**: A predicate with two inputs, e.g. `a.r = b.s`, here tuples from both relations, `a` and `b` are needed in order to evaluate the predicate

## Semantics and Relations

With such a query, a **Relation** is defined. The description of a relation comprises of the inputs, and the predicates (unary and binary). The tuples in this relation adhere the predicates.

In general, we interpret a **relation** as a specification of **tuples**.
Data in relation might stem from various sources and is arranged in tuples.
A tuple consists of attributes which satisfy certain properties.

Relations can also be defined in a programmatic way. Consider the following:

```
r1 = relationOf("R")
r2 = r.where("R.x = 1")
r3 = r.where("R.y = 2")
```

Here subsequently three relations are created: `r1`, `r2` and `r3`. `r1` is a BaseRelation with the base name "R". `r2` is a derived relation with the unary predicate forcing the attribute "R.x" to be 1. `r3` is another derived relation with two unary predicates, one carried over from `r2`, and the new one demanding "R.y = 2".

With a join this works as follows:

```
r1 = relationOf("R")
r2 = r.where("R.x = 1")
s1 = relationOf("S")
rs1 = r.join("S")
rs2 = r.where("R.z = S.z")
```

The meaning of `r1`, `r2`, and `s1` is like in the previous example. `rs1` is now a relation with two base names, "R" and "S", and the unary predicate "R.x = 1". `rs2` then also has two base names and the unary predicate as well as a binary predicate which describes the join "R.z = S.z".

## Schemas and Tuples of Relations

Tuples of relations need to adhere to a (potentially implicit) schema.
Consider the query:

```sql
SELECT s.name, s.address
FROM students s
WHERE s.semester > 10
```

Here, the implicit schema for `students` contains attributes `name`, `address`, and `semester`. And for

```sql
SELECT * 
FROM orders o
WHERE o.state = 'DELIVERED'
```

the schema for `orders` consists of attribute `state` as well as an unknown number of further attributes captured by the `*` wildcard.

Join queries like the following show the need for qualification of attribute names:

```sql
SELECT s.name, o.name
FROM supplier s, orders o
WHERE s.suppkey = o.suppkey
```

**For ease of programming (and enforcing good style from the user ;)) in CLASH all attribute accesses in select and from clauses need to be qualified with the base relation or the alias of the base relation.**


## Connection to the Outside World

TODO.

