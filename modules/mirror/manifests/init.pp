class mirror {

  file { '/usr/local/bin/govuk_update_mirror':
    ensure => present,
    mode   => '0755',
    source => 'puppet:///modules/mirror/govuk_update_mirror',
  }

  package { 'spidey':
    ensure   => present,
    provider => gem,
    require  => Package['libxml2-dev'],
  }

  file { '/usr/local/bin/govuk_mirrorer':
    ensure  => present,
    mode    => '0755',
    source  => 'puppet:///modules/mirror/govuk_mirrorer',
    require => Package['spidey'],
  }

  file { '/var/lib/govuk_mirror':
    ensure => directory,
  }

  file { '/etc/init/govuk_update_mirror.conf':
    content => '
task
exec /usr/local/bin/govuk_update_mirror
',
    require => File['/usr/local/bin/govuk_update_mirror'],
  }

  cron { 'update-latest-to-mirror':
    ensure  => present,
    user    => 'root',
    hour    => '0',
    minute  => '0',
    command => 'start govuk_update_mirror',
    require => File['/etc/init/govuk_update_mirror.conf'],
  }

}
