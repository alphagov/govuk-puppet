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
  * You have a recent version of [Vagrant](https://www.vagrantup.com/downloads.html)
    installed - these instructions may work with older versions, but
    they're not officially supported
  * You have some other repositories from GDS checked out to work on -
    these should be located alongside the `puppet` repository we're in
    now (e.g `~/govuk/govuk-puppet:~/govuk/frontend`)

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

    ~/govuk/govuk-puppet

the following commands will bootstrap your VM:

    cd ~/govuk/govuk-puppet/development-vm
    ./bootstrap.sh

and follow the instructions. Your machine will be automatically
provisioned so you shouldn't have to do anything once it's finished.

Once your VM is running you should be able to SSH into it:

    vagrant ssh

and that's it. Now you can get to work!

## Extras

* Your VM comes pre-configured with an IP address. This is visible in
  the [Vagrantfile](./Vagrantfile) (but currently defaults to `10.1.1.254`)
* If you have < 8GB of RAM on your host machine, you will need to reduce the
  RAM available to the VM. You can also add extra RAM if you require more.
  You can do both of these things in a `Vagrantfile.localconfig` file in this
  directory, which is automatically read by Vagrant (don't forget to re-run
  `vagrant up`!):

        $ cat ./Vagrantfile.localconfig
        config.vm.provider :virtualbox do |vm|
          vm.customize [ "modifyvm", :id, "--memory", "1024", "--cpus", "2" ]
        end

* If you want to be able to SSH into your VM directly, consider using `vagrant
  ssh` as it'll always do the right thing. If you need direct access (for
  `rsync`, `scp` or similar), you'll need to manually configure your ssh
  configuration: run `vagrant ssh-config --host dev` and paste the output into
  your `~/.ssh/config`. It'll now be available to SSH into using `ssh dev`.

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

### Permission denied (publickey).

You need to forward your publickey to the vm. Run `ssh-add` from the host machine, then attempt to provision your machine again.

To confirm your key has been forwarded to the development vm you can run

```
vagrant ssh # ssh onto vm
ssh-add -L  # list key and location on host machine
```

### Errors with NFS

You're likely on the production VPN. Disconnect the VPN and `reload`
your VM.

#### Vagrant error :NFS is reporting that your exports file is invalid
```
==> default: Exporting NFS shared folders...
NFS is reporting that your exports file is invalid. Vagrant does
this check before making any changes to the file. Please correct
the issues below and execute "vagrant reload":

exports:2: path contains non-directory or non-existent components: /Users/<username>/path/to/vagrant
exports:2: no usable directories in export entry
exports:2: using fallback (marked offline): /
exports:5: path contains non-directory or non-existent components: /Users/<username>/path/to/vagrant
exports:5: no usable directories in export entry
exports:5: using fallback (marked offline): /
```

This means that you may already have old vagrant path definitions in your `/etc/exports` file.

Try opening up `/etc/exports` file to identify old or unwanted vagrant paths and removing them if necessary

On opening `/etc/exports` file each set begins with # VAGRANT-BEGIN: and ends with # VAGRANT-END:. Make sure to delete these and any other lines between VAGRANT-BEGIN: and VAGRANT-END:

or maybe

```
sudo rm /etc/exports
sudo touch /etc/exports

vagrant halt
vagrant up
```

### Errors with vagrant-dns having updated vagrant

If after updating vagrant, you get errors regarding vagrant-dns when provisioning the VM you will need to reinstall the vagrant-dns plugin:

    vagrant plugin uninstall vagrant-dns
    vagrant plugin install vagrant-dns

You may also need to make sure the plugin has been started:

    vagrant dns --start

If you're having issues with your host machine resolving hosts, try purging and reinstalling the DNS config:

    vagrant dns --purge
    vagrant dns --install
    vagrant dns --start

In order to check if the plugin started correctly, you can run:

    ps aux | grep vagrant-dns
    vagrant dns --start -o

If you're still having issues you can try to update the vagrant-dns plugin:

    vagrant plugin update vagrant-dns

### Errors fetching packages

GDS have an apt repository at http://apt.production.alphagov.co.uk/ This is not accessible on the internet, so if you're trying to provision the virtual machine outside of the GDS office, you have a little bit of work to do. The prerequisites talk about needing an LDAP account to access GDS Github Enterprise, so you should have an account which lets you access the VPN.

1. [Install openconnect](https://github.com/alphagov/gds-boxen/blob/1ba02125e0/modules/people/manifests/jabley.pp#L31)
2. [Connect to the Aviation House VPN](https://github.com/jabley/homedir/commit/2682f094024524cb7e31ca447694bdf81b1239a2)
3. `vagrant provision` should now be able to download packages when running apt


### Errors running `govuk_puppet` on VM

Generally, you might want to try `vagrant provision` on your host machine, which does the same thing as `govuk_puppet`, but in a more reliable fashion.

### Can't connect to Mongo

This is probably happening because your VM didn't shut down cleanly. You should be running `vagrant halt` or `vagrant suspend` but if you had to kill your VM or restart your machine mongo won't be able to connect. You can fix this by deleting your `mongod.lock` and restarting mongodb.

```
sudo rm /var/lib/mongodb/mongod.lock
sudo service mongodb start
```

#### `librarian:install` fails due to permission errors

Seeing `chown` / `OperationNotPermitted` errors during the `librarian:install` rake task?

Try `vagrant provision` on your host machine, as above.

#### Hostname provisioning errors

If you use Vagrant v1.8.x, you may encounter an error along these lines during provisioning:

```
Default: Setting hostname...
/opt/vagrant/embedded/gems/gems/vagrant-1.8.1/plugins/guests/ubuntu/cap/change_host_name.rb:37:in `block in init_package': unexpected return (LocalJumpError)
    from /opt/vagrant/embedded/gems/gems/vagrant-1.8.1/plugins/communicators/ssh/communicator.rb:222:in `call’
```

Try `sudo vim`ing (or `sudo nano`, whichever you prefer) into that file and removing the offending `return` line.
