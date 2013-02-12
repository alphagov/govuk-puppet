# == Type: elasticsearch::plugin
#
# Install an elasticsearch plugin on the current host.
#
# === Parameters
#
# [*plugin_name*]
#   The name of the plugin. This *must* match the name of the directory
#   created in $ES_HOME/plugins by elasticsearch's plugin installer, e.g.
#   "head", or "redis-river"
#
# [*install_from*]
#   The argument to pass to the elasticsearch plugin installer, e.g.
#   "mobz/elasticsearch-head", or "leeadkins/elasticsearch-redis-river/0.0.4"
#
define elasticsearch::plugin (
  $install_from,
  $plugin_name = $title
) {

  $plugin_dir = "/usr/share/elasticsearch/plugins/${plugin_name}"

  # Explicitly manage directory to override resource purging of
  # /usr/share/elasticsearch/plugins
  file { $plugin_dir:
    ensure => 'directory',
  }

  exec { "/usr/share/elasticsearch/bin/plugin -install '${install_from}'":
    unless => "test -n \"$(ls '${plugin_dir}')\"",
    notify => Class['elasticsearch::service'],
  }

}
