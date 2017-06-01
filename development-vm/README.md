# Get started


Welcome to GOV.UK.

Follow the steps on this page to get your GDS development environment running with a [VirtualBox](https://www.virtualbox.org/) VM, managed and configured by [Vagrant](http://vagrantup.com/).

> You'll need to use a Mac to follow this guide.

It will take you roughly one day to do everything in this guide from start to finish. There are lots of things to download, and loads of installers need to do their thing.

> You'll need up to 100GB of free space on your hard-drive to run the whole of GOV.UK.

**Developing outside the VM**

You don't have to develop on the VM, but we strongly recommend it. If you have problems with the development VM you can always ask for help in the #govuk-developers Slack channel.

**Where you should run commands**

Run `mac$` commands in the shell on your Mac:

    mac$ echo "Think Different"

Run `dev$` commands in the shell on the development VM:

    dev$ echo "Linux for human beings"

**If you run into problems**

If you're having trouble with Vagrant or the development VM, there are [troubleshooting tips](https://docs.publishing.service.gov.uk/manual/troubleshooting-vagrant.html) in the dev manual. Of course you should also feel free to call on your colleagues or ask in the #govuk-developers channel in Slack.

## 1. Install some dependencies

First, install:

* git command line tool: either from the managed software center or from [git-scm](https://git-scm.com/downloads)
* [VirtualBox](https://www.virtualbox.org/)
* [Vagrant](https://www.vagrantup.com/downloads.html)
* vagrant-dns plugin: `vagrant plugin install vagrant-dns`
* install vagrant: `vagrant dns --install`
* start vagrant: `vagrant dns --start`

## 2. Create your GitHub accounts

1. Set up a [GitHub](https://www.github.com) account.
1. Ask your tech lead to add you to the [alphagov organisation](https://github.com/alphagov).
1. Set up a [GitHub Enterprise](https://github.digital.cabinet-office.gov.uk) (private) account and ask to be added to the `gds` organisation.
1. [Generate and register an SSH key pair](https://help.github.com/articles/connecting-to-github-with-ssh/) for your Mac for your GitHub account.
1. Import the SSH key into your keychain. Once you’ve done this, it’ll be available to the VM you'll install in the next step.

        mac$ /usr/bin/ssh-add -K yourkey

1. Test that it all works by running `ssh -T git@github.com`.

## 3. Create a user in Integration and CI

User accounts in our Integration and CI environments are managed in the [govuk-puppet](https://github.com/alphagov/govuk-puppet) repository.

    mac$ mkdir ~/govuk
    mac$ cd ~/govuk
    mac$ git clone git@github.com:alphagov/govuk-puppet.git

To create a new account, start by creating an SSH key at least 4096 bits long. For example:

    mac$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ~/.ssh/alphagov

Now create a user manifest in `~/govuk/govuk-puppet/modules/users/manifests` with your username and the public key you just created. Your username should use the `firstnamelastname` format.

Add the name of your manifest (your username) into the list of `users::usernames` in [`hieradata/integration.yaml`][integration-hiera].

There's another bit of hieradata in [`integration.yaml`][integration-hiera] for `govuk_jenkins::config::admins` which will give you access to the deployment Jenkins. Add your **GitHub Enterprise** username to this list.

Create a pull request with these changes. Once it has been reviewed by a member of the GOV.UK team, you can merge it and it will automatically deploy to the Integration environment. This will come in handy later.

[integration-hiera]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata/integration.yaml

## 4. Boot your VM

Run the VM bootstrap script:

    mac$ cd govuk-puppet/development-vm
    mac$ vagrant up

This will take a little while, but it will throw up a question or two in your console so check back on it occassionally. Now might be a good time to scan through the [GOV.UK technology blog](https://gdstechnology.blog.gov.uk/category/gov-uk/) while Puppet runs.

Once your VM is running, you should be able to SSH into it with:

    mac$ vagrant ssh

> See the full command list by typing `vagrant --help`

### Set your Git username and email

You can assign your name and email to commits on the VM:

    dev$ git config --global user.email "friendly.giraffe@digital.cabinet-office.gov.uk"
    dev$ git config --global user.name "Friendly Giraffe"

## 5. Set up your apps

Begin by checking out all of the gov.uk services. There's a handy shortcut:

    dev$ cd /var/govuk/govuk-puppet/development-vm
    dev$ ./checkout-repos.sh < alphagov_repos

Most of our apps are written in Ruby and use [Bundler](http://bundler.io/rationale.html) to manage their dependencies. To boot apps, you’ll also need to install those dependencies:

    dev$ ./update-bundler.sh

There are also some Python apps, which use [PIP](https://pip.pypa.io/en/stable/). You’ll probably need to install those dependencies too, so run:

    dev$ ./update-pip.sh

> `~/govuk/` on your host machine is mounted as `/var/govuk` inside the VM. Any app repositories you clone should go here.

## 6. Access remote environments

Your pull request from earlier will hopefully have been merged by now. It's time to test your access to servers via SSH.

> If you're not in the office right now, you'll need to be connected to the Aviation House VPN for SSH access to Integration.

While the applications are available directly via the public internet, SSH access to the environment is via a ‘jumpbox’. You’ll need to configure your machine to use this jumpbox, using this example SSH config file:

```
Host *
  UseRoaming no

Host *.integration
    IdentityFile ~/.ssh/alphagov
    User $USERNAME

# Integration
# -------
Host jumpbox.integration.publishing.service.gov.uk
  ProxyCommand none

Host *.integration.publishing.service.gov.uk
  ProxyCommand ssh -e none %r@jumpbox.integration.publishing.service.gov.uk -W %h:%p

Host jumpbox-1.management.integration
  Hostname jumpbox.integration.publishing.service.gov.uk
  ProxyCommand none

Host jumpbox-2.management.integration
  Hostname jumpbox.integration.publishing.service.gov.uk
  Port     1022
  ProxyCommand none

Host *.integration
  ProxyCommand ssh -e none %r@jumpbox-1.management.integration -W $(echo %h | sed 's/\.integration$//'):%p
```

Copy that into the `~/.ssh/config` file on your mac, substituting your username for `$USERNAME`. You should then be able to ssh into any box in the Integration environment directly. Test that it works, by running:

    mac$ ssh backend-1.backend.integration

Next, create an ssh config file inside the VM with the same contents. You can choose whether to import your `alphagov` keypair to the VM or to use the built in key-forwarding. If you choose the latter, then remove the `IdentityFile` declaration. Test that you can reach Integration from your VM:

    dev$ ssh backend-1.backend.integration

## 7. Import production data

Dumps are generated from production data in the early hours each day, and are then downloaded from integration.

If you have integration access, you can download and import the latest data by running:

    dev$ cd /var/govuk/govuk-puppet/development-vm/replication
    dev$ ./replicate-data-local.sh -u $USERNAME -F ../ssh_config

If you don't have integration access, ask someone to give you a copy of their dump. Then, from `govuk-puppet/development-vm/replication` run:

    dev$ ./replicate-data-local.sh -d path/to/dir -s

For more information, see the guide in the developer docs on [replicating application data locally for development](https://docs.publishing.service.gov.uk/manual/replicate-app-data-locally.html).

## 8. Run your apps

You can run any of the GOV.UK apps from the `/var/govuk/govuk-puppet/development-vm` directory. You’ll first need to run `bundle install` in this folder to install the required gems.

Since many of our apps depend on other apps, we normally run them using [bowler](https://github.com/JordanHatch/bowler) instead of foreman.

To run particular apps with bowler, use:

    dev$ bowl content-tagger

This will also run all of the dependencies defined in the Pinfile.

If you don't need an optional dependency, you can pass the `-w` option:

    dev$ bowl whitehall -w mapit

## 9. Keep your VM up to date

There are a few scripts that should be run regularly to keep your VM up to date. In `govuk-puppet/development-vm` there is `update-git.sh` and `update-bundler.sh` to help with this. Also, `govuk_puppet` should be run from anywhere on the VM regularly.

The following invocation will do all of this for you.

    dev$ cd /var/govuk/govuk-puppet/development-vm
    dev$ ./update-all.sh

This will run:

* `git pull` on each of the applications checked out in `/var/govuk`
* `govuk_puppet` to bring the latest configuration to the dev VM
* `bundle install` for each Ruby application to install any missing gems
* `pip install` to update runtime dependencies for any python apps

## 10. Access the web frontend

Most GOV.UK web applications and services are available via the public internet, on the following forms of URL:

* [http://publisher.dev.gov.uk](http://publisher.dev.gov.uk) (local dev, requires the application to be running)
* [https://www-origin.integration.publishing.service.gov.uk](https://www-origin.integration.publishing.service.gov.uk) (integration, HTTP basic auth)
* [https://deploy.staging.publishing.service.gov.uk](https://deploy.staging.publishing.service.gov.uk) (staging, restricted to GDS office IP addresses)
* [https://alert.publishing.service.gov.uk](https://alert.publishing.service.gov.uk) (production, restricted to GDS office IP addresses)

The basic authentication username and password is widely known, so just ask somebody on your team if you don't know it.
