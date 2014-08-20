# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class rkhunter::config {

  file { '/etc/default/rkhunter':
    ensure => 'present',
    source => 'puppet:///modules/rkhunter/etc/default/rkhunter',
  }

  file { '/etc/rkhunter.conf.local':
    ensure => 'present',
    source => 'puppet:///modules/rkhunter/etc/rkhunter.conf.local',
  }

}
