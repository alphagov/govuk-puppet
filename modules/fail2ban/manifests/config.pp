# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class fail2ban::config {

  file { '/etc/fail2ban/fail2ban.local':
    source => 'puppet:///modules/fail2ban/etc/fail2ban/fail2ban.local',
  }

  file { '/etc/fail2ban/jail.local':
    source => 'puppet:///modules/fail2ban/etc/fail2ban/jail.local',
  }

}
