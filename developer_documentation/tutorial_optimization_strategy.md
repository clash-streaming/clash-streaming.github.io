---
layout: documentation
title: Optimization Strategy
major_category: Tutorial
---

In this tutorial we look into writing an optimization strategy. Technically, an optimization strategy is class that implements `GlobalStrategy`, which defines only a single method:

```kotlin
fun optimize(
    query: Query,
    dataCharacteristics: DataCharacteristics,
    params: OptimizationParameters
): OptimizationResult
```

The `query` is the description of what the user wants, `dataCharacteristics` is what we (belive to) know about the incoming data, `params` are further parameters that we should respect during optimization, e.g., available resources of the compute cluster.


## Big Picture

The optimizer takes a query and produces a PhysicalGraph. If that graph is transformed into a Storm Topology, this topology will produce a result that fits the query.

The PhysicalGraph consists of **nodes**, **edges**, and **rules**. The nodes represent compute units that may store data. These nodes are connected by edges which have a name. The actions that a node performs are configured using the rules. A rule says, for example, if a tuple arrives on edge _a_, store it in the local state, and send its value + 1 over edge _b_.


## The BinaryTheta Strategy

Let us walk through the BinaryTheta strategy. You can find this in the source code in the package `de.unikl.dbis.clash.optimizer.constant`. While the optimization algorithm is not that special (well, it only works for join queries over exactly two relations) this serves as example on what the tasks of the optimizer include in terms of producing a PhysicalGraph.

The materialization tree that we are building looks like this:

```
         result
          /  \
         /    \
  A-Store      B-Store
```


At first, we create the PhysicalGraph object:

```kotlin
val physicalGraph = PhysicalGraph()
```

### Inputs

Variables `relA` and `relB` contain the relations that are inputs of the query, this means, the query looks like `SELECT * FROM relA, relB WHERE some_predicate`. This data comes from somewhere, e.g. it arrives at the system by reading a file, listening to a Kafka topic, etc. But this is irrelevant to the optimizer, thus `InputStub`s are used here. In a later step (outside of the optimizer) these stubs are replaced by the actual input readers.

```kotlin
val inputA = physicalGraph.addInputStubFor(relA)
val inputB = physicalGraph.addInputStubFor(relB)
```

### Stores

Then we add the stores for relations a and b.

```kotlin
val storeA = ThetaStore(label(relA), relA, 1)
physicalGraph.relationStores[relA] = storeA
val storeB = ThetaStore(label(relB), relB, 1)
physicalGraph.relationStores[relB] = storeB
```

Here we initialize both stores with a label (for convenient output), the relation that is stored inside and the degree of parallelism (in this case `1`). The stores are put into the `relationStores` of the physical graph. This is the way, a `PhysicalGraph` organizes the registered stores. Each store is identified by the stored relation.

### Wiring Things Up

Now we have two input stubs and two stores. But they are not connected, yet. We now add individual edges as well as rules for getting data to and from those edges. First, we add the edges for the tuples that are sent to the stores for storing:

```kotlin
val storeAEdge = addEdge(inputA, storeA, EdgeType.SHUFFLE)
inputA.addRule(RelationSendRule(relA, storeAEdge.streamName))
storeA.addRule(RelationReceiveRule(relA, storeAEdge.streamName))
val storeBEdge = addEdge(inputB, storeB, EdgeType.SHUFFLE)
inputB.addRule(RelationSendRule(relB, storeBEdge.streamName))
storeB.addRule(RelationReceiveRule(relB, storeBEdge.streamName))
```

The function `addEdge()` is responsible for adding the edge to the sending and receiving node, and also the edge type is set. Once we have an edge, we can use it to construct rules. The two rules for the first relation are `RelationSendRule(relA, storeAEdge.streamName)` which means "If you have a tuple for relation relA, then send it over the edge storeAEdge.streamName", and `RelationReceiveRule(relA, storeAEdge.streamName)` which means "If you receive a tuple over the edge storeAEdge.streamName, then treat it like a tuple belonging to relation relA". The former is also called (and an instance of) `OutRule` and the latter of `InRule` and we register the first one with inputA, because there the tuples are sent, and the second one to storeA, because there the tuples are received. Of course, we do the same for tuples of relB.

Now all arriving tuples end up at the correct stores. But we also need some joining.

```
val probeAEdge = addEdge(inputB, storeA, EdgeType.ALL)
val predicateEvaluationA = predicatesForStore(storeA, query.result.joinPredicates)
storeA.addRule(JoinResultRule(probeAEdge.streamName, predicateEvaluationA, query.result))
val probeBEdge = addEdge(inputA, storeB, EdgeType.ALL)
val predicateEvaluationB = predicatesForStore(storeB, query.result.joinPredicates)
storeB.addRule(JoinResultRule(probeBEdge.streamName, predicateEvaluationB, query.result))
```

Here we connect the B with the A-store and vice versa for the actual join processing. Again we add an edge, this time of type ALL. For join processing, we now need the predicates that should be evaluated. At this time we already decide on the concrete evaluation. For example, for the predicate `a.x < b.x`, the evaluation decides which side of the inequality is the stored tuple, and which is the probe tuple. The method `predicatesForStore` constructs such an evaluation. With this evaluation, we can construct a `JoinResultRule`, meaning "If a tuple from edge probeAEdge.streamName arrives, probe it against the locally stored tuples using the predicate evaluation predicateEvaluationA. The resulting tuple belongs to relation query.result". Again, we do the same for tuples from relA that are sent to the B-store.

### Finalizing and Output

The graph stores so called relation producers. These are nodes where tuples of a certain relation are originating. As the desired join is produced at the A- as well as at the B-store, both are registered:

```kotlin
physicalGraph.addRelationProducer(query.result, storeA)
physicalGraph.addRelationProducer(query.result, storeB)
```

Similar to input stubs, we register output stubs as sink. The user can decide where to put the results, e.g., write it to a Kafka topic or to a file inside a distributed file system. But that is irrelevant to the obtimization.

```kotlin
val outputStub = OutputStub(label(query.result), query.result)
physicalGraph.outputStub = outputStub
val storeAResultEdge = addEdge(storeA, outputStub, EdgeType.SHUFFLE)
storeA.addRule(RelationSendRule(query.result, storeAResultEdge.streamName))
val storeBResultEdge = addEdge(storeB, outputStub, EdgeType.SHUFFLE)
storeB.addRule(RelationSendRule(query.result, storeBResultEdge.streamName))
```

We create the `OutputStub` and add it to the physical graph. Then we also connect both result generating nodes to the stub, and add the according RelationSendRule to the stores. We have seen this rule already at the input stubs. This time they are invoked when a new join result is created.