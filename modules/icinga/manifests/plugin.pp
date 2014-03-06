# == Define: icinga:plugin
#
# Define a nagios plugin
#
# == Paramters:
#
# [*ensure*]
#   Can be used to remove an existing plugin.
#   Default: file
#
# [*content*]
#   The `content` of the plugin file.
#   See: http://docs.puppetlabs.com/references/latest/type.html#file
#
# [*source*]
#   The `source` of the plugin file.
#   See: http://docs.puppetlabs.com/references/latest/type.html#file
#
define icinga::plugin (
  $ensure = 'file',
  $content = undef,
  $source = undef
) {

  file { "/usr/lib/nagios/plugins/${title}":
    ensure  => $ensure,
    mode    => '0755',
    content => $content,
    source  => $source,
    require => Class['icinga::client::package'],
    notify  => Class['icinga::client::service'],
  }

}
