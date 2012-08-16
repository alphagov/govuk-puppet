node default {
  case $govuk_class {
    backend:            { include govuk_base::ruby_app_server::backend_server }
    cache:              { include govuk_base::cache_server }
    data:               { include govuk_base::db_server }
    development:        { include development }
    elms-development:   { include elms_base::development }
    elms-frontend:      { include elms_base::frontend_server }
    elms-mongo:         { include elms_base::mongo_server }
    ertp-api-citizen:   { include ertp_base::api_server::citizen }
    ertp-api-ero:       { include ertp_base::api_server::ero }
    ertp-api:           { include ertp_base::api_server::all }
    ertp-development:   { include ertp_base::development }
    ertp-frontend:      { include ertp_base::frontend_server }
    ertp-mongo:         { include ertp_base::mongo_server }
    frontend:           { include govuk_base::ruby_app_server::frontend_server }
    graylog:            { include govuk_base::graylog_server }
    jumpbox:            { include govuk_base }
    logging:            { include govuk_base::graylog_server }
    management:         { include govuk_base::management_server::master }
    management_slave:   { include govuk_base::management_server::slave }
    mapit_server:       { include govuk_base::mapit_server }
    mongo:              { include govuk_base::mongo_server include govuk_base::mysql_master_server }
    monitoring:         { include govuk_base::monitoring_server }
    mysql_master:       { include govuk_base::mysql_master_server}
    mysql_slave:        { include govuk_base::mysql_slave_server}
    places-api:         { include places_base::api_server }
    places-mongo:       { include places_base::mongo_server }
    puppet:             { include govuk_base::puppetmaster }
    redirect:           { include govuk_base::redirect_server }
    router-mongo:       { include govuk_base::router_mongo }
    support:            { include govuk_base::support_server }
    whitehall-frontend: { include govuk_base::ruby_app_server::whitehall_frontend_server }
    default:            { }
  }
}
