# == Class: licensify::apps::certs
#
# Creates the appropriate certificates for licensify apps to work properly.
#
#
# === Parameters
#
# [*java_cacerts*]
#   CA certificates for JAVA
#   Type: base64
#   Default: undef
#
# [*licensing_cacerts*]
#   CA certificates for Licensify Apps
#   Type: base64
#   Default: undef
#
# [*services_to_notify*]
#   list of services to notify when the certs file are modified
#   Type: array of string name of services
#   Default: undef
#
class licensify::apps::certs(
  $java_cacerts = undef,
  $licensing_cacerts = undef,
  $services_to_notify = [],
){
    file { '/etc/licensing/cacerts_java8':
      ensure  => file,
      content => base64('decode',$java_cacerts),
      mode    => '0644',
      owner   => 'deploy',
      group   => 'deploy',
      notify  => Service[$services_to_notify],
    }

    file { '/etc/licensing/cacerts_licensing':
      ensure  => file,
      content => base64('decode',$licensing_cacerts),
      mode    => '0644',
      owner   => 'deploy',
      group   => 'deploy',
      notify  => Service[$services_to_notify],
    }
}
