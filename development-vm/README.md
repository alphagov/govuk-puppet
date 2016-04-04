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
  * On a new mac, you should import the SSH key you generated into your keychain. Once you have done this, it will be available to the VM you'll install in the next step.

        /usr/bin/ssh-add -K yourkey

## 2. Install dev tools and the VM

You probably want
[GDS Boxen](https://github.com/alphagov/gds-boxen). If you don't want
that, you just need Git and the information in the next section.

## 3. Running the VM

See
[the Puppet development README](https://github.com/alphagov/govuk-puppet/blob/master/development/README.md)
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

The above command will use the Procfile and start everything at once. This will
almost certainly fail, since you will not have all the appropriate code downloaded,
and possibly don't have access to some repos. Even if you have all targets mentioned
in the Procfile downloaded, it will be slow to startup so if you know what you're
working on you're probably better running just those parts using
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

## 7. Create a user account on our remote servers

To get access to connect to machines in our environments you'll need to make
a pull request against the Puppet repository to create a user account and add
your public key.

Create yourself a manifest in `govuk-puppet/modules/users/manifests/`. If your LDAP username
is `friendlygiraffe` the manifest will be called `friendlygiraffe.pp` and will look
like this:

```
# Creates the friendlygiraffe user
class users::friendlygiraffe {
  govuk::user { 'friendlygiraffe':
    fullname => 'Friendly Giraffe',
    email    => 'friendly.giraffe@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAA... friendlygiraffe-laptop-20130101',
  }
}
```

To get access to integration, add your username to `hieradata/integration.yaml` under
the section `users::usernames`.

Once you've made a pull request and somebody has merged it to master, it will
automatically deploy to integration within a few minutes.

Production access isn't automatically granted to new starters - it requires
being on the 2nd line support rotation and some knowledge of the GOV.UK stack.
To get access to staging and production, make a pull request to add your
username to `hieradata/staging.yaml` and `hieradata/production.yaml` under
`ssh::config::allow_users` and `users::usernames`.

## 8. Import production data

These dumps are generated from production data in the early hours each day,
and are then downloaded from integration.

Some databases aren't synced out of production because of security concerns.
Those databases include:

- Licensify
- Signon

EFG isn't synced out of production because GOV.UK doesn't host the non-production
instance of that application.

To get production data on to your local vm you will need to either have access
to integration or a mongo and a mysql export from someone that does. If you
have integration access then importing the latest data can be done by running
the following from `development/replication`.

    dev$ ./replicate-data-local.sh -F ../ssh_config -u $USERNAME

If you do not have integration access, ask someone to give you a copy of their
dump.  This should be a directory structure similar to:

    dir
    ├── elasticsearch
    │   ├── api-elasticsearch-1.api.integration
    │   │   ├── detailed.zip
    │   │   ├── government.zip
    │   │   ├── mainstream.zip
    │   │   ├── metasearch.zip
    │   │   ├── page-traffic.zip
    │   │   └── service-manual.zip
    │   └── elasticsearch-1.backend.integration
    │       └── maslow.zip
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

Then, from `development/replication` run.

    dev$ ./replicate-data-local.sh -d path/to/dir -s

After replicating data a few times, your machine might be running low
on disk space. This is because the old database dumps aren't cleaned
up once newer ones have been downloaded. To get over this, it is
advised to periodically `rm -r` older directories in
`development/replication/backups`.

Some tables aren't included in the standard replication. This is due to their
size relative to their usefulness in development. These exemptions can be found
in the `replication/mappings/dbs` folder, and are skipped by small sed scripts
that delete entire `INSERT INTO` lines from the dumps. To force these tables to
be restored, simply delete or rename the relevant sed script and run replication.

## 9. Accessing remote environments

### 9.1 Access to the web frontend

Most GOV.UK web applications and services are available via the public Internet,
on URLs of the following form:

- https://www-origin.integration.publishing.service.gov.uk (integration, HTTP basic auth)
- https://deploy.staging.publishing.service.gov.uk (staging, restricted to GDS office IP addresses)
- https://alert.publishing.service.gov.uk (production, restricted to GDS office IPs addresses)

The basic authentication username and password is widely known, so just ask somebody
on your team if you don't know it.

### 9.2 Access to servers via SSH

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

## 10. Keeping your VM up to date

There are a few scripts that should be run regularly to keep your VM up to date. In the
`development` there is `update-git.sh` and `update-bundler.sh` to keep your projects up
to date. Also, `govuk_puppet` should be run from anywhere on the VM regularly.

All of the above can be run at once with a single command `update-all.sh`.
