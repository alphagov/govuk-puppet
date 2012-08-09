define elasticsearch::node::service (
  $ensure,
  $cluster_name = $title
) {

  $ensure_file = $ensure ? {
    'absent' => 'absent',
    default  => 'present'
  }

  $ensure_svc = $ensure ? {
    'absent' => 'stopped',
    default  => 'running',
  }

  file { "/etc/init/elasticsearch-${cluster_name}.conf":
    ensure  => $ensure_file,
    content => template('elasticsearch/upstart.conf.erb'),
  }

  service { "elasticsearch-${cluster_name}":
    ensure   => $ensure_svc,
    provider => upstart,
  }

  if $ensure == 'present' {
    File["/etc/init/elasticsearch-${cluster_name}.conf"] -> Service["elasticsearch-${cluster_name}"]
    File["/etc/init/elasticsearch-${cluster_name}.conf"] ~> Service["elasticsearch-${cluster_name}"]
  } else {
    Service["elasticsearch-${cluster_name}"] -> File["/etc/init/elasticsearch-${cluster_name}.conf"]
  }

}
