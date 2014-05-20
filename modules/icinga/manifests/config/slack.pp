class icinga::config::slack {
  package {'icinga-slack-webhook':
    ensure   => '1.0.1',
    provider => 'pip',
  }
}
