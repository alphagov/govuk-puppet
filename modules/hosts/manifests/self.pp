# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class hosts::self {
  host { $::fqdn:
    ensure       => present,
    ip           => '127.0.1.1',
    host_aliases => $::hostname,
  }
}
