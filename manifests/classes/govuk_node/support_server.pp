class govuk_node::support_server inherits govuk_node::base {
  include solr
  include apollo
  include apt_cacher::server
  include apt_cacher::client

  if $::govuk_platform == 'production' {
    # Since these backups are only for the purposes of restoring production
    # data to preview and development, it makes no sense to configure them on
    # any environment but production.
    include mysql::backup
  }

  if $::govuk_platform == 'preview' {
    $mysql_host     = 'rds.cluster'
    $mysql_user     = 'backup'
    $mysql_password = extlookup('mysql_preview_backup', '')

    file { '/home/deploy/.my.cnf':
      ensure  => file,
      owner   => 'deploy',
      group   => 'deploy',
      mode    => '0600',
      require => User['deploy'],
      content => "[client]
host=${mysql_host}
user=${mysql_user}
password=${mysql_password}
"
    }
  }

  include elasticsearch
  elasticsearch::node { "govuk-${::govuk_platform}": }
}
