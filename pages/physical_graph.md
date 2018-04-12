---
layout: default
---

# Physical Graph

The physical graph describes how the processing of the join happens.
It is a directed graph with a bunch of labels. E.g. the following graph corresponds to the join between relations R and S:

![Ideal course of events]({{ "/pages/physical_graph/2way_example.png" | absolute_url }})

Here we see the yellow stub-nodes that represent sources of data (e.g., the stream named `r` originates from node `input[r]`) and sinks where results are sent to (e.g., the stream named `rs` is produced at all nodes that have edges towards `output[rs]`).
The blue nodes, here `r-store` and `s-store` are the locations where prefixes are stored. They are labeled with

* a **node name** for nicer identification of that component,
* a **degree of parallelism** that indicates the number of instances that are running that store in parallel, and
* a **list of rules** that determine the behaviour of that component, see below.

The nodes in the graph are connected via directed edges which are labelled with

* a **stream name** for nicer identification of the individual stream and
* a **partitioning method** that indicates, how messages should be distributed to the instances of each component, see below.

## Rules

The nodes are labelled with rules. These rules specify a multitude of behaviours, e.g., _if a tuple from stream s1 arrives, join it with stored tuples and send the result to stream s2_.

Currently, there are these rules available:
* `IntermediateJoinRule`: if a tuple arrives at the stream `incomingStreamName`, then join it using `predicates` and send emerging results to stream `outgoingStreamName`.
* `JoinResultRule`: if a tuple arrives at the stream `incomingStreamName`, then join it using `predicates` and use emerging results as tuples for `relationName`.
* `StreamSendRule`: if a new tuple for `relationName` is produced, send it to stream `outgoingStreamName`

## Examples

### BiStream

For a BiStream like join between `r` and `s`, that results in relation `rs`, the following setup could be used:

Nodes like above:

* input for r
* input for s
* output for rs
* r-store
* s-store

In order to store tuples from r at the r-store:

* edge from input-r to the r-store with shuffle label
* a XXXXXX store rule

For probing tuples from r with previously arrived tuples at the s-store:

* edge from input-r to the s-store with all label
* a JoinResultRule at the s-store with the given predicate and relation rs

Vice versa for tuples from s.


## Partitioning Methods

Similar to Storm, in this Physical graph each node represents potentially multiple running instances and the edges between the nodes indicate communication flow. This means, we have to indicate, which message is sent to which instance of the component represented by a node.

This is specified by the partitioning method of the edge labels. The following partitioning methods are currently supported:

* shuffle: send it to any instance, round robin
* all: send it to all instances, broadcast