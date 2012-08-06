Exec { path => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin' }

File {
  owner => 'root',
  group => 'root',
  mode  => '0644',
}

if $::govuk_platform == 'development' {
  $extlookup_datadir = '/var/govuk/deployment/puppet/extdata'
} else {
  $extlookup_datadir = '/usr/share/puppet/production/current/extdata'
}
$extlookup_precedence = ['%{fqdn}', 'domain_%{domain}', 'common']

import 'classes/*'
import 'nodes.pp'
