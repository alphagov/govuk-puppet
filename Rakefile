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
    govuk::apps::cache_clearing_service::puppetdb_node_url
    govuk::apps::ckan::db_allow_prepared_statements
    govuk::apps::ckan::db_port
    govuk::apps::content_publisher::db::backend_ip_range
    govuk::apps::info_frontend::vhost_aliases
    govuk::apps::publisher::email_group_business
    govuk::apps::publisher::email_group_citizen
    govuk::apps::publisher::email_group_dev
    govuk::node::s_logging::apt_mirror_hostname
    govuk_ci::agent::master_ssh_key
    govuk_ci::master::ci_agents
    govuk_ci::master::credentials_id
    govuk_ci::master::pipeline_jobs
    govuk_containers::apps::release::envvars
    govuk_containers::frontend::haproxy::backend_mappings
    govuk_containers::frontend::haproxy::wildcard_publishing_certificate
    govuk_containers::frontend::haproxy::wildcard_publishing_key
    govuk_jenkins::config::user_permissions
    govuk_jenkins::packages::sops::apt_mirror_hostname
    govuk_jenkins::packages::terraform_docs::apt_mirror_hostname
    govuk_jenkins::packages::vale::apt_mirror_hostname
    govuk_mysql::server::expire_log_days
    govuk_mysql::server::monitoring::master::plaintext_mysql_password
    govuk_mysql::server::monitoring::slave::plaintext_mysql_password
    govuk_search::gor::enabled
    govuk_sysdig::apt_mirror_hostname
    govuk_sysdig::ensure
    hosts::production::api::app_hostnames
    hosts::production::api::hosts
    hosts::production::backend::app_hostnames
    hosts::production::backend::hosts
    hosts::production::ci::hosts
    hosts::production::external_licensify
    hosts::production::frontend::app_hostnames
    hosts::production::frontend::hosts
    hosts::production::ip_api_lb
    hosts::production::ip_backend_lb
    hosts::production::ip_draft_api_lb
    hosts::production::ip_frontend_lb
    hosts::production::ip_licensify_lb
    hosts::production::licensify::hosts
    hosts::production::management::hosts
    hosts::production::redirector::hosts
    hosts::production::router::hosts
    jenkins_admin_permission_list
    monitoring::vpn_gateways::endpoints
    postgresql_api_slave_addresses_dr
    postgresql_api_slave_addresses_live
    postgresql_slave_addresses_dr
    postgresql_slave_addresses_live
    postgresql_transition_slave_addresses_dr
    postgresql_transition_slave_addresses_live
    postgresql_transition_standby_addresses_dr
    postgresql_transition_standby_addresses_live
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
    govuk::apps::whitehall::cpu_critical
    govuk::apps::whitehall::cpu_warning
    govuk::node::s_api_lb::api_servers
    govuk::node::s_api_lb::content_store_servers
    govuk::node::s_api_lb::draft_content_store_servers
    govuk::node::s_api_lb::mapit_servers
    govuk::node::s_api_lb::search_servers
    govuk::node::s_backend_lb::backend_servers
    govuk::node::s_backend_lb::ckan_backend_servers
    govuk::node::s_backend_lb::email_alert_api_backend_servers
    govuk::node::s_backend_lb::perfplat_public_app_domain
    govuk::node::s_backend_lb::publishing_api_backend_servers
    govuk::node::s_backend_lb::whitehall_backend_servers
    govuk::node::s_backend_lb::whitehall_frontend_servers
    govuk::node::s_frontend_lb::calculators_frontend_servers
    govuk::node::s_frontend_lb::draft_frontend_servers
    govuk::node::s_frontend_lb::frontend_servers
    govuk::node::s_frontend_lb::whitehall_frontend_servers
    govuk::node::s_mysql_backup::s3_bucket_name
    govuk::node::s_mysql_master::s3_bucket_name
    govuk::node::s_transition_postgresql_slave::redirector_ip_range
    govuk::node::s_transition_postgresql_standby::redirector_ip_range
    govuk::node::s_whitehall_mysql_backup::s3_bucket_name
    govuk::node::s_whitehall_mysql_master::s3_bucket_name
    govuk_jenkins::config::banner_colour_background
    govuk_jenkins::config::banner_colour_text
    govuk_jenkins::config::banner_string
    govuk_jenkins::config::theme_colour
    govuk_jenkins::config::theme_environment_name
    govuk_jenkins::config::theme_text_colour
    govuk_postgresql::server::standby::pgpassfile_enabled
    hosts::production::ip_bouncer
    hosts::production::licensify_hosts
    mongodb::s3backup::backup::s3_bucket
    mongodb::s3backup::backup::s3_bucket_daily

    _
    backup::assets::backup_private_gpg_key_fingerprint
    backup::assets::jobs
    backup::offsite::jobs
    govuk::apps::local_links_manager::local_links_manager_passive_checks
    govuk::apps::local_links_manager::run_links_ga_export
    govuk::deploy::actionmailer_enable_delivery
    govuk::node::s_apt::real_ip_header
    govuk::node::s_backup::offsite_backups
    govuk::node::s_monitoring::enable_fastly_metrics
    govuk_bouncer::gor::enabled
    govuk_bouncer::gor::target
    govuk_crawler::ssh_keys
    govuk_jenkins::jobs::content_audit_tool::rake_import_all_content_items_frequency
    govuk_jenkins::jobs::content_audit_tool::rake_import_all_ga_metrics_frequency
    govuk_jenkins::jobs::content_performance_manager::rake_etl_master_process_cron_schedule
    govuk_jenkins::jobs::deploy_emergency_banner::clear_cdn_cache
    govuk_jenkins::jobs::network_config_deploy::environments
    govuk_jenkins::jobs::signon_cron_rake_tasks::configure_jobs
    govuk_jenkins::jobs::signon_cron_rake_tasks::rake_oauth_access_grants_delete_expired_frequency
    govuk_jenkins::jobs::signon_cron_rake_tasks::rake_organisations_fetch_frequency
    govuk_jenkins::jobs::signon_cron_rake_tasks::rake_users_send_suspension_reminders_frequency
    govuk_jenkins::jobs::signon_cron_rake_tasks::rake_users_suspend_inactive_frequency
    govuk_postgresql::backup::auto_postgresql_backup_hour
    govuk_postgresql::backup::auto_postgresql_backup_minute
    hosts::production::releaseapp_host_org
    monitoring::checks::mirror::enabled
  ]

  # Keys that are AWS-only
  AWS_ONLY_KEYS = %w[
    backup::mysql::alert_hostname
    collectd::package::collectd_version
    govuk::apps::bouncer::postgresql_role::rds
    govuk::apps::ckan::db::allow_auth_from_lb
    govuk::apps::ckan::db::lb_ip_range
    govuk::apps::ckan::db::rds
    govuk::apps::ckan::s3_aws_access_key_id
    govuk::apps::ckan::s3_aws_secret_access_key
    govuk::apps::content_audit_tool::db::allow_auth_from_lb
    govuk::apps::content_audit_tool::db::lb_ip_range
    govuk::apps::content_audit_tool::db::rds
    govuk::apps::content_data_admin::db::allow_auth_from_lb
    govuk::apps::content_data_admin::db::lb_ip_range
    govuk::apps::content_data_admin::db::rds
    govuk::apps::content_performance_manager::db::allow_auth_from_lb
    govuk::apps::content_performance_manager::db::lb_ip_range
    govuk::apps::content_performance_manager::db::rds
    govuk::apps::content_publisher::backend_ip_range
    govuk::apps::content_publisher::db::allow_auth_from_lb
    govuk::apps::content_publisher::db::lb_ip_range
    govuk::apps::content_publisher::db::rds
    govuk::apps::content_tagger::db::allow_auth_from_lb
    govuk::apps::content_tagger::db::lb_ip_range
    govuk::apps::content_tagger::db::rds
    govuk::apps::email_alert_api::db::allow_auth_from_lb
    govuk::apps::email_alert_api::db::lb_ip_range
    govuk::apps::email_alert_api::db::rds
    govuk::apps::link_checker_api::db::allow_auth_from_lb
    govuk::apps::link_checker_api::db::lb_ip_range
    govuk::apps::link_checker_api::db::rds
    govuk::apps::local_links_manager::db::allow_auth_from_lb
    govuk::apps::local_links_manager::db::lb_ip_range
    govuk::apps::local_links_manager::db::rds
    govuk::apps::publisher::alert_hostname
    govuk::apps::publishing_api::db::allow_auth_from_lb
    govuk::apps::publishing_api::db::lb_ip_range
    govuk::apps::publishing_api::db::rds
    govuk::apps::rummager::elasticsearch_hosts
    govuk::apps::search_api::elasticsearch_hosts
    govuk::apps::service_manual_publisher::db::allow_auth_from_lb
    govuk::apps::service_manual_publisher::db::lb_ip_range
    govuk::apps::service_manual_publisher::db::rds
    govuk::apps::service_manual_publisher::db_hostname
    govuk::apps::support_api::db::allow_auth_from_lb
    govuk::apps::support_api::db::lb_ip_range
    govuk::apps::support_api::db::rds
    govuk::apps::transition::db_password
    govuk::apps::transition::postgresql_db::rds
    govuk::deploy::setup::gemstash_server
    govuk::deploy::sync::auth_token
    govuk::deploy::sync::jenkins_domain
    govuk::node::s_apt::apt_service
    govuk::node::s_apt::gemstash_service
    govuk::node::s_asset_base::alert_hostname
    govuk::node::s_backend_lb::ckan_backend_servers
    govuk::node::s_base::log_remote
    govuk::node::s_postgresql_primary::alert_hostname
    govuk::node::s_transition_postgresql_master::alert_hostname
    govuk_bundler::config::service
    govuk_containers::apps::router::envvars
    govuk_crawler::alert_hostname
    govuk_datascrubber::apt_mirror_hostname
    govuk_datascrubber::aws_region
    govuk_elasticsearch::backup::alert_hostname
    govuk_elasticsearch::backup_enabled
    govuk_elasticsearch::open_firewall_from_all
    govuk_jenkins::deploy_all_apps::apps_on_nodes
    govuk_jenkins::deploy_all_apps::deploy_environment
    govuk_jenkins::jobs::deploy_app::graphite_host
    govuk_jenkins::jobs::deploy_app::graphite_port
    govuk_jenkins::jobs::passive_checks::alert_hostname
    govuk_pgbouncer::admin::rds
    govuk_pgbouncer::db::lb_ip_range
    govuk_postgresql::backup::alert_hostname
    govuk_splunk::repos::apt_mirror_hostname
    govuk_unattended_reboot::alert_hostname
    icinga::client::config::allowed_hosts
    icinga::config::graphite_hostname
    mongodb::backup::alert_hostname
    monitoring::checks::cache::servers
    monitoring::checks::rds::servers
    monitoring::client::alert_hostname
    monitoring::client::graphite_hostname
    monitoring::uptime_collector::aws
    nginx_enable_ssl
    puppet::monitoring::alert_hostname
    puppet::puppetserver::puppetdb_version
    stackname

    govuk::apps::ckan::s3_aws_region_name
    govuk::apps::ckan::s3_bucket_name
    govuk::apps::content_store::app_domain
    govuk::deploy::config::licensify_app_domain
    govuk::node::s_base::node_apps
    govuk::node::s_cache::router_as_container
    govuk_containers::terraboard::aws_bucket
    govuk_containers::terraboard::oauth2_proxy_base_url
    govuk_datascrubber::ensure
    govuk_datascrubber::s3_export_prefix
    govuk_datascrubber::share_with
    hosts::backend_migration::hosts
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
    govuk_elasticsearch::dump::run_es_dump_hour
    govuk_jenkins::jobs::data_sync_complete_production::signon_domains_to_migrate
    govuk_jenkins::jobs::search_fetch_analytics_data::cron_schedule
    govuk_jenkins::jobs::search_fetch_analytics_data::skip_page_traffic_load
    govuk_jenkins::jobs::smokey::environment
    govuk_mysql::server::expire_log_days
    govuk_mysql::server::slow_query_log
    govuk_sudo::sudo_conf
    grafana::dashboards::machine_suffix_metrics
    monitoring::checks::sidekiq::enable_support_check
    monitoring::pagerduty_drill::enabled
    router::nginx::robotstxt
  ]

  failed = false

  %w[common staging production].each do |environment|
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

    if failed
      exit 1
    end
  end
end
