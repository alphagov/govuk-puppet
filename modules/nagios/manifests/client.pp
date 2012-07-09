class nagios::client {
  include nagios::client::install, nagios::client::service
  @@nagios::host { "${::govuk_class}-${::hostname}":
    hostalias => $::fqdn,
    address   => $::ipaddress,
  }
}
