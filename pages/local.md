---
layout: default
title: Local execution
---

Local execution is a mode where a single threaded program runs a physical graph. This is great for testing and debugging.

## Overview

A LocalTopology consists of nodes and edges. Each edge contains a FIFO queue, where components can put tuples in at the end and read from components.
The topology runs from 

### Inputs

Input nodes read the entire input (table, file, ...) at the beginning. Thus, the input stays in memory during the job execution.

### Execution

An execution step transforms the topology.



## Examples

### Filter&Project

For queries of type

```
SELECT f.a, f.b
FROM f
WHERE f.x = 5
```

