---
layout: documentation
title: Managed Topologies
major_category: Internals
---

A managed topology is managed by the manager.


## Communication

The manager maintains a queue of commands. This queue can be polled from by sending a post request to  `/api/v1/collect-commands`. Once a command is published that way it is removed from the queue. The idea is, that the control spout in a topology executes this request in its `nextTuple()` method.

Here's an example queue:

```
[
  { "command": "ping"}
]
```

Once the control spout reads this command, its internal logic tells further actions, like forwarding this command to which bolts or changing internal state. After some time, this ping command should be returned to the manager. This is again done using a post request by the control bolt, this time to `/api/v1/send-message`

## Setup

Start the manager first on a known hostname. When it is online, set this hostname to the topology and start it. In the first invocation of the controlSpout's `nextTuple()` method, it will issue the following message to the manager:

```
{
  "message": "topology-alive",
}
```


## Commands

### Ping

```
{
  "command": "ping",
  "sent": "<timestamp>"
}
```

Is forwarded to all bolts and they return this message:

```
{
  "message": "pong",
  "sent": "<timestamp>", // the timestamp from ping
  "received": "<timestamp>",
  "from": "<component-id>"
}
```


### Reset

```
{
  "command": "reset"
}
```

Is forwarded to all bolts, makes them reset their internal state. Returns this as confirmation:

```
{
  "message": "reset",
  "from": "<component-id>"
}
```