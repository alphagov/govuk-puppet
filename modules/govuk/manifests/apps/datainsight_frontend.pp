class govuk::apps::datainsight_frontend(
  $port = 3027,
  $vhost_protected
) {
  govuk::app { 'datainsight-frontend':
    app_type              => 'rack',
    port                  => $port,
    vhost_protected       => $vhost_protected,
    health_check_path     => '/performance',
    asset_pipeline        => true,
    asset_pipeline_prefix => 'datainsight-frontend',
  }

  file { ['/mnt/datainsight', '/mnt/datainsight/graphs']:
    ensure => directory,
    owner  => 'deploy'
  }

  file { '/var/tmp/graphs':
    ensure => link,
    target => '/mnt/datainsight/graphs',
  }

  include phantomjs
  include fonts
}
