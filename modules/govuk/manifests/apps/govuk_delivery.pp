# == Class: govuk::apps::govuk_delivery
#
# An API to interface with govdelivery, sending email notices to users
# subscribed to content changes on GOV.UK
#
# === Parameters
#
# [*redis_host*]
#   Hostname of redis, used as message queue for celery
#
# [*redis_port*]
#   Port of redis, used as message queue for celery
#
# [*mongodb_hosts*]
#   List of hostnames running mongodb used to store the govdelivery allocated ID
#   of a feed for later use when adding subscribers
#
# [*mongodb_database*]
#   Name of the database in mongo where the govdelivery topic IDs are stored
#
# [*list_title_format*]
#   String format (Python syntax) for the title of lists
#
# [*govdelivery_username*]
#   Username used to authenticate with govdelivery API
#
# [*govdelivery_password*]
#   Password used to authenticate with govdelivery API
#
# [*govdelivery_account_code*]
#   Identifier for GOV.UK within the govdelivery service
#
# [*govdelivery_hostname*]
#   Hostname for the govdelivery API (changes depending on environment)
#
# [*govdelivery_signup_form*]
#   URL to the public govdelivery page users are redirected to to enter their
#   email and subscribe (URL should include a %s to provide a topic ID)
#
# [*port*]
#   Port the govuk_delivery service runs on, used in healthchecking the service.
#
# [*enable_procfile_worker*]
#   Run the celery worker defined in the procfile
class govuk::apps::govuk_delivery(
  $redis_host,
  $redis_port,
  $mongodb_hosts,
  $mongodb_database,
  $list_title_format,
  $govdelivery_username = undef,
  $govdelivery_password = undef,
  $govdelivery_account_code = undef,
  $govdelivery_hostname = undef,
  $govdelivery_signup_form = undef,
  $port = '3042',
  $enable_procfile_worker = true,
) {
  $app_name = 'govuk-delivery'
  include govuk_python

  govuk::app { $app_name:
    app_type           => 'procfile',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/_status',
    log_format_is_json => true,
  }

  govuk::procfile::worker { 'govuk-delivery':
    enable_service => $enable_procfile_worker,
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app::envvar::mongodb_uri { $app_name:
    hosts    => $mongodb_hosts,
    database => $mongodb_database,
  }

  govuk::app::envvar::redis { $app_name:
    host => $redis_host,
    port => $redis_port,
  }

  govuk::app::envvar {
    "${title}-GOVDELIVERY_USERNAME":
      varname => 'GOVDELIVERY_USERNAME',
      value   => $govdelivery_username;
    "${title}-GOVDELIVERY_PASSWORD":
      varname => 'GOVDELIVERY_PASSWORD',
      value   => $govdelivery_password;
    "${title}-GOVDELIVERY_ACCOUNT_CODE":
      varname => 'GOVDELIVERY_ACCOUNT_CODE',
      value   => $govdelivery_account_code;
    "${title}-GOVDELIVERY_HOSTNAME":
      varname => 'GOVDELIVERY_HOSTNAME',
      value   => $govdelivery_hostname;
    "${title}-GOVDELIVERY_SIGNUP_FORM":
      varname => 'GOVDELIVERY_SIGNUP_FORM',
      value   => $govdelivery_signup_form;
    "${title}-LIST_TITLE_FORMAT":
      varname => 'LIST_TITLE_FORMAT',
      value   => $list_title_format;
  }
}
