# == Define: govuk_solr6::configset
# 
# Ensures the presence of a configset based on the solr installation's
# basic_configs with $schema_xml as its schema. The configset's label
# will be the resource's $name.
#
# === Parameters:
#
# [*schema_xml*]
#   Schema file to use for the configset
#
define govuk_solr6::configset (
  $schema_xml,
) {
  file{'/var/lib/solr/configsets':
    ensure    => directory,
    owner     => 'solr',
    group     => 'solr',
    subscribe => Package['solr'],
  } ~>

  file{"/var/lib/solr/configsets/${name}":
    ensure  => directory,
    owner   => 'solr',
    group   => 'solr',
    source  => '/opt/solr/server/solr/configsets/basic_configs',
    recurse => true,
    # we don't want the basic_configs' managed_schema and add schema.xml ourselves
    ignore  => ['schema.xml', 'managed-schema'],
  } ~>

  file{"/var/lib/solr/configsets/${name}/conf/schema.xml":
    owner  => 'solr',
    group  => 'solr',
    source => $schema_xml,
  } ~>

  file{"/var/lib/solr/configsets/${name}/conf/managed-schema":
    # this gets re-created by solr every time the configset is used to create a core,
    # but we want to be able to update the schema.xml without it being ignored in
    # favour of a stale managed-schema.
    ensure => absent,
  }
}
