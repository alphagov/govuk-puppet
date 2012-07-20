class govuk::apps::review_o_matic_explore( $port = 3023 ) {
  include nodejs

  govuk::app { 'review-o-matic-explore':
    config  => true,
    require => Class['nodejs'],
    port    => $port;
  }
}
