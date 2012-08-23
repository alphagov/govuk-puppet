class java(
  $distribution = 'jdk',
  $version      = 'installed'
) {

  case $::lsbdistcodename {
    'precise': {
      $owner = 'webupd8team'
      $repo  = 'java'
      $distribution_debian = $distribution ? {
          jdk     => 'oracle-java7-installer',
          jre     => 'oracle-java7-installer',
      }
    }
    default: {
      $owner = 'sun-java-community-team'
      $repo  = 'sun-java6'
      $distribution_debian = $distribution ? {
          jdk     => 'sun-java6-jdk',
          jre     => 'sun-java6-jre',
      }
    }
  }

  apt::repository { 'sun-java-community-team':
    type  => 'ppa',
    owner => $owner,
    repo  => $repo,
  }

  file { '/var/local/sun-java6.preseed':
    content => template("${module_name}/sun-java6.preseed")
  }

  package { 'java':
    ensure       => $version,
    name         => $distribution_debian,
    responsefile => '/var/local/sun-java6.preseed',
    require      => [
      Apt::Repository['sun-java-community-team'],
      File['/var/local/sun-java6.preseed']
    ],
  }
}
