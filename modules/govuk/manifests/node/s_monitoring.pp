class govuk::node::s_monitoring inherits govuk::node::s_base {

  include monitoring

  $offsite_backup = extlookup('offsite-backups', 'off')

  case $offsite_backup {
    "on":    { include backup::offsite::monitoring }
    default: {}
  }

  $campfire = extlookup('campfire','off')
  case $campfire {
    "on":     {
      nagios::campfire_contact {'campfire_notification':
        campfire_subdomain => extlookup('campfire_subdomain','unset'),
        campfire_token     => extlookup('campfire_token','unset'),
        campfire_room      => extlookup('campfire_room','unset'),
      }
    }
    default : {}
  }

  case $::govuk_platform {
    production: {
      case $::govuk_provider {
        sky: {
          if extlookup(nagios_is_zendesk_enabled, '') == "yes" {
            if $campfire == "on" {
              $urgentprio_members = ['monitoring_google_group', 'pager_nonworkhours', 'zendesk_urgent_priority', 'campfire_notification']
              $highprio_members   = ['monitoring_google_group','zendesk_high_priority', 'campfire_notification']
              $normalprio_members = ['monitoring_google_group','zendesk_normal_priority', 'campfire_notification']
            } else {
              $urgentprio_members = ['monitoring_google_group','pager_nonworkhours','zendesk_urgent_priority']
              $highprio_members   = ['monitoring_google_group','zendesk_high_priority']
              $normalprio_members = ['monitoring_google_group','zendesk_normal_priority',]
            }
          } else {
              $urgentprio_members = ['monitoring_google_group']
              $highprio_members   = $urgentprio_members
              $normalprio_members = $urgentprio_members
          }
        }
        default: {
          $urgentprio_members = ['monitoring_google_group']
          $highprio_members  = $urgentprio_members
          $normalprio_members  = $urgentprio_members
        }
      }
    }
    default: {
      $urgentprio_members = ['monitoring_google_group']
      $highprio_members  = $urgentprio_members
      $normalprio_members  = $urgentprio_members
    }
  }

  nagios::contact_group { 'urgent-priority':
    group_alias => 'Contacts for urgent priority alerts',
    members     => $urgentprio_members,
  }

  nagios::contact_group { 'high-priority':
    group_alias => 'Contacts for high priority alerts',
    members     => $highprio_members,
  }

  nagios::contact_group { 'normal-priority':
    group_alias => 'Contacts for normal priority alerts',
    members     => $normalprio_members,
  }

}
