class govuk::apps::redirector {
  file { '/etc/nginx/sites-enabled/businesslink':
    ensure => link,
    target => '/var/apps/redirector/businesslink.conf',
    notify => Class['nginx::service'],
  }
  file { '/etc/nginx/sites-enabled/communities':
    ensure => link,
    target => '/var/apps/redirector/communities.conf',
    notify => Class['nginx::service'],
  }
  file { '/etc/nginx/sites-enabled/directgov':
    ensure => link,
    target => '/var/apps/redirector/directgov.conf',
    notify => Class['nginx::service'],
  }
  file { '/etc/nginx/sites-enabled/ago':
    ensure => link,
    target => '/var/apps/redirector/ago.conf',
    notify => Class['nginx::service'],
  }
  file { '/etc/nginx/sites-enabled/mod':
    ensure => link,
    target => '/var/apps/redirector/mod.conf',
    notify => Class['nginx::service'],
  }
  file { '/etc/nginx/sites-enabled/decc':
    ensure => link,
    target => '/var/apps/redirector/decc.conf',
    notify => Class['nginx::service'],
  }
  file { '/etc/nginx/sites-enabled/og_decc':
    ensure => link,
    target => '/var/apps/redirector/og_decc.conf',
    notify => Class['nginx::service'],
  }
  file { '/var/apps/redirector':
    ensure  => directory,
    owner   => 'deploy',
    group   => 'deploy',
    require => User['deploy'],
  }
}
