class govuk::node::s_monitoring inherits govuk::node::s_base {

  include monitoring

  $offsite_backup = extlookup('offsite-backups', 'off')

  case $offsite_backup {
    "on":    { include backup::offsite::monitoring }
    default: {}
  }

}
