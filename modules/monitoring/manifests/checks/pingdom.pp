# == Class: monitoring::checks::pingdom
#
# Nagios alerts for Pingdom checks.
#
# === Parameters:
#
# [*enable*]
#   Can be used to disable checks/alerts for a given environment. Because
#   the URLs for the checks are configured at Pingdom's side, it is not
#   desirable to have production and preview send an alert for the same
#   thing.
#
class monitoring::checks::pingdom (
  $enable = true,
) {

  icinga::check_config::pingdom {
    'homepage':
      check_id => 489558;
    'calendar':
      check_id => 489561;
    'quick_answer':
      check_id => 662431;
    'search':
      check_id => 662465;
    'smart_answer':
      check_id => 489560;
    'specialist':
      check_id => 662460;
    'mirror':
      check_id => 944701;
  }

  if $enable {
    icinga::check { 'check_pingdom':
      check_command       => 'run_pingdom_homepage_check',
      use                 => 'govuk_urgent_priority',
      host_name           => $::fqdn,
      service_description => 'Pingdom homepage check',
    }

    icinga::check { 'check_pingdom_calendar':
      check_command       => 'run_pingdom_calendar_check',
      use                 => 'govuk_high_priority',
      host_name           => $::fqdn,
      service_description => 'Pingdom calendar check',
    }

    icinga::check { 'check_pingdom_search':
      check_command       => 'run_pingdom_search_check',
      use                 => 'govuk_urgent_priority',
      host_name           => $::fqdn,
      service_description => 'Pingdom search check',
    }

    icinga::check { 'check_pingdom_smart_answer':
      check_command       => 'run_pingdom_smart_answer_check',
      use                 => 'govuk_high_priority',
      host_name           => $::fqdn,
      service_description => 'Pingdom smartanswers check',
    }

    icinga::check { 'check_pingdom_specialist':
      check_command       => 'run_pingdom_specialist_check',
      use                 => 'govuk_high_priority',
      host_name           => $::fqdn,
      service_description => 'Pingdom specialist guides check',
    }

    icinga::check { 'check_pingdom_mirror':
      check_command       => 'run_pingdom_mirror_check',
      use                 => 'govuk_high_priority',
      host_name           => $::fqdn,
      service_description => 'Pingdom mirror check',
    }
  }
}
