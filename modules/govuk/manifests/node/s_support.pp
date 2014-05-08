class govuk::node::s_support inherits govuk::node::s_base {

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

  include govuk_java::openjdk6::jre
  include govuk_java::openjdk6::jdk

  class { 'govuk_java::set_defaults':
    jdk => 'openjdk6',
    jre => 'openjdk6',
  }

  class { 'govuk_elasticsearch':
    version            => '0.19.8',
    cluster_name       => "govuk-${::govuk_platform}",
    heap_size          => '2g',
    number_of_replicas => '0',
    require            => Class['govuk_java::set_defaults'],
  }

}
