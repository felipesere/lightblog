---
title: Using Lotus Model
author: Felipe Sere
date: 2014-9-7
---

As part of the apprenticeship I have begun building a toy-sized Rails application. The purpose is to get familiar with concepts and techniques of Rails. Although Rails already brings a pre-packaged interface into the database, ActiveRecord, I wanted to use a different framework form my data access layer: [Lotus][1] *emphasized text*
<!-- more -->

# Lotus itself

Lotus was recommended as an alternative to Rails to me by my fellow apprentice [Uku][2] It's a rather young project and still has some ways to go. But it brings forward a couple of nice properties which might make it really attractive down the road. The first thing you'll notice just by going to the projects' website is that Lotus is split across six modules. Each of the modules stands on its, allowing you to swap out single peaces or use elements of Lotus in conjunction with other frameworks.

## Foundations of Lotus model

Let's look at the Model, Lotus answer to persisting "things" "somewhere".

### Entity

A `Lotus::Entity` is a regular Ruby object which gets a very few methods by using Lotus. Here is an example of my `Book` entity in my `Slate` book application:

``` ruby
require 'lotus/entity'

module Slate
  class Book
    include Lotus::Entity

    self.attributes = :id, :title, :author, :reading_state, :started_reading_on

    def days_reading
      if @started_reading_on
        Date.today.mjd - @started_reading_on.mjd
      else
        0
      end
    end
  end
end
```


Including `Lotus::Entity` gives you access to the `attributes` method. All it does is provide you accessors for the designated attributes. Furthermore an initializer is created for you that takes a hash as an argument and assigns those attributes. The only notable attribute to mention here is that your entity must have an `id` attribute. Other than that there is very little to say about `Lotus::Entity`. It is nice, unobtrusive and gives you barely enough functionality to consider it. Mind you, you could do all the *magic* that `Lotus::Entity` does yourself. The framework neither cares about it nor does it rely on any inheritance chain for it to work.

### Repository

The repository is the gateway between whatever persistence system you use and your entities. An important concept to grasp here is that *persistance* does not automatically mean SQL. The repository only needs to rely on the `query` abstraction and the underlying adapter. If the Lotus guys did their job right, you should be able to switch adapters with *zero* effect on your repositories or entities. I have tried switching between the `SqlAdapter` and the `Memory` adapter and it worked like a charm! Below you can find my tiny `BookRepository`:

``` ruby
require 'lotus/repository'

module Slate
  class BookRepository
    include Lotus::Repository

    def self.create_book(attrs)
      book = Slate::Book.new(attrs)
      create(book)
    end

    def self.find_by_title(title)
      query.where(title: title).first
    end
  end
end
```

Including `Lotus::Repository` does quite a bit more than `Lotus::Entity`. From a users perspective, it adds basic methods to `persist` , `update` and `delete` entities as well as some framework related methods. The most interesting one of those framework methods is `query`. It allows you to construct complex queries against your dataset. A very important feature here is that `query` is a *private* method. This means that it can not be accessed from outside of the repository. You wonder how or why that is a feature worth mentioning? It enforces a clean separation. It is not possible to construct queries as a *client* of the repository. All queries that are to be executed *must* be defined by the repository and thus be *named*. In an application that makes heavy use of Rails *ActiveRecord* this is not the case. There, any controller or other entity can create custom queries which tightly bind those objects to the underlying structure of your persisted data!

### Query

`query` is the Lotus abstraction for building queries of any kind. It has a nice chainable syntax to construct complex queries using `where`, `select`, `or`, `sort` and `limit` among a few others. An interesting feature is that the resulting query is just another object. Only when you call `first` or `all` on that query object is the actually query realised and performed against the database. What benefit is that? You can DRY up your queries by creating *intermediate* queries and name them:

``` ruby
def self.authors()
  query_authors.all()
end

def self.active_authors()
  query_authors.where(active: true).all()
end

private
  def self.query_authors()
    query.where(author: true)
  end
```


The query in `query_authors` should not be materialized until either `authors()` or `active_authors()` is called. Only those two methods call `all`. I had not seen this clean separation before, but being a big fan of the builder pattern, I really like it.

As a rule I would never let those `queries` leak out. In my eyes it is the repositories responsibility to materialize all queries and turn them into usable business objects. Allowing those queries to cross the boundary to the business logic would undermine the purpose of the repository.

### Adapter

The adapter is the layer that translates the queries into persistence-specific operations. `Lotus::Model` provides two out-of-the-box adapters: `SqlAdapter` and `Memory`.

