node default {

  if $::govuk_class == '' {
    $warn_head = '$::govuk_class is blank, not doing any initialization!'
    $warn_body = 'Consider sourcing `/etc/environment` or running with `sudo -i`'

    warning($warn_head)
    notify { "${warn_head} ${warn_body}": }
  } else {
    case $::govuk_class {
      'elms-sky-frontend':  { include govuk::node::s_licensify_frontend }
      'elms-sky-backend':   { include govuk::node::s_licensify_backend }
      'elms-mongo':         { include govuk::node::s_licensify_mongo }

      default: {
        $underscored_govuk_class = regsubst($::govuk_class, '-', '_', 'G')
        $node_class_name = "govuk::node::s_${underscored_govuk_class}"
        include $node_class_name
      }
    }
  }
}
