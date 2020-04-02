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
# [*apt_mirror_gpg_key_fingerprint*]
#   The fingerprint for the apt mirror to add to enable fetching specific
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
  $apt_mirror_gpg_key_fingerprint,
  $version = $govuk_jenkins::version,
  $config  = {},
  $plugins = {},
  ) {
  validate_hash($config, $plugins)

  include govuk_java::openjdk8::jdk
  include govuk_java::openjdk8::jre

  apt::source { 'govuk-jenkins':
    location     => "http://${apt_mirror_hostname}/govuk-jenkins",
    release      => 'stable',
    architecture => $::architecture,
    key          => $apt_mirror_gpg_key_fingerprint,
  }

  class { 'govuk_java::set_defaults':
    jdk     => 'openjdk8',
    jre     => 'openjdk8',
    require => [
                  Class['govuk_java::openjdk8::jdk'],
                  Class['govuk_java::openjdk8::jre'],
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

  class { 'govuk_jenkins::pipeline':
    require => Class['jenkins'],
  }

}