# Adding Lotus to my project

Adding Lotus to your project is not really hard. All you have to do is:

*   Add the dependencies to your `Gemfile`
*   Include `Lotus::Entity` in your entity
*   Include `Lotus::Repository` in the soon-to-be repository
*   Write a `Lotus::Model::Mapper` that maps your entities attribute to columns and DB types
*   Wire it all up

You have seen both my book entity and repository in the code examples above, so let's have closer look at the mapper and how everything gets wired up.

## The Mapper

My mapper for the books is as follows:

``` ruby
module Slate
  class Mappers
    def self.mapper
      Lotus::Model::Mapper.new do
        collection :books do
          entity Slate::Book
          attribute :id,                   Integer
          attribute :title,                String
          attribute :author,               String
          attribute :reading_state,        Symbol
          attribute :started_reading_on,   DateTime
          attribute :days_read_counter,    Integer
        end
      end
    end
  end
end
```


A couple of things happen in this mapper. The mapper is responsible for converting out `Lotus::Entity` into something the persistance can actually understnad. It also responsible for converting the data the other way. Meaning tha it takes a record from the persistance and creates a fully-functional entity for you.

Now, in this case the data is going to be stored in a MySQL database. The line `collection :books` tells Lotus what the table for the Book entity is. Obviously this is adapter specific. At least semantically. In a RDBMS a `collection` of entities in a table. In a Cassandra datastore it would probably be something like a ColumnFamily or similar.

The `attribute` methods take two mandatory and an optionl third paramter. The first the name of the attribute in the entity. The second is the way to store in the persistance. Stick to simple types and you'll be safe. That setup assumes that the name of the attribute in your entity matches the column in your database. In case that assumption proves false, you can pass a third arugment in form of hash:

``` ruby
attribute :id, Integer, as: :p_id
```


That will make sure the entity attribute `:id` gets mapped to `:p_id` in the database.

## Wiring it all up

Wiring up `Lotus::Model` to work with Rails is not particularly tricky. All you need to do is create an instance of a `Mapper`, give it to the `Adapter` with some possible additional configuration, attach that adapter to the repository and call `load!` on the `Mapper`.

In my case I put all that into a separate class called `Configuration`. That `Configuration` is able to create a connection to either a `MemoryAdapter` or a `SqlAdapter`. The tricky bit for the `SqlAdapter` was to read its configuration settings such as host and port from `database.yml`. Here is the code for that configuration:

``` ruby
require 'active_support/core_ext/hash/keys'
require 'sequel'
require 'mapper'
require 'books/book_repository'
require 'lotus/model/adapters/memory_adapter'
require 'lotus/model/adapters/sql_adapter'
require 'lotus/model'
require 'books/book'
require 'yaml'

module Slate
  class Configuration

    def initialize(env = :development)
      @env = env
    end

    def memory_adapter
      connect_adapter Lotus::Model::Adapters::MemoryAdapter.new(mapper)
    end

    def sql_adapter
      connect_adapter Lotus::Model::Adapters::SqlAdapter.new(mapper, db_config)
    end

    def db_connection
      ::Sequel.connect(db_config)
    end

    def db_config
      db_file[env][:connection_config]
    end

    private
    attr_reader :env

    def connect_adapter(adapter)
      BookRepository.adapter = adapter
      mapper.load!
    end

    def mapper
      @mapper ||= Slate::Mappers.mapper
    end

    def db_file
      @file ||= YAML.load_file('config/database.yml').deep_symbolize_keys
    end
  end
end
```


The last bit necessary is to actually call into this class during the initialisation of Rails. All I did to achieve that was to add a simple call in `config/application.rb`:

``` ruby
config.after_initialize do
  require 'configuration'
  Configuration.new.sql_adapter
end
```


Done. You application should spin up happily using `Lotus` to persist your entities!

# Outlook

So, adding `Lotus` was not as hard as I thought. And I get the benefit of high-speed tests at the flick of a switch. Still, I would not recommend this for anything near production. Some hard bits like associations (*relationships* between entities) are not in place right now. There are only two adapters, and nothing more on the horizon. Finally, I have not done or seen any benchmarks that show that there are no performance issues.

On the other hand, I am really liking the cleanliness. Repositories and entities just feel right, with very little, unobtrusive code. My personal favourite must be the private `query` method and the framework-mandated named queries. That shows how a good framework will point you towards best practices established by a community.

 [1]: http://lotusrb.org
 [2]: http://www.ukutaht.co/
