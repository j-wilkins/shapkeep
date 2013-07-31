# Shapkeep

Shapkeep keeps track of your Redis Lua script SHA's so you don't have to.

Shapkeep will optimize your Redis EVAL calls by always attempting to use
EVALSHA.

If we get a `NOSCRIPT` error, we load the script, and then `retry`.

Next time, we won't get a `NOSCRIPT`, and so it's Optimized™.

Shapkeep also gives you a central repo of Lua scripts in the form of a YAML
file that you put them all in. The advantages of this are debatable, but for right
now I like it.

It does allow us to eval scripts by name:

     Shapkeep.new('/path/to/store.yml').eval(redis, :name)

## Installation

Add this line to your application's Gemfile:

    gem 'shapkeep'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shapkeep

## Usage

Shapkeep has two ways of using it, as a separate object and as a wrapper of
your Redis object

As a separate object:

     redis = Redis.new
     shapkeep = Shapkeep.new('/path/to/store.yml')

     shapkeep.eval(redis, :script__name)


Or as a wrapper (uses SimpleDelegator)

     redis = Shapkeep::Wrapper.new('/path/to/store.yml', redis)

     redis.keys                # => []

     redis.eval_script(:one)   # => 1

`Shapkeep#eval` and `Shapkeep::Wrapper#eval_script` both accept the `keys` and
`args` arguments as arrays.

     redis.eval_script(:one, ['key1'], ['arg1'])

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
