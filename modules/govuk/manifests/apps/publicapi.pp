class govuk::apps::publicapi {

  $app_domain = extlookup('app_domain')

  $privateapi = "contentapi.${app_domain}"
  $whitehallapi = "whitehall-frontend.${app_domain}"
  $factcaveapi = "fact-cave.${app_domain}"
  $backdropread = "read.backdrop.${app_domain}"
  $backdropwrite = "write.backdrop.${app_domain}"

  $enable_fact_cave_public_api = str2bool(extlookup('govuk_enable_fact_cave', 'no'))
  $enable_backdrop_test_bucket = str2bool(extlookup('govuk_enable_backdrop_test_bucket', 'no'))
  $enable_backdrop_government_annotations_bucket = str2bool(extlookup('govuk_enable_backdrop_government_annotations_bucket', 'no'))
  $enable_fco_journey_buckets = str2bool(extlookup('govuk_enable_backdrop_fco_journey_buckets', 'no'))
  $enable_realtime_buckets = str2bool(extlookup('govuk_enable_realtime_buckets', 'no'))


  $backdrop_buckets = [
    {
      'path' => 'licensing/api/journey',
      'name' => 'licensing_journey',
      'enabled' => true,
    },
    {
      'path' => 'licensing/api/application',
      'name' => 'licensing',
      'enabled' => true,
    },
    {
      'path' => 'licensing/api/realtime',
      'name' => 'licensing_realtime',
      'enabled' => $enable_realtime_buckets,
    },
    {
      'path' => 'government/api/annotations',
      'name' => 'government_annotations',
      'enabled' => $enable_backdrop_government_annotations_bucket,
    },
    {
      'path' => 'government/api/realtime',
      'name' => 'govuk_realtime',
      'enabled' => $enable_realtime_buckets,
    },
    {
      'path' => 'test/api/test',
      'name' => 'test',
      'enabled' => $enable_backdrop_test_bucket,
    },
    {
      'path' => 'pay-legalisation-post/api/journey',
      'name' => 'pay_legalisation_post_journey',
      'enabled' => $enable_fco_journey_buckets,
    },
    {
      'path' => 'pay-legalisation-post/api/realtime',
      'name' => 'pay_legalisation_post_realtime',
      'enabled' => $enable_realtime_buckets,
    },
    {
      'path' => 'pay-legalisation-drop-off/api/journey',
      'name' => 'pay_legalisation_drop_off_journey',
      'enabled' => $enable_fco_journey_buckets,
    },
    {
      'path' => 'pay-legalisation-drop-off/api/realtime',
      'name' => 'pay_legalisation_drop_off_realtime',
      'enabled' => $enable_realtime_buckets,
    },
    {
      'path' => 'pay-register-birth-abroad/api/journey',
      'name' => 'pay_register_birth_abroad_journey',
      'enabled' => $enable_fco_journey_buckets,
    },
    {
      'path' => 'pay-register-birth-abroad/api/realtime',
      'name' => 'pay_register_birth_abroad_realtime',
      'enabled' => $enable_realtime_buckets,
    },
    {
      'path' => 'pay-register-death-abroad/api/journey',
      'name' => 'pay_register_death_abroad_journey',
      'enabled' => $enable_fco_journey_buckets,
    },
    {
      'path' => 'pay-register-death-abroad/api/realtime',
      'name' => 'pay_register_death_abroad_realtime',
      'enabled' => $enable_realtime_buckets,
    },
    {
      'path' => 'pay-foreign-marriage-certificates/api/journey',
      'name' => 'pay_foreign_marriage_certificates_journey',
      'enabled' => $enable_fco_journey_buckets,
    },
    {
      'path' => 'pay-foreign-marriage-certificates/api/realtime',
      'name' => 'pay_foreign_marriage_certificates_realtime',
      'enabled' => $enable_realtime_buckets,
    },
    {
      'path' => 'deposit-foreign-marriage/api/journey',
      'name' => 'deposit_foreign_marriage_journey',
      'enabled' => $enable_fco_journey_buckets,
    },
    {
      'path' => 'deposit-foreign-marriage/api/realtime',
      'name' => 'deposit_foreign_marriage_realtime',
      'enabled' => $enable_realtime_buckets,
    },
  ]

  $app_name = 'publicapi'
  $full_domain = "${app_name}.${app_domain}"

  nginx::config::vhost::proxy { $full_domain:
    to               => [$privateapi],
    protected        => false,
    ssl_only         => false,
    extra_app_config => "
      # Don't proxy_pass / anywhere, just return 404. All real requests will
      # be handled by the location blocks below.
      return 404;
    ",
    extra_config     => template('govuk/publicapi_nginx_extra_config.erb')
  }
}
