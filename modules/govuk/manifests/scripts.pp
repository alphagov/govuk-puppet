class govuk::scripts {

  # govuk_node_list is a simple script that lists nodes of specified classes
  # using puppetdb
  file { '/usr/local/bin/govuk_node_list':
    ensure  => present,
    source  => 'puppet:///modules/govuk/bin/govuk_node_list',
    mode    => '0755',
  }

}
