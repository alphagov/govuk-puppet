# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define licensify::build_clean {

  $app_domain = hiera('app_domain')

  $clean_cmd = "ls -dt1 '/data/vhost/${title}/releases/'* | tail -n +11 | while read dir; do rm -rf \"\${dir}\"; done"

  cron { "licensify-build-clean-${title}":
    command => $clean_cmd,
    user    => 'deploy',
    require => User['deploy'],
    hour    => '*/6',
  }
}
