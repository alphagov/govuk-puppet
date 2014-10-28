# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_monitoring (
  $enable_fastly_metrics = false,
  $offsite_backups = false,
) inherits govuk::node::s_base {

  validate_bool($enable_fastly_metrics, $offsite_backups)

  include monitoring

  if $enable_fastly_metrics {
    include collectd::plugin::cdn_fastly
  }

  nginx::config::vhost::proxy { 'graphite':
    to        => ['graphite.cluster'],
    aliases   => ['graphite.*', 'grafana', 'grafana.*'],
    ssl_only  => true,
    protected => false,
    root      => '/dev/null',
  }

  harden::limit { 'nagios-nofile':
    domain => 'nagios',
    type   => '-', # set both hard and soft limits
    item   => 'nofile',
    value  => '16384',
  }

  file { '/opt/smokey':
    ensure => 'directory',
    owner  => 'deploy',
    group  => 'deploy',
  }

  if $offsite_backups {
    include backup::offsite::monitoring
  }
}
