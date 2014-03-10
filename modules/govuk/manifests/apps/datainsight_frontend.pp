class govuk::apps::datainsight_frontend(
  $port = 3027,
  $ensure = 'present',
  $vhost_protected
) {
  govuk::app { 'datainsight-frontend':
    ensure                => $ensure,
    app_type              => 'rack',
    port                  => $port,
    vhost_protected       => $vhost_protected,
    health_check_path     => '/performance',
    asset_pipeline        => true,
    asset_pipeline_prefix => 'datainsight-frontend',
  }

  $ensure_directory = $ensure ? {
    'present' => 'directory',
    'absent'  => 'absent',
  }

  $ensure_link = $ensure ? {
    'present' => 'link',
    'absent'  => 'absent',
  }

  file { ['/mnt/datainsight', '/mnt/datainsight/graphs']:
    ensure => $ensure_directory,
    owner  => 'deploy',
    group  => 'deploy',
    force  => true,
  }

  file { '/var/tmp/graphs':
    ensure => $ensure_link,
    target => '/mnt/datainsight/graphs',
  }

  include phantomjs
  include fonts
}
