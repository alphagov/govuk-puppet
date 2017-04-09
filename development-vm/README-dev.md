# Development

So, you've started as a developer at GDS. The instructions that follow should
help you get your development machine set up with our development environment.

## 0. Context

Our development environment is an Ubuntu virtual machine with a view to
achieving [dev-prod parity][1]. By default, the steps below will set you up
with a [VirtualBox][2] VM, managed and configured by [Vagrant][3]. You don't have
to develop on the VM, but we strongly recommend it.
If you encounter problems with the development VM you can always ask for help in the #govuk-developers slack channel.

[1]: http://www.12factor.net/dev-prod-parity
[2]: https://www.virtualbox.org/
[3]: http://vagrantup.com/

Commands that look like this:

    mac$ echo "Think Different"

should be run in the shell on your Mac, whereas commands that look like this:

    dev$ echo "Linux for human beings"

should be run in the shell on the development VM.

This folder contains tools you'll find useful during development, and scripts for replicating data from our integration environment.

## 1. Prerequisites and assumptions

  * You are using a Mac
  * You should have an account on:
    * GitHub.com (public) and be added to the `alphagov` organisation
    * GitHub Enterprise (private) and be added to the `gds` organisation
  * You should have [generated and registered](https://help.github.com/categories/56/articles) SSH key pairs for your Mac for both your GitHub accounts (later you may need to do this on your vagrant box too).
  * On a new mac, you should import the SSH key you generated into your keychain. Once you have done this, it will be available to the VM you'll install in the next step.

        mac$ /usr/bin/ssh-add -K yourkey

## 2. Install the VM

See
[the Puppet development README](https://github.com/alphagov/govuk-puppet/blob/master/development-vm/README.md)
for more information on installing the VM.

You may find it useful to use
[GDS Boxen](https://github.com/alphagov/gds-boxen), which will install the required dependencies for you.

At this point, you should be able to ssh into your vagrant vm by running `vagrant ssh` from `govuk_puppet/development-vm`.

`~/govuk/` on your host machine is mounted as `/var/govuk` inside the VM. Any app repositories you clone should go here.

## 3. Set up the apps

If you didn't use Boxen, you will first need to clone some project repositories:

    ./checkout-repos.sh < alphagov_repos

Most of our apps are written in Ruby and use [Bundler][bundler] to manage their
dependencies. They won't be able to boot without their dependencies, so we need
to install them:

    dev$ cd /var/govuk/govuk-puppet/development-vm
    dev$ ./update-bundler.sh

There are a handful of Python apps which use [PIP][pip].
You will probably need to install these dependencies too, so run:

    dev$ ./update-pip.sh

For many apps, they won't be usable until you create a user by hand in their
database, or grab a copy of production data (see below).

If you have failures then turn off the multi-process update as follows to allow you
to see clearly which updates are failing. You may not need every application so may
be able to ignore some errors.

    dev$ PROC_COUNT=1 ./update-bundler.sh

[bundler]: http://bundler.io/rationale.html
[pip]: https://pip.pypa.io/en/stable/

## 4. Running the apps

You can run any of the GOV.UK apps from the `/var/govuk/govuk-puppet/development-vm` directory.

The examples in this section may not work until you've imported production data (see below).

You can use [foreman][foreman] to run a single app. The available apps are defined in the Procfile.

    dev$ cd /var/govuk/govuk-puppet/development-vm
    dev$ foreman start rummager

Since many of apps depend on other apps, we normally run them using [Bowler][bowler] instead of foreman. To install bowler:

    dev$ sudo gem install bowler

Then to run particular apps with bowler:

    dev$ bowl publisher content-tagger

This will also run all of the dependencies defined in the Pinfile.

If you don't need an optional dependency, you can pass the `-w` option:

    dev$ bowl whitehall -w mapit

If you want to run the project in development mode with the static assets
served from your local copy, run bowler with the STATIC_DEV variable defined
and make sure you're not setting static=0:

    dev$ STATIC_DEV="http://static.dev.gov.uk" bowl planner static

[foreman]: http://ddollar.github.io/foreman/
[bowler]: https://github.com/JordanHatch/bowler

## 5. Set Your Git User and Email

This way, commits you make on the VM get your name and email set on them:

    dev$ git config --global user.email "friendly.giraffe@digital.cabinet-office.gov.uk"
    dev$ git config --global user.name "Friendly Giraffe"

## 6. Create a user account on our remote servers

Follow [the docs in the Puppet repository to create an account][account-docs].

[account-docs]: https://github.com/alphagov/govuk-puppet/blob/master/docs/creating-a-user-account.md

## 7. Import production data

These dumps are generated from production data in the early hours each day,
and are then downloaded from integration.

Some databases aren't synced out of production because of security concerns.
Those databases include:

- Licensify
- Signon

However, the dump includes the Signon database from integration.

Mapit's database will be downloaded in the Mapit repo and therefore will be not be in the backups folder.

To get production data on to your local vm you will need to either have access
to integration or a mongo and a mysql export from someone that does. If you
have integration access then importing the latest data can be done by running
the following from `govuk-puppet/development-vm/replication`.

    dev$ ./replicate-data-local.sh -u $USERNAME

If you do not have integration access, ask someone to give you a copy of their
dump.  This should be a directory structure similar to:

    dir
    ├── elasticsearch
    │   └── api-elasticsearch-1.api.integration
    │       ├── detailed.zip
    │       ├── government.zip
    │       ├── mainstream.zip
    │       ├── metasearch.zip
    │       ├── page-traffic.zip
    │       └── service-manual.zip
    ├── mongo
    │   ├── api-mongo-1.api.integration
    │   │   └── 2015-06-02_05h33m.Tuesday.tgz
    │   ├── mongo-1.backend.integration
    │   │   └── 2015-06-02_06h13m.Tuesday.tgz
    │   └── router-backend-1.router.integration
    │       └── 2015-06-02_06h19m.Tuesday.tgz
    ├── mysql
    │   ├── mysql-backup-1.backend.integration
    │   │   └── latest.tbz2
    │   └── whitehall-mysql-backup-1.backend.integration
    │       └── latest.tbz2
    └── postgresql
        ├── postgresql-master-1.backend.integration
        |   └── latest.tbz2
        └── transition-postgresql-master-1.backend.integration
            └── latest.tbz2

Then, from `govuk-puppet/development-vm/replication` run.

    dev$ ./replicate-data-local.sh -d path/to/dir -s

The `replicate-data-local.sh` script accepts the following arguments:

    -F file  Use a custom SSH configuration file.
    -u user  SSH user to log in as (overrides SSH config).
    -d dir   Use named directory to store and load backups.
    -s       Skip downloading the backups (use with -d to load old backups).
    -r       Reset ignore list. This overrides any default ignores.
    -i       Databases to ignore. Can be used multiple times, or as a quoted space-delimited list.
    -n       Don't actually import anything (dry run).

After replicating data a few times, your machine might be running low
on disk space. This is because the old database dumps aren't cleaned
up once newer ones have been downloaded. To get over this, it is
advised to periodically `rm -r` older directories in
`govuk-puppet/development-vm/replication/backups`.

Some tables aren't included in the standard replication. This is due to their
size relative to their usefulness in development. These exemptions can be found
in the `replication/mappings/dbs` folder, and are skipped by small sed scripts
that delete entire `INSERT INTO` lines from the dumps. To force these tables to
be restored, simply delete or rename the relevant sed script and run replication.

If you take your laptop home at night, you may want to download the data while in
the office and restore it overnight to minimise disruption. First, do the download
on your host as the unzipping is a lot quicker when not run over NFS:

    mac$ ./replicate-data-local.sh -u your_ssh_username -n

Then when you get home (or if you have a spare hour during meetings) run the script
on your VM and specify the backup directory for the date you performed the download:

    dev$ ./replicate-data-local.sh -s -d backups/2016-11-17

## 8. Accessing remote environments

### 8.1 Access to the web frontend

Most GOV.UK web applications and services are available via the public Internet,
on URLs of the following form:

- https://www-origin.integration.publishing.service.gov.uk (integration, HTTP basic auth)
- https://deploy.staging.publishing.service.gov.uk (staging, restricted to GDS office IP addresses)
- https://alert.publishing.service.gov.uk (production, restricted to GDS office IPs addresses)

The basic authentication username and password is widely known, so just ask somebody
on your team if you don't know it.

### 8.2 Access to servers via SSH

Note: This assumes that you have followed the previous steps, and have your machine's public
key added to the Puppet repository, and this has been deployed to the environment
you're trying to access.

While the applications are available directly via the public
Internet, SSH access to the environment is via a "jumpbox".
You will need to configure your machine to use this jumpbox. See
the [instructions in the Ops
Manual](https://github.gds/pages/gds/opsmanual/2nd-line/technical-setup.html#ssh-config)
for adding the relevant lines to your `~/.ssh/config`.

Note: if the user name you added to puppet is different to the user name you
have on your laptop, then pay particular attention to the note at the bottom of the
Ops Manual page. You will need to add the User directive to both Host stanzas.

Assuming you have created an SSH keypair and the public key has been distributed,
and your SSH config is up-to-date, you can connect to machines with:

    $ ssh backend-1.backend.integration
    $ ssh backend-1.backend.staging
    $ ssh backend-1.backend.production

## 9. Keeping your VM up to date

There are a few scripts that should be run regularly to keep your VM up to date. In `govuk-puppet/development-vm` there is `update-git.sh` and `update-bundler.sh` to help keep your projects and their dependencies up
to date. Also, `govuk_puppet` should be run from anywhere on the VM regularly.

All of the above can be run at once with a single command `update-all.sh`.
