class govuk::apps::review_o_matic_explore {
  include nodejs

  package { 'review-o-matic-explore':
    ensure => latest
  }

  file { '/etc/init/review-o-matic-explore.conf':
    content  => template('govuk/apps/review_o_matic_explore/upstart.conf.erb'),
    require =>  Package[review-o-matic-explore],
  }

  service { 'review-o-matic-explore':
    provider => upstart,
    require => [File['/etc/init/review-o-matic-explore.conf'],Package['review-o-matic-explore']],
    subscribe => [File['/etc/init/review-o-matic-explore.conf'],Package['review-o-matic-explore']]
  }

}
