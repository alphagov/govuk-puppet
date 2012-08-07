worker_processes 2
stdout_path "#{ENV.fetch('GOVUK_APP_LOGROOT')}/app.out.log"
stderr_path "#{ENV.fetch('GOVUK_APP_LOGROOT')}/app.err.log"
before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "#{ENV.fetch('GOVUK_APP_ROOT')}/Gemfile"
end
