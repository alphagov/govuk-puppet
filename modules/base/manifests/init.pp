# == Class: base
#
# Pull in a standard set of modules for all machines. Used everywhere, by
# both `govuk::node::s_base` and `govuk::node::s_development`.
#
class base {
  include apparmor
  include apt
  include apt::unattended_upgrades
  include base::packages
  include cron
  include gcc
  include logrotate
  include ntp
  include screen
  include shell
  include ssh
  include motd
  include govuk_sudo
  include sysctl
  include timezone
  include tmpreaper
  include tmux
  include wget
  include curl

  # FIXME: Fix to reset rubygems to Precise version
  # Described in https://www.pivotaltracker.com/story/show/76786302

  # This is purely to reset the stub, it doesn't seem to affect versioning
  exec { 'reinstall correct ruby1.9.1 package':
    user    => 'root',
    command => 'apt-get -y --force-yes --reinstall install ruby1.9.1=1.9.3.0-1ubuntu2.8 libruby1.9.1=1.9.3.0-1ubuntu2.8 ruby1.9.1-dev=1.9.3.0-1ubuntu2.8',
    unless  => 'echo "3afb14dbac5fb97eb505fa4f74469c19  /usr/bin/gem1.9.1" | /usr/bin/md5sum -c --status',
    require => Exec['apt_update'],
  }

  # Once we have removed the excess rubygems.rb and rbconfig in /usr/local/lib, our
  # gems will be in the wrong place. Ubuntu expects them to be in /var/lib/gems
  exec { 'migrate /usr/lib/ruby/gems to /var/lib/gems':
    user    => 'root',
    command => 'mv /usr/lib/ruby/gems /var/lib/',
    unless  => 'test -d /var/lib/gems',
    require => Exec['reinstall correct ruby1.9.1 package'],
  }

  # The version of rubygems embedded in the system ruby (and rbconfig) are overridden
  # by the copies in /usr/local/lib/site_ruby/1.9.1, by removing them we revert back
  # to the version supplied in the ruby1.9.1 package (/usr/lib/ruby/1.9.1/rubygems.rb)
  exec { 'remove weird rubygems in /usr/local/lib':
    user    => 'root',
    command => 'mv /usr/local/lib/site_ruby/1.9.1 /root/',
    onlyif  => 'test -f /usr/local/lib/site_ruby/1.9.1/rubygems.rb',
    require => Exec['migrate /usr/lib/ruby/gems to /var/lib/gems'],
  }
  # End Rubygems fix

}
