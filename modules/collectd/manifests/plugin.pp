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
define collectd::plugin(
  $source = undef,
  $content = undef
) {
  if !$source and !$content {
    $content_real = "LoadPlugin ${title}\n"
  } else {
    $content_real = $content
  }

  @file { "/etc/collectd/conf.d/${title}.conf":
    ensure  => present,
    content => $content_real,
    source  => $source,
    tag     => 'collectd::plugin',
    notify  => Class['collectd::service'],
    require => Class['collectd::config'],
  }
}
