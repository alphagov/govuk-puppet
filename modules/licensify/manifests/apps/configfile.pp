# == Class: licensify::apps::configfile
#
# Creates the config file which is common to all three Licensify apps.
#
# TODO: document all the parameters
#
# # === Parameters
#
# [*mongo_database_hosts*]
#   List of addresses for the Licencify Mongodb/DocumentdDB instances
#   Type: array of string
#   Default: []
#
# [*mongo_database_auth_enabled*]
#   State whether to use a username and password to access the
#   Mongodb/DocumentDB instances
#   Type: boolean
#   Default: false
#
# [*mongo_database_auth_username*]
#   Username to access the Mongodb/DocumentDB instances
#   Type: string
#   Default: ''
#
# [*mongo_database_auth_password*]
#   Password to access the Mongodb/DocumentDB instances
#   Type: string
#   Default: ''
#
class licensify::apps::configfile(
  $mongo_database_hosts = [],
  $mongo_database_reference_name = undef,
  $mongo_database_audit_name = undef,
  $mongo_database_slaveok = undef,
  $mongo_database_auth_enabled = false,
  $mongo_database_auth_username = '',
  $mongo_database_auth_password = '',
  $places_api_url = undef,
  $feed_actor = undef,
  $oauth_callback_url_override = undef,
  $upload_url_base = undef,
  $elms_frontend_host = undef,
  $elms_admin_host = undef,
  $elms_pdf_apihost = undef,
  $elms_max_app_process_attempt_count = undef,
  $access_token_url = undef,
  $authorization_url = undef,
  $user_details_url = undef,
  $client_id = undef,
  $client_secret = undef,
  $google_analytics_account_admin = undef,
  $google_analytics_domain_admin = undef,
  $google_analytics_account_frontend = undef,
  $google_analytics_domain_frontend = undef,
  $signon_url = undef,
  $worldpay_redirect_url = undef,
  $worldpay_cancelled_redirect_url = undef,
  $payments_test_mode = undef,
  $no_reply_mail_address = undef,
  $govuk_url = undef,
  $licence_finder_url = undef,
  $scheduled_virus_scan_cron_expression = undef,
  $performance_platform_bearer_token = undef,
  $performance_data_sender_cron_expression = undef,
  $performance_platform_service_url = undef,
  $notify_key_api = undef,
  $is_master_node = true,
  $email_override_recipient = undef,
  $email_periodic_enabled = undef,
  $licenceApplication_expirationPeriod = undef,
  $notify_periodic_email_cron = undef,
  $notify_template_applicant_none = undef,
  $notify_template_applicant_offline = undef,
  $notify_template_applicant_online = undef,
  $notify_template_authority = undef,
  $notify_template_periodic = undef,
  $payment_bibit_formUrl = undef,
  $payment_capita_formUrl = undef,
  $payment_northgate_callback_override = undef,
  $payment_worldpay_formUrl = undef,
  $uncollected_expiry_cron = undef,
  $uncollected_expiry_enabled = undef,
  $uncollected_expiry_purge_days = undef,
  $uncollected_expiry_start_days = undef,
  $services_to_notify = [],
) {
  file { '/etc/licensing/gds-licensing-config.properties':
    ensure  => file,
    content => template('licensify/gds-licensing-config.properties.erb'),
    mode    => '0644',
    owner   => 'deploy',
    group   => 'deploy',
    notify  => Service[$services_to_notify],
  }
}
