class mirror {

  include lockrun

  #create cron lock file writable by user
  file { '/var/run/govuk_update_and_upload_mirror.lock':
    ensure => present,
    mode   => '0500',
  }

  # directory that we put the mirrored content into locally
  file { '/var/lib/govuk_mirror':
    ensure => directory,
  }

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

  file { '/usr/local/bin/govuk_upload_mirror':
    ensure => present,
    mode   => '0755',
    source => 'puppet:///modules/mirror/govuk_upload_mirror',
}

  file { '/usr/local/bin/govuk_update_and_upload_mirror':
    ensure  => present,
    mode    => '0755',
    source  => 'puppet:///modules/mirror/govuk_update_and_upload_mirror',
    require => [File['/usr/local/bin/govuk_upload_mirror'],
                File['/usr/local/bin/govuk_update_mirror'],
                File['/var/lib/govuk_mirror']],
}

  cron { 'update-latest-to-mirror':
    ensure  => present,
    user    => 'root',
    hour    => '0',
    minute  => '0',
    command => '/usr/local/bin/lockrun -L /var/run/govuk_update_and_upload_mirror.lock -- /usr/local/bin/govuk_update_and_upload_mirror',
    require => File['/usr/local/bin/govuk_update_and_upload_mirror'],
  }

}
