class datainsight::recorders::everything {

  datainsight::recorder { 'everything': port => '3105' }

  file { [ '/var/tmp/datainsight-everything-recorder.json' ]:
    ensure  => present,
    owner   => 'deploy',
    group   => 'deploy',
  }

  file { [ '/var/data/datainsight/everything' ]:
    ensure  => directory,
    owner   => 'deploy',
    group   => 'deploy',
  }

}
