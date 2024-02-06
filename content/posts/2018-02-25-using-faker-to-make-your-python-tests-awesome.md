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
title: Using Faker to make your Python tests awesome.
description: A simple and quick way to generate fake data for your Python tests.
---

When you are testing your Python apps, you will find in the need for generating some dummy data that is as close as possible to real user input and also not have to worry about it containing personally identifying information (PII) for security reasons (This may seem trivial but us developers tend to suck at generating data, and we end using our own data, some movies or games that we like or data from somebody's on the team or a real customer). Also, something essential is to generate data that is not repeated on every test run to add more reliability to those tests against different inputs, that's what your users will do at the end. One possible solution for this in the case we are using Django can be using fixtures or factories by using [FactoryBoy](https://github.com/FactoryBoy/factory_boy/), but this means a lot of unnecessary extra work and the generated is static. However, there is a package named **faker** [https://github.com/joke2k/faker](https://github.com/joke2k/faker) that can be used to create fake data very quickly for your tests or just to populate a database for a demo or whatever your need is. In this post, i will show the basics of such package and how handy it can be to have it in your toolset.

![Faker](/imgs/faker.webp)

## Setting Up

In this post, i will use Python3.6 (because there is no reason to use two anymore 😊) and **pipenv** for creating a virtualenv and installing packages, I wrote about it in a previous [post](http://dairon.org/2018/01/07/pipenv-python-package-manager.html). Open a terminal window and follow these steps:

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

```python
class Customer:

    def __init__(self, name, address, state, zipcode, contact_name,
                 phone_number, email, notes):
        self.name = name
        self.address = address
        self.state = state
        self.zipcode = zipcode
        self.contact_name = contact_name
        self.phone_number = phone_number
        self.email = email
        self.notes = notes

    @property
    def full_address(self):
        return f'{self.address} {self.state} {self.zipcode}'

    @property
    def contact(self):
        return f'{self.contact_name} <self.email>'
```

Now lets create a simple and trivial testcase illustrating how to generate fake attributes for our `Customer` object:

```python
import unittest

from faker import Faker

from customer import Customer


class TestCustomer(unittest.TestCase):

    def setUp(self):
        fake = Faker()
        self.customer = Customer(
                name = fake.company(),
                address = fake.street_address(),
                state = fake.state(),
                zipcode = fake.zipcode(),
                contact_name = fake.name_female(),
                phone_number = fake.phone_number(),
                email = fake.company_email(),
                notes = fake.text(max_nb_chars=20)
        )

    def test_full_address(self):
        expected = f'{self.customer.address} {self.customer.state} {self.customer.zipcode}'
        self.assertEqual(expected, self.customer.full_address)

    def test_contact(self):
        expected = f'{self.customer.contact_name} <self.customer.email>'
```

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

```python
from faker import Faker

fake  = Faker('es_ES')

print(fake.name())
print(fake.address())
print(fake.phone_number())
```

```console
(faker_testing-rhVJ83Ej) ʄ faker_testing >> python fake_es.py
Joan Morán Ávila
Pasadizo Felix Escamilla 13 Apt. 22
Granada, 18242
+34 686 985 516
```

### Creating custom providers

This example illustrates how to create a provider for the planets on the milky way:

```python
from faker.providers import BaseProvider


class PlanetProvider(BaseProvider):

    __provider__ = 'planet'
    __lang___ = 'en_US'

    planets = ['Neptune', 'Mars', 'Mercury', 'Venus', 'Earth', 'Jupiter', 'Saturn', 'Uranus']

    def planet(self):
        return self.random_element(self.planets)
```

It can be used like:

```python
from faker import Faker

from planet_provider import PlanetProvider

fake = Faker()

fake = Faker()
fake.add_provider(PlanetProvider)
print(fake.planet())
```

```console
(faker_testing-rhVJ83Ej) ʄ faker_testing >> python planet_test.py
Earth
```

### Generating always the same data

Sometimes you need to return the same data on every run for tests that need verifiable input/output. Faker allows to do this by using a seed(can be any number) that always will return the same data, like:

```python
from faker import Faker

fake = Faker()
fake.random.seed(1234)

print(fake.name())
```

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

To learn more about faker and see all the available generators, you can refer to the documentation at:
[https://faker.readthedocs.io](https://faker.readthedocs.io).
