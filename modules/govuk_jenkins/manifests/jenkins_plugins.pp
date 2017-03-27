# == Class: govuk_jenkins::jenkins_plugins
#
# Uses a shell script to install plugins and their dependencies idempontently
#
# === Parameters:
#
# [*install_plugins*]
#   The name of the shell script that installs plugins
#
# [*jenkins_api_password*]
#   The credentials for the $jenkins_api_user
#
# [*jenkins_api_user*]
#   A Jenkins user that exists only to install plugins (must be an admin)
#
# [*jenkins_source_file*]
#   The file that contains credentials for $jenkins_api_user
#
# [*plugins_hash*]
#   Hiera hash of plugins to install
#
# [*plugins_list*]
#   The path to the file containing a bash array of Jenkins plugins to install
#
# [*user*]
#   The Jenkins user as defined in the Jenkins class
#
# == Variables:
#
# [*plugins*]
#   Array of plugins and their versions as the Jenkins api expects them
#
class govuk_jenkins::jenkins_plugins (
  $install_plugins      = '/usr/local/bin/install_plugins',
  $jenkins_api_password = undef,
  $jenkins_api_user     = 'mrplugin', # Referenced in govuk-puppet/hieradata/integration.yaml
  $jenkins_source_file  = '/etc/jenkinspasswd',
  $plugins_hash         = undef,
  $plugins_list         = '/var/lib/jenkins/plugins_list',
  $user                 = 'jenkins',
){

  validate_hash($plugins_hash)
  $plugins = join(join_keys_to_values($plugins_hash, '@'), ' ')

  file { $jenkins_source_file:
    ensure  => file,
    owner   => $user,
    mode    => '0640',
    content => template('govuk_jenkins/jenkinspasswd.erb'),
  }

  file { $plugins_list:
    ensure  => file,
    owner   => $user,
    group   => $user,
    content => template('govuk_jenkins/plugins_list.erb'),
    mode    => '0755',
  }

  file { $install_plugins:
    ensure  => file,
    content => "Puppet:///files/${install_plugins}",
    mode    => '0755',
    require => File[$plugins_list],
  }

  exec { $install_plugins:
    command   => $install_plugins,
    subscribe => File['plugin_list'],
    require   => File[$install_plugins],
  }

}
