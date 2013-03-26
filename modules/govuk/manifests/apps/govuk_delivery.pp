class govuk::apps::govuk_delivery( $port = 3042 ) {
  include pip
  include virtualenv

  govuk::app { 'govuk-delivery':
    app_type        => 'procfile',
    port            => $port,
    vhost_ssl_only  => true,
  }
}
