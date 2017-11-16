# SearchQueryParser

This gem allows you to create PostgreSQL 9.6 compatible ts_query expressions from simple-to-use "query language".

See for reference:

* [Text Search Types](https://www.postgresql.org/docs/9.6/static/datatype-textsearch.html) on PostgreSQL docs
* [Text Search Functions and Operators](https://www.postgresql.org/docs/9.6/static/functions-textsearch.html) on PostgreSQL docs

Example:

```
require 'search_query_parser'

q = SearchQueryParser.to_ts_query("
    (cats | !(angry dogs)) &
    (кошки | !(злые собаки))
")
puts q
# ((to_tsquery('cats:*') || (!! (to_tsquery('angry:*') <-> to_tsquery('dogs:*')))) && (to_tsquery('кошки:*') || (!! (to_tsquery('злые:*') <-> to_tsquery('собаки:*')))))
```

You can use `&`, `|`, `!` operators in the source query, which are transformed into corresponding PostgreSQL operators. Spaces are transformed into `<->` ("follows") PostgreSQL operator.

`.to_ts_query` accepts 3 arguments, only first is required:

* Search string
* Language ('enlgish' by default, will be given as first argument to Postgres' `to_tsquery`)
* Whether to use prefix (`true` by default, `:*` will be added to each word)

## What's the problem

When you use PostgreSQL full-text search you want your users to be able to utilize full power of expressions in a convinient manner. Let's say, you want your users to be able to issue a request to find all documents with `cats` but without `dogs`.

Unfortunately, you can't use Postgres' `plain_tosquery` ([link](https://www.postgresql.org/docs/9.6/static/functions-textsearch.html)) function for that, which would be the closest match to our goal. If you give the string `cates & !dogs` to `plainto_tsquery`, the result will be:

```
=> select plainto_tsquery('cats & !dogs');
 plainto_tsquery
-----------------
 'cat' & 'dog'
```

...so, it just drops all the punctuation and concatenate words with logical AND (`&`), just as the documentation says.

## The solution

Use `SearchQueryParser.to_ts_query(q)` to produce PostgreSQL-compatible expression. All non-alphanumeric and non-operator symbols will be dropped from the `q`.

## How can I use it?

Use it in your Rails finders for models with `tsdata` columns like that:

```
q = SearchQueryParser.to_ts_query('кошки & !собаки', 'russian')
Document.where("tsdata @@ #{q}")
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'search_query_parser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install search_query_parser

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/search_query_parser.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
