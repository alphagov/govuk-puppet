# == Class: govuk::node::s_asset_slave
#
# Sets up an asset slave machine to serve assets
#
# === Parameters
#
# [*offsite_backups*]
#   Boolean indicating whether assets should be backed up offsite
#
class govuk::node::s_asset_slave (
  $offsite_backups = false,
) inherits govuk::node::s_asset_base {

  validate_bool($offsite_backups)

  include assets::ssh_authorized_key

  if $offsite_backups {
    include backup::assets
  }
}
