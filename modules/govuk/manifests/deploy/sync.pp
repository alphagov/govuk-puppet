# == Class: govuk_sync_apps
#
# Installs a script which can be run on user data to trigger a jenkins job and
# trigger app deploys
#
# === Parameters
#
# [*jenkins_domain*]
#   Domain of the jenkins server containing the deploy job
#
# [*auth_token*]
#   Token required to trigger the job remotely
class govuk::deploy::sync (
  $jenkins_domain,
  $auth_token,
) {
  file { '/usr/local/bin/govuk_sync_apps':
    ensure  => 'present',
    content => template('govuk/usr/local/bin/govuk_sync_apps'),
    mode    => '0700',
  }
}
