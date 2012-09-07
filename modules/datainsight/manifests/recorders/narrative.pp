class datainsight::recorders::narrative {

  datainsight::recorder { 'narrative': port => '8081' }

  file { [ '/var/lib/datainsight-narrative-recorder.json' ]:
    ensure  => present,
    owner   => 'deploy',
    group   => 'deploy',
  }

}
