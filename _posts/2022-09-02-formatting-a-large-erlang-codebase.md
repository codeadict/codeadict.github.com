---
layout: post
type: post
tags:
  - git
  - tips
  - erlang
  - beam
  - clean code
published: true
title: Formatting an existing Erlang codebase
description: How to format an existing codebase without messing git history. Usin an Erlang project  with erlfmt as an example.
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

I recently applied a code formatter on the [VerneMQ](https://vernemq.com) existing codebase. This post will outline the process we took to do this without disrupting the existing git commit history in the project.

## First, why use a code formatter?

A uniform code makes it easier to focus on business logic. By using a code formatter, we make sure that the code is consistent no matter who wrote it, which editor/IDE was used to write it or in which component of the system it resides.

Uniform code makes code reviews faster because reviewers can concentrate on the technical details, functionality, correctness, and testability by ceding control over the minutiae of hand formatting. It should also be easier for new contributors to maintain the code style and read diffs.

It's all about consistency, folks!

## This sounds great, how do we do it?

There are many code formatters nowadays for Erlang. How lucky we are! Years ago formatting with Emacs was the only option. I took some time to investigate the available tools out there to apply a formatter to [VerneMQ](https://vernemq.com):

I searched on GitHub and hex.pm and found these to be the major players in the Erlang formatting game:

**[steamroller](https://github.com/old-reliable/steamroller)**

I didn't play much with this project since it has not had new commits in 2 years. Applying it on VerneMQ resulted in some weird comment reordering.

**[rebar3_format](https://github.com/AdRoll/rebar3_format)**

rebar3_format is a [rebar3](https://rebar3.org) plugin with a default formatter that uses the `katana_code` package, which, in turn, uses [erl_tidy](https://www.erlang.org/docs/23/man/erl_tidy.html), and it also suffers from the same struggles with macros like `erl_tidy`. The default formatter also can be configured to have different code styles, and we wanted full consistency.

This plugin can in turn use other formatters like `steamroller` and `erlfmt` but seemed overkill to not use one of those directly.

**[erl_tidy](https://www.erlang.org/docs/23/man/erl_tidy.html)**

Erltidy comes with OTP, so it's zero dependency which is nice, but it struggled with some VerneMQ files, generating broken indentation with records and crashing on macros with arguments.

**[erlang-formatter](https://github.com/fenollp/erlang-formatter)**

This one has a decent output that doesn't get in the way; it was one of my favorites, but it requires Emacs with `erlang-mode` and, we wanted to be friendly to people who use different editors/IDEs.

**[erlfmt](https://github.com/WhatsApp/erlfmt)**

`erlfmt` generated pleasant output on the VerneMQ codebase, was very fast to format the entire project, and is opinionated on how it formats code, which is great. Why have opinions when a tool con apply consistency for you? It also can skip modules (`%%% % @noformat`) or expressions (`%% erlfmt-ignore`) with code comments in case the formatter gets wild with some piece of code we want to remain untouched. This project is well maintained and supported by WhatsApp/Meta and supports any editor.

**So, we have a winner here: `erlfmt` yay!** But not so fast, there are two unsolved problems:

### How to keep Git history untouched?

I didn't want to erase all the commit history and become the sole contributor to every file in the codebase, making it hard for other contributors to find out when and who introduced a change.

Luckily, since Git version 2.23, Git natively supports [ignoring revisions in blame](https://git-scm.com/docs/git-blame#Documentation/git-blame.txt---ignore-revltrevgt) with the `--ignore-rev` flag.

Contributors can also pass a file listing the revisions to ignore using the `--ignore-revs-file` flag or configure it globally with `git config --global blame.ignoreRevsFile .git-blame-ignore-revs`. The mentioned file is supported by GitHub too (See: https://docs.github.com/en/repositories/working-with-files/using-files/viewing-a-file#ignore-commits-in-the-blame-view).

This option solved the problem nicely, I formatted the codebase in one massive commit (`51114111cd70f82731f1b9ed7d4c29358e71e41b`) and then put the commit hash in the [].git-blame-ignore-revs](https://github.com/vernemq/vernemq/blob/master/.git-blame-ignore-revs) file at the root of the project:

```
# Code formatter applied: `rebar3 fmt`
51114111cd70f82731f1b9ed7d4c29358e71e41b
```

With this file, other contributors can use git blame in the GitHub UI or their local machines and `git` will skip the formatting commit.

### How to ensure new commits don't introduce unformatted code?

Enforcing code formatting was an easy effort, in VerneMQ we use GitHub Actions for CI, so adding a new step to the CI pipeline was enough to prevent unformatted pull requests from making it to the `main` branch. Here is how it would look for a new project:

```yaml
name: Check PR

on: [pull_request]

jobs:
  code_checks:
    name: Check code style and quality
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2.0.0
      - uses: erlef/setup-beam@v1
        with:
          otp-version: 25.0
      - name: Check code formatting (erlfmt)
        run: ./rebar3 fmt -c
```

That's it, folks! I hope this can be useful to anybody applying code formatting to their Erlang projects.
