# == Class: Govuk_ci::Limits
#
# Set process and file limits for the Jenkins user
#
class govuk_ci::limits {
  limits::limits { 'jenkins_nofile':
    ensure     => present,
    user       => 'jenkins',
    limit_type => 'nofile',
    both       => 8192,
  }

  limits::limits { 'jenkins_nproc':
    ensure     => present,
    user       => 'jenkins',
    limit_type => 'nproc',
    both       => 30654,
  }
}
