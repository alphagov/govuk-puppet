# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_monitoring (
  $enable_fastly_metrics = false,
  $notify_pager = false,
  $notify_slack = false,
  $offsite_backups = false,
  $slack_token = undef,
  $slack_channel = undef,
  $slack_subdomain = undef,
  $slack_username = 'Icinga',
  $nagios_cgi_url = 'https://example.com/cgi-bin/icinga/status.cgi'
) inherits govuk::node::s_base {

  validate_bool($enable_fastly_metrics, $notify_pager, $notify_slack, $offsite_backups)

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

  if $notify_slack and ($slack_subdomain and $slack_token and $slack_channel) {
    icinga::slack_contact { 'slack_notification':
      slack_token     => $slack_token,
      slack_channel   => $slack_channel,
      slack_subdomain => $slack_subdomain,
      slack_username  => $slack_username,
      nagios_cgi_url  => $nagios_cgi_url,
    }

    $slack_members = ['slack_notification']
  } else {
    $slack_members = []
  }

  $google_members = 'monitoring_google_group'
  $pager_members = $notify_pager ? {
    true    => ['pager_nonworkhours'],
    default => [],
  }

  icinga::contact_group { 'urgent-priority':
    group_alias => 'Contacts for urgent priority alerts',
    members     => flatten([
      $google_members,
      $slack_members,
      $pager_members,
    ])
  }

  icinga::contact_group { 'high-priority':
    group_alias => 'Contacts for high priority alerts',
    members     => flatten([
      $google_members,
      $slack_members,
    ])
  }

  icinga::contact_group { 'normal-priority':
    group_alias => 'Contacts for normal priority alerts',
    members     => flatten([
      $google_members,
      $slack_members,
    ])
  }

  icinga::contact_group { 'regular':
    group_alias => 'Contacts for regular alerts',
    members     => flatten([
      $google_members,
      $slack_members,
    ])
  }

}
