---
layout: documentation
title: Optimization
major_category: Internals
---

The Optimization process is responsible for creating a PhysicalGraph from a Query. The only outside information an Optimizer is allowed to use are captured in the data class `OptimizationParameters`.

## Implementing an Optimizer

An Optimizer has to implement the following interface:

```kotlin
interface OptimizationStrategy {
    fun optimize(query: Query, params: OptimizationParameters): OptimizationResult
}
```

With OptimizationParameters and OptimizationResult being defined as follows:

```kotlin
// default value omitted
data class OptimizationParameters(
    val dataCharacteristics: DataCharacteristics,
    val taskCapacity: Long,
    val availableTasks: Int,
    val probeOrderOptimizationStrategy: ProbeOrderOptimizationStrategy,
    val partitioningAttributesSelectionStrategy: PartitioningAttributesSelectionStrategy,
    val partitioningAttributesSelection: PartitioningAttributesSelection?,
    val crossProductsAllowed: Boolean)

data class OptimizationResult(
        val physicalGraph: PhysicalGraph,
        val costEstimation: CostEstimation)

data class CostEstimation(
        val storageCost: Double,
        val probeCost: Double
)
```

The OptimizationParameters have default values except for the dataCharacteristics. They can be modified, e.g. by command line flags using the CLI. The idea is, that it should be easy to add new parameters to the optimization process which do not influence other optimizers.

The same holds for CostEstimation. It might be that an optimizer can express more cost.

A custom optimizer looks from far away like this:

```kotlin
class MyOptimizer : OptimizationStrategy {
    override fun optimize(query: Query, params: OptimizationParameters): OptimizationResult {
        val graph = // something using query and params
        val cost = // maybe the cost are collected in a local data structure
        return OptimizationResult(graph, cost)
    }
}
```

## Tree based optimization

An important class of optimizers uses join trees as intermediate data structures. For those, there is the abstract `TreeStrategy` class. Subclasses of that class need to implement

```kotlin
abstract fun optimizeTree(query: Query, params: OptimizationParameters): TreeOptimizationResult

// with this result type:
data class TreeOptimizationResult(
        val tree: MaterializationTree,
        val costEstimation: CostEstimation)
```

The TreeStrategy's optimize method cares about translating the created MaterializationTree into a Physical Graph.
