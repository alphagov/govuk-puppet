desc "Test icinga::checks are unique per machine"
task :icinga_checks do
  $stderr.puts '---> Checking icinga::check titles are sufficiently unique'
  bad_lines = %x{grep -rnF --include '*.pp' icinga::check . | grep -Ev '^./modules/(icinga|monitoring/manifests/checks)' | grep -vF hostname}
  if !bad_lines.empty? then
    $stderr.puts bad_lines
    fail 'ERROR: icinga::check resource titles should be unique per machine. Normally you can achieve this by adding ${::hostname} eg "check_widgets_${::hostname}".'
  end
  $stderr.puts '---> Checking icinga::passive_check titles are sufficiently unique'
  bad_lines = %x{grep -rnF --include '*.pp' icinga::passive_check . | grep -Ev '^./modules/(icinga|monitoring/manifests/checks)' | grep -vF hostname}
  if !bad_lines.empty? then
    $stderr.puts bad_lines
    fail 'ERROR: icinga::passive_check resource titles should be unique per machine. Normally you can achieve this by adding ${::hostname} eg "check_widgets_${::hostname}".'
  end
end
