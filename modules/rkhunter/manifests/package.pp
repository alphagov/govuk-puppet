# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class rkhunter::package (
  $ensure = 'installed',
){

  package { 'rkhunter':
    ensure => $ensure,
  }

  # The rkhunter package adds an entry to cron.daily by default,
  # but we write our own which integrates with our monitoring.
  file { '/etc/cron.daily/rkhunter':
    ensure => absent,
  }

}
