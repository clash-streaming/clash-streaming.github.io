---
layout: default
---

# Welcome to CLASH

Clash is a system for query processing.

The principal idea is as follows:

![Ideal course of events]({{ "/overview_static.png" | absolute_url }})

We take a query (for now `select-from-where`) and fixed data characteristics (stream rates and join selectivities) and put this into an optimizer.
This optimizer generates a physical graph, which in an abstract way models a streaming system. This physical graph can then be translated to a Storm topology.

## Future work

As this should be a streaming system, obviously the initial data might change over time. Thus, changes in the data characteristics imply other optimal strategies.

![Ideal course of events]({{ "/overview_dynamic.png" | absolute_url }})

So now a physical graph is given (the one currently used for answering the query), and the currently observed data. This is given into a (re)optimizer, which then tells, how the graph should be changed. E.g., by changing the join order.


## Productive code

* [clash-core](https://git.cs.uni-kl.de/clash/clash-core) provides interface definitions used in the other packages as well as core facilities like configuration and the very central operators. As well as the query description, e.g., definition of sources and sinks as well as join predicates.
* [data-characteristics](https://git.cs.uni-kl.de/clash/data-characteristics) Everything related to estimation of data characteristics (rate, selectivity, etc.)
* [physical-graph](https://git.cs.uni-kl.de/clash/physical-graph) The core data structure that is the result of optimization and that describes data flow and materialization.
* [optimizer](https://git.cs.uni-kl.de/clash/optimizer) Different techniques for optimization are collected here, at most MultiStream operator optimization as well as join tree construction.
* [clash-storm](https://git.cs.uni-kl.de/clash/clash-storm) provides translation from a physical graph to the clash storms

![Structure of the CLASH projects]({{ "/project_structure.png" | absolute_url }})

## Support

* [starter-scripts](https://git.cs.uni-kl.de/clash/starter-scripts) Daemon controlling scripts.
* [storm-config](https://git.cs.uni-kl.de/clash/storm-config) Ruby library that abstracts the settings of a **storm cluster** (bad naming).
* [stork](https://git.cs.uni-kl.de/clash/stork) StormKontroller, ruby project that controlls a storm cluster (shutting down, restarting daemons, etc.).
* [ruby-ssh](https://git.cs.uni-kl.de/clash/ruby-ssh) ssh wrapper for remote file and command handling.