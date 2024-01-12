---
layout: post
type: post
tags:
- python
- testing
- faker
- datasets
- fake data
published: true
title: Using Faker to make your Python tests awesome 
---

When you are testing your Python apps, you will find in the need for generating some dummy data that is as close as possible to real user input and also not have to worry about it containing personally identifying information (PII) for security reasons (This may seem trivial but us developers tend to suck at generating data, and we end using our own data, some movies or games that we like or data from somebody's on the team or a real customer). Also, something essential is to generate data that is not repeated on every test run to add more reliability to those tests against different inputs, that's what your users will do at the end. One possible solution for this in the case we are using Django can be using fixtures or factories by using [FactoryBoy](https://github.com/FactoryBoy/factory_boy/), but this means a lot of unnecessary extra work and the generated is static. However, there is a package named **faker** [https://github.com/joke2k/faker](https://github.com/joke2k/faker) that can be used to create fake data very quickly for your tests or just to populate a database for a demo or whatever your need is. In this post, i will show the basics of such package and how handy it can be to have it in your toolset.

![Faker]({{ site.url }}/imgs/faker.webp)

## Setting Up

In this post, i will use Python3.6 (because there is no reason to use two anymore :)) and **pipenv** for creating a virtualenv and installing packages, I wrote about it in a previous [post](http://dairon.org/2018/01/07/pipenv-python-package-manager.html). Open a terminal window and follow these steps:

* In the terminal, create a directory for your project and generate a virtualenv for it:

  ```console
  $ mkdir faker_testing && cd faker_testing
  $ pipenv --python 3.6
  ```

* Install the faker package:

  ```console
  $ pipenv install faker
  ```

## Getting hands-on code

Let's consider a case where we have a `Customer` object with some attributes and methods, and we wanna write tests for those methods:

{% gist d310a5a457dd0bb55e45b18dfce8dcd3 %}

Now lets create a simple and trivial testcase illustrating how to generate fake attributes for our `Customer` object:

{% gist 20d5be237c66cfc59b9250270e4be84e %}

Let's run the tests with:

```console
(faker_testing-rhVJ83Ej) ʄ faker_testing >> python -m unittest
..
----------------------------------------------------------------------
Ran 2 tests in 0.049s

OK
```

## Advanced Usage

As you can see above, faker is very easy to use. There are more advanced things that you can do with it:

### Generating data for some specific locale

Lets try generating some data in Spanish:

{% gist 2e04e13ad467606322b25a47cc601a35 %}

```console
(faker_testing-rhVJ83Ej) ʄ faker_testing >> python fake_es.py 
Joan Morán Ávila
Pasadizo Felix Escamilla 13 Apt. 22 
Granada, 18242
+34 686 985 516
```

### Creating custom providers

This example illustrates how to create a provider for the planets on the milky way:

{% gist 9512a87becd0f27e69070ca8b021d350 %}

It can be used like:

{% gist c5f863190271658eca660f7584a6de9d %}

```console
(faker_testing-rhVJ83Ej) ʄ faker_testing >> python planet_test.py
Earth
```

### Generating always the same data

Sometimes you need to return the same data on every run for tests that need verifiable input/output. Faker allows to do this by using a seed(can be any number) that always will return the same data, like:

{% gist 2c960aa49dd56d4aefdd3694863f9014 %}

```console
(faker_testing-rhVJ83Ej) ʄ faker_testing >> python faker_seed.py 
Jessica Smith
(faker_testing-rhVJ83Ej) ʄ faker_testing >> python faker_seed.py 
Jessica Smith
(faker_testing-rhVJ83Ej) ʄ faker_testing >> python faker_seed.py 
Jessica Smith
```

As you can see running the program will always return the same data.

# References

To learn more about faker and see all the available generators, you can refer to the documentation on [https://faker.readthedocs.io](https://faker.readthedocs.io).

