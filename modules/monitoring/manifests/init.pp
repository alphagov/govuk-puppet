# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class monitoring {

  package { 'python-rrdtool':
    ensure => 'installed',
  }

  include icinga
  include nsca::server

  include govuk::htpasswd

  # Monitoring server only.
  include monitoring::contacts
  include monitoring::checks

}
