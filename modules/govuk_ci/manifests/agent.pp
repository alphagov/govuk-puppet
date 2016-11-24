# == Class: govuk_ci::agent
#
# Class to manage continuous deployment agents
#
class govuk_ci::agent {

  include ::govuk_ci::agent::redis
  include ::govuk_ci::agent::rabbitmq
  include ::govuk_ci::agent::elasticsearch
  include ::govuk_ci::agent::mongodb
  include ::govuk_ci::agent::postgresql
  include ::govuk_ci::agent::mysql
  include ::govuk_ci::agent::swarm
  include ::govuk_java::oracle8

  ufw::allow { 'allow-jenkins-slave-swarm-to-listen-on-ephemeral-ports':
    port  => '32768:65535',
    proto => 'udp',
    ip    => 'any',
  }

  # Override sudoers.d resource (managed by sudo module) to enable Jenkins user to run sudo tests
  File<|title == '/etc/sudoers.d/'|> {
    mode => '0555',
  }

}
