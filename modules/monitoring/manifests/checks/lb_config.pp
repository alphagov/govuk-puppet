# == Define: monitoring::checks::lb_config
#
# Nagios alert config for AWS ALB/ELB.
#
# === Parameters
#
# [*region*]
#  Which AWS region should be checked ['us-east-1','eu-west-1']
#
# [*healthyhosts_warning*]
#  Defines the number of healthy hosts attached to an ELB or Target Group for which a warning alert will be triggered. 
#
# [*healthyhosts_critical*]
#  Defines the number of healthy hosts attached to an ELB or Target Group for which a critical alert will be triggered. 
#
# [*healthyhosts_ignore*]
#  List of Target Groups to ignore when performing a healthyhosts checks on this ALB.
#
define monitoring::checks::lb_config (
  $region = undef,
  $healthyhosts_warning = 1,
  $healthyhosts_critical = 0,
  $healthyhosts_ignore = [],
){

  $ignore = join(prefix($healthyhosts_ignore, '-i '), ' ')

  icinga::check { "check_aws_lb_healthyhosts-${title}":
    check_command       => "check_aws_lb_healthyhosts!${region}!${healthyhosts_warning}!${healthyhosts_critical}!${title}!${ignore}",
    host_name           => $::fqdn,
    service_description => "${title} - AWS LB Healthy Hosts",
    notes_url           => monitoring_docs_url(aws-lb-healthyhosts),
    require             => Icinga::Check_config['check_aws_lb_healthyhosts'],
  }
}
