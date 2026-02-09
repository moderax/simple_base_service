# SimpleService

A small framework for building plain Ruby "service objects" with a consistent interface.

This gem provides:

- A `Base` class for services with `.run` and `#call` conventions
- Lightweight error handling (`add_error`, `success?`, `failure?`)
- Pluggable logging (instance-level, class-level, `:rails`, and `:stdout` options)

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add simple_base_service
```

If bundler is not being used to manage dependencies, install the gem by executing:

```ruby
# Gemfile
gem 'simple_base_service', github: 'moderax/simple_base_service'
```

Then run `bundle install`.

## Usage

Define a service by inheriting from `SimpleService::Base` and implementing `#call`:

```ruby
class MyService < SimpleService::Base
  def call
    log('starting')

    # perform work
    if something_went_wrong
      add_error('something bad happened')
      return
    end

    :ok
  end
end

# Execute the service (class-level convenience)
MyService.run
```

Inspecting result and errors

```ruby
service = MyService.new
service.call
if service.failure?
  puts service.errors
end
```

### Logging

You can control logging per call, per instance, or globally:

- Pass an object that responds to `info(message)` as `logger: my_logger` to `MyService.run` or `MyService.new`
- Pass `logger: :rails` to use `Rails.logger` when available (falls back to STDOUT)
- Pass `logger: :stdout` to force a simple STDOUT logger
- Set a class-level default with `SimpleService::Base.logger = :stdout` or `MyService.logger = my_logger`

Logger resolution order:

1. Instance `@logger` (if set)
2. Class-level `logger` (inheritable by subclasses)
3. `Rails.logger` (if available)
4. Fallback `Logger.new($stdout)`

### Example: Rails integration

In Rails apps, using `logger: :rails` will forward logs to `Rails.logger` when present:

```ruby
MyService.run(logger: :rails)
```

## Development

- Install dependencies: `bin/setup` (bundler will install gems)
- Run tests: `bundle exec rspec`
- Lint: `bundle exec standardrb` and `bundle exec rubocop`

## Release

- Bump the version in `lib/simple_base_service/version.rb`
- Run `bundle exec rake release` (this tags and pushes a gem to RubyGems)

## Contributing

Bug reports and pull requests are welcome. Please follow these steps:

1. Fork the repository
2. Create a branch for your change
3. Add tests and update the README if you change behavior
4. Open a pull request

We use `standardrb` and `rubocop` for linting—PRs should pass linters and specs.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SimpleService project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/moderax/simple_base_service/blob/master/CODE_OF_CONDUCT.md).
