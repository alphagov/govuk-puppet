class govuk::node::s_management inherits govuk::node::s_base {
  include govuk::node::s_management_base
  include jenkins::master
  include govuk::openconnect

  host { 'github.gds':
    ip      => '192.168.9.110',
    comment => 'Ignore VPN DNS and set static host for GHE',
  }
}
