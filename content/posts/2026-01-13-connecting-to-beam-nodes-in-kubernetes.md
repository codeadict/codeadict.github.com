---
layout: post
type: post
tags:
  - kubernetes
  - erlang
  - elixir
  - beam
  - kubectl
  - devops
  - tooling
published: true
title: Easily connecting to BEAM Nodes in Kubernetes with kubectl-beam
description: A kubectl plugin that makes connecting to Erlang and Elixir nodes running in Kubernetes pods as easy as running a single command---with full TTY support and Observer GUI.
twitter:
  username: RedClawTech
  card: summary
social:
  name: Dairon Medina
  links:
    - https://twitter.com/RedClawTech
    - https://www.linkedin.com/in/codeadict
    - https://github.com/codeadict
---

Debugging BEAM applications in Kubernetes has always been more painful than it should be. You know the drill: your Phoenix app is misbehaving in production, you need to inspect some process state, maybe run a few commands in an IEx shell, or fire up Observer to see what's going on. Simple enough on your local machine, right? But in Kubernetes, you end up manually port-forwarding EPMD, figuring out the dynamic distribution port, wrestling with DNS resolution, and praying your terminal doesn't get mangled in the process.

I've done this dance too many times---enough to finally build something that handles all the tedious bits automatically. That's why I created [kubectl-beam](https://github.com/codeadict/kubectl-beam), a kubectl plugin that connects you to BEAM nodes running in Kubernetes pods with a single command.

## The Problem

Let's say you have an Elixir application running in your Kubernetes cluster and you need to connect to it for some live debugging. The traditional approach involves several manual steps:

1. Port-forward EPMD (port 4369) to discover the distribution port
2. Query EPMD to find out which port the node is actually using
3. Port-forward that dynamic distribution port
4. Set up proper DNS resolution so the local node can find the remote one
5. Start a local hidden node with the right cookie and configuration
6. Hope your terminal doesn't get corrupted because TTY handling in kubectl exec is... let's call it quirky

This works, but it's error-prone and tedious. And if you want to use Observer? Good luck getting X11 forwarding or VNC working properly through all those layers.

There had to be a better way.

## Installing kubectl-beam

Follow the installation instructions at https://github.com/codeadict/kubectl-beam?tab=readme-ov-file#installation

That's it. You now have `kubectl beam` available alongside your other kubectl commands.

## Basic Usage

The plugin supports both Elixir (IEx) and Erlang (erl) shells. Here's the simplest way to connect to a pod:

```bash
kubectl beam iex my-app-pod
```

This connects you to the BEAM node running in `my-app-pod` using an IEx shell. You'll get a proper interactive shell with full TTY support---history, auto-completion, multi-line editing, all the things you expect from IEx work exactly as they should.

If you're working with Erlang directly, use the `erl` subcommand:

```bash
kubectl beam erl my-app-pod
```

### Specifying Namespaces

Working in a specific namespace? Just add the `-n` flag like you would with any kubectl command:

```bash
kubectl beam iex -n production my-app-pod
```

### Using Erlang Observer

Here's where things get interesting. Observer is an incredibly useful tool for inspecting live BEAM systems---process trees, memory usage, message queues, all visualized in a GUI. Getting it to work through Kubernetes has traditionally been somewhere between difficult and impossible.

With kubectl-beam, it's a single flag:

```bash
kubectl beam iex --observer -n production my-app-pod
```

This starts your IEx shell and automatically launches the Observer GUI, properly connected to the remote node. You can inspect processes, view memory allocation, trace messages---everything Observer does, but for a node running inside a Kubernetes pod.

### Node Names and Cookies

The BEAM VM's distributed computing model uses node names and cookies for authentication. By default, kubectl-beam uses short names (just the hostname) and attempts to auto-detect the cookie from common locations in the container.

If you need long names (fully qualified domain names), use the `-l` flag:

```bash
kubectl beam iex -l my-app-pod
```

For explicit cookie specification (useful when auto-detection fails or you're dealing with custom cookie configurations), use the `--cookie` flag:

```bash
kubectl beam iex --cookie secret123 my-app-pod
```

You can combine these flags as needed:

```bash
kubectl beam erl -l --cookie myapp_cookie -n production my-app-pod
```

## How It Works

The plugin handles all the tedious port-forwarding and configuration automatically, but it's worth understanding what's happening under the hood:

When you run `kubectl beam`, here's the sequence of operations:

**1. EPMD Port Discovery**

First, the plugin port-forwards the EPMD port (4369) from the pod to your local machine. EPMD (Erlang Port Mapper Daemon) is how BEAM nodes discover each other's distribution ports.[^epmd-note]

[^epmd-note]: EPMD is a small name server that BEAM nodes register with when they start. Other nodes query EPMD to find out which port a particular node is listening on.

The plugin queries the local EPMD to discover which port the target node is actually using for distribution. These ports are dynamically assigned, which is why manual connection is such a pain.

**2. Distribution Port Forwarding**

Once the plugin knows the distribution port, it sets up a second port-forward for that port. This is the actual communication channel your local BEAM node will use to talk to the remote one.

**3. DNS Resolution Setup**

Here's a subtle but critical piece: BEAM nodes need to resolve each other's hostnames. In Kubernetes, your pod has a hostname that means something inside the cluster but nothing on your local machine.

The plugin adds a temporary entry to `/etc/hosts` (with appropriate cleanup on exit) so your local node can resolve the remote pod's hostname to localhost. This makes the distribution protocol work seamlessly despite the pod being in a different network namespace.

**4. Cookie Handling**

The plugin attempts to read the Erlang cookie from common locations in the container:

- `/var/run/secrets/erlang-cookie`
- `/app/.erlang.cookie`
- `~/.erlang.cookie` (home directory of the container's user)

If it finds a cookie, it uses it automatically. Otherwise, you'll need to specify one with `--cookie`.

**5. Starting the Local Shell**

Finally, the plugin starts your chosen shell (IEx or erl) as a hidden node[^hidden-node] configured to connect to the remote node. All the environment variables, cookie settings, and connection parameters are set up correctly so the connection just works.

[^hidden-node]: Hidden nodes are a special type of BEAM node that doesn't participate in the normal node discovery process. They're perfect for debugging and inspection tools since they don't affect the cluster's topology.

The terminal handling is done carefully to preserve TTY characteristics---your shell gets the terminal size, control sequences, and all the interactive features you expect.

## Wrapping Up

If you're running Erlang or Elixir applications in Kubernetes, kubectl-beam should make your life a bit easier. The plugin is [open source on GitHub](https://github.com/codeadict/kubectl-beam)---contributions, issues, and feedback are welcome.

Enjoy!
