class govuk::apps::support($port = 3031) {

  file { '/etc/support.htpasswd':
    ensure => present,
    source => 'puppet:///modules/govuk/support.htpasswd'
    }
  govuk::app { 'support':
    app_type                => 'rack',
    vhost_aliases           => ['internalsupport'],
    port                    => $port,
    health_check_path       => '/';
  }
}
