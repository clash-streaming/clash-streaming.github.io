---
layout: index
---

# CLASH

CLASH is a research project dedicated to query processing over semi-relational streams.

# Welcome to CLASH

Clash is a system for query processing.

The principal idea is as follows:

![Ideal course of events]({{ "/overview_static.png" | absolute_url }})

We take a query (for now `select-from-where`) and fixed data characteristics (stream rates and join selectivities) and put this into an optimizer.
This optimizer generates a physical graph, which in an abstract way models a streaming system. This physical graph can then be translated to a Storm topology.

## Contents

For consistent wording, refer to this document: [Glossary]({{ 'glossary' | absolute_url }})

All pages of this documentation in no particular order:

<ul>
{% for p in site.pages %}
{% if p.url contains 'pages' %}
<li><a href="{{ p.url | absolute_url }}">{{ p.title }}</a></li>
{% endif %}
{% endfor %}
</ul>

## Future Work

As this should be a streaming system, obviously the initial data might change over time. Thus, changes in the data characteristics imply other optimal strategies.

![Ideal course of events]({{ "/overview_dynamic.png" | absolute_url }})

So now a physical graph is given (the one currently used for answering the query), and the currently observed data. This is given into a (re)optimizer, which then tells, how the graph should be changed. E.g., by changing the join order.


## Productive Code

The code lives in the [Clash Gitlab Project](https://git.cs.uni-kl.de/clash/clash). Under [Code Structure](/pages/code_structure) the way the project is set up is explained.

There are further helpful projects, e.g., for running Clash:

* [starter-scripts](https://git.cs.uni-kl.de/clash/starter-scripts) Daemon controlling scripts.
* [storm-config](https://git.cs.uni-kl.de/clash/storm-config) Ruby library that abstracts the settings of a **storm cluster** (bad naming).
* [stork](https://git.cs.uni-kl.de/clash/stork) StormKontroller, ruby project that controlls a storm cluster (shutting down, restarting daemons, etc.).
* [ruby-ssh](https://git.cs.uni-kl.de/clash/ruby-ssh) ssh wrapper for remote file and command handling.