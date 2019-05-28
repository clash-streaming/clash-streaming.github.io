---
layout: default
title: Metrics
---

CLASH for Storm writes metrics in order to asses the performance.

The following is a list of metrics. All of these metrics are grouped by task and component, thus for example for a Lineitem-store with parallelism 4, there are 4 measurements (one for each task) which have to be aggregated to get the entire picture.

## Store metrics

### Counters

* `clash_metric.probeTuplesReadCounter` The total number of probe tuples read during that topology's execution
* `clash_metric.probeMessagesReadCounter` The total number of probe messages read during that topology's execution
* `clash_metric.storeTuplesReadCounter` The total number of store tuples read during that topology's execution
* `clash_metric.storeMessagesReadCounter` The total number of store messages read during that topology's execution
* `clash_metric.emittedResultTuplesCounter` The total number of join result tuples sent as result of a probe
* `clash_metric.emittedResultMessagesCounter` The total number of join result messages sent as result of a probe
* `clash_metric.emittedDelayedResultTuplesCounter` The total number of join result tuples sent as result of a delayed store
* `clash_metric.emittedDelayedResultMessagesCounter` The total number of join result messages sent as result of a delayed store

### Timers

* `clash_metric.probeTimer` The duration of a invocation of the probe function
* `clash_metric.storeTimer` The duration of a invocation of the store function
