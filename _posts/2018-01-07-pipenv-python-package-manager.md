---
layout: post
type: post
tags:
- python
- pip
- package managers
published: true
title: Pipenv - Managing your Python projects like a boss
---

I'm a Pythonista by nature, I always have been. I play with other languages and enjoy them, but [Python](https://www.python.org) is my favorite language that I still get back to.

![Dependency Hell]({{ site.url }}/imgs/dependency_hell.webp) 

But.. it is far from perfect and especially managing dependencies, and isolated environments do not feel that modern and robust like [npm](https://www.npmjs.com/) or [Cargo](https://doc.rust-lang.org/cargo/). [Pip](https://pip.pypa.io/en/stable/), the most used package manager for Python can be frustrating for the following situations:

1. Running `pip freeze >> requirements.txt` can just make your requirements file polluted with unwanted packages (dependencies of your packages), which could change some day and leave my environment with extra libraries, also if that other package is not maintained anymore or removed from Pypi, it will break your installation process. One can manually add the packages to `requirements.txt` but come on it's 2018 and we developers are lazy and busy with more interesting problems.
2. Separating development and production, it's not possible without creating two requirement files: `requirements.txt` and `requirements-dev.txt` (WTF? smells hacky right). I don't want the huge **factoryboy**, **django-debug-toolbar** or **faker** packages on my server and don't wanna worry about it.
3. I don't like to be managing [virtualenvs](https://virtualenv.pypa.io/en/stable/) and packages separately. It's great that since Python 3.3 we have some virtualenv in the interpreter itself, but it still lacks the ease of use that [virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/en/latest/index.html) provides. Pip defaults to the global packages, and I think it should default to a local virtualenv inside the project (like NPM).
4. Dependency spiderweb (a.k.a dependency hell) it's something annoying, and while it could be a hard problem to solve in an elegant way (not the `node_modules` dependency tree way), efforts have not progressed a lot since 2013 (https://github.com/pypa/pip/issues/988). You can reproduce this issue if you install the package `foo==0.0.1` which depends on `requests==2.18.4` and the package `bar==0.0.1` which depends on `requests==2.3.1`, then PIP will downgrade the `requests` package using the order in the `requirements.txt` and probably leave `foo` unusable. This is a big issue, and at least PIP should prompt the user about which one to keep or have some kind of syntax for the preferred one.
5. Pip dropped the old `easy_install` ability to install binary eggs. When you know what your target platform is, this change just adds extra overhead of having to have a compiler installed and the compilation time that a library can take. Just have [GDAL](http://gdal.org/python/) as a dependency, and you will know what I'm talking. Hope your boss doesn't need a change in two minutes, and you need to deploy your project with a newly compiled dependency.


### Introducing Pipenv

![Pipenv]({{ site.url }}/imgs/pipenv.webp) 

Fortunately, there is a new player in the package management arena for Pythonistas and recommended in the official [Python website](https://packaging.python.org/tutorials/managing-dependencies/#managing-dependencies) itself. It is called [Pipenv](https://docs.pipenv.org) and addresses most of the weak points of Pip. It brings the best of other language's package managers to the Python world and unifies [Pip](https://pip.pypa.io/en/stable/), [Pipfile](https://github.com/pypa/pipfile) and [Virtualenv](https://virtualenv.pypa.io/en/stable/) into a simple and powerful tool to manage you Python-based projects. The new `Pipfile` format differs from our old friend `requirements.txt` in several ways:

* You no longer need to use [Pip](https://pip.pypa.io/en/stable/) and [Virtualenv](https://virtualenv.pypa.io/en/stable/) separately, and no [virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/en/latest/index.html) either.

* Uses the [TOML](https://github.com/toml-lang/toml) syntax to allow more powerful and readable configuration.

* Allows declaring dependency groups (i.e., separate main application packages from development packages) so you don't have to deal with `requirements.txt` and `requirements-dev.txt` anymore 🌈.

* It can lock packages to specific versions by generating a file called `Pipfile.lock` (Yes like `package.lock` or `Cargo.lock` YAY!). This mechanism also comes with the ability to generate and check **sha256** hashes of each package to guarantee that you are installing what you are expecting, providing better security in case of untrusted or compromised package sources.

* No dealing with `pip freeze` anymore (It is painful I know), just install and uninstall packages and they will be automatically added to the `Pipfile`, lock them when you are happy with the versions used.


Here is a simple `Pipfile` example to have an idea of how they look like, and below I explain the basics of how you start using `Pipenv` and the commands it provides:

{% gist bedafa8a8989372436196150f5d8bbad %}


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

{% gist 31aa4a4620e5a7b823d817d6482b2579 %}


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

{% gist 98f730b2a36d9a8466771dd6904beb38 %}

super cool, isn't it?

The `check` command also can be used to check code style by making use of the built-in [Flake8](http://flake8.pycqa.org/en/latest/):

```
$ pipenv check --style
```

Other cool feature is the ability of automatically load any `.env` file:

{% gist ea9fe4c86628585e0b04c39ce76a2874 %}

As a plus feature, we can import and export Pip's `requirements.txt` files to keep both tools compatibility and I think is great because allows you to test `Pipenv` without the fear of not getting back if it doesn't meet all your expectations.


### Final Thoughts

While [Pipenv](https://docs.pipenv.org) is still a young project and there are some bugs and nice to have features, I have been using it for a few projects, and it feels mature enough for using it in production. Hopefully, it gets more traction, committers, and support from the [PSF](https://www.python.org/psf-landing/) to become the default tool for handling Python packaging and virtualenvs. The more people use it, the better it will get, and more we can know about it to report bugs or contribute back.