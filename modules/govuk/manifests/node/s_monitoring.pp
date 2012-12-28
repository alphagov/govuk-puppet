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

}
