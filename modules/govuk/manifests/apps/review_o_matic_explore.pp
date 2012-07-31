class govuk::apps::review_o_matic_explore( $port = 3023 ) {
  if $::govuk_platform == 'development' {
    $upstream_domain = 'dev.gov.uk'
  } else {
    $upstream_domain = "${::govuk_platform}.alphagov.co.uk"
  }

  govuk::app { 'review-o-matic-explore':
    app_type        => 'procfile',
    port            => $port,
    environ_content => template('govuk/etc/envmgr/review-o-matic-explore.conf.erb'),
    vhost           => 'explore-reviewomatic',
    vhost_ssl_only  => false,
    require         => Class['nodejs'];
  }
}
