class java::set_defaults (
  $jdk = 'sun6',
  $jre = 'openjdk6'
) {

  $jdk_real = $jdk ? {
    'openjdk6' => 'java-1.6.0-openjdk',
    'oracle7'  => 'java-7-oracle',
    'sun6'     => 'java-6-sun',
    default    => 'UNKNOWN'
  }

  $jre_real = $jre ? {
    'openjdk6' => 'java-1.6.0-openjdk',
    'oracle7'  => 'java-7-oracle',
    'sun6'     => 'java-6-sun',
    default    => 'UNKNOWN'
  }

  if $jdk_real == 'UNKNOWN' {
    fail "Unknown Java JDK name supplied to java::set_defaults: '${jdk}'"
  }

  if $jre_real == 'UNKNOWN' {
    fail "Unknown Java JRE name supplied to java::set_defaults: '${jre}'"
  }

  $path_javac = $jdk ? {
    'openjdk6' => '/usr/lib/jvm/java-6-openjdk/bin/javac',
    'oracle7'  => '/usr/lib/jvm/java-7-oracle/bin/javac',
    'sun6'     => '/usr/lib/jvm/java-6-sun/bin/javac'
  }

  $path_java = $jre ? {
    'openjdk6' => '/usr/lib/jvm/java-6-openjdk/jre/bin/java',
    'oracle7'  => '/usr/lib/jvm/java-7-oracle/jre/bin/java',
    'sun6'     => '/usr/lib/jvm/java-6-sun/jre/bin/java',
  }

  # NB: update-java-alternatives may return non-zero exit status for non-
  #     fatal errors, hence the use of '|| :'

  exec { 'java-set-default-jdk':
    command => "update-java-alternatives --set '${jdk_real}' || :",
    unless  => "readlink /etc/alternatives/javac | grep -Fq '${path_javac}'",
    require => Class["java::${jdk}::jdk"],
  }

  exec { 'java-set-default-jre':
    command => "update-java-alternatives --jre --set '${jre_real}' || :",
    unless  => "readlink /etc/alternatives/java | grep -Fq '${path_java}'",
    require => [Class["java::${jre}::jre"], Exec['java-set-default-jdk']],
  }

}
