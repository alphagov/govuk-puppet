# == Define: govuk::app::envvar::plek_uri_overrides
#
# Defines Plek Overrides which are required as part 
# of the migration processi from carrenza to aws.
#
# === Parameters
#
# [*app*]
#   An optional GOV.UK app that the env vars are for.
#
define govuk::app::envvar::plek_uri_overrides (
  $app_domain,
) {

  Govuk::App::Envvar {
    app => $title,
  }

  govuk::app::envvar {
    "${title}-PLEK_SERVICE_SEARCH_URI":
      varname => PLEK_SERVICE_SEARCH_URI,
      value   => "search.${app_domain}";
    "${title}-PLEK_SERVICE_EMAIL_ALERT_API_URI":
      varname => PLEK_SERVICE_EMAIL_ALERT_API_URI,
      value   => "email-alert-api.${app_domain}";
    "${title}-PLEK_SERVICE_PUBLISHING_API_URI":
      varname => PLEK_SERVICE_PUBLISHING_API_URI,
      value   => "publishing-api.${app_domain}";
  }
}
