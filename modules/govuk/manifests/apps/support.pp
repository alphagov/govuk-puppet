class govuk::apps::support($port = 3031) {

  file { '/etc/support.htpasswd':
    ensure => present,
    source => 'puppet:///modules/govuk/support.htpasswd'
    }
  govuk::app { 'support':
    app_type                => 'rack',
    vhost_aliases           => ['internalsupport'],
    port                    => $port,
    health_check_path       => '/',
    nginx_extra_app_config  => 'auth_basic "Enter your password";
    auth_basic_user_file  /etc/support.htpasswd;
    ';
  }
}
