node default {
  case $govuk_class {
    frontend:           { include govuk_base::ruby_app_server::frontend_server }
    backend:            { include govuk_base::ruby_app_server::backend_server }
    data:               { include govuk_base::db_server }
    mongo:              { include govuk_base::mongo_server }
    support:            { include govuk_base::support_server }
    monitoring:         { include govuk_base::monitoring_server }
    development:        { include development }
    puppet:             { include govuk_base::puppetmaster }
    management:         { include govuk_base::management_server::master }
    management_slave:   { include govuk_base::management_server::slave }
    cache:              { include govuk_base::cache_server }
    graylog:            { include govuk_base::graylog_server }
    whitehall-frontend: { include govuk_base::ruby_app_server::whitehall_frontend_server }
    redirect:           { include govuk_base::redirect_server }
    ertp-mongo:         { include ertp_base::mongo_server }
    ertp-api:           { include ertp_base::api_server::all }
    ertp-api-citizen:   { include ertp_base::api_server::citizen }
    ertp-api-ero:       { include ertp_base::api_server::ero }
    ertp-frontend:      { include ertp_base::frontend_server }
    ertp-development:   { include ertp_base::development }
    elms-frontend:      { include elms_base::frontend_server }
    elms-mongo:         { include elms_base::mongo_server }
    mapit_server:       { include mapit_server }
    places-api:         { include places_base::api_server }
    places-mongo:       { include places_base::mongo_server }
    default:            { }
  }
}
 