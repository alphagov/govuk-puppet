Exec { path => '/usr/lib/rbenv/shims:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin' }

File {
  owner => 'root',
  group => 'root',
  mode  => '0644',
}

# Default destination address to 'any' instead of the default `$::ipaddress`
# in order to support nodes with multiple interfaces such as Vagrant.
Ufw::Allow {
  ip  => 'any',
}

# Many of the 3rd party repos we use don't provide sources.
Apt::Source {
  include_src => false,
}

# apt-add-repository(1) on Lucid doesn't support `-y`
if $::lsbdistcodename == 'lucid' {
  Apt::Ppa {
    options => '',
  }
}

# Ensure update is always run before any package installs.
# title conditions prevent a dependency loop within apt module.
Class['apt::update'] -> Package <|
  provider != pip and
  provider != gem and
  ensure != absent and
  ensure != purged and
  title != 'python-software-properties' and
  title != 'software-properties-common' and
  tag != 'no_require_apt_update'
|>

# extdata is parallel to the manifests and modules directories.
# NB: manifestdir may not be correct if `puppet apply` is used.
$extlookup_datadir = inline_template('<%=
  File.expand_path(
    "../extdata",
    File.dirname(scope.lookupvar("::settings::manifest"))
  )
-%>')

$extlookup_precedence = [
  '%{environment}_credentials',
  '%{environment}',
  'common'
]

# Ensure that hiera is working. Now that we depend on it for config.
if !hiera('HIERA_SAFETY_CHECK', false) {
  fail('Hiera does not appear to be working. Update `vagrant-govuk` and/or `vagrant reload` your VM')
}

import 'nodes.pp'
