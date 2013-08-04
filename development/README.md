# Developing on GDS Virtual Machines

Welcome to GDS. The following instructions show you how to get your
development environment running.

## 0. Context

Our development environment is an Ubuntu virtual machine with a view
to achieving [dev-prod parity][1]. By default, the steps below will
set you up with a [VirtualBox][2] VM, managed and configured by
[Vagrant][3]. If you feel strongly about using another piece of
software (such as VMWare) for your development VM, you may find
instructions for doing so [on the wiki][4].

[1]: http://www.12factor.net/dev-prod-parity
[2]: https://www.virtualbox.org/
[3]: http://vagrantup.com/
[4]: https://github.com/alphagov/wiki/wiki

## 1. Prerequisites and assumptions

  * You have [VirtualBox](https://www.virtualbox.org/) installed
  * You have an account on [GitHub.com](https://github.com)
  * You have an account on
    [GDS's GitHub Enterprise](https://github.gds) and you can see the
    [Puppet repository](https://github.gds/gds/puppet) (which you can,
    because you're reading this)
  * You have [Vagrant 1.2](http://downloads.vagrantup.com/) or greater
    installed - these instructions may work with older versions, but
    they're not officially supported
  * You have some other repositories from GDS checked out to work on -
    these should be located alongside the `puppet` repository we're in
    now (e.g `~/govuk/puppet:~/govuk/frontend`)

### A note on Boxen

If you have a GDS issued laptop and you want to automate most of this,
consider building your laptop using
[GDS Boxen](https://github.com/alphagov/gds-boxen). Specifically
you'll want these things:

    include vagrant
    include virtualbox
    vagrant::plugin { 'vagrant-dns': }
    include projects::puppet

## 2. Booting your VM

Assuming your Puppet code is checked out into:

    ~/govuk/puppet

the following commands will boot your VM:

    cd ~/govuk/puppet
    sudo vagrant dns --install # Only has to be run once
    vagrant up

wait a few minutes and your VM should be running. You can now SSH into it with:

    vagrant ssh

and install the Puppet manifests with:

    govuk_puppet

and that's it. Now you can get to work!
