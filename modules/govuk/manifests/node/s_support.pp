class govuk::node::s_support ( $mysql_preview_backup = '', ) inherits govuk::node::s_base {

  include govuk_java::openjdk6::jre
  include govuk_java::openjdk6::jdk

  class { 'govuk_java::set_defaults':
    jdk => 'openjdk6',
    jre => 'openjdk6',
  }

  class { 'govuk_elasticsearch':
    cluster_name       => 'govuk-production',
    heap_size          => '2g',
    number_of_replicas => '0',
    require            => Class['govuk_java::set_defaults'],
  }

}
