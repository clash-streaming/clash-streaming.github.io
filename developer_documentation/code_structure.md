---
layout: default
title: Code Structure
major_category: Tutorial
---

This is an older illustration of Clash's structure, however, it should still give a hint on how things are organized.

![Structure of the CLASH projects]({{ "/pages/images/project_structure.png" | absolute_url }})

The current intra-submodule dependencies are illustrated on the bottom of this page. Remarkable notes about the submodules:

* **query**: the query contains the abstract description of relations (because queries are relations) and the parser for transforming SQL to a relation.
* **physicalgraph**: this is the target of optimization, and basically an abstract version of a storm topology. It contains the nodes, edges, and rules that define a processing strategy. 
* **optimizer**: this is responsible for creating a physical graph from the query
* **tpch** and **join-order-benchmark** are quality-of-life modules that contain queries and data characteristics
* **documents** are the elements that are sent through topologies and are contained inside relations
* **workers** are the actual implementations of functionality local to bolts (e.g. the join or aggregation components)
* **local** is a single-threaded simulation of storm which should make it easier to test new implementations

![Internal Dependencies]({{ "/pages/images/internal_dependencies.svg" | absolute_url }})
