---
layout: post
type: post
tags:
  - git
  - tips
  - productivity
published: true
title: Git tricks - worktree
description: How to use git worktree or how to work on different things and not get crazy
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

I recently found out about this git utility named [git-worktree](https://git-scm.com/docs/git-worktree), and it has been a godsend for my development workflow.

Imagine you are working on a branch in your editor, but wanna work on another branch in a different editor instance. That was a hard thing to do until I discovered this powerful git feature that has existed for a long time but, yet, I've never heard about it.

My previous workflow was to stash the changes I had in the current branch or write a crappy commit and get back to the other branch. This was problematic, usually I simply stashed without a good description, and finding what the stash was about required some time. The short nonsense `fix` or `wip` commit was not helpful either and required me to squash commits later.

So, being familiar with the problem I'm sure many programmers have faced, let's get to the action with `git worktree`:

The only small change in your workflow is that you will need to have a bare clone of the repository you will be working.

```console
λ -> git clone --bare https://github.com/vernemq/vernemq.git vernemq && cd vernemq/
```

Let's say you are starting to work on the first branch, you need to create a workspace for it using `git-worktree`:

```console
λ -> git worktree add erlfmt_v2
```

The above will create a new name spaced directory and branch named "erlfmt_v2", you can navigate to it, open that directory with your editor and start working like normally you do with git:

```console
λ -> cd erlfmt_v2
λ -> git status
On branch erlfmt_v2
nothing to commit, working tree clean
```

Now you got stuck or tired of that work and want to leave it for later and will work on a very different problem. You get out of the namespace and start a new one:

```console
cd ..
λ -> git worktree add long_term_logging_improvements
λ -> cd long_term_logging_improvements
λ -> git status
On branch long_term_logging_improvements
nothing to commit, working tree clean
```

You can now have these two work trees open in different editors, terminals, and tmux panes without worrying about one work interfering with the other. If you use VSCode, there is a nice extension that makes creating an switching worktrees easier, check https://marketplace.visualstudio.com/items?itemName=GitWorktrees.git-worktrees.

I hope this can be helpful to anyone, and for more advanced usage you can refer to the [git-worktree documentation](https://git-scm.com/docs/git-worktree).

Happy hacking!
