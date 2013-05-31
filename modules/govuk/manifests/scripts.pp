class govuk::scripts {

  # govuk_node_list is a simple script that lists nodes of specified classes
  # using puppetdb
  file { '/usr/local/bin/govuk_node_list':
    ensure  => present,
    source  => 'puppet:///modules/govuk/bin/govuk_node_list',
    mode    => '0755',
  }

  # govuk_node_clean removes stale or decommissioned nodes from puppetdb and the
  # puppetmaster
  file { '/usr/local/bin/govuk_node_clean':
    ensure  => present,
    source  => 'puppet:///modules/govuk/bin/govuk_node_clean',
    mode    => '0755',
  }

  # govuk_unused_kernels identifies unused kernel packages than can be
  # uninstalled
  file { '/usr/local/bin/govuk_unused_kernels':
    ensure  => present,
    source  => 'puppet:///modules/govuk/bin/govuk_unused_kernels',
    mode    => '0755',
  }

}
