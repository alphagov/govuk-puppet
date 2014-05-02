# == Type: elasticsearch_old::plugin
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
#   If an HTTP[S] URL is provided then the install command will take the
#   form of `-install ${plugin_name} -url ${install_from}`. This is
#   necessary for plugins that aren't published on Maven (Central/Sonatype)
#   or as GitHub tags.
#
define elasticsearch_old::plugin (
  $install_from,
  $plugin_name = $title
) {

  $plugin_dir = "/usr/share/elasticsearch/plugins/${plugin_name}"

  $install_args = $install_from ? {
    /^(?i:https?:\/\/)/ => "'${plugin_name}' -url '${install_from}'",
    default             => "'${install_from}'",
  }

  # Explicitly manage directory to override resource purging of
  # /usr/share/elasticsearch/plugins
  file { $plugin_dir:
    ensure => 'directory',
  }

  exec { "elasticsearch install plugin ${plugin_name}":
    command => "/usr/share/elasticsearch/bin/plugin -install ${install_args}",
    unless  => "test -n \"$(ls '${plugin_dir}')\"",
    notify  => Class['elasticsearch_old::service'],
    require => Package['elasticsearch'],
  }

}
