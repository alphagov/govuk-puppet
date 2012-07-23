class govuk::apps::review_o_matic_explore( $port = 3023 ) {
  govuk::app { 'review-o-matic-explore':
    config  => true,
    vhost   => 'explore-reviewomatic',
    require => Class['nodejs'],
    port    => $port;
  }
}
