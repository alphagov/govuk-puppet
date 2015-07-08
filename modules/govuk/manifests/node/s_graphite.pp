# == Class: govuk::node::s_graphite
#
# Class to specify a machine for gathering and storing metrics.
#
# === Parameters:
#
# [*enable_basic_auth*]
#   Boolean. Whether basic auth should be enabled or disabled.
#
class govuk::node::s_graphite (
  $enable_basic_auth = true,
) inherits govuk::node::s_base {
  validate_bool($enable_basic_auth)

  class { 'graphite':
    version                    => '0.9.12',
    port                       => '33333',
    carbon_aggregator          => true,
    aggregation_rules_source   => 'puppet:///modules/govuk/node/s_graphite/aggregation-rules.conf',
    storage_aggregation_source => 'puppet:///modules/govuk/node/s_graphite/storage-aggregation.conf',
    storage_schemas_source     => 'puppet:///modules/govuk/node/s_graphite/storage-schemas.conf',
    carbon_source              => 'puppet:///modules/govuk/node/s_graphite/carbon.conf',
    require                    => Govuk::Mount['/opt/graphite'],
  }

  harden::limit { 'www-data-nofile':
    domain => 'www-data',
    type   => '-', # set both hard and soft limits
    item   => 'nofile',
    value  => '16384',
    notify => Class['graphite::service'],
  }

  # Remove this fix when upgrading from 0.9.12:
  # https://github.com/graphite-project/graphite-web/issues/423
  $util_py          = '/opt/graphite/webapp/graphite/util.py'
  $util_patch       = '/tmp/graphite_util.patch'
  $util_patched_md5 = 'aa6b5e9234dfc705fa01cb871f8eec38'
  file { $util_patch:
    ensure => file,
    source => 'puppet:///modules/govuk/node/s_graphite/graphite_carbonlink.patch',
  }
  exec { 'patch graphite 0.9.12':
    command => "/usr/bin/patch -b ${util_py} ${util_patch}",
    unless  => "/usr/bin/md5sum ${util_py} | /bin/grep -qsw ${util_patched_md5}",
    notify  => Class['graphite::service'],
    require => [
      Class['graphite::install'],
      File[$util_patch],
    ],
  }

  @@icinga::check { "check_carbon_cache_running_on_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!carbon-cache.py',
    service_description => 'carbon-cache running',
    host_name           => $::fqdn,
  }

  @@icinga::check { "check_carbon_aggregator_running_on_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!carbon-aggregat',
    service_description => 'carbon-aggregator running',
    host_name           => $::fqdn,
  }

  @ufw::allow {
    'allow-graphite-2003-from-all':
      port => 2003;
    'allow-graphite-2004-from-all':
      port => 2004;
    'allow-graphite-7002-from-all':
      port => 7002;
  }

  include ::nginx

  $cors_headers = '
  add_header "Access-Control-Allow-Origin" "*";
  add_header "Access-Control-Allow-Methods" "GET, OPTIONS";
  add_header "Access-Control-Allow-Headers" "origin, authorization, accept";
'

  nginx::config::vhost::proxy { 'graphite':
    to           => ['localhost:33333'],
    root         => '/opt/graphite/webapp',
    aliases      => ['graphite.*'],
    protected    => $enable_basic_auth,
    extra_config => $cors_headers,
  }

  include collectd::server
  include grafana
}
