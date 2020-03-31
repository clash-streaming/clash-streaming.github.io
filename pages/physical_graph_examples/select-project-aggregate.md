---
title: Select-Project-Aggregate
---

This example covers easy queries of type

```sql
SELECT r.key, avg(r.val1), sum(r.val2) ...
FROM relation r
WHERE filter_condition(r)
GROUP BY r.key
```

The physical graph for such a select-project-aggregate query consists of three nodes:

- InputStub
- SelectProjectNode
- AggregateNode

The InputStub resembles the relation `relation`. The (stateless) SelectProjectNode is responsible for transforming tuples of `relation` to tuples of a relation where the filter-criterion is satisfied and only attributes are left that are needed for the aggregation. Finally, the (stateful) AggregateNode computes all aggregates simultaneously.

The **relations** involved here are the following:

```sql
SELECT * FROM relation r
```

For tuples arriving at and emitted from the InputStub.
The SelectProjectNode transforms these to this relation:

```sql
SELECT r.key, r.val1, r.val2
FROM relation r
WHERE filter_condition(r)
```

And finally, the AggregateNode produces the resulting relation from the top of this page.