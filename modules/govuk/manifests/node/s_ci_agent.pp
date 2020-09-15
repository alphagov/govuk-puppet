# == Class: govuk::node::s_ci_agent
#
# Class to manage the continuous deployment job executors
#
class govuk::node::s_ci_agent inherits govuk::node::s_base {

  notify {"hiera value of postgresql in ci agent ${postgresql::globals::version},  aws_hostname ${::aws_hostname}, ec2_aws_hostname ${::ec2_aws_hostname}":}

  include ::govuk_ci::agent
}
