---
layout: default
---

The Clash API, especially the `Clash`-class in the api package, can be used in three stages:

* Stage 1: Basics
    - Register sources and sinks using the `registerSource` and `registerSink` methods. This way the interfacing with the outside world are registered.
    - Setting assumed data characteristics and optimization strategies using the `setDataCharacteristics` and `setOptimizationStrategy` methods. This influences the following plan generation.
* Stage 2: Query
    - Using the `QueryBuilder` returned by the `query` method, the desired query is specified.
* Stage 3: Construction
    - The `buildTopology` method is called and constructs a physical query plan.
    - The `buildStormTopology` method then constructs a storm topology from that physical query plan.

## Example

A complete example computing a binary join looks like this:

```java
Config config = new Config();
Clash clash = new Clash(config);
clash.registerSource("r", /* source definition */);
clash.registerSource("s", /* source definition */);
clash.registerSink("SINK", /* sink definition */);
clash.setDataCharacteristics(manualCharacteristics());

clash.setOptimizationStrategy(new LeftDeepStrategy());

clash.query()
    .from("r")
    .from("s")
    .where(new MyPredicate())
    .to("SINK");

clash.buildTopology();
stormTopology = clash.buildStormTopology();
```

The obtained `stormTopology` can be submitted to a Storm cluster.

If you are interested in the generated physical graph, you can inspect it using the `clash.getTopologyGraph().toDotString()` method.
