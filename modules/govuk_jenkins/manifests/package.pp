# == Class: govuk_jenkins::package
#
# Install the Jenkins package and dependencies
#
# === Parameters:
#
# [*apt_mirror_hostname*]
#   The hostname for the apt mirror to add to enable fetching specific
#   packages
#
# [*version*]
#   Specify the version of Jenkins you wish to install
#
# [*config*]
#   A hash of configuration options
#
# [*plugins*]
#   A hash of plugins to enable
#
class govuk_jenkins::package (
  $apt_mirror_hostname,
  $version = '1.554.2',
  $config  = {},
  $plugins = {},
  ) {
  validate_hash($config, $plugins)

  include govuk_java::openjdk7::jdk
  include govuk_java::openjdk7::jre

  apt::source { 'govuk-jenkins':
    location     => "http://${apt_mirror_hostname}/govuk-jenkins",
    release      => 'stable',
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }

  class { 'govuk_java::set_defaults':
    jdk     => 'openjdk7',
    jre     => 'openjdk7',
    require => [
                  Class['govuk_java::openjdk7::jdk'],
                  Class['govuk_java::openjdk7::jre'],
                ],
    notify  => Class['jenkins::service'],
  }

  class { 'jenkins':
    version            => $version,
    repo               => false,
    install_java       => false,
    configure_firewall => false,
    config_hash        => $config,
    manage_user        => false,
    manage_group       => false,
    plugin_hash        => $plugins,
    require            => Class['govuk_java::set_defaults'],
  }

}
