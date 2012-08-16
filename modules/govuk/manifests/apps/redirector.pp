class govuk::apps::redirector {
  file { '/etc/nginx/sites-enabled/redirections':
    ensure => link,
    target => '/var/apps/redirector/redirections',
    notify => Class['nginx::service'],
  }
  file { '/var/apps/redirector':
    ensure  => directory,
    owner   => 'deploy',
    group   => 'deploy',
    require => User['deploy'],
  }
}
