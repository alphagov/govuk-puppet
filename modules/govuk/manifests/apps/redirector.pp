class govuk::apps::redirector {
  file { ['/var/apps/redirector', '/var/apps/redirector/configs']:
    ensure  => directory,
    owner   => 'deploy',
    group   => 'deploy',
    require => User['deploy'],
  }
  file { '/etc/nginx/sites-enabled/redirector_include_all':
    ensure  => present,
    content => "include /var/apps/redirector/configs/*.conf;\n",
    notify  => Class['nginx::service'],
    require => File['/var/apps/redirector/configs'],
  }
}
