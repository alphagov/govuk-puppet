class govuk::apps::redirector {
  file { ['/var/apps/redirector', '/var/apps/redirector/configs']:
    ensure  => directory,
    owner   => 'deploy',
    group   => 'deploy',
    require => User['deploy'],
  }
  nginx::config::site { 'redirector_include_all':
    content => "include /var/apps/redirector/configs/*.conf;\n",
    require => File['/var/apps/redirector/configs'],
  }
}
