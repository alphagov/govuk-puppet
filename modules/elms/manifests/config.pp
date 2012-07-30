class elms::config {
  file { '/etc/gds-ertp-config.properties':
    ensure => present,
    source => [
      "puppet:///modules/elms/gds-ertp-config.properties.${::govuk_platform}",
      'puppet:///modules/elms/gds-ertp-config.properties'
    ]
  }

  file { '/etc/nginx/htpasswd.elms':
    source => 'puppet:///modules/elms/etc/nginx/htpasswd.elms',
  }

  nginx::config::ssl { 'www.preview.alphagov.co.uk': }
  nginx::config::site { 'elms':
    source  => 'puppet:///modules/elms/etc/nginx/elms',
    require => File['/etc/nginx/htpasswd.elms'],
  }

  file {'/etc/init/elms.conf':
    ensure => present,
    source => ['puppet:///modules/elms/etc/init/elms.conf']
  }

  file {'/etc/init/elms-admin.conf':
    ensure => present,
    source => ['puppet:///modules/elms/etc/init/elms-admin.conf']
  }

  file {'/etc/init/licensify-feed.conf':
    ensure => present,
    source => ['puppet:///modules/elms/etc/init/licensify-feed.conf']
  }

  file {'/etc/init/fake-adobe-lifecycle.conf':
    ensure => present,
    source => ['puppet:///modules/elms/etc/init/fake-adobe-lifecycle.conf']
  }
}
