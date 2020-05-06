---
layout: documentation
title: On Inputs and Aliases
major_category: Internals
---

Inputs have names. Aliases are names. However, they remain separate.

For example, in the query

```sql
SELECT a.name
FROM myTable a
WHERE a.x = 6
```

`myTable` is the input name, `a` is the alias.

## Jobs of input names

The input name indicates the source. It has to be configured in the system. If the tuples should originate from a Kafka topic called "tweets", then in the system the mapping `myTable -> Kafka(tweets)` has to be declared.

When a user writes a query, they can just use myTable for accessing this.

## Job of aliases

An input alias indicates logical belonging of query specification elements to an input. In the example above, the predicate `a.x = 6` is applied on tuples of the source myTable, and `a.name` indicates what should be output.

## Implications

### ... on Relations

A relation should only operate on aliases, but on on input names.

For example the query from above results in a relation ('a', 'a.x=6', '', 'infty')