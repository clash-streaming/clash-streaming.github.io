---
layout: documentation
title: Outside Interfaces
major_category: User Facing
---

An outside interface consists of sources and sinks. It is used to tell CLASH, which spouts to instantiate and with which parameters as well as how the result bolt should communicate its results with the sink.

Here's an example:

```json
{"sources": {
    "customer": {
       "type": "postgres",
       "query": "SELECT * FROM customer LIMIT 100",
       "millisDelay": 1
    },
    "orders": {
       "type": "postgres",
       "query": "SELECT * FROM orders LIMIT 100",
       "millisDelay": 1
    },
    "lineitem": {
       "type": "postgres",
       "query": "SELECT * FROM  lineitem LIMIT 100",
       "millisDelay": 1
    }
 },
 "sink": {
   "type": "null"
 }
}
```

## Source types

### Postgres

Used for developing or testing. The Postgres source looks like:

```json
{  
   "type": "postgres",
   "query": "SELECT * FROM customer LIMIT 100",
   "millisDelay": 1
}
```

It will create a spout that connects to the Postgres database as defined in the ClashConfig.

## Sink types

### Null

Used for developing or testing. The Null source looks like:

```json
{  
   "type": "null"
}
```

It does not sent any tuples to data sinks. However, it counts statistics and can thus be used in order to check, if all tuples make it through the topology and how long they take.

### Postgres

Used for developing or testing. The Postgres source looks like:

```json
{  
   "type": "postgres",
   "query": "INSERT INTO result(tuple) VALUES (?)"
}
```

It inserts the tuples as plain JSON Strings using the query as provided.