# Puppet manifests

This repository contains the puppet modules and manifests for GOV.UK related projects.

## Getting started

In order to run/test the Puppet manifests you will need Ruby and Puppet. Running under Ruby other than 1.9.x may work but is unsupported.

Dependencies are managed with Bundler. Just run `bundle install` and you should be good to go.

## Standards

Please familiarise yourself with [our Puppet style guide][style] before contributing to this repository.

[style]: https://github.com/alphagov/styleguides/blob/master/puppet.md

## Testing

Run the tests with the provider wrapper around rake:

    bundle exec rake test

The manifest tests are located in `manifests/spec` and some individual modules
have tests in `modules/<module>/spec`. See the [RSpec
Puppet](https://github.com/rodjek/rspec-puppet) documentation for more
details. The specs are run in parallel, so PLEASE SPLIT YOUR TESTS INTO ONE
TEST PER FILE.

[Puppet-lint][pl] is a tool that checks various syntax and style rules common
to well written Puppet code. It can be run with:

    bundle exec rake lint

This outputs a set of errors or warnings that should be fixed. See the
[Puppet Style Guide](http://docs.puppetlabs.com/guides/style_guide.html)
for more information.

[pl]: https://github.com/rodjek/puppet-lint

You can also run both tests and lint checks with the default rake task:

    bundle exec rake

### Scoped testing

You can run the tests for a specific module or modules by setting an
environment variable, `mods` for the rake task, e.g.

    bundle exec rake mods=nginx,varnish

The `manifests/` directory is considered one module called `manifests` for
this purpose.

    bundle exec rake mods=manifests,govuk
