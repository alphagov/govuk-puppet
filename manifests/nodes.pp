node default {
  case $govuk_class {
    frontend:           { include govuk_base::ruby_app_server::frontend_server }
    backend:            { include govuk_base::ruby_app_server::backend_server }
    data:               { include govuk_base::db_server }
    mongo:              { include govuk_base::mongo_server }
    support:            { include govuk_base::support_server }
    monitoring:         { include govuk_base::monitoring_server }
    development:        { include development }
    management:         { include govuk_base::management_server }
    cache:              { include govuk_base::cache_server }
    graylog:            { include govuk_base::graylog_server }
    whitehall-frontend: { include govuk_base::ruby_app_server::whitehall_frontend_server }
    redirect:           { include govuk_base::redirect_server }
    ertp-mongo:         { include ertp_base::mongo_server }
    ertp-api:           { include ertp_base::api_server::all }
    ertp-api-citizen:   { include ertp_base::api_server::citizen }
    ertp-api-ems:       { include ertp_base::api_server::ems }
    ertp-frontend:      { include ertp_base::frontend_server }
    ertp-development:   { include ertp_base::development }
    default:            { }
  }
}
