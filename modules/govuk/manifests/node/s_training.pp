# Test
class govuk::node::s_training {

#   include ::govuk::node::s_development

  package {['duplicity','jq','python-boto']:
    ensure => 'installed',
  }

}
