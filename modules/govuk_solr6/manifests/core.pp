# == Define: govuk_solr6::core
#
# Creates a solr core named $name if a so-named core doesn't already
# exist. Does nothing otherwise, and makes no attempt to purge
# no-longer-existent cores.
#
# === Parameters:
#
# [*configset*]
#   Name of configSet core should be created with
#
# [*solr_port*]
#   Port of solr server on which to operate
#
# [*solr_host*]
#   Host of solr server on which to operate
#
define govuk_solr6::core (
  $configset,
  $solr_port = 8983,
  $solr_host = 'localhost',
) {
  exec { "test \"$(curl -sL -w '%{http_code}' 'http://${solr_host}:${solr_port}/solr/admin/cores?action=CREATE&name=${name}&configSet=${configset}' -o /dev/null)\" = 200":
    path     => '/usr/bin:/bin',
    provider => shell,
    unless   => "test \"$(curl -sL -w '%{http_code}' 'http://${solr_host}:${solr_port}/solr/${name}/schema' -o /dev/null)\" = 200",
    require  => [
      Configset[$configset],
      Service['solr'],
    ],
  }
}
