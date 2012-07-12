Exec { path => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin' }

File {
  owner => 'root',
  group => 'root',
  mode  => '0644',
}

$extlookup_datadir = '/usr/share/puppet/production/current/extdata'
$extlookup_precedence = ['%{fqdn}', 'domain_%{domain}', 'common']

import 'modules.pp'
import 'classes/*'
import 'nodes.pp'
