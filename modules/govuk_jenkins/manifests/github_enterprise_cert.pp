# == Class: govuk_jenkins::github_enterprise_cert
#
# Add GDS GitHub Enterprise certificate to Jenkins machines. The certificate
# is added to the Java keystore and the OS certificate store. The Jenkins
# process needs to be restarted to reload changes on the Java keystore, that
# dependency is not managed in this class.
# 
#
# === Parameters:
#
# [*certificate*]
#   PEM certificate for GitHub Enterprise.
#
# [*certificate_path*]
#   Path to GitHub Enterprise certificate for java_ks
#
# [*github_enterprise_hostname*]
#   The hostname of Github Enterprise
#
class govuk_jenkins::github_enterprise_cert (
  $certificate,
  $certificate_path,
  $github_enterprise_hostname,
) {

  # In addition to the keystore below, in the Deploy Jenkins instances the certificate path is also
  # referenced by the `GITHUB_GDS_CA_BUNDLE` environment variable in Jenkins, which is used by
  # ghtools during GitHub.com -> GitHub Enterprise repo backups.
  file { [ $certificate_path, '/usr/local/share/ca-certificates/github_enterprise.crt']:
    ensure  => file,
    content => $certificate,
  }

  # Add the certificate to the default Java keystore 
  java_ks { "${github_enterprise_hostname}:cacerts":
    ensure       => latest,
    certificate  => $certificate_path,
    target       => '/usr/lib/jvm/java-7-openjdk-amd64/jre/lib/security/cacerts',
    password     => 'changeit',
    trustcacerts => true,
    require      => Class['govuk_java::openjdk7::jre'],
  }

  # Rebuild /etc/ssl/certs when /usr/local/share/ca-certificates/filename is updated
  exec { 'update-ca-certificates':
    path        => ['/usr/bin', '/usr/sbin', '/bin'],
    subscribe   => File['/usr/local/share/ca-certificates/github_enterprise.crt'],
    refreshonly => true,
  }

}
