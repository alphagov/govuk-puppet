# == Define: collectd::plugin
#
# Setup a collectd plugin virtual file resource with the appropriate tag,
# notify and require params. If no content or source params are provided it
# will default to a simple config file of:
#
#     LoadPlugin ${title}
#
# === Parameters
#
# [*source*]
#   Puppet file URI.
#
# [*content*]
#   Rendered template string.
#
# [*prefix*]
#   String to prepend the config file name with. This can be set to '00-' to
#   ensure that a plugin is loaded before any others, since collectd using
#   globbing.
#
define collectd::plugin(
  $source = undef,
  $content = undef,
  $prefix = ''
) {
  if !$source and !$content {
    $content_real = "LoadPlugin ${title}\n"
  } else {
    $content_real = $content
  }

  @file { "/etc/collectd/conf.d/${prefix}${title}.conf":
    ensure  => present,
    content => $content_real,
    source  => $source,
    tag     => 'collectd::plugin',
    notify  => Class['collectd::service'],
    require => Class['collectd::config'],
  }
}
