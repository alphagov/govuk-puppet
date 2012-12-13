class govuk_node::monitoring_server inherits govuk_node::base {

  include monitoring
  
  $offsite_backup = extlookup('offsite-backups', 'off')

  case $offsite_backup {
    "on":    { include backup::offsite::monitoring }
    default: {}
  }

}
