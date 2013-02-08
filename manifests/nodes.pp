node default {

  if $::govuk_class == '' {
    warning('$govuk_class is blank, not doing any initialization!')
  } else {
    case $::govuk_class {
      'elms-development':   { include elms_base::development }
      'elms-frontend':      { include elms_base::frontend_server }
      'elms-mongo':         { include elms_base::mongo_server }
      'elms-sky-backend':   { include elms_base::sky_backend_server }
      'elms-sky-frontend':  { include elms_base::sky_frontend_server }
      'ertp-api-citizen':   { include ertp_base::api_server::citizen }
      'ertp-api-dwp':       { include ertp_base::api_server::dwp }
      'ertp-api-ero':       { include ertp_base::api_server::ero }
      'ertp-api':           { include ertp_base::api_server::all }
      'ertp-development':   { include ertp_base::development }
      'ertp-frontend':      { include ertp_base::frontend_server }
      'ertp-mongo':         { include ertp_base::mongo_server }
      'graylog':            { include govuk::node::s_logging }
      'places-api':         { include places_base::api_server }
      'places-mongo':       { include places_base::mongo_server }

      default: {
        $underscored_govuk_class = regsubst($::govuk_class, '-', '_')
        $node_class_name = "govuk::node::s_${underscored_govuk_class}"
        include $node_class_name
      }
    }
  }
}
