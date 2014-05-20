class govuk::node::s_monitoring (
  $notify_pager = false,
  $notify_slack = false,
  $slack_token = undef,
  $slack_channel = undef,
  $slack_subdomain = undef,
  $slack_username = 'Icinga',
  $nagios_cgi_url = 'https://example.com/cgi-bin/icinga/status.cgi'
) inherits govuk::node::s_base {

  validate_bool($notify_pager, $notify_slack)

  include monitoring

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

  $offsite_backup = extlookup('offsite-backups', 'off')
  case $offsite_backup {
    'on':    { include backup::offsite::monitoring }
    default: {}
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
  $transition_members = 'transition_members'
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

  icinga::contact_group { 'transition_members':
    group_alias => 'Contacts for transition issues',
    members     => flatten([
      $transition_members
    ])
  }
}
