# Development

So, you've started as a developer at GDS. The instructions that follow should
help you get your development machine set up with our development environment.

## 0. Context

Our development environment is an Ubuntu virtual machine with a view to
achieving [dev-prod parity][1]. By default, the steps below will set you up
with a [VirtualBox][2] VM, managed and configured by [Vagrant][3]. If you feel
strongly about using another piece of software (such as VMWare) for your
development VM, you may find instructions for doing so [on the wiki][4].

Either way, you will need virtualisation enabled in your BIOS, otherwise it
won't work. This tends to be enabled by default on Macs, but is worth
checking for other manufacturers.

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

  * You are using a Mac
  * You should have an account on:
    * GitHub.com (public) and be added to the `alphagov` organisation
    * GitHub Enterprise (private) and be added to the `gds` organisation
  * You should have [generated and registered](https://help.github.com/categories/56/articles) SSH key pairs for your Mac for both your GitHub accounts (later you may need to do this on your vagrant box too).

## 2. Install dev tools and the VM

You probably want
[GDS Boxen](https://github.com/alphagov/gds-boxen). If you don't want
that, you just need Git and the information in the next section.

## 3. Running the VM

See
[the Puppet development README](https://github.gds/gds/puppet/blob/master/development/README.md)
for more information.

## 4. Set up the apps

Most of our apps are written in Ruby and use Bundler to manage their
dependencies. They won't be able to boot without their dependencies, so we need
to install them:

    dev$ cd /var/govuk/development
    dev$ ./update-bundler.sh

For many apps, they won't be usable until you create a user by hand in their
database, or grab a copy of production data (see below).

If you have failures then turn off the multi-process update as follows to allow you
to see clearly which updates are failing. You may not need every application so may
be able to ignore some errors.

    dev$ PROC_COUNT=1 ./update-bundler.sh

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

## 7. Create a production/preview user

To get production/preview access you will need to add your public key and
configure a user account for yourself in our `puppet` repository.

Let's say you want the username "friendlygiraffe". Create a puppet manifest file containing
your user account settings in `puppet/modules/users/manifests/` and include it in
`puppet/modules/users/manifests/groups/govuk.pp`. New starters should
fork their own copy of this repo and submit a pull request to add
their manifest - they don't automatically get write access.

Your manifest for the above would be called `friendlygiraffe.pp` and look similar to the following:

    class users::friendlygiraffe {
      govuk::user { 'friendlygiraffe':
        fullname => 'Friendly Giraffe',
        email    => 'friendly.giraffe@digital.cabinet-office.gov.uk',
        ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAA... friendlygiraffe-laptop-20130101',
      }
    }

To gain ssh access to preview, it should be included in
`puppet/modules/users/manifests/groups/govuk.pp` like so:

    include users::friendlygiraffe

Make a pull request for it; once merged to master, it will automatically deploy
within a few minutes.

To gain ssh access to production, the same line should be included in
`puppet/modules/users/manifests/groups/govuk_production_access.pp`.  Once this
is committed and pushed, you'll need to find someone who already has production
permissions to deploy it for you. It is worth noting that production
access is not automatically given to new starters either - it requires a
rotation on second-line support and some knowledge of the GOV.UK stack.

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

Dumps of the Elasticsearch indexes take place nightly on preview boxes. To get a
copy of the production search index on your local vm, run the following from
`rummager`:

    dev$ RUMMAGER_INDEX=all bundle exec rake rummager:migrate_from_unaliased_index

Then run this from `development/replication`:

    dev$ ./replicate-search-index.sh -F ../ssh_config -u $USERNAME

If you have an existing search index you need to remove, run the following from the
Rummager repository before the replication script.

    dev$ RUMMAGER_INDEX=all rake rummager:switch_to_empty_index

## 9. Accessing Preview

### 9.1 Access to Web apps and services
Preview Web services and applications are available via the public Internet,
and are presented on URLs of the following form:

    www.preview.alphagov.co.uk
    nagios.preview.alphagov.co.uk

These web pages are generally protected via HTTP basic authentication, which
requires a shared username and password to be provided. This shared username and
password should be well known by members of the development team, so just ask.

### 9.2 Access to servers via SSH

Note: This assumes that you have followed Step 6, and have your machine's Public
key added to the Puppet repository, and this has been deployed to the preview environment.

While the load balanced endpoints are available directly via the public
Internet, SSH access to the boxes which comprise the environment is brokered via
a "jumpbox". You will need to configure your machine to use this jumpbox. See
the [instructions in the Ops
Manual](https://github.gds/pages/gds/opsmanual/2nd-line/technical-setup.html#ssh-config)
for adding the relevant lines to your `~/.ssh/config`.

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

All of the above can be run at once with a single command `update-all.sh`.
