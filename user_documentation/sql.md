---
layout: documentation
title: CLASH's SQL Dialect
major_category: User Facing
---

We support queries of type

```sql
SELECT (list of attributes)
FROM (list of streamNames)
WHERE (list of join predicates)
```

Currently, there is no support for aggregation.
Attribute lists as well as predicates have to be qualified, e.g.

```sql
SELECT a.foo, b.bar
FROM topic a, othertopic b
WHERE a.foo < 500
  AND a.key = b.key

```

This is due to the ad-hoc nature of the schema. When this query is posed, a-tuples are assumed to have a 'foo' and a 'key' attribute, b-tuples have 'bar' and 'key'. If these attributes are not found, they are set to `NULL`.
Nested queries are not allowed. Finally, windows are specified using a table function syntax:

```sql
SELECT a.foo
FROM topic a('sliding', '4', 'hours')
```

## Connecting Relations to Stream Providers

If you query a relation in the FROM clause and assign an alias to it, like here:

```sql
SELECT *
FROM topic a
```

Then in the rest of the query you need to address data from that relation as `a`, so using the alias. The stream provider is connected by specifying it for `topic`, so for the base relation name.


## Parsing and Interpreting

Clash uses [JSqlParser](https://github.com/JSQLParser/JSqlParser) for parsing plain text queries. Ultimately it produces a `Query` object as described [here](/query). The parser code lives in `package de.unikl.dbis.clash.query`.

### JSql ASTNodes

You can find a little more details [in the docs](https://www.javadoc.io/doc/com.github.jsqlparser/jsqlparser/1.3).

| class                     | example | comment |
|---------------------------|---------|---------|
| Between                   | `BETWEEN expr1 expr2 statement` | |
| CaseExpression            | `case` | |
| DateValue                 | `date` | |
| DoubleValue               | `1234.567` | |
| HexValue                  | - | Strange documentation |
| LongValue                 | `12345` | |
| NullValue                 | `NULL` | |
| SignedExpression          | `-exrp, +expr, ~expr` | |
| StringValue               | `my first string` | |
| TimestampValue            | `yyyy-mm-dd hh:mm:ss.f` | |
| TimeValue                 | `hh:mm:ss` | |
