# Development

So, you've started as a developer at GDS. The instructions that follow should
help you get your development machine set up with our development environment.

## 0. Context

Our development environment is an Ubuntu virtual machine with a view to
achieving [dev-prod parity][1]. By default, the steps below will set you up
with a [VirtualBox][2] VM, managed and configured by [Vagrant][3]. If you feel
strongly about using another piece of software (such as VMWare) for your
development VM, you may find instructions for doing so [on the wiki][4].

[1]: http://www.12factor.net/dev-prod-parity
[2]: https://www.virtualbox.org/
[3]: http://vagrantup.com/
[4]: https://github.com/alphagov/wiki/wiki

Commands that look like this:

    mac$ echo "Think Different"

should be run in the shell on your Mac, whereas commands that look like this:

    dev$ echo "Linux for human beings"

should be run in the shell on the development VM.

## 1. Prerequisites and assumptions

  * You should have an account on GitHub and be added to the `alphagov` organisation
  * You should have [generated and registered](https://help.github.com/categories/56/articles) an SSH key pair with your GitHub account
  * You are using a Mac
  * You should have installed [VirtualBox](https://www.virtualbox.org/) on
    your machine (**NB**: you don't need to do any more than install
    VirtualBox. The steps that follow will create your VM.)

## 2. Install dev tools and the VM

  1. Decide where you want to check out GOV.UK code repositories. Maybe `~/govuk`?
  2. Download a copy of [install.sh](https://github.com/alphagov/development/blob/master/install.sh) into this directory.
  3. Run the following:

        mac$ cd ~/govuk
        mac$ sh install.sh

This script will install git, vagrant, and a development virtual machine.

## 3. Running the VM

### 3.1 Switching between Ubuntu versions

The default VM is currently version 10.04 (lucid). You can switch versions by destroying your current VM and setting an environment variable, then bringing up the VM again.

    mac$ cd development
    mac$ vagrant destroy
    mac$ export govuk_dev_dist=lucid; vagrant up
    mac$ vagrant destroy
    mac$ export govuk_dev_dist=precise; vagrant up

### 3.2 Starting Vagrant

    mac$ cd development
    mac$ vagrant up
    mac$ vagrant ssh

Once on the Virtual Machine, you should provision the development environment
by running puppet:

    dev$ govuk_puppet

This may take a long time on first run, but *should* exit with no errors.

## 4. Set up the apps

Most of our apps are written in Ruby and use Bundler to manage their
dependencies. They won't be able to boot without their dependencies, so we need
to install them:

    dev$ cd /var/govuk/development
    dev$ ./update-bundler.sh

For many apps, they won't be usable until you create a user by hand in their
database, or grab a copy of production data (see below).

## 5. Running the apps

GOV.UK repositories live in `/var/govuk` (a directory which is shared between
your Mac and your VM) and you can easily run multiple services using the
Procfile in `/var/govuk/development`:

    dev$ cd /var/govuk/development
    dev$ foreman start

The above command will use the Procfile and start everything at once. This can
be slow to startup so if you know what you're working on you're probably
better running just those parts using
[Bowler](https://github.com/JordanHatch/bowler). To install bowler:

    dev$ sudo gem install bowler

Then to run particular apps with bowler:

    dev$ bowl publisher panopticon

If you want to run the project in development mod with the static assets
served from your local copy, run foreman with the STATIC_DEV variable defined
and make sure you're not setting static=0:

    dev$ STATIC_DEV="http://static.dev.gov.uk" bowl planner static

## 6. Set Your Git User and Email

This way, commits you make on the VM get your name and email set on them:

    dev$ git config --global user.email "friendly.giraffe@digital.cabinet-office.gov.uk"
    dev$ git config --global user.name "Friendly Giraffe"

## 7. Create a production user

To get production/preview access you will need to add your public key and
configure a user account for yourself in our `puppet` repository.

Let's say you want the username "friendlygiraffe". Add your user account
settings to `puppet/modules/users/manifests/groups/govuk.pp`. Your entry will
look similar to the following:

    govuk::user { 'friendlygiraffe':
      fullname => 'Friendly Giraffe',
      email    => 'friendly.giraffe@digital.cabinet-office.gov.uk',
      ssh_key  => 'AAAAB3NzaC1yc2EAAAA...',
    }

Once committed and pushed, you'll need to find someone who already has
production permissions to deploy it for you.

## 8. Import production data

These dumps are generated from production data in the early hours each day,
and are then downloaded from preview. Some databases can't yet be copied onto
preview (or Dev VMs) because of security concerns. Those databases include:
Signon, Licensify and EFG.

To get production data on to your local vm you will need to either have access
to preview or a mongo and a mysql export from someone that does. If you
have preview access then importing the latest data can be done by running
the following from `development/replication`.

    dev$ ./replicate-data-local.sh -F ../ssh_config -u $USERNAME

If you do not have preview access, get hold of a mongo and a mysql database
dump files and place them in a specific directory structure shown below.

    dir/
        mongo/[mongo-dump-file]
        mysql/[mysql-dump-file]

Then, from `development/replication` run.

    dev$ ./replicate-data-local.sh -F ../ssh_config -d path/to/dir -s -u $USERNAME

## 9. Accessing Skyscape Preview

The Skyscape Preview environment is not behind a VPN but still remains less open 
than legacy preview (which was on AWS). The following documents access during the
migration period from the AWS Preview environment. It will be updated again after
this migration is complete.

### 9.1 Access to Web apps and services
Skyscape Preview Web services and applications are available via the public Internet,
and are presented on URLs of the following form:

    www.preview.alphagov.co.uk
    nagios.preview.alphagov.co.uk

These web pages are generally protected via HTTP basic authentication, which
requires a shared username and password to be provided. This shared username and
password should be well known by members of the development team, so just ask.

During the migration to Skyscape Preview, access to these URLs requires some 
additional host entries, to override the public DNS entries for the AWS legacy
environment. After the migration the public DNS will be updated to point to 
Skyscape Preview, but until then a script is available to add the required 
host aliases to your Mac.

See Script:
https://github.com/alphagov/private-utils/blob/master/script/govuk_select_preview

### 9.2 Access to servers via SSH

Note: This assumes that you have followed Step 6, and have your machine's Public 
key added to the Puppet repositary, and this has been deployed to the Skyscape 
preview environment.

While the load balanced endpoints are available directly via the public 
Internet, SSH access to the boxes which comprise the environment is brokered via 
a "jumpbox". You will need to configure your machine to use this jumpbox. See the
last three stanzas in the configuration below and add them to your ~/.ssh/config.

See Ops Manual:
http://goo.gl/UFcnQ

Note: if the user name you added to puppet is different to the user name you
have on your laptop, then pay particular attention to the note at the bottom of the
Ops Manual page. You will need to add the User directive to both Host stanzas. 

Assuming you have created an ssh key-pair and the public key has been distributed, 
and your SSH config is upto date, you can connect to `backend-1.backend.preview` by:

    $ ssh backend-1.backend.preview

## 10. Keeping your VM up to date

There are a few scripts that should be run regularly to keep your VM up to date. In the
`development` there is `update-git.sh` and `update-bundler.sh` to keep your projects up
to date. Also, `govuk_puppet` should be run from anywhere on the VM regularly.
