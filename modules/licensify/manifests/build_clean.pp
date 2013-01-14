define licensify::build_clean {

  $app_domain = extlookup('app_domain')

  cron { "licensify-build-clean-${title}":
    command => "ls -dt1 '/data/vhost/${title}.${app_domain}/${title}'-* | tail -n +11 | while read dir; do rm -rf \"\${dir}\"; done",
    user    => 'deploy',
    require => User['deploy'],
    hour    => '*/6'
  }
}
