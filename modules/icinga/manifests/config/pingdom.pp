# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class icinga::config::pingdom (
  $username = 'UNSET',
  $password = 'UNSET',
  $key = 'UNSET'
) {

  file { '/etc/pingdom.ini':
    ensure  => 'absent',
    content => template('icinga/etc/pingdom.ini.erb'),
    owner   => 'nagios',
    mode    => '0400',
  }

  file { '/usr/local/bin/check_pingdom.py':
    ensure => 'absent',
    source => 'puppet:///modules/icinga/usr/local/bin/check_pingdom.py',
    mode   => '0755',
  }
}
