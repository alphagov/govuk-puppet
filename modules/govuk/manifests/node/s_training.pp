# Test
class govuk::node::s_training {

  contains ::govuk::node::s_development

  package {['duplicity','jq','python-boto']:
    ensure => 'installed',
  }

}
