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
  file { '/var/apps/redirector':
    ensure  => directory,
    owner   => 'deploy',
    group   => 'deploy',
    require => User['deploy'],
  }
}
