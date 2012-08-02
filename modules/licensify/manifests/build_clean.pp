define licensify::build_clean {
  cron { "licensify-build-clean-$title":
    command => "ls -dt1 '/data/vhost/${title}.${::govuk_platform}.alphagov.co.uk/${title}'-* | tail -n +11 | while read dir; do echo rm -rf \"\${dir}\"; done",
    user    => 'deploy',
    require => User['deploy'],
    hour    => '*/6'
  }
}