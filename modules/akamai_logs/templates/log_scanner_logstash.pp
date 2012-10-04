input {
  file {
    type => "datainsight-<%= @app_name %>-collector-app"
    path => "/data/vhost/<%= @app_name %>/shared/log/*.log"
  }
}