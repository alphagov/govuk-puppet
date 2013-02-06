# vagrant-govuk

Vagrant node definitions for GOV.UK

## Prereq

You will need access to the repos:

- `puppet` obviously
- `vcloud-templates` for node definitions
- `deployment` for extdata

## Setup

The above repos should be cloned parallel to this one. `development/install.sh` will do this for you.

The preferred method of installing Vagrant is through Bundler. This allows us to pin specific versions. However if you already have a system-wide installation that should also work.

There is also an rbenv version file included. I recommend that you use rbenv and the version of Ruby specified in there. If you only have 1.8.x available then you will almost certainly need to install rbenv, see [here](https://github.com/sstephenson/rbenv/#homebrew-on-mac-os-x) and [here](http://dan.carley.co/blog/2012/02/07/rbenv-and-bundler/).

## Usage

You need only bring up the subset of nodes that you're working on. To bring up a frontend and backend for example:
```sh
vagrant up frontend-1.frontend backend-1.backend
```

Vagrant will run the Puppet provisioner against the node when it boots up. Nodes should look almost identical to that of Skyscape staging, including network addresses.

## Customisation

Node definitions can be overridden with a `nodes.local.json` file in the vagrant-govuk directory that is merged on top of all other node definitions.

To increase the amount of RAM on a PuppetMaster for example:
```json
{
  "puppet-1.management": {
    "memory": 768
  }
}
```

## Errors

### Ruby warnings
```
/usr/local/lib/site_ruby/1.9.1/rubygems/custom_require.rb:36:in `require': iconv will be deprecated in the future, use String#encode instead.
/usr/lib/ruby/gems/1.9.1/gems/puppet-2.7.19/lib/puppet/provider/service/bsd.rb:12: warning: class variable access from toplevel
```
These are expected because Puppet 2.7 doesn't quite claim to be compatible with Ruby 1.9

### Storeconfigs
```
warning: You cannot collect without storeconfigs being set on line ..
warning: You cannot collect exported resources without storeconfigs being set; the collection will be ignored on line ..
```
These are expected because storeconfigs doesn't work with `puppet apply`. If you want to test a manifest that requires storeconfigs you can bring up a `puppet-1.management` node and use `puppet agent`.

### NFS failed mounts
```
[frontend-1.frontend] Mounting NFS shared folders...
Mounting NFS shared folders failed. This is most often caused by the NFS
client software not being installed on the guest machine. Please verify
that the NFS client software is properly installed, and consult any resources
specific to the linux distro you're using for more information on how to do this.
```
This seems to be caused by a combination of OSX, VirtualBox, and Cisco AnyConnect. Try temporarily disconnecting from the VPN when bringing up a new node.
