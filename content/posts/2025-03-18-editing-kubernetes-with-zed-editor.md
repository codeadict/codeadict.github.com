---
layout: post
type: post
tags:
  - zed
  - kubernetes
  - editor
  - tips
  - productivity
published: true
title: Editing Kubernetes configurations with the Zed Editor
description: How to edit the Kubernetes configurations confidently using the Zed Editor
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

The [Zed Editor](https://zed.dev/) has been my daily driver for writting code for over a year now. It has become an integral part of my workflow, and I have also contributed to it by creating and maintaining the [Erlang plugin](https://github.com/zed-extensions/erlang). While I'm very happy with the experience, I found myself having to often go back to Visual Studio Code to edit Kubernetes configurations that I work with on my day to day.

I started to look for some solutions to this problem, and I found that the Zed Editor uses the [yaml-language-server](https://github.com/redhat-developer/yaml-language-server) to edit YAML files and this language server has support for providing Kubernetes schema validation. This means that the Zed Editor can provide real-time validation and error checking for Kubernetes configurations, making it easier to catch and fix errors without having to switch to another editor or running `kubectl` commands which can be time-consuming.

To enable this, you need to edit your project's Zed settings (`.zed/settings.json`) (Accessed with `CMD + Shift + p` in OSX and choose "zed: open project settings") and add the following lines:

```yaml
"lsp": {
    "yaml-language-server": {
      "settings": {
        "yaml": {
          "schemaStore": {
            "enable": true
          },
          "completion": true,
          "schemas": {
            "kubernetes": "path/to/k8s_files/**.yaml"
          }
         ...
        }
      }
    }
  }
```

Now you get autocompletion, schema validation and documentation for Kubernetes configurations:

![Kubernetes configurations autocompletion](/imgs/zed_kube_autocompletion.png){: .photo }

![Kubernetes configurations documentation](/imgs/zed_kube_documentation.png){: .photo }

This small addition has made a significant difference in my workflow, and I highly recommend it to anyone who works with Kubernetes configurations.

Enjoy!
