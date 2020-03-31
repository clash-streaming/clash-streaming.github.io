---
layout: default
title: Command Line Interface
major_category: User Facing
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

Yields this to stdout (also, catch stderr):

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

## Running Storm

With the command

```bash
clashcli storm
```

you can run storm. You can start a local test server using the `--local` flag as follows:

```bash
clashcli --local -- $QUERY $DATACHARACTERISTICS $OUTSIDEINTERFACE
```

Or run it on a remote nimbus using:

```bash
clashcli --nimbus dbis-exp1 --config config.yaml -- $QUERY $DATACHARACTERISTICS $OUTSIDEINTERFACE
```

**ATTENTION**: This running storm remotely assumes some things: First, there should be a jar without storm sources next to the jar you are running. For example, if the jar is named `clash-0.2.0.jar`, the jar without storm sources should be named `clash-0.2.0-stormCluster.jar`.

The config you provide is optional, but will be used for setting up the topology. This is useful, e.g., for setting Postgres or Kafka connection options which are specific to the cluster you are running on but not the actual query.

Further you have to provide arguments `$QUERY`, `$DATACHARACTERISTICS`, and `$OUTSIDEINTERFACE`. `$QUERY` is a query string as above. `$DATACHARACTERISTICS` is a JSON-String containing the data characteristics. `$OUTSIDEINTERFACE` explains how to wire up the spouts with data sources and the result bolt with data sinks, see [OutsideInterfaces]({{ 'pages/outside_interfaces' | absolute_url }}).




## Implementation Notes

The CLI implementation is found in the `de.unikl.dbis.clash.api` package. The CLI aspects are implemented using the excellent [clikt](https://ajalt.github.io/clikt) package.