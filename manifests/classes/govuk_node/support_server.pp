class govuk_node::support_server inherits govuk_node::base {
  include solr
  include apollo

  if $::govuk_platform == 'production' {
    # Since these backups are only for the purposes of restoring production
    # data to preview and development, it makes no sense to configure them on
    # any environment but production.
    include mysql::backup
  }

  include elasticsearch
  elasticsearch::node { "govuk-${::govuk_platform}": }
}
