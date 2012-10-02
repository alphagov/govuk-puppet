# This is the redirector app for redirecting Directgov and Business Link URLs
class govuk_node::redirector_server inherits govuk_node::base {
  include nginx
  include nginx::php
  include govuk::apps::redirector

  # We're going to be running the redirector integration tests *from* the
  # redirector server itself -- they take 5m to run this way, and over 40m if we
  # have to wait for the network overhead of running them from Jenkins. In order
  # to do this, Crypt::SSLeay needs to be installed.
  #
  # At some point in the future when we're confident of the redirector, this can
  # be removed.
  package { 'libcrypt-ssleay-perl':
    ensure => present,
  }
}
