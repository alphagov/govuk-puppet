class govuk::node::s_monitoring (
  $notify_pager = false,
  $notify_campfire = false,
  $campfire_token = undef,
  $campfire_room = undef,
  $campfire_subdomain = undef,
) inherits govuk::node::s_base {

  validate_bool($notify_pager, $notify_campfire)

  include monitoring

  nginx::config::vhost::proxy { 'graphite':
    to       => ['graphite.cluster'],
    aliases  => ['graphite.*', 'grafana', 'grafana.*'],
    ssl_only => true,
    root     => '/dev/null',
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

  if $notify_campfire and ($campfire_subdomain and $campfire_token and $campfire_room) {
    icinga::campfire_contact { 'campfire_notification':
      campfire_token     => $campfire_token,
      campfire_room      => $campfire_room,
      campfire_subdomain => $campfire_subdomain,
    }

    $campfire_members = ['campfire_notification']
  } else {
    $campfire_members = []
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
      $campfire_members,
      $pager_members,
    ])
  }

  icinga::contact_group { 'high-priority':
    group_alias => 'Contacts for high priority alerts',
    members     => flatten([
      $google_members,
      $campfire_members,
    ])
  }

  icinga::contact_group { 'normal-priority':
    group_alias => 'Contacts for normal priority alerts',
    members     => flatten([
      $google_members,
      $campfire_members,
    ])
  }

  icinga::contact_group { 'regular':
    group_alias => 'Contacts for regular alerts',
    members     => flatten([
      $google_members,
      $campfire_members,
    ])
  }
}
