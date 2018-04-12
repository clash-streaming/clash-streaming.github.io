---
layout: default
---

# Input/Output

How is input and output handled in CLASH and what is considered input and output?

Input is the source of a data stream, output is the sink for results of CLASH computations. For example, a source could be a Kafka stream, a Postgres table, a random number generator, ..., a sink could be a Kafka stream, a Postgres table or a log file.

The high level view looks like this:

![Blackbox CLASH connecting in and outputs]({{ "/pages/io/blackbox.png" | absolute_url }})

CLASH should compute a query, and here we do not care how the result is computed. We only know, that the query has inputs `r`, `s`, and `t`, and that it produces results `u` and `v`. Now the task is, to connect `r`, `s`, and `t` to real inputs and `u` and `v` to real sinks.

In order to do this, let's look how the physical graph looks like after optimization is done:

![Physical graph after optimization]({{ "/pages/io/physical_after_optimization.png" | absolute_url }})