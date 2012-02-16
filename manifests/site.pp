Exec {
  path => "/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin"
}

$extlookup_datadir = "/etc/puppet/extdata"
$extlookup_precedence = ["%{fqdn}", "domain_%{domain}", "common"]

import "modules.pp"
import "classes.pp"
import "opg_classes.pp"
import "nodes.pp"
