# == Class: govuk_env_sync::aws_auth
#
# Provide the AWS authentication information to envdir
#
class govuk_env_sync::aws_auth(
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
){

  $user = $govuk_env_sync::user
  $conf_dir = $govuk_env_sync::conf_dir
  $aws_region = $govuk_env_sync::aws_region
  $app_domain_internal = hiera('app_domain_internal')

  file { "${conf_dir}/env.d/AWS_REGION":
    content => $aws_region,
    owner   => $user,
    group   => $user,
    mode    => '0640',
  }

  file { "${conf_dir}/env.d/LOCAL_DOMAIN":
    content => $app_domain_internal,
    owner   => $user,
    group   => $user,
    mode    => '0770',
  }

}
