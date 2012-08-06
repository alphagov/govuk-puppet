worker_processes 2
stdout_path "#{ENV.fetch('GOVUK_APP_LOGROOT')}/app.out.log"
stderr_path "#{ENV.fetch('GOVUK_APP_LOGROOT')}/app.err.log"
