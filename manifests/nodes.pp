node default {
  case $::govuk_class {
    akamai_logs:        { include govuk_node::akamai_logs }
    asset_master:       { include govuk_node::asset_master }
    asset_slave:        { include govuk_node::asset_slave }
    backend:            { include govuk_node::backend_server }
    backend-lb:         { include govuk_node::backend_load_balancer }
    backup:             { include govuk_node::backup }
    cache:              { include govuk_node::cache_server }
    data:               { include govuk_node::db_server }
    datainsight:        { include govuk_node::datainsight }
    development:        { include development }
    efg_frontend:       { include govuk_node::efg_frontend_server }
    efg_mysql_master:   { include govuk_node::efg_mysql_master_server }
    elms-development:   { include elms_base::development }
    elms-frontend:      { include elms_base::frontend_server }
    elms-sky-backend:   { include elms_base::sky_backend_server }
    elms-sky-frontend:  { include elms_base::sky_frontend_server }
    elms-mongo:         { include elms_base::mongo_server }
    ertp-api-citizen:   { include ertp_base::api_server::citizen }
    ertp-api-ero:       { include ertp_base::api_server::ero }
    ertp-api-dwp:       { include ertp_base::api_server::dwp }
    ertp-api:           { include ertp_base::api_server::all }
    ertp-development:   { include ertp_base::development }
    ertp-frontend:      { include ertp_base::frontend_server }
    ertp-mongo:         { include ertp_base::mongo_server }
    frontend:           { include govuk_node::frontend_server }
    frontend-lb:        { include govuk_node::frontend_load_balancer }
    graylog:            { include govuk_node::graylog_server }
    jumpbox:            { include govuk_node::base }
    licensify-lb:       { include govuk_node::licensify_load_balancer }
    logging:            { include govuk_node::graylog_server }
    management:         { include govuk_node::management_server_master }
    management_slave:   { include govuk_node::management_server_slave }
    mapit_server:       { include govuk_node::mapit_server }
    mirror:             { include govuk_node::mirror_server }
    mongo:              { include govuk_node::mongo_server include govuk_node::mysql_master_server }
    monitoring:         { include govuk_node::monitoring_server }
    mysql_master:       { include govuk_node::mysql_master_server }
    mysql_slave:        { include govuk_node::mysql_slave_server }
    places-api:         { include places_base::api_server }
    places-mongo:       { include places_base::mongo_server }
    puppet:             { include govuk_node::puppetmaster }
    redirect:           { include govuk_node::redirect_server }
    redirector:         { include govuk_node::redirector_server }
    router-mongo:       { include govuk_node::router_mongo }
    support:            { include govuk_node::support_server }
    whitehall-frontend: { include govuk_node::whitehall_frontend_server }
    default:            { }
  }
}
