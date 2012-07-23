class govuk::apps::review_o_matic_explore( $port = 3023 ) {
  govuk::app { 'review-o-matic-explore':
    port           => $port,
    config         => true,
    vhost          => 'explore-reviewomatic',
    vhost_ssl_only => false,
    require        => Class['nodejs'];
  }
}
