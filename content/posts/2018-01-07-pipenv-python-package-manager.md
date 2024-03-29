---
layout: post
type: post
tags:
- python
- pip
- package managers
published: true
title: Pipenv - Managing your Python projects like a boss
description: A modern Python package manager that solves the problems of dependency hell, separation of development and production, and managing virtualenvs and packages separately.
---

I'm a Pythonista by nature, I always have been. I play with other languages and enjoy them, but [Python](https://www.python.org) is my favorite language that I still get back to.

![Dependency Hell](/imgs/dependency_hell.webp)

But.. it is far from perfect and especially managing dependencies, and isolated environments do not feel that modern and robust like [npm](https://www.npmjs.com/) or [Cargo](https://doc.rust-lang.org/cargo/). [Pip](https://pip.pypa.io/en/stable/), the most used package manager for Python can be frustrating for the following situations:

1. Running `pip freeze >> requirements.txt` can just make your requirements file polluted with unwanted packages (dependencies of your packages), which could change some day and leave my environment with extra libraries, also if that other package is not maintained anymore or removed from Pypi, it will break your installation process. One can manually add the packages to `requirements.txt` but come on it's 2018 and we developers are lazy and busy with more interesting problems.
2. Separating development and production, it's not possible without creating two requirement files: `requirements.txt` and `requirements-dev.txt` (WTF? smells hacky right). I don't want the huge **factoryboy**, **django-debug-toolbar** or **faker** packages on my server and don't wanna worry about it.
3. I don't like to be managing [virtualenvs](https://virtualenv.pypa.io/en/stable/) and packages separately. It's great that since Python 3.3 we have some virtualenv in the interpreter itself, but it still lacks the ease of use that [virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/en/latest/index.html) provides. Pip defaults to the global packages, and I think it should default to a local virtualenv inside the project (like NPM).
4. Dependency spiderweb (a.k.a dependency hell) it's something annoying, and while it could be a hard problem to solve in an elegant way (not the `node_modules` dependency tree way), efforts have not progressed a lot since 2013 (https://github.com/pypa/pip/issues/988). You can reproduce this issue if you install the package `foo==0.0.1` which depends on `requests==2.18.4` and the package `bar==0.0.1` which depends on `requests==2.3.1`, then PIP will downgrade the `requests` package using the order in the `requirements.txt` and probably leave `foo` unusable. This is a big issue, and at least PIP should prompt the user about which one to keep or have some kind of syntax for the preferred one.
5. Pip dropped the old `easy_install` ability to install binary eggs. When you know what your target platform is, this change just adds extra overhead of having to have a compiler installed and the compilation time that a library can take. Just have [GDAL](http://gdal.org/python/) as a dependency, and you will know what I'm talking. Hope your boss doesn't need a change in two minutes, and you need to deploy your project with a newly compiled dependency.


### Introducing Pipenv

![Pipenv](/imgs/pipenv.webp)

Fortunately, there is a new player in the package management arena for Pythonistas and recommended in the official [Python website](https://packaging.python.org/tutorials/managing-dependencies/#managing-dependencies) itself. It is called [Pipenv](https://docs.pipenv.org) and addresses most of the weak points of Pip. It brings the best of other language's package managers to the Python world and unifies [Pip](https://pip.pypa.io/en/stable/), [Pipfile](https://github.com/pypa/pipfile) and [Virtualenv](https://virtualenv.pypa.io/en/stable/) into a simple and powerful tool to manage you Python-based projects. The new `Pipfile` format differs from our old friend `requirements.txt` in several ways:

* You no longer need to use [Pip](https://pip.pypa.io/en/stable/) and [Virtualenv](https://virtualenv.pypa.io/en/stable/) separately, and no [virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/en/latest/index.html) either.

* Uses the [TOML](https://github.com/toml-lang/toml) syntax to allow more powerful and readable configuration.

* Allows declaring dependency groups (i.e., separate main application packages from development packages) so you don't have to deal with `requirements.txt` and `requirements-dev.txt` anymore 🌈.

* It can lock packages to specific versions by generating a file called `Pipfile.lock` (Yes like `package.lock` or `Cargo.lock` YAY!). This mechanism also comes with the ability to generate and check **sha256** hashes of each package to guarantee that you are installing what you are expecting, providing better security in case of untrusted or compromised package sources.

* No dealing with `pip freeze` anymore (It is painful I know), just install and uninstall packages and they will be automatically added to the `Pipfile`, lock them when you are happy with the versions used.


Here is a simple `Pipfile` example to have an idea of how they look like, and below I explain the basics of how you start using `Pipenv` and the commands it provides:

```toml
[[source]]
url = 'https://pypi.python.org/simple'
verify_ssl = true

[requires]
python_version = '3.6'

[packages]
flask = "*"
boto3 = ">=1.4"

[dev-packages]
awscli = "*"
pycodestyle = "*"
pytest = '*'
```

#### Creating a new virtual environment.

Go to your project root directory and run:

```
$ pipenv --python 3.6
```

The above command will create a virtualenv in a centralized directory (honors the **WORKON_HOME** environment variable), using Python 3 because we supplied the `--python 3.6` argument.


#### Installing dependencies.

To add project dependencies run:

```
$ pipenv install requests==2.13.0
```

You will see that `requests` will be added to the `Pipfile` in your project's root.
To add dependencies that will be used only for development, like testing dependencies, just add the `--dev` argument to pipenv:

```
$ pipenv install --dev pytest
```

#### Locking dependencies

Once you are happy with your dependencies, you can generate a `Pipfile.lock` File that will lock your packages to specific versions and hashes. I recommend adding this file whatever version control system you are using to get  the exact environment on other developer's machines or servers that run your app:

```
$ pipenv lock
```

This will generate a file that looks like:

```json
{
    "_meta": {
        "hash": {
            "sha256": "b802fff146f9ce84e1e9281ab16181a877ecd5981ecca9e462dcac13099e5b7e"
        },
        "host-environment-markers": {
            "implementation_name": "cpython",
            "implementation_version": "3.6.3",
            "os_name": "posix",
            "platform_machine": "x86_64",
            "platform_python_implementation": "CPython",
            "python_full_version": "3.6.3",
            "python_version": "3.6",
            "sys_platform": "darwin"
        },
        "pipfile-spec": 6,
        "requires": {
            "python_version": "3.6"
        },
        "sources": [
            {
                "url": "https://pypi.python.org/simple",
                "verify_ssl": true
            }
        ]
    },
    "default": {
        "flask": {
            "hashes": [
                "sha256:0749df235e3ff61ac108f69ac178c9770caeaccad2509cb762ce1f65570a8856",
                "sha256:49f44461237b69ecd901cc7ce66feea0319b9158743dd27a2899962ab214dac1"
            ],
            "version": "==0.12.2"
        }
    },
    "develop": {
        "pycodestyle": {
            "hashes": [
                "sha256:6c4245ade1edfad79c3446fadfc96b0de2759662dc29d07d80a6f27ad1ca6ba9",
                "sha256:682256a5b318149ca0d2a9185d365d8864a768a28db66a84a2ea946bcc426766"
            ],
            "version": "==2.3.1"
        }
    }
}

```


#### Uninstalling dependencies.

To uninstall packages from your project, just run:

```
$ pipenv uninstall requests
```

It will remove the package both from the virtualenv and from the `Pipfile` and `Pipfile.lock`.

#### Entering your virtualenv.

To access a shell with your activated virtualenv, just run:

```
$ pipenv shell
```

Or you can directly run commands inside the virtualenv like:

```
$ pipenv run python manage.py runserver
```

#### Other fancy commands.

```
$ pipenv check
```

Will scan your dependencies for known security vulnerabilities. For example:

```console
$ pipenv check
Checking PEP 508 requirements…
Passed!
Checking installed package safety…

33300: django >=1.10,<1.10.7 resolved (1.10.1 installed)!
CVE-2017-7233: Open redirect and possible XSS attack via user-supplied numeric redirect URLs
============================================================================================

Django relies on user input in some cases  (e.g.
:func:`django.contrib.auth.views.login` and :doc:`i18n </topics/i18n/index>`)
to redirect the user to an "on success" URL. The security check for these
redirects (namely ``django.utils.http.is_safe_url()``) considered some numeric
URLs (e.g. ``http:999999999``) "safe" when they shouldn't be.
Also, if a developer relies on ``is_safe_url()`` to provide safe redirect
targets and puts such a URL into a link, they could suffer from an XSS attack.
...
```

super cool, isn't it?

The `check` command also can be used to check code style by making use of the built-in [Flake8](http://flake8.pycqa.org/en/latest/):

```
$ pipenv check --style
```

Other cool feature is the ability of automatically load any `.env` file:

```console
$ cat .env
API_KEY=supersecretstuff

$ pipenv run python
Loading .env environment variables…
Python 3.6.3 (default, Oct  4 2017, 06:09:15)
[GCC 4.2.1 Compatible Apple LLVM 9.0.0 (clang-900.0.37)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> import os
>>> os.getenv['API_KEY']
'supersecretstuff'
```

As a plus feature, we can import and export Pip's `requirements.txt` files to keep both tools compatibility and I think is great because allows you to test `Pipenv` without the fear of not getting back if it doesn't meet all your expectations.


### Final Thoughts

While [Pipenv](https://docs.pipenv.org) is still a young project and there are some bugs and nice to have features, I have been using it for a few projects, and it feels mature enough for using it in production. Hopefully, it gets more traction, committers, and support from the [PSF](https://www.python.org/psf-landing/) to become the default tool for handling Python packaging and virtualenvs. The more people use it, the better it will get, and more we can know about it to report bugs or contribute back.
