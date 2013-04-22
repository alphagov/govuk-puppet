class monitoring::checks::pingdom {
  nagios::check { 'check_pingdom':
    check_command       => 'run_pingdom_homepage_check',
    use                 => 'govuk_urgent_priority',
    service_description => 'Pingdom homepage check',
  }

  nagios::check { 'check_pingdom_calendar':
    check_command       => 'run_pingdom_calendar_check',
    use                 => 'govuk_high_priority',
    service_description => 'Pingdom calendar check',
  }

  nagios::check { 'check_pingdom_search':
    check_command       => 'run_pingdom_search_check',
    use                 => 'govuk_urgent_priority',
    service_description => 'Pingdom search check',
  }

  nagios::check { 'check_pingdom_smart_answer':
    check_command       => 'run_pingdom_smart_answer_check',
    use                 => 'govuk_high_priority',
    service_description => 'Pingdom smartanswers check',
  }

  nagios::check { 'check_pingdom_specialist':
    check_command       => 'run_pingdom_specialist_check',
    use                 => 'govuk_high_priority',
    service_description => 'Pingdom specialist guides check',
  }
}
