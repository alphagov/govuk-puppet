# == Class: monitoring::checks::pingdom
#
# Nagios alerts for Pingdom checks.
#
# === Variables:
#
# [*pingdom_enable_checks*]
#   Can be used to disable checks/alerts for a given environment. Because
#   the URLs for the checks are configured at Pingdom's side, it is not
#   desirable to have Production and Preview send an alert for the same
#   thing.
#   Default: yes
#
class monitoring::checks::pingdom {
  $pingdom_enable_checks = str2bool(extlookup('pingdom_enable_checks', 'yes'))

  if $pingdom_enable_checks {
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
}
