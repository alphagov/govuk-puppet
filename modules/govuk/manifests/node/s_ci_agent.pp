# == Class: govuk::node::s_ci_agent
#
# Class to manage the continuous deployment job executors
#
class govuk::node::s_ci_agent inherits govuk::node::s_base {

  include ::govuk_ci::agent

  notify {"hiera value of postgresql in ci agent ${::postgresql::globals::version}":}

}
