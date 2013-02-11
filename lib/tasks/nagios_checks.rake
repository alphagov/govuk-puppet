desc "Test nagios::checks are unique per machine"
task :nagios_checks do
  $stderr.puts '---> Checking nagios::check titles are sufficiently unique'
  bad_lines = %x{grep -rnF --include '*.pp' nagios::check . | grep -Ev '^./modules/(nagios|monitoring/manifests/checks)' | grep -vF hostname}
  if !bad_lines.empty? then
    $stderr.puts bad_lines
    fail 'ERROR: nagios::check resource titles should be unique per machine. Normally you can achieve this by adding ${::hostname} eg "check_widgets_${::hostname}".'
  end
  $stderr.puts '---> Checking nagios::passive_check titles are sufficiently unique'
  bad_lines = %x{grep -rnF --include '*.pp' nagios::passive_check . | grep -Ev '^./modules/(nagios|monitoring/manifests/checks)' | grep -vF hostname}
  if !bad_lines.empty? then
    $stderr.puts bad_lines
    fail 'ERROR: nagios::passive_check resource titles should be unique per machine. Normally you can achieve this by adding ${::hostname} eg "check_widgets_${::hostname}".'
  end
end
