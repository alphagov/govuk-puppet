# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define licensify::build_clean {

  $app_domain = hiera('app_domain')

  cron { "licensify-build-clean-${title}":
    command => "ls -dt1 '/data/vhost/${title}.${app_domain}/${title}'-* | tail -n +11 | while read dir; do rm -rf \"\${dir}\"; done",
    user    => 'deploy',
    require => User['deploy'],
    hour    => '*/6'
  }
}
