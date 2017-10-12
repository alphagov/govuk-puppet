# == Class: Govuk_containers::Cluster::Global
#
# Create global environment variables in a file
#
class govuk_containers::cluster::global (
  $envvars = {},
  $ensure = 'present',
) {

  govuk_containers::envvar { "global":
    envvars   => $envvars,
    directory => '/etc/govuk/env.d',
    ensure    => $ensure,
  }
}
