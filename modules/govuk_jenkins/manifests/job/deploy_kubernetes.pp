# == Class: govuk_jenkins::job::deploy_kubernetes
#
# === Parameters
#
# [*gce_project_id*]
#   The name of the Google Compute Engine project that contains the resources you want to interact with.
#
# [*gce_credential_id*]
#   Jenkins credential ID that stores the Gcloud account.
#
# [*private_gpg_key*]
#   GPG private key for secrets decryption
#
# [*private_gpg_key_fingerprint*]
#   GPG private key fingerprint for secrets decryption
#
class govuk_jenkins::job::deploy_kubernetes (
  $gce_project_id = undef,
  $gce_credential_id = undef,
  $private_gpg_key = undef,
  $private_gpg_key_fingerprint = undef,
) {

  validate_re($private_gpg_key_fingerprint, '^[[:alnum:]]{40}$', 'Must supply full GPG fingerprint')

  contain 'govuk_jenkins::packages::gcloud'

  file { '/etc/jenkins_jobs/jobs/deploy_kubernetes.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_kubernetes.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  file { '/var/lib/jenkins/.gnupg':
    ensure => directory,
    mode   => '0700',
    owner  => 'jenkins',
    group  => 'jenkins',
  }

  file { '/var/lib/jenkins/.gnupg/gpg.conf':
    ensure  => present,
    content => 'trust-model always',
    mode    => '0600',
    owner   => 'jenkins',
    group   => 'jenkins',
  }

  file { "/var/lib/jenkins/.gnupg/${private_gpg_key_fingerprint}_secret_key.asc":
    ensure  => present,
    mode    => '0600',
    content => $private_gpg_key,
    owner   => 'jenkins',
    group   => 'jenkins',
  }

  # import key
  exec { "import_gpg_secret_key_${::hostname}":
    command     => "gpg --batch --delete-secret-and-public-key ${private_gpg_key_fingerprint}; gpg --allow-secret-key-import --import /var/lib/jenkins/.gnupg/${private_gpg_key_fingerprint}_secret_key.asc",
    user        => 'jenkins',
    group       => 'jenkins',
    subscribe   => File["/var/lib/jenkins/.gnupg/${private_gpg_key_fingerprint}_secret_key.asc"],
    refreshonly => true,
  }

}
