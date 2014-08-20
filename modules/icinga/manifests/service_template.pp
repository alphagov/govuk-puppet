# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define icinga::service_template ($contact_groups) {

  file { "/etc/icinga/conf.d/service_template_${name}.cfg":
    content => template('icinga/service_template.cfg.erb'),
    require => Class['icinga::package'],
    notify  => Class['icinga::service'],
  }

}
