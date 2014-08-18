class govuk::apps::sidekiq_monitoring () {
  $app_name = 'sidekiq-monitoring'
  $app_domain = hiera('app_domain')
  $full_domain = "${app_name}.${app_domain}"

  govuk::app { $app_name:
    app_type           => 'bare',
    command            => 'bundle exec foreman start',
    enable_nginx_vhost => false,
  }

  nginx::config::site { $full_domain:
    content => template('govuk/sidekiq_monitoring_nginx_config.conf.erb'),
  }
}
