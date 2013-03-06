class govuk::apps::transaction_wrappers(
  $port = 3041,
  $vhost_protected
) {
  govuk::app { 'transaction-wrappers':
    app_type          => 'rack',
    port              => $port,
    vhost_protected   => $vhost_protected,
    health_check_path => '/pay-certificates-marriage',
  }
}
