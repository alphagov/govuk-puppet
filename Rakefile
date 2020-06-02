require 'rspec/core/rake_task'
require 'puppet'
require 'yaml'

def get_modules
  if ENV['mods']
    ENV['mods'].split(',').map { |x| x == 'manifests' ? x : "modules/#{x}" }
  else
    ['manifests', 'modules/*']
  end
end

FileList['lib/tasks/*.rake'].each do |rake_file|
  import rake_file
end

desc "Run all tests except lint" # used by jenkins.sh
task :all_but_lint => [:puppetfile, :syntax, :bash_syntax, :yaml_syntax, :spec, :icinga_checks, :custom]

desc "Run all tests"
task :default => [:lint, :all_but_lint]

desc "Check consistency of hiera data between AWS and Carrenza"
task :check_consistency_between_aws_and_carrenza do
  # Keys that are Carrenza-only
  CARRENZA_ONLY_KEYS = %w[
    app_domain_internal
    environment_ip_prefix
    govuk::apps::content_publisher::db_allow_prepared_statements
    govuk::apps::content_publisher::db_port
    govuk::apps::content_publisher::db::backend_ip_range
    govuk::apps::content_tagger::db_allow_prepared_statements
    govuk::apps::content_tagger::db_port
    govuk::apps::publisher::email_group_business
    govuk::apps::publisher::email_group_citizen
    govuk::apps::publisher::email_group_dev
    govuk::apps::service_manual_publisher::db_allow_prepared_statements
    govuk::apps::service_manual_publisher::db_port
    govuk::node::s_logging::apt_mirror_hostname
    govuk_ci::agent::master_ssh_key
    govuk_ci::master::ci_agents
    govuk_ci::master::credentials_id
    govuk_ci::master::pipeline_jobs
    govuk_containers::frontend::haproxy::backend_mappings
    govuk_containers::frontend::haproxy::wildcard_publishing_certificate
    govuk_containers::frontend::haproxy::wildcard_publishing_key
    govuk_jenkins::config::user_permissions
    govuk_jenkins::packages::sops::apt_mirror_hostname
    govuk_jenkins::packages::sops::apt_mirror_gpg_key_fingerprint
    govuk_mysql::server::expire_log_days
    govuk_mysql::server::monitoring::master::plaintext_mysql_password
    govuk_mysql::server::monitoring::slave::plaintext_mysql_password
    govuk_sysdig::apt_mirror_hostname
    govuk_sysdig::ensure
    hosts::production::api::app_hostnames
    hosts::production::api::hosts
    hosts::production::backend::app_hostnames
    hosts::production::backend::hosts
    hosts::production::ci::hosts
    hosts::production::frontend::hosts
    hosts::production::ip_api_lb
    hosts::production::ip_backend_lb
    hosts::production::ip_draft_api_lb
    hosts::production::ip_frontend_lb
    hosts::production::management::hosts
    hosts::production::redirector::hosts
    jenkins_admin_permission_list
    monitoring::checks::sidekiq::enable_support_check
    monitoring::checks::smokey::ensure
    monitoring::vpn_gateways::endpoints
    postgresql_api_slave_addresses_dr
    postgresql_api_slave_addresses_live
    postgresql_slave_addresses_dr
    postgresql_slave_addresses_live
    puppet::master::puppetdb_version
    puppet::puppetdb::database_password
    rabbitmq::manage_repos
    rabbitmq::package_ensure
    redis::conf_aof_rewrite_incremental_fsync
    redis::conf_hz
    redis::conf_repl_disable_tcp_nodelay
    redis::conf_tcp_keepalive
    redis::conf_timeout
    resolvconf::nameservers
    resolvconf::options
    router::assets_origin::vhost_name
    router::draft_assets::vhost_name

    govuk::apps::government-frontend::cpu_critical
    govuk::apps::government-frontend::cpu_warning
    govuk::node::s_api_lb::api_servers
    govuk::node::s_backend_lb::backend_servers
    govuk::node::s_backend_lb::perfplat_public_app_domain
    govuk::node::s_backend_lb::whitehall_backend_servers
    govuk::node::s_backend_lb::whitehall_frontend_servers
    govuk::node::s_frontend_lb::whitehall_frontend_servers
    govuk::node::s_mysql_backup::s3_bucket_name
    govuk::node::s_mysql_master::s3_bucket_name
    govuk::node::s_postgresql_standby::aws_access_key_id
    govuk::node::s_postgresql_standby::aws_secret_access_key
    govuk::node::s_postgresql_standby::s3_bucket_url
    govuk::node::s_postgresql_standby::wale_private_gpg_key
    govuk::node::s_postgresql_standby::wale_private_gpg_key_fingerprint
    govuk_jenkins::config::banner_colour_background
    govuk_jenkins::config::banner_colour_text
    govuk_jenkins::config::banner_string
    govuk_jenkins::config::theme_colour
    govuk_jenkins::config::theme_environment_name
    govuk_jenkins::config::theme_text_colour
    govuk_postgresql::server::standby::pgpassfile_enabled
    hosts::production::ip_bouncer
    mongodb::s3backup::backup::s3_bucket
    mongodb::s3backup::backup::s3_bucket_daily
    mongodb::server::version

    govuk::apps::content_tagger::override_search_location
    govuk::apps::hmrc_manuals_api::override_search_location
    govuk::apps::search_admin::override_search_location

    _
    backup::offsite::jobs
    govuk::deploy::actionmailer_enable_delivery
    govuk::node::s_apt::real_ip_header
    govuk::node::s_backup::offsite_backups
    govuk::node::s_monitoring::enable_fastly_metrics
    govuk_bouncer::gor::enabled
    govuk_bouncer::gor::target
    govuk_jenkins::jobs::network_config_deploy::environments
    govuk_jenkins::jobs::signon_cron_rake_tasks::configure_jobs
    govuk_jenkins::jobs::signon_cron_rake_tasks::rake_oauth_access_grants_delete_expired_frequency
    govuk_jenkins::jobs::signon_cron_rake_tasks::rake_organisations_fetch_frequency
    govuk_jenkins::jobs::signon_cron_rake_tasks::rake_users_send_suspension_reminders_frequency
    govuk_jenkins::jobs::signon_cron_rake_tasks::rake_users_suspend_inactive_frequency
  ]

  # Keys that are AWS-only
  AWS_ONLY_KEYS = %w[
    backup::mysql::alert_hostname
    govuk::apps::bouncer::db_hostname
    govuk::apps::bouncer::nagios_memory_critical
    govuk::apps::bouncer::nagios_memory_warning
    govuk::apps::bouncer::postgresql_role::rds
    govuk::apps::bouncer::unicorn_worker_processes
    govuk::apps::cache_clearing_service::enabled
    govuk::apps::cache_clearing_service::nagios_memory_critical
    govuk::apps::cache_clearing_service::nagios_memory_warning
    govuk::apps::cache_clearing_service::rabbitmq::enabled
    govuk::apps::cache_clearing_service::rabbitmq::queue_size_critical_threshold
    govuk::apps::cache_clearing_service::rabbitmq::queue_size_warning_threshold
    govuk::apps::cache_clearing_service::rabbitmq_hosts
    govuk::apps::ckan::ckan_site_url
    govuk::apps::ckan::cronjobs::enable_solr_reindex
    govuk::apps::ckan::db::allow_auth_from_lb
    govuk::apps::ckan::db::backend_ip_range
    govuk::apps::ckan::db::lb_ip_range
    govuk::apps::ckan::db::rds
    govuk::apps::ckan::db_hostname
    govuk::apps::ckan::gunicorn_worker_processes
    govuk::apps::ckan::redis_host
    govuk::apps::ckan::redis_port
    govuk::apps::ckan::s3_aws_access_key_id
    govuk::apps::ckan::s3_aws_secret_access_key
    govuk::apps::collections::unicorn_worker_processes
    govuk::apps::collections::nagios_memory_critical
    govuk::apps::collections::nagios_memory_warning
    govuk::apps::content_data_admin::db::allow_auth_from_lb
    govuk::apps::content_data_admin::db::lb_ip_range
    govuk::apps::content_data_admin::db::rds
    govuk::apps::content_data_admin::db::backend_ip_range
    govuk::apps::content_data_admin::db_hostname
    govuk::apps::content_data_admin::redis_host
    govuk::apps::content_data_admin::redis_port
    govuk::apps::content_data_admin::aws_csv_export_bucket_name
    govuk::apps::content_data_admin::google_tag_manager_id
    govuk::apps::content_data_admin::govuk_notify_template_id
    govuk::apps::content_data_api::db::lb_ip_range
    govuk::apps::content_data_api::db::rds
    govuk::apps::content_data_api::db_hostname
    govuk::apps::content_data_api::etl_healthcheck_enabled_from_hour
    govuk::apps::content_data_api::rabbitmq_hosts
    govuk::apps::content_data_api::rabbitmq_password
    govuk::apps::content_data_api::rabbitmq_user
    govuk::apps::content_data_api::redis_host
    govuk::apps::content_data_api::redis_port
    govuk::apps::content_data_api::db_name
    govuk::apps::content_data_api::db_username
    govuk::apps::content_publisher::backend_ip_range
    govuk::apps::content_publisher::db::allow_auth_from_lb
    govuk::apps::content_publisher::db::lb_ip_range
    govuk::apps::content_publisher::db::rds
    govuk::apps::content_store::nagios_memory_critical
    govuk::apps::content_store::nagios_memory_warning
    govuk::apps::content_store::performance_platform_big_screen_view_url
    govuk::apps::content_store::performance_platform_spotlight_url
    govuk::apps::content_store::unicorn_worker_processes
    govuk::apps::content_tagger::db::allow_auth_from_lb
    govuk::apps::content_tagger::db::lb_ip_range
    govuk::apps::content_tagger::db::rds
    govuk::apps::govuk_crawler_worker::enabled
    govuk::apps::govuk_crawler_worker::root_urls
    govuk::apps::govuk_crawler_worker::nagios_memory_critical
    govuk::apps::govuk_crawler_worker::nagios_memory_warning
    govuk::apps::govuk_crawler_worker::disable_during_data_sync
    govuk::apps::email_alert_api::db::allow_auth_from_lb
    govuk::apps::email_alert_api::db::backend_ip_range
    govuk::apps::email_alert_api::db::lb_ip_range
    govuk::apps::email_alert_api::db::rds
    govuk::apps::email_alert_api::db_hostname
    govuk::apps::email_alert_api::db_password
    govuk::apps::email_alert_api::delivery_request_threshold
    govuk::apps::email_alert_api::email_address_override
    govuk::apps::email_alert_api::email_address_override_whitelist
    govuk::apps::email_alert_api::email_address_override_whitelist_only
    govuk::apps::email_alert_api::email_archive_s3_bucket
    govuk::apps::email_alert_api::email_archive_s3_enabled
    govuk::apps::email_alert_api::enabled
    govuk::apps::email_alert_api::govuk_notify_template_id
    govuk::apps::email_alert_api::nagios_memory_critical
    govuk::apps::email_alert_api::nagios_memory_warning
    govuk::apps::email_alert_api::redis_host
    govuk::apps::email_alert_api::redis_port
    govuk::apps::email_alert_api::unicorn_worker_processes
    govuk::apps::email_alert_frontend::subscription_management_enabled
    govuk::apps::email_alert_service::enable_unpublishing_queue_consumer
    govuk::apps::email_alert_service::enabled
    govuk::apps::email_alert_service::rabbitmq::queue_size_critical_threshold
    govuk::apps::email_alert_service::rabbitmq::queue_size_warning_threshold
    govuk::apps::email_alert_service::rabbitmq_hosts
    govuk::apps::email_alert_service::redis_host
    govuk::apps::finder_frontend::enabled
    govuk::apps::finder_frontend::nagios_memory_critical
    govuk::apps::finder_frontend::nagios_memory_warning
    govuk::apps::finder_frontend::unicorn_worker_processes
    govuk::apps::frontend::govuk_notify_template_id
    govuk::apps::frontend::nagios_memory_critical
    govuk::apps::frontend::nagios_memory_warning
    govuk::apps::frontend::redis_host
    govuk::apps::frontend::redis_port
    govuk::apps::frontend::unicorn_worker_processes
    govuk::apps::government_frontend::nagios_memory_critical
    govuk::apps::government_frontend::nagios_memory_warning
    govuk::apps::government_frontend::unicorn_worker_processes
    govuk::apps::imminence::mongodb_nodes
    govuk::apps::imminence::nagios_memory_critical
    govuk::apps::imminence::nagios_memory_warning
    govuk::apps::imminence::redis_host
    govuk::apps::imminence::redis_port
    govuk::apps::imminence::unicorn_worker_processes
    govuk::apps::info_frontend::enabled
    govuk::apps::sidekiq_monitoring::imminence_redis_host
    govuk::apps::sidekiq_monitoring::imminence_redis_port
    govuk::apps::smartanswers::nagios_memory_critical
    govuk::apps::smartanswers::nagios_memory_warning
    govuk::apps::smartanswers::unicorn_worker_processes
    govuk::apps::static::ga_universal_id
    govuk::apps::static::nagios_memory_critical
    govuk::apps::static::nagios_memory_warning
    govuk::apps::static::redis_host
    govuk::apps::static::redis_port
    govuk::apps::static::asset_host
    govuk::apps::static::unicorn_worker_processes
    govuk::apps::licencefinder::elasticsearch_uri
    govuk::apps::link_checker_api::db::allow_auth_from_lb
    govuk::apps::link_checker_api::db::lb_ip_range
    govuk::apps::link_checker_api::db::rds
    govuk::apps::link_checker_api::db::backend_ip_range
    govuk::apps::link_checker_api::db_hostname
    govuk::apps::link_checker_api::redis_host
    govuk::apps::link_checker_api::redis_port
    govuk::apps::local_links_manager::db::allow_auth_from_lb
    govuk::apps::local_links_manager::db::backend_ip_range
    govuk::apps::local_links_manager::db::lb_ip_range
    govuk::apps::local_links_manager::db::rds
    govuk::apps::local_links_manager::db_hostname
    govuk::apps::local_links_manager::local_links_manager_passive_checks
    govuk::apps::local_links_manager::nagios_memory_critical
    govuk::apps::local_links_manager::nagios_memory_warning
    govuk::apps::local_links_manager::redis_host
    govuk::apps::local_links_manager::redis_port
    govuk::apps::local_links_manager::run_links_ga_export
    govuk::apps::local_links_manager::unicorn_worker_processes
    govuk::apps::mapit::enabled
    govuk::apps::mapit::gdal_version
    govuk::apps::manuals_publisher::mongodb_nodes
    govuk::apps::manuals_publisher::mongodb_username
    govuk::apps::manuals_publisher::mongodb_password
    govuk::apps::maslow::mongodb_nodes
    govuk::apps::maslow::mongodb_username
    govuk::apps::maslow::mongodb_password
    govuk::apps::publisher::alert_hostname
    govuk::apps::publisher::mongodb_nodes
    govuk::apps::publisher::mongodb_username
    govuk::apps::publisher::mongodb_password
    govuk::apps::publishing_api::content_store
    govuk::apps::publishing_api::db::allow_auth_from_lb
    govuk::apps::publishing_api::db::backend_ip_range
    govuk::apps::publishing_api::db::lb_ip_range
    govuk::apps::publishing_api::db::rds
    govuk::apps::publishing_api::db_hostname
    govuk::apps::publishing_api::draft_content_store
    govuk::apps::publishing_api::event_log_aws_bucketname
    govuk::apps::publishing_api::govuk_content_schemas_path
    govuk::apps::publishing_api::nagios_memory_critical
    govuk::apps::publishing_api::nagios_memory_warning
    govuk::apps::publishing_api::rabbitmq_hosts
    govuk::apps::publishing_api::rabbitmq_password
    govuk::apps::publishing_api::redis_host
    govuk::apps::publishing_api::redis_port
    govuk::apps::publishing_api::unicorn_worker_processes
    govuk::apps::router::sentry_environment
    govuk::apps::release::db_hostname
    govuk::apps::release::db_password
    govuk::apps::release::db_username
    govuk::apps::release::github_username
    govuk::apps::search_api::nagios_memory_warning
    govuk::apps::search_api::nagios_memory_critical
    govuk::apps::search_api::rabbitmq_hosts
    govuk::apps::search_api::enable_bulk_reindex_listener
    govuk::apps::search_api::enable_publishing_listener
    govuk::apps::search_api::enable_govuk_index_listener
    govuk::apps::search_api::rabbitmq::enable_bulk_reindex_listener
    govuk::apps::search_api::rabbitmq::enable_govuk_index_listener
    govuk::apps::search_api::rabbitmq::enable_publishing_listener
    govuk::apps::search_api::rabbitmq_user
    govuk::apps::search_api::redis_host
    govuk::apps::search_api::redis_port
    govuk::apps::search_api::elasticsearch_hosts
    govuk::apps::search_api::unicorn_worker_processes
    govuk::apps::search_api::relevancy_bucket_name
    govuk::apps::search_api::sitemaps_bucket_name
    govuk::apps::search_api::enable_learning_to_rank
    govuk::apps::search_api::tensorflow_sagemaker_endpoint
    govuk::apps::sidekiq_monitoring::content_data_admin_redis_host
    govuk::apps::sidekiq_monitoring::content_data_admin_redis_port
    govuk::apps::sidekiq_monitoring::content_data_api_redis_host
    govuk::apps::sidekiq_monitoring::content_data_api_redis_port
    govuk::apps::sidekiq_monitoring::link_checker_api_redis_host
    govuk::apps::sidekiq_monitoring::link_checker_api_redis_port
    govuk::apps::sidekiq_monitoring::publishing_api_redis_host
    govuk::apps::sidekiq_monitoring::publishing_api_redis_port
    govuk::apps::sidekiq_monitoring::search_api_redis_host
    govuk::apps::sidekiq_monitoring::search_api_redis_port
    govuk::apps::sidekiq_monitoring::support_api_redis_host
    govuk::apps::sidekiq_monitoring::support_api_redis_port
    govuk::apps::sidekiq_monitoring::transition_redis_host
    govuk::apps::sidekiq_monitoring::transition_redis_port
    govuk::apps::search_api::elasticsearch_hosts
    govuk::apps::service_manual_publisher::db::allow_auth_from_lb
    govuk::apps::service_manual_publisher::db::lb_ip_range
    govuk::apps::service_manual_publisher::db::rds
    govuk::apps::service_manual_publisher::db_hostname
    govuk::apps::short_url_manager::mongodb_nodes
    govuk::apps::short_url_manager::mongodb_username
    govuk::apps::short_url_manager::mongodb_password
    govuk::apps::specialist_publisher::aws_s3_bucket_name
    govuk::apps::support::aws_s3_bucket_name
    govuk::apps::support::redis_host
    govuk::apps::support::redis_port
    govuk::apps::support_api::aws_s3_bucket_name
    govuk::apps::support_api::db::allow_auth_from_lb
    govuk::apps::support_api::db::backend_ip_range
    govuk::apps::support_api::db::lb_ip_range
    govuk::apps::support_api::db::rds
    govuk::apps::support_api::db_hostname
    govuk::apps::support_api::db_name
    govuk::apps::support_api::db_password
    govuk::apps::support_api::db_username
    govuk::apps::support_api::govuk_notify_template_id
    govuk::apps::support_api::pp_data_url
    govuk::apps::support_api::redis_host
    govuk::apps::support_api::redis_port
    govuk::apps::support_api::zendesk_anonymous_ticket_email
    govuk::apps::transition::db_hostname
    govuk::apps::transition::db_password
    govuk::apps::transition::postgresql_db::backend_ip_range
    govuk::apps::transition::postgresql_db::rds
    govuk::apps::transition::redis_host
    govuk::apps::transition::redis_port
    govuk::apps::travel_advice_publisher::mongodb_nodes
    govuk::apps::travel_advice_publisher::mongodb_username
    govuk::apps::travel_advice_publisher::mongodb_password
    govuk::apps::whitehall::admin_db_hostname
    govuk::apps::whitehall::admin_db_name
    govuk::apps::whitehall::admin_db_password
    govuk::apps::whitehall::admin_db_username
    govuk::apps::whitehall::admin_key_space_limit
    govuk::apps::whitehall::db::whitehall_fe_password
    govuk::apps::whitehall::db_hostname
    govuk::apps::whitehall::db_name
    govuk::apps::whitehall::db_password
    govuk::apps::whitehall::db_username
    govuk::apps::whitehall::jwt_auth_secret
    govuk::apps::whitehall::redis_host
    govuk::apps::whitehall::redis_port
    govuk::deploy::setup::gemstash_server
    govuk::deploy::sync::auth_token
    govuk::deploy::sync::jenkins_domain
    govuk::node::s_apt::apt_service
    govuk::node::s_content_data_api_db_admin::apt_mirror_hostname
    govuk::node::s_apt::gemstash_service
    govuk::node::s_asset_base::alert_hostname
    govuk::node::s_base::log_remote
    govuk::node::s_gatling::apt_mirror_hostname
    govuk::node::s_gatling::apt_mirror_gpg_key_fingerprint
    govuk::node::s_gatling::repo
    govuk::node::s_gatling::ssh_public_key
    govuk::node::s_gatling::ssh_private_key
    govuk::node::s_licensing_backend::apt_mirror_hostname
    govuk::node::s_licensing_backend::apt_mirror_gpg_key_fingerprint
    govuk::node::s_licensing_frontend::apt_mirror_hostname
    govuk::node::s_licensing_frontend::apt_mirror_gpg_key_fingerprint
    govuk::node::s_postgresql_primary::alert_hostname
    govuk::node::s_transition_db_admin::apt_mirror_hostname
    govuk_bundler::config::service
    govuk_containers::apps::router::envvars
    govuk_crawler::alert_hostname
    govuk_crawler::amqp_host
    govuk_crawler::seed_enable
    govuk_crawler::site_root
    govuk_crawler::ssh_keys
    govuk_crawler::sync_enable
    govuk_crawler::targets
    govuk_jenkins::deploy_all_apps::apps_on_nodes
    govuk_jenkins::deploy_all_apps::deploy_environment
    govuk_jenkins::jobs::content_data_api::rake_etl_master_process_cron_schedule
    govuk_jenkins::jobs::deploy_app::graphite_host
    govuk_jenkins::jobs::deploy_app::graphite_port
    govuk_jenkins::jobs::deploy_emergency_banner::clear_cdn_cache
    govuk_jenkins::jobs::email_alert_check::email_addresses_to_check
    govuk_jenkins::jobs::passive_checks::alert_hostname
    govuk_pgbouncer::admin::rds
    govuk_pgbouncer::db::lb_ip_range
    govuk_splunk::repos::apt_mirror_hostname
    govuk_splunk::repos::apt_mirror_gpg_key_fingerprint
    govuk_unattended_reboot::alert_hostname
    icinga::client::config::allowed_hosts
    icinga::config::graphite_hostname
    mongodb::backup::alert_hostname
    monitoring::checks::cache::servers
    monitoring::checks::lb::region
    monitoring::checks::lb::loadbalancers
    monitoring::checks::rds::servers
    monitoring::client::alert_hostname
    monitoring::checks::sidekiq::enable_signon_check
    monitoring::checks::smokey::features
    monitoring::checks::smokey::disable_during_data_sync
    monitoring::client::graphite_hostname
    monitoring::uptime_collector::aws
    nginx_enable_ssl
    puppet::monitoring::alert_hostname
    puppet::puppetserver::puppetdb_version
    stackname

    govuk_search::monitoring::es_port
    govuk_search::monitoring::es_host

    govuk::apps::ckan::s3_aws_region_name
    govuk::apps::ckan::s3_bucket_name
    govuk::node::s_base::node_apps
    govuk::node::s_cache::real_ip_header
    govuk::node::s_cache::router_as_container
    monitoring::checks::cache::region
    monitoring::checks::rds::region
    nginx::config::stack_network_prefix
    node_class

    backup::server::backup_hour
    cron::daily_hour
    govuk::apps::content_data_admin::google_tag_manager_auth
    govuk::apps::content_data_admin::google_tag_manager_preview
    govuk::apps::link_checker_api::govuk_basic_auth_credentials
    govuk::apps::short_url_manager::instance_name
    govuk::apps::support::zendesk_anonymous_ticket_email
    govuk::apps::support::zendesk_client_username
    govuk::apps::support_api::zendesk_client_username
    govuk::node::s_asset_master::copy_attachments_hour
    govuk::node::s_monitoring::offsite_backups
    govuk_cdnlogs::bouncer_monitoring_enabled
    govuk_cdnlogs::critical_cdn_freshness
    govuk_cdnlogs::warning_cdn_freshness
    govuk_jenkins::jobs::athena_fastly_logs_check::databases
    govuk_jenkins::jobs::athena_fastly_logs_check::s3_results_bucket
    govuk_jenkins::jobs::data_sync_complete_production::signon_domains_to_migrate
    govuk_jenkins::jobs::search_fetch_analytics_data::cron_schedule
    govuk_jenkins::jobs::search_fetch_analytics_data::skip_page_traffic_load
    govuk_jenkins::jobs::search_relevancy_rank_evaluation::cron_schedule
    govuk_jenkins::jobs::search_relevancy_metrics_etl::cron_schedule
    govuk_jenkins::jobs::smokey::environment
    govuk_mysql::server::expire_log_days
    govuk_mysql::server::slow_query_log
    govuk_sudo::sudo_conf
    grafana::dashboards::machine_suffix_metrics
    monitoring::checks::sidekiq::enable_support_check
    monitoring::pagerduty_drill::enabled
    router::assets_origin::website_root
    router::nginx::robotstxt
    govuk::apps::govuk_crawler_worker::blacklist_paths
    govuk_awscloudwatch::apt_mirror_hostname
    govuk_awscloudwatch::apt_mirror_gpg_key_fingerprint
    govuk_crawler::start_hour
    govuk_crawler::days
    govuk::apps::govuk_crawler_worker::crawler_threads
    licensify::apps::configfile::access_token_url
    licensify::apps::configfile::authorization_url
    licensify::apps::configfile::elms_admin_host
    licensify::apps::configfile::elms_frontend_host
    licensify::apps::configfile::elms_max_app_process_attempt_count
    licensify::apps::configfile::email_override_recipient
    licensify::apps::configfile::email_periodic_enabled
    licensify::apps::configfile::feed_actor
    licensify::apps::configfile::google_analytics_account_admin
    licensify::apps::configfile::google_analytics_account_frontend
    licensify::apps::configfile::google_analytics_domain_admin
    licensify::apps::configfile::google_analytics_domain_frontend
    licensify::apps::configfile::is_master_node
    licensify::apps::configfile::licenceApplication_expirationPeriod
    licensify::apps::configfile::mongo_database_audit_name
    licensify::apps::configfile::mongo_database_auth_enabled
    licensify::apps::configfile::mongo_database_reference_name
    licensify::apps::configfile::mongo_database_slaveok
    licensify::apps::configfile::no_reply_mail_address
    licensify::apps::configfile::notify_periodic_email_cron
    licensify::apps::configfile::notify_template_applicant_none
    licensify::apps::configfile::notify_template_applicant_offline
    licensify::apps::configfile::notify_template_applicant_online
    licensify::apps::configfile::notify_template_authority
    licensify::apps::configfile::notify_template_periodic
    licensify::apps::configfile::oauth_callback_url_override
    licensify::apps::configfile::performance_data_sender_cron_expression
    licensify::apps::configfile::performance_platform_service_url
    licensify::apps::configfile::uncollected_expiry_cron
    licensify::apps::configfile::uncollected_expiry_enabled
    licensify::apps::configfile::uncollected_expiry_purge_days
    licensify::apps::configfile::uncollected_expiry_start_days
    licensify::apps::configfile::upload_url_base
    licensify::apps::configfile::user_details_url
    licensify::apps::licensify::alert_5xx_critical_rate
    licensify::apps::licensify::alert_5xx_warning_rate
    licensify::apps::licensify::environment
    licensify::apps::licensify_admin::environment
    licensify::apps::licensify_feed::environment
  ]

  failed = false

  hieradata_file_names = %w[common staging production]

  hieradata_file_names.each do |environment|
    carrenza = YAML.load_file("hieradata/#{environment}.yaml")

    aws = YAML.load_file("hieradata_aws/#{environment}.yaml")

    carrenza_only = (carrenza.keys - aws.keys).sort - CARRENZA_ONLY_KEYS
    aws_only = (aws.keys - carrenza.keys).sort - AWS_ONLY_KEYS

    if carrenza_only.any? || aws_only.any?
      puts "\n\nCHECKING #{environment}"
      puts "\nThese keys exist in hieradata/#{environment}.yaml, but not in hieradata_aws/#{environment}.yaml: \n -" + carrenza_only.join("\n -")
      puts "\nThese keys exist in hieradata_aws/#{environment}.yaml, but not in hieradata/#{environment}.yaml: \n -" + aws_only.join("\n -")
      failed = true
    else
      puts "#{environment} keys okay!"
    end
  end

  all_carrenza_keys = hieradata_file_names.flat_map do |filename|
    YAML.load_file("hieradata/#{filename}.yaml").keys
  end

  missing_carrenza_keys = CARRENZA_ONLY_KEYS - all_carrenza_keys

  if missing_carrenza_keys.any?
    puts "\n\nCHECKING all Carrenza keys"
    puts "\nThese keys are listed as Carrenza only, but don't exist in any Carrenza related hieradata file: \n -" + missing_carrenza_keys.join("\n -")
    failed = true
  end

  all_aws_keys = hieradata_file_names.flat_map do |filename|
    YAML.load_file("hieradata_aws/#{filename}.yaml").keys
  end

  missing_aws_keys = AWS_ONLY_KEYS - all_aws_keys

  if missing_aws_keys.any?
    puts "\n\nCHECKING all AWS keys"
    puts "\nThese keys are listed as AWS only, but don't exist in any AWS related hieradata file: \n -" + missing_aws_keys.join("\n -")
    failed = true
  end

  if failed
    exit 1
  end
end
