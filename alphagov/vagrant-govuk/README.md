# vagrant-govuk

Vagrant node definitions for GOV.UK

## Prereq

You will need access to the repos:

- `puppet` obviously
- `govuk-provisioning` for node definitions

## Setup

The above repos should be cloned in parallel to this one. Either
`alphagov/gds-boxen` or `gds/development:install.sh` can do this for you.

It is recommended that you use Vagrant > 1.4 from a binary/system install.
`alphagov/gds-boxen` can set this up for you.

## Usage

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
  "puppetmaster-1.management": {
    "memory": 768
  }
}
```

## Errors

Some errors that you might encounter..

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
new node. You can also set `VAGRANT_GOVUK_NFS=no` as an environment variable to disable the use of NFS. This is less perfomant but fine for checking puppet runs.
