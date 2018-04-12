---
layout: default
---

For deploying to Storm, you need a PhysicalGraph, e.g., obtained through the use of the various optimization procedures.
This PhysicalGraph consists of `InputStub`s, `OutputStub`s, and of course `Store`s.

Through the use of the `StormTopologyBuilder`, a `StormPhysicalGraph` is built.
This additionally consists of the `Dispatcher` node, `InputStub`s are replaced by `Spout`s, and `OutputStub`s by `Sink`s.

An example would be:

```java
StormTopologyBuilder builder = new StormTopologyBuilder(physicalGraph);
builder.setSpout("r", new PGTableSpout("SELECT ... "));
builder.setSpout("s", new PGTableSpout("SELECT ... "));
builder.setSink("result", new PGSinkBolt("INSERT ..."));
StormTopology topology = builder.build();
```
