# == Class: govuk_ci::agenttest
#
# Class to manage continuous deployment agents
#
# === Parameters:
#
# [*version*]
#   version to print out
#
class govuk_ci::agenttest(
  $version = undef,
) {

  notify {"hiera value of postgresql in ci agent $version":}
}
