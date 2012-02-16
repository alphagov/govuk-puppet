node alphagov-devbox {
  include developer_machine
}

node default {
  case $govuk_class {
    frontend:           { include frontend_server }
    backend:            { include backend_server }
    data:               { include db_server }
    mongo:              { include mongo_server }
    support:            { include support_server }
    monitoring:         { include monitoring_server }
    development:        { include development }
    management:         { include management_server }
    cache:              { include cache_server }
    graylog:            { include graylog_server }
    whitehall-frontend: { include whitehall_frontend_server }
    redirect:           { include redirect_server }
    default:            { include base }
  }
}
