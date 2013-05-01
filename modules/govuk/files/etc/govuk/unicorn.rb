worker_processes 2
stdout_path "#{ENV.fetch('GOVUK_APP_LOGROOT')}/app.out.log"
stderr_path "#{ENV.fetch('GOVUK_APP_LOGROOT')}/app.err.log"
before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "#{ENV.fetch('GOVUK_APP_ROOT')}/Gemfile"
end

if self.respond_to?('check_client_connection')
  check_client_connection true
else
  warn "check_client_connection: will not enabled for Unicorn version < 4.5.0"
end
