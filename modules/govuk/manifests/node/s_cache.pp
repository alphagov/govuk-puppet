class govuk::node::s_cache inherits govuk::node::s_base {

  $protect_cache_servers    = str2bool(extlookup('protect_cache_servers', 'no'))
  $extlookup_real_ip_header = extlookup('cache_real_ip_header', '')

  # FIXME: extlookup() can't return a real `undef` value. So we have to
  # proxy it to preserve the class's own default.
  $cache_real_ip_header = $extlookup_real_ip_header ? {
    ''      => undef,
    default => $extlookup_real_ip_header,
  }

  include govuk::htpasswd
  include nginx

  class { 'router::nginx':
    vhost_protected => $protect_cache_servers,
    real_ip_header  => $cache_real_ip_header,
  }

  # the assets-origin stuff here is WIP, will be extracted into a
  # separate class before finishing the story
  # -- @philippotter 2013-06-19
  $app_domain = extlookup('app_domain')
  # suspect we want `protected => false` here
  # once appropriate firewalling is in place?
  nginx::config::site { 'assets-origin.digital.cabinet-office.gov.uk':
    content => '
# This file is managed by Puppet. Local changes will be clobbered.
server {
  server_name assets-origin.digital.cabinet-office.gov.uk ;
  listen 80;
  rewrite ^/(.*) https://$server_name/$1 permanent;
}

server {
  server_name assets-origin.digital.cabinet-office.gov.uk ;

  listen              443 ssl;
  ssl_certificate     /etc/nginx/ssl/assets-origin.digital.cabinet-office.gov.uk.crt;
  ssl_certificate_key /etc/nginx/ssl/assets-origin.digital.cabinet-office.gov.uk.key;
  include             /etc/nginx/ssl.conf;

  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Forwarded-Server $host;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_redirect off;

  access_log /var/log/nginx/assets-origin.digital.cabinet-office.gov.uk-access.log timed_combined;
  access_log /var/log/nginx/assets-origin.digital.cabinet-office.gov.uk-json.event.access.log json_event;
  error_log /var/log/nginx/assets-origin.digital.cabinet-office.gov.uk-error.log;

  location / {
    proxy_pass http://static.preview.alphagov.co.uk;
  }
}
    ',
  }
  nginx::log {
    $json_access_log:
      json          => true,
      logstream     => true,
      statsd_metric => "${::fqdn_underscore}.nginx_logs.assets-origin.http_%{@fields.status}";
    $access_log:
      logstream => false;
    $error_log:
      logstream => true;
  }

  # Set the varnish storage size to 75% of memory
  $varnish_storage_size = $::memtotalmb / 4 * 3
  class { 'varnish':
    storage_size => join([$varnish_storage_size,'M'],''),
    default_ttl  => '900',
  }

  # Close connection if vhost not known
  nginx::config::vhost::default { 'default':
    status         => '444',
    status_message => '',
  }

  case $::govuk_provider {
    'sky': {
        ufw::allow { 'Allow varnish cache bust from backend machines':
          from => '10.3.0.0/24',
          port => '7999'
        }
    }
    default: {}
  }
}
