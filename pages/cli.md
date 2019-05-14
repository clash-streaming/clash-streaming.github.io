---
layout: default
title: Command Line Interface
---

You can use CLASH via the command line interface embedded into the built jarfile. Alias `clashcli` to `java -jar $PATH_TO_CASH_JAR` if you want it quicker.

Verify that clash is working by using one of these:

```bash
clashcli --help
clashcli --version
```

## Getting CLASH's capabilities

You can get information about the supported features of clash using a series of flags:

```bash
clashcli --supported-global-strategies
clashcli --supported-probe-order-strategies
clashcli --supported-partitioning-attribute-selection-strategies
```

## Query Parsing

For parsing a [SQL]({{ 'pages/sql' | absolute_url }}) query, for example for quickly checking syntactical correctness, the query subcommand can be used. It will show the interpreted subcommand as JSON or show an error.

For example:

```bash
clashcli query -- "SELECT r.a, s.b FROM r, s WHERE r.c = s.d"
```

Yields:

```json
{
  "binaryPredicates": ["r.c = s.d"],
  "unaryPredicates": [],
  "query": "SELECT r.a, s.b FROM r, s WHERE r.c = s.d",
  "baseRelations": [
    {"inner": "r"},
    {"inner": "s"}
  ],
  "baseRelationAliases": [
    {"inner": "r"},
    {"inner": "s"}
  ]
}
```

An erroneous query is detected:

```bash
clashcli query -- "SELECT r.a, s.b FROM r, s, r.c = s.d"
```

Yields:

```json
{
  "query": "SELECT r.a, s.b FROM r, s, r.c = s.d",
  "error": "net.sf.jsqlparser.JSQLParserException"
}
```

In both examples, after `query` two dashes `--` are written. This stops the query parser from interpreting certain symbols in the following strings.

## Optimization

Optimization tasks can be given via JSON documents, specifying everything needed.

```json
{
  "query": "SELECT ... "
  "dataCharacteristics": { ... },
  "optimizationParameters": {
    "taskCapacity": 1000000,
    "availableTasks": 100,
    "globalStrategy": { "name": "Flat", ... },
    "probeOrderOptimizationStrategy": { "name": "LeastSent", ... },
    "partitioningAttributesSelectionStrategy": { "name": "Explicit", ... }
  },
}
```

The result will consist of two parts, once the optimization result, which is an internal representation, e.g., of a materialization tree, and a physical graph, which ultimately will be deployed as a Storm topology.

```json
{
  "optimizationResult": { ... }
  "physicalGraphResult": { ... }
}
```

The json task is called via

```bash
clashcli query -- "{}"
```

you have to take care of proper escaping of quotes.

## Implementation Notes

The CLI implementation is found in the `de.unikl.dbis.clash.api` package. The CLI aspects are implemented using the excellent [clikt](https://ajalt.github.io/clikt) package.