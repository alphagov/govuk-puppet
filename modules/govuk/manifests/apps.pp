class govuk::apps {
  @logrotate::conf { 'govuk_apps':
    matches => '/data/vhost/**/shared/log/*.log',
  }
}
