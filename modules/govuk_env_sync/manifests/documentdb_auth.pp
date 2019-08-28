# == Class: govuk_env_sync::licensify_documentdb_auth
#
# Provide the AWS DocumentDB authentication
# information to envdir
#
# === Parameters:
#
# [*host*]
#   The hostname and port pair to be used to contact Licensify DocumentDB
#   Format: address:port
#   Type: string
#   Default= undef
#
# [*password*]
#   The password to access the Licensify DocumentDB
#   Type: string of 8-100 characters
#   Default= undef
#
define govuk_env_sync::documentdb_auth(
  $host = undef,
  $password = undef,
){

  $user = $govuk_env_sync::user
  $conf_dir = $govuk_env_sync::conf_dir
  $title_normalized = regsubst(upcase($title), '-', '_', 'G')

  # only put the host file if $password is set
  if $host {
    file { "${conf_dir}/env.d/${title_normalized}_DOCUMENTDB_HOST":
    content => $host,
    owner   => $user,
    group   => $user,
    mode    => '0640',
    }
  } else {
    file { "${conf_dir}/env.d/${title_normalized}_DOCUMENTDB_HOST":
      ensure => 'absent',
    }
  }

  # only put the password file if $password is set
  if $password {
    file { "${conf_dir}/env.d/${title_normalized}_DOCUMENTDB_PASSWD":
      content => $password,
      owner   => $user,
      group   => $user,
      mode    => '0640',
    }
  } else {
    file { "${conf_dir}/env.d/${title_normalized}_DOCUMENTDB_PASSWD":
      ensure => 'absent',
    }
  }
}
