# = govuk_java::set_defaults
#
# Sets the debian `alternatives` for the `java` and similar symlinks to
# point to the requested version of the JDK or JRE
#
# [*jdk*]
# The version of the JDK to use. Default: 'openjdk6'
#
# [*jre*]
# The version of the JRE to use. Default: 'openjdk6'
#
class govuk_java::set_defaults (
  $jdk = 'openjdk6',
  $jre = 'openjdk6'
) {

  $jdk_real = $jdk ? {
    'openjdk6' => 'java-1.6.0-openjdk',
    'openjdk7' => 'java-1.7.0-openjdk',
    'openjdk8' => 'java-1.8.0-openjdk',
    'oracle7'  => 'java-7-oracle',
    default    => 'UNKNOWN'
  }

  $jre_real = $jre ? {
    'openjdk6' => 'java-1.6.0-openjdk',
    'openjdk7' => 'java-1.7.0-openjdk',
    'openjdk8' => 'java-1.8.0-openjdk',
    'oracle7'  => 'java-7-oracle',
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
    'openjdk7' => '/usr/lib/jvm/java-7-openjdk-amd64/bin/javac',
    'openjdk8' => '/usr/lib/jvm/java-8-openjdk-amd64/bin/javac',
    'oracle7'  => '/usr/lib/jvm/java-7-oracle/bin/javac',
  }

  $path_java = $jre ? {
    'openjdk6' => '/usr/lib/jvm/java-6-openjdk/jre/bin/java',
    'openjdk7' => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
    'openjdk8' => '/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java',
    'oracle7'  => '/usr/lib/jvm/java-7-oracle/jre/bin/java',
  }

  # NB: update-java-alternatives may return non-zero exit status for non-
  #     fatal errors, hence the use of '|| :'

  exec { 'java-set-default-jdk':
    command => "update-java-alternatives --set '${jdk_real}' || :",
    unless  => "readlink /etc/alternatives/javac | grep -Fq '${path_javac}'",
    require => Class["govuk_java::${jdk}::jdk"],
  }

  exec { 'java-set-default-jre':
    command => "update-java-alternatives --jre --set '${jre_real}' || :",
    unless  => "readlink /etc/alternatives/java | grep -Fq '${path_java}'",
    require => [Class["govuk_java::${jre}::jre"], Exec['java-set-default-jdk']],
  }

}
