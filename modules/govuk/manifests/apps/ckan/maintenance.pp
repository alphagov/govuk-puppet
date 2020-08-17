# == Class: govuk::apps::ckan::maintenance
#
# Ensure the machine has a static copy of the scheduled maintenance
# html page.
#
class govuk::apps::ckan::maintenance {
  file { '/usr/share/nginx/www':
    ensure  => directory,
    mode    => '0755',
    owner   => 'deploy',
    group   => 'deploy',
    require => Class['nginx::package'],
  }

  router::errorpage { 'scheduled_maintenance':
    require => File['/usr/share/nginx/www'],
  }
}
