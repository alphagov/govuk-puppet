# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class tmpreaper($days_to_keep = 7) {

  # Ensure TMPTIME is set in /etc/default/rcS
  exec { 'set TMPTIME':
    command => "sed -i -r -e '/^TMPTIME=/d' -e '$ a TMPTIME=${days_to_keep}' /etc/default/rcS",
    unless  => "grep -qFx 'TMPTIME=${days_to_keep}' /etc/default/rcS",
  }

  package { 'tmpreaper':
    ensure => present,
  }

  file { '/etc/tmpreaper.conf':
    ensure => present,
    source => 'puppet:///modules/tmpreaper/tmpreaper.conf',
  }

}