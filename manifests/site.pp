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

import 'classes/**/*'
import 'nodes.pp'
