This repository contains the puppet modules and manifests for GOV.UK related projects.

In order to run these locally you first want to install puppet and for that you'll want Ruby.

    export PUPPET_VERSION="2.7.3"
    export RUBY_PACKAGE="https://github.com/downloads/alphagov/packages/ruby-1.9.2-p290_amd64.deb"
    wget -q -O ruby.deb $RUBY_PACKAGE && dpkg -i ruby.deb
    gem install -v $PUPPET_VERSION puppet --no-rdoc --no-ri

These modules probably work with different Ruby versions and Puppet versions, but consider doing so
unsupported. It's also only tested/supported on Ubuntu 10.04 LTS 64bit.

You can then run the manifests with the following command:

    sudo FACTER_govuk_class="$FACTER_govuk_class" puppet apply --modulepath=modules manifests/site.pp --onetime --no-daemonize --debug

This assumes you have an environment variable set called FACTER_govuk_class. This should be set to the relevant class,
if in doubt this is probably "development". Check the manifests/nodes.pp file for more options.

A handy script is included that will:

* Install Ruby if required
* Install Puppet if required
* Exit unless FACTER_govuk_class is set
* Run the local puppet manifests

So to get started, or just to apply the latest manifests you can run:

    ./update.sh

On first run with the development class this currently takes approximately 8 minutes on a single processor virtual machine with 1GB RAM.

## Linting

Puppet Lint is a tool that checks various syntax and style rules common
to well written Puppet code. It can be run with:

    bundle exec rake lint

This outputs a set of errors or warnings that should be fixed. See the
[Puppet Style Guide](http://docs.puppetlabs.com/guides/style_guide.html)
for more information.
