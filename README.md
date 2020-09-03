# GOV.UK Puppet

This repository contains the puppet modules and manifests for GOV.UK.

## Getting started

In order to run/test the Puppet manifests you will need Ruby 1.9.x and
Bundler.

Dependencies are managed with [Bundler](http://bundler.io/) and
[librarian-puppet](http://librarian-puppet.com/), but hopefully this should be
transparent unless you need to update the dependencies yourself.

## Standards

Please familiarise yourself with our Puppet standards before contributing to
this repository:

* [Things that should not be in Puppet](/docs/things-that-should-not-be-in-puppet.md)
* [Dependency management](/docs/dependency-management.md)
* [Process supervision](/docs/process-supervision.md)
* [Nagios checks](/docs/nagios-checks.md)

Run `rake spec` and `rake lint` to run the tests and lint before checking in.

## Dependencies

All modules from librarian-puppet are cached in this repo under
`vendor/puppet/` in order to ensure that third-party code doesn't change
underneath us, protect us from downtime, and improve build times.

### Installing

If you're using this repo for the first time or the contents of
`Gemfile[.lock]` or `Puppetfile[.lock]` have recently changed then you'll
need to run:

    $ bundle install
    $ bundle exec rake librarian:install

Please avoid using `librarian-puppet` directly because it's not very good at
respecting or maintaining its own config file.

Running these commands will often be the solution to Puppet errors about
unknown classes or functions such as:

- `Unknown function validate_bool at …`
- `Could not find class apt for …`
- `Puppet::Parser::AST::Resource failed with error ArgumentError: Invalid resource type apt::source …`

It may affect errors relating to classes you have not modified when running spec tests after a rebase.

This should also fix errors while trying to run `govuk_puppet`, of the form:

- `chown: changing ownership of '/home/vagrant/.puppet/[…]': Operation not permitted`

### Updating

If you need to add a new module to the `Puppetfile` then you will need to
run the following to install it and update the cache:

    $ bundle exec rake librarian:package

If you need to update an existing module to a newer version, you'll need to
run the following:

    $ bundle exec rake 'librarian:update[alphagov/tune_ext]'

Afterwards you should commit the `Puppetfile`, `Puppetfile.lock` and any new
files in `vendor/puppet/`. If updating a module then you will need to
manually delete the old tarball from the cache directory.

NB: There should *never* be any changes to `.librarian/puppet/config`.

## Testing

Assuming that your dependencies are installed, run all the tests:

    $ bundle exec rake

The module tests are located in `modules/<module>/spec`. See the [RSpec
Puppet](https://github.com/rodjek/rspec-puppet) documentation for more
details. The specs are run in parallel by default.

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

### Precommit Testing

This repo uses [pre-commit](http://pre-commit.com/) for managing its pre-
commit hooks. This is available via brew:

```brew install pre-commit```

The pre-commit hooks are configured in the .pre-commit-config.yaml file in the
root of this repo. To make the pre-commit hooks work you first need to install
the pre-commit shim in your local .git/hooks directory:

```pre-commit install```

This will run hooks configured in `.pre-commit-config.yaml` when you run a
`git commit` and will pass each hook the list of files staged as part of the
commit. You can test the hooks by doing:

```pre-commit run```

You can also run the hooks on all files to test the status of the entire repo.
This might be useful, for example, as part of a PR builder job:

```pre-commit run --all-files```

### Node testing

Some issues that span multiple classes or modules may not be picked up unit
testing. Duplicate resources and mislabelled dependencies are such examples.
To catch these, all available `govuk::node` classes can be exercised with:

    $ bundle exec rake spec:nodes

Compiling node complete node catalogs takes quite a long time, so you may
wish to restrict it to certain classes of node by setting the environment
variable `classes` for the rake task, e.g.

    $ bundle exec rake spec:nodes classes=frontend,backend

#### Test Hieradata

During spec tests `spec/fixtures/hiera/hiera.yaml` is used to configure hieradata which *only* uses `spec/fixtures/hieradata/common.yaml` for its values (i.e. nothing from `hieradata/`).

During node tests the hieradata uses the `vagrant` environment.

### Test Coverage

Each test suite's results are followed by a summary of how many resources that suite covers, how many the tests touch and the coverage as a percentage. e.g.

```bash
Total resources:   175
Touched resources: 36
Resource coverage: 20.57%
```

A list of untouched resources can be gained by setting the `FULL_COVERAGE_REPORT` environment variable before running the tests:

```
FULL_COVERAGE_REPORT=true bundle exec rake spec
```

***Warning*** Given the number of modules that have limited tests this will produce a very large amount of output unless the tests are scoped.

### Rspec Basic Mode

It is sometimes useful to have access to the normal RSpec Rake task. This exposes the `SPEC` and `SPEC_OPTS` environment variables that mean you can set the test specification and RSpec options respectively. This gives finer grain control when it is needed. e.g.

    $ bundle exec rake rspec_basic_mode SPEC="./modules/collectd/spec/classes/collectd__package_spec.rb:7" SPEC_OPTS="-c"

runs the single test at line 7 of `collectd__package_spec.rb` with colour mode enabled.

***Warning*** using this option disables parallel running of tests and the `mod` arguments will not work.

### Vagrant testing

#### Prerequisites

You will need an up-to-date checkout of the private `govuk-provisioning`
repository for node definitions.

#### Setup

It is recommended that you use Vagrant > 1.4 from a binary/system install.
`alphagov/gds-boxen` can set this up for you.

#### Usage

You need only bring up the subset of nodes that you're working on. For
example, to bring up a frontend and backend:
```sh
vagrant up frontend-1.frontend backend-1.backend
```

Vagrant will run the Puppet provisioner against the node when it boots up.
Nodes should look almost identical to that of our real
production/staging/preview environments, including network addresses. To
access a node's services like HTTP/HTTPS you can point your `hosts` file to
the host-only IP address (eth1).

Physical attributes like `memory` and `num_cores` will be ignored because
they don't scale appropriately to local VMs, but can still be customised as
described below.

#### Customisation

Node definitions can be overridden with a `nodes.local.yaml` file in this
directory. This is merged on top of all other node
definitions. The following keys are currently available for customisation:

- `box_dist` Ubuntu distribution. Currently "trusty".
- `box_version` Internal version number of the GDS basebox.
- `memory` Amount of RAM. Default is "384".
- `ip` IP address for hostonly networking. Currently all subnets are /16.
- `class` Name of the Puppet class/role.

For example to increase the amount of RAM on a PuppetMaster:
```yaml
---
puppetmaster-1.management:
  memory: 768
```

#### Errors

Some errors that you might encounter..

##### NFS failed mounts
```
[frontend-1.frontend] Mounting NFS shared folders...
Mounting NFS shared folders failed. This is most often caused by the NFS
client software not being installed on the guest machine. Please verify
that the NFS client software is properly installed, and consult any resources
specific to the linux distro you're using for more information on how to do this.
```
This seems to be caused by a combination of OSX, VirtualBox, and Cisco
AnyConnect. Try temporarily disconnecting from the VPN when bringing up a
new node. You can also set `VAGRANT_GOVUK_NFS=no` as an environment variable to
disable the use of NFS. This is less performant but fine for checking puppet
runs.
