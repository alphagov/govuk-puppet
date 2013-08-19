class govuk::apps::publicapi {

  $app_domain = extlookup('app_domain')

  $privateapi = "contentapi.${app_domain}"
  $whitehallapi = "whitehall-frontend.${app_domain}"
  $factcaveapi = "fact-cave.${app_domain}"
  $backdropread = "read.backdrop.${app_domain}"
  $backdropwrite = "write.backdrop.${app_domain}"

  $enable_backdrop_test_bucket = str2bool(extlookup('govuk_enable_backdrop_test_bucket', 'no'))
  $enable_backdrop_hmrc_preview_bucket = str2bool(extlookup('govuk_enable_backdrop_hmrc_buckets', 'no'))
  $enable_backdrop_government_annotations_bucket = str2bool(extlookup('govuk_enable_backdrop_government_annotations_bucket', 'no'))
  $enable_fco_journey_buckets = str2bool(extlookup('govuk_enable_backdrop_fco_journey_buckets', 'no'))
  $enable_realtime_buckets = str2bool(extlookup('govuk_enable_realtime_buckets', 'no'))
  $enable_lpa_buckets = str2bool(extlookup('govuk_enable_lpa_buckets', 'no'))


  $backdrop_buckets = [
    {
      'path' => 'deposit-foreign-marriage/api/journey',
      'name' => 'deposit_foreign_marriage_journey',
      'enabled' => $enable_fco_journey_buckets,
    },
    {
      'path' => 'deposit-foreign-marriage/api/monitoring',
      'name' => 'deposit_foreign_marriage_monitoring',
      'enabled' => $enable_fco_journey_buckets,
    },
    {
      'path' => 'deposit-foreign-marriage/api/realtime',
      'name' => 'deposit_foreign_marriage_realtime',
      'enabled' => $enable_realtime_buckets,
      'realtime' => true,
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
      'realtime' => true,
    },
    {
      'path' => 'hmrc_preview/api/volumes',
      'name' => 'hmrc_preview',
      'enabled' => $enable_backdrop_hmrc_preview_bucket
    },
    {
      'path' => 'licence_finder/api/monitoring',
      'name' => 'licence_finder_monitoring',
      'enabled' => true,
    },
    {
      'path' => 'licensing/api/application',
      'name' => 'licensing',
      'enabled' => true,
    },
    {
      'path' => 'licensing/api/journey',
      'name' => 'licensing_journey',
      'enabled' => true,
    },
    {
      'path' => 'licensing/api/monitoring',
      'name' => 'licensing_monitoring',
      'enabled' => true,
    },
    {
      'path' => 'licensing/api/realtime',
      'name' => 'licensing_realtime',
      'enabled' => $enable_realtime_buckets,
      'realtime' => true,
    },
    {
      'path' => 'lasting-power-of-attorney/api/monitoring',
      'name' => 'lpa_monitoring',
      'enabled' => $enable_lpa_buckets,
    },
    {
      'path' => 'lasting-power-of-attorney/api/journey',
      'name' => 'lpa_journey',
      'enabled' => $enable_lpa_buckets,
    },
    {
      'path' => 'lasting-power-of-attorney/api/volumes',
      'name' => 'lpa_volumes',
      'enabled' => $enable_lpa_buckets,
    },
    {
      'path' => 'pay-foreign-marriage-certificates/api/journey',
      'name' => 'pay_foreign_marriage_certificates_journey',
      'enabled' => $enable_fco_journey_buckets,
    },
    {
      'path' => 'pay-foreign-marriage-certificates/api/monitoring',
      'name' => 'pay_foreign_marriage_certificates_monitoring',
      'enabled' => $enable_fco_journey_buckets,
    },
    {
      'path' => 'pay-foreign-marriage-certificates/api/realtime',
      'name' => 'pay_foreign_marriage_certificates_realtime',
      'enabled' => $enable_realtime_buckets,
      'realtime' => true,
    },
    {
      'path' => 'pay-legalisation-drop-off/api/journey',
      'name' => 'pay_legalisation_drop_off_journey',
      'enabled' => $enable_fco_journey_buckets,
    },
    {
      'path' => 'pay-legalisation-drop-off/api/monitoring',
      'name' => 'pay_legalisation_drop_off_monitoring',
      'enabled' => $enable_fco_journey_buckets,
    },
    {
      'path' => 'pay-legalisation-drop-off/api/realtime',
      'name' => 'pay_legalisation_drop_off_realtime',
      'enabled' => $enable_realtime_buckets,
      'realtime' => true,
    },
    {
      'path' => 'pay-legalisation-post/api/journey',
      'name' => 'pay_legalisation_post_journey',
      'enabled' => $enable_fco_journey_buckets,
    },
    {
      'path' => 'pay-legalisation-post/api/monitoring',
      'name' => 'pay_legalisation_post_monitoring',
      'enabled' => $enable_fco_journey_buckets,
    },
    {
      'path' => 'pay-legalisation-post/api/realtime',
      'name' => 'pay_legalisation_post_realtime',
      'enabled' => $enable_realtime_buckets,
      'realtime' => true,
    },
    {
      'path' => 'pay-register-birth-abroad/api/journey',
      'name' => 'pay_register_birth_abroad_journey',
      'enabled' => $enable_fco_journey_buckets,
    },
    {
      'path' => 'pay-register-birth-abroad/api/monitoring',
      'name' => 'pay_register_birth_abroad_monitoring',
      'enabled' => $enable_fco_journey_buckets,
    },
    {
      'path' => 'pay-register-birth-abroad/api/realtime',
      'name' => 'pay_register_birth_abroad_realtime',
      'enabled' => $enable_realtime_buckets,
      'realtime' => true,
    },
    {
      'path' => 'pay-register-death-abroad/api/journey',
      'name' => 'pay_register_death_abroad_journey',
      'enabled' => $enable_fco_journey_buckets,
    },
    {
      'path' => 'pay-register-death-abroad/api/monitoring',
      'name' => 'pay_register_death_abroad_monitoring',
      'enabled' => $enable_fco_journey_buckets,
    },
    {
      'path' => 'pay-register-death-abroad/api/realtime',
      'name' => 'pay_register_death_abroad_realtime',
      'enabled' => $enable_realtime_buckets,
      'realtime' => true,
    },
    {
      'path' => 'register-sorn-statutory-off-road-notification/api/monitoring',
      'name' => 'sorn_monitoring',
      'enabled' => true,
    },
    {
      'path' => 'tax-disc/api/monitoring',
      'name' => 'tax_disc_monitoring',
      'enabled' => true,
    },
    {
      'path' => 'vehicle-licensing/api/services',
      'name' => 'evl_services_volumetrics',
      'enabled' => true,
    },
    {
      'path' => 'vehicle-licensing/api/channels',
      'name' => 'evl_channel_volumetrics',
      'enabled' => true,
    },
    {
      'path' => 'vehicle-licensing/api/failures',
      'name' => 'evl_services_failures',
      'enabled' => true,
    },
    {
      'path' => 'test/api/test',
      'name' => 'test',
      'enabled' => $enable_backdrop_test_bucket,
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
