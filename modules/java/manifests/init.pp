class java(
  $distribution = 'jdk',
  $version      = 'installed'
) {
  include apt

  $distribution_debian = $distribution ? {
    jdk => 'sun-java6-jdk',
    jre => 'sun-java6-jre',
  }

  apt::ppa_repository { "sun-java-community-team":
    publisher => "sun-java-community-team",
    repo => "sun-java6"
  }

  file { "/var/local/sun-java6.preseed":
    content => template("${module_name}/sun-java6.preseed"),
  }

  package { 'java':
    ensure       => $version,
    name         => $distribution_debian,
    responsefile => "/var/local/sun-java6.preseed",
    require      => [Exec["add_repo_sun-java-community-team"], File["/var/local/sun-java6.preseed"], Package['remove-openjdk']],
  }

  package { 'remove-openjdk':
    name => 'openjdk-6-jre-headless',
    ensure => 'absent'
  }
}
