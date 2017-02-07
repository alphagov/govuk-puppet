#
class filebeat::config {

  $filebeat_config = delete_undef_values({
    'beat_name' => $::fqdn,
    'output'    => $filebeat::outputs,
  })

  file {'/etc/filebeat/filebeat.yml':
    ensure  => file,
    content => template('filebeat/filebeat.yml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['filebeat'],
    require => File['/etc/filebeat/conf.d'],
  }

  file {'/etc/filebeat/conf.d':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => $filebeat::purge_conf_dir,
    purge   => $filebeat::purge_conf_dir,
  }

}
