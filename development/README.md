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

Either way, you will need virtualisation enabled in your BIOS, otherwise it
won't work. This tends to be enabled by default on Macs, but is worth
checking for other manufacturers.

[1]: http://www.12factor.net/dev-prod-parity
[2]: https://www.virtualbox.org/
[3]: http://vagrantup.com/
[4]: https://github.com/alphagov/wiki/wiki

## 1. Prerequisites and assumptions

  * You have [OSX GCC tools installed](https://github.com/kennethreitz/osx-gcc-installer) (or via XCode)
  * You have [VirtualBox](https://www.virtualbox.org/) installed
  * You have an account on [GitHub.com](https://github.com)
  * You have an account on
    [GDS's GitHub Enterprise](https://github.gds) and you can see the
    [Puppet repository](https://github.gds/gds/puppet) (which you can,
    because you're reading this)
  * You have [Vagrant 1.3](http://downloads.vagrantup.com/) or greater
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

If your profile is based on

    include gds-development

then you will already have these, and will automatically get any
improvements made in that module. This is the recommended approach.

## 2. Booting your VM

Assuming your Puppet code is checked out into:

    ~/govuk/puppet

the following commands will bootstrap your VM:

    cd ~/govuk/puppet/development
    ./bootstrap.sh

and follow the instructions. Your machine will be automatically
provisioned so you shouldn't have to do anything once it's finished.

Once your VM is running you should be able to SSH into it:

    vagrant ssh

and that's it. Now you can get to work!

## Extras

* Your VM comes pre-configured with an IP address. This is visible in
  the [Vagrantfile](./Vagrantfile) (but currently defaults to `10.1.1.254`)
* If you want to add extra RAM, you can do so in a
  `Vagrantfile.localconfig` file in this directory, which is
  automatically read by Vagrant (don't forget to re-run `vagrant
  up`!):

        $ cat ./Vagrantfile.localconfig
        config.vm.provider :virtualbox do |vm|
          vm.customize [ "modifyvm", :id, "--memory", "1024", "--cpus", "2" ]
        end

* If you want to be able to SSH into your VM directly, add the
  following to your `~/.ssh/config`:

        Host dev
          User vagrant
          ForwardAgent yes
          IdentityFile ~/.vagrant.d/insecure_private_key
          HostName 10.1.1.254
          StrictHostKeyChecking no
          UserKnownHostsFile=/dev/null

* To re-run Puppet, just SSH into your VM and run `govuk_puppet`.

## Troubleshooting

### Errors loading the Vagrantfile

If you're encountering errors loading the `Vagrantfile`, check you're running the right version:

    vagrant --version

if it reports a version below `1.3.x`, you're out of date. This can be
verified by running `which rbenv`, which will likely report a path
like `/opt/boxen/rbenv/shims/vagrant`.

This means you're still running the old Gem installed version of
Vagrant, which can be forcibly removed by running the following
script (directly on the terminal):

```shell
for version in `rbenv versions --bare`; do
    rbenv local $version
    gem uninstall vagrant
    gem uninstall vagrant-dns
done
```

then run `rbenv rehash` to make sure all the Gem installed shims are
removed from your `PATH`.

### Errors with NFS

You're likely on the production VPN. Disconnect the VPN and `reload`
your VM.

### Errors with vagrant-dns having updated vagrant

If after updating vagrant, you get errors regarding vagrant-dns when provisioning the VM you will need to reinstall the vagrant-dns plugin:

    vagrant plugin uninstall vagrant-dns
    vagrant plugin install vagrant-dns

### Errors fetching packages

GDS have an apt repository at http://apt.production.alphagov.co.uk/ This is not accessible on the internet, so if you're trying to provision the virtual machine outside of the GDS office, you have a little bit of work to do. The prerequisites talk about needing an LDAP account to access GDS Github Enterprise, so you should have an account which lets you access the VPN.

#. [Install openconnect](https://github.com/alphagov/gds-boxen/blob/1ba02125e0/modules/people/manifests/jabley.pp#L31)
#. [Connect to the Aviation House VPN](https://github.com/jabley/homedir/commit/2682f094024524cb7e31ca447694bdf81b1239a2)
#. `vagrant provision` should now be able to download packages when running apt
