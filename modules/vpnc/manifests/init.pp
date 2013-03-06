# == Class: vpnc
#
# Installs the vpnc package. Nothing more. Utilised by OpenConnect.
#
class vpnc {
  package {'vpnc':
    ensure => present,
  }
}
