---
layout: default
---

# Out of order join execution

Given a store $R_i$ with arriving probe tuples $s_1, \dots, s_n$.
The timestamps of these each tuple should coincide with index.
This means, ideally the tuples would arrive in order at the store as depicted here:

![Ideal course of events]({{ "/pages/delayed_joins/no_problem.png" | absolute_url }})

First, $s_1$ is sent there to probe against previously stored tuples. However there are none, so there's no join result for $s_1 \Join R_i$.
Then, $r_2$ and $r_4$ arrive at the store and are placed there for later use.
Now, when $s_7$ arrives, it finds $r_2$ and $r_4$ and can join with them (green markers), producing $s_7 \Join \\{r_2, r_4\\}$. Finally, $r_8$ is also placed in the buffer.

## Delayed probes

What if a probe comes late? For example, let $s_7$ arrive after the tuple $r_8$ as here:

![Delayed Probe]({{ "/pages/delayed_joins/delayed_probe.png" | absolute_url }})

As before, $s_7$ joins with $r_2$ and $r_4$) (green markers), however, $s_7$ must not be joined with $r_8$ (red marker). Why? Because at the same time, at some $S$-store, $s_7$ was already stored and $r_8$ will arrive as a probe and there the join result $s_7 \Join r_8$ will be produced.

Thus, a probed tuple is only probed against all stored tuples with a timestamp smaller than that tuple.

## Delayed stores

What if a store comes late? For example, if probe $s_7$ arrives before store $r_4$ like here:

![Delayed Store]({{ "/pages/delayed_joins/delayed_store.png" | absolute_url }})

Then the current store is according to our model responsible for generating the join between $s_7$ and $r_4$. However, it only knows of $r_2$ and can produce that join (green marker). So, the store has to buffer $s_7$ up to the point later when $r_4$ arrives, in order to compute that join (red marker).

# Local Implementation

From a high level, the implementation looks like this:

{% plantuml %}
class Storage {
    {field} local storage
    {field} probe buffer
    List<Tuple> store(Tuple)
    List<Tuple> probe(Tuple)
}
{% endplantuml %}

When a store tuple arrives, `sm.store(tuple)` is called, `tuple` is placed in the `local storage` and the join result with all "later" tuples from the `probe buffer` is returned. Vice versa, when a probe tuple arrives, `sm.probe(tuple)` is called, `tuple` is placed in the `probe buffer` and the join result with all previous tuples from the `local storage` is returned.


# Java Implementation for Storm

The class `Joiner` subsumes storing of documents as well as joining and handling delayed joins. Thus, it internally consists of a `ProbeBuffer` and a `StoreBuffer` (see there for documentation). The `StoreBuffer` handles normal joins as well as delayed probes. The `ProbeBuffer` handles delayed stores.
