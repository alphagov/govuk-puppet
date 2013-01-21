Exec { path => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin' }

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

if $::govuk_platform == 'development' {
  $extlookup_datadir = '/var/govuk/development/extdata'
} else {
  $extlookup_datadir = '/usr/share/puppet/production/current/extdata'
}
$extlookup_precedence = ['%{govuk_platform}', 'common']

import 'classes/**/*'
import 'nodes.pp'
