# Puppet manifests

This repository contains the puppet modules and manifests for GOV.UK related projects.

## Getting started

In order to run/test the Puppet manifests you will need Ruby 1.9.x and
Bundler.

Dependencies are managed with [Bundler](http://gembundler.com/) and
[librarian-puppet](http://librarian-puppet.com/), but hopefully this should be
transparent unless you need to update the dependencies yourself.

If you wish to apply the Puppet manifests on the current machine (currently
only advisable if you're on an Ubuntu 10.04 machine) you can run

    $ ./tools/puppet-apply-dev

If you're on a GOV.UK development VM, you should be able to run

    $ govuk_puppet

which is a thin wrapper around the `puppet-apply-dev` script.

## Standards

Please familiarise yourself with [our Puppet style guide][style] before
contributing to this repository.

[style]: https://github.com/alphagov/styleguides/blob/master/puppet.md

Pay particular attention to the section **Things that should not be in the Puppet Repo**

## Testing

If you haven't already run `puppet-apply-dev` you'll need to ensure that the
manifest dependencies are up to date:

    $ bundle install
    $ bundle exec librarian-puppet install

Run the tests:

    $ bundle exec rake

The manifest tests are located in `manifests/spec` and some individual modules
have tests in `modules/<module>/spec`. See the [RSpec
Puppet](https://github.com/rodjek/rspec-puppet) documentation for more
details. The specs are run in parallel, so PLEASE SPLIT YOUR TESTS INTO ONE
TEST PER FILE.

[Puppet-lint][pl] is a tool that checks various syntax and style rules common
to well written Puppet code. It can be run with:

    $ bundle exec rake lint

This outputs a set of errors or warnings that should be fixed. See the [Puppet
Style Guide](http://docs.puppetlabs.com/guides/style_guide.html) for more
information.

[pl]: https://github.com/rodjek/puppet-lint

### Scoped testing

You can run the tests for a specific module or modules by setting an
environment variable, `mods` for the rake task, e.g.

    $ bundle exec rake mods=nginx,varnish

The `manifests/` directory is considered one module called `manifests` for
this purpose.

    $ bundle exec rake mods=manifests,govuk

### Node testing

Some issues that span multiple classes or modules may not be picked up unit
testing. Duplicate resource and mislabelled depdendencies are such examples.
To catch these, all available `govuk::node` classes can be exercised with:

    $ bundle exec rake spec:nodes

Because compiling node complete node catalogs takes quite a long time you
may wish to restrict it to certain classes of node by setting an environment
variable, `classes` for the rake task, e.g.

    $ bundle exec rake spec:nodes classes=frontend,backend
