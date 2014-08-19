class hosts::self {
  host { $::fqdn:
    ensure       => present,
    ip           => '127.0.1.1',
    host_aliases => $::hostname,
  }
}
