# vagrant-govuk

Vagrant node definitions for GOV.UK

## Prereq

You will need access to the repos:

- `puppet` obviously
- `deployment` for node definitions and extdata

## Setup

The above repos should be cloned parallel to this one. `development/install.sh` will do this for you.

The preferred method of installing Vagrant is through Bundler. This allows us to pin specific versions. However if you already have a system-wide installation that should also work.

There is also an rbenv version file included. I recommend that you use rbenv and the version of Ruby specified in there. If you only have 1.8.x available then you will almost certainly need to install rbenv, see [here](https://github.com/sstephenson/rbenv/#homebrew-on-mac-os-x) and [here](http://dan.carley.co/blog/2012/02/07/rbenv-and-bundler/).

## Usage

You need only bring up the subset of nodes that you're working on. To bring up a frontend and backend for example:
```sh
vagrant up frontend-1.frontend backend-1.backend
```

Vagrant will run the Puppet provisioner against the node when it boots up. Some yellow warnings are expected due to [storeconfigs](http://projects.puppetlabs.com/issues/7078). Nodes should look almost identical to that of Skyscape staging, including network addresses.

## Customisation

Node definitions can be overridden with a `nodes.local.json` file that is merged on top of all other node definitions.

To increase the amount of RAM on a PuppetMaster for example:
```json
{
  "puppet-1.management": {
    "memory": 768
  }
}
```
