# vagrant-govuk

Vagrant node definitions for GOV.UK

## Prereq

You will need access to the repos:

- `puppet` obviously
- `vcloud-templates` for node definitions

## Setup

The above repos should be cloned in parallel to this one. Either
`alphagov/gds-boxen` or `gds/development:install.sh` can do this for you.

The preferred method of installing Vagrant is through Bundler. This allows us
to pin specific versions. However if you already have a system-wide
installation that should also work.

It is recommended that you use Ruby 1.9 through rbenv. `alphagov/gds-boxen`
can also set this up for you. Alternatively you can read about how to do it
yourself [here](https://github.com/sstephenson/rbenv/#homebrew-on-mac-os-x)
and [here](http://dan.carley.co/blog/2012/02/07/rbenv-and-bundler/).

## Usage

You need only bring up the subset of nodes that you're working on. For
example, to bring up a frontend and backend:
```sh
vagrant up frontend-1.frontend backend-1.backend
```

Vagrant will run the Puppet provisioner against the node when it boots up.
Nodes should look almost identical to that of Skyscape, including network
addresses. To access a node's services like HTTP/HTTPS you can point your
`hosts` file to the host-only IP address (eth1).

Physical attributes like `memory` and `num_cores` will be ignored because
they don't scale appropriately to local VMs, but can still be customised as
described below.

## Customisation

Node definitions can be overridden with a `nodes.local.json` file in the
vagrant-govuk directory. This is merged on top of all other node
definitions. The following keys are currently available for customisation:

- `box_dist` Ubuntu distribution. Currently "precise" (default) or "lucid".
- `box_version` Internal version number of the GDS basebox.
- `memory` Amount of RAM. Default is "384".
- `ip` IP address for hostonly networking. Currently all subnets are /16.
- `class` Name of the Puppet class/role.

For example to increase the amount of RAM on a PuppetMaster:
```json
{
  "puppet-1.management": {
    "memory": 768
  }
}
```

## Errors

Some errors that you might encounter..

### Ruby warnings
```
/usr/local/lib/site_ruby/1.9.1/rubygems/custom_require.rb:36:in `require': iconv will be deprecated in the future, use String#encode instead.
/usr/lib/ruby/gems/1.9.1/gems/puppet-2.7.19/lib/puppet/provider/service/bsd.rb:12: warning: class variable access from toplevel
```
These are expected because Puppet 2.7 doesn't quite claim to be compatible
with Ruby 1.9

### Storeconfigs
```
warning: You cannot collect without storeconfigs being set on line ..
warning: You cannot collect exported resources without storeconfigs being set; the collection will be ignored on line ..
```
These are expected because storeconfigs doesn't work with `puppet apply`. If
you want to test a manifest that requires storeconfigs you can bring up a
`puppet-1.management` node and use `puppet agent`.

### NFS failed mounts
```
[frontend-1.frontend] Mounting NFS shared folders...
Mounting NFS shared folders failed. This is most often caused by the NFS
client software not being installed on the guest machine. Please verify
that the NFS client software is properly installed, and consult any resources
specific to the linux distro you're using for more information on how to do this.
```
This seems to be caused by a combination of OSX, VirtualBox, and Cisco
AnyConnect. Try temporarily disconnecting from the VPN when bringing up a
new node.
