---
layout: default
title: Aggregations
---

A query can have multiple aggregations, for example:

```sql
SELECT
  department
  AVG(grade)
  SUM(fees)
  COUNT(id))
FROM students, ...
GROUP BY department
```

This query computes the aggrgations `avg, sum, count` per different value of `department`.

## Abstract Representation

Each individual aggregation part is an `AggregationOperation`. For now, we support `AggregationSum`, `AggregationAverage`, `AggregationCount`. Each aggregation has an attributeAccess declaring how to get the aggregated value. Also it has an alias for the generated output tuple.
These are combined into an `Aggregation` object which consists of the attributeAccesses that are used for grouping (in the example above just 'department'), and all aggregation operations.