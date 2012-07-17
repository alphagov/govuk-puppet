class govuk::apps::review_o_matic_explore {
  include nodejs

  if $::govuk_platform != 'development' {
    file { '/var/apps/review-o-matic-explore':
      ensure => directory,
      owner  => 'deploy',
      group  => 'deploy';
    }
  }

  file { '/etc/init/review-o-matic-explore.conf':
    content => template('govuk/apps/review_o_matic_explore/upstart.conf.erb')
  }

  service { 'review-o-matic-explore':
    ensure    => running,
    provider  => upstart,
    require   => File['/etc/init/review-o-matic-explore.conf'],
    subscribe => File['/etc/init/review-o-matic-explore.conf']
  }

}
