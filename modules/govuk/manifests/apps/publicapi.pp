class govuk::apps::publicapi {

  $app_domain = extlookup('app_domain')

  $privateapi = "contentapi.${app_domain}"
  $whitehallapi = "whitehall-frontend.${app_domain}"
  $backdropread = "read.backdrop.${app_domain}"

  $app_name = 'publicapi'
  $full_domain = "${app_name}.${app_domain}"

  nginx::config::vhost::proxy { $full_domain:
    to               => [$privateapi],
    protected        => false,
    ssl_only         => false,
    extra_app_config => "
      # Don't proxy_pass / anywhere, just return 404. All real requests will
      # be handled by the location blocks below.
      return 404;
    ",
    extra_config     => "
      expires 30m;

      # Specify these locations regexfully to avoid quirky Nginx behaviour
      # where a location block with a trailing slash triggers 301 redirects on
      # requests made to that path without a trailing slash, *if* there is a
      # proxy_pass directive in the block.

      location ~ ^/api/(specialist|worldwide-organisations|world-locations)(/|$) {
        proxy_set_header Host ${whitehallapi};
        proxy_pass http://${whitehallapi};
      }

      location ~ ^/api(/|$) {
        # Remove the prefix before passing through
        # Can't just do this using the proxy_pass URL, because we're
        # having to match the incoming path on a regular expression
        rewrite ^/api/?(.*) /\$1 break;

        proxy_set_header Host ${privateapi};
        proxy_set_header API-PREFIX api;
        proxy_set_header Authorization  \"\";
        proxy_pass http://${full_domain}-proxy;
      }

      location ~ ^/performance/licensing/api(/|$) {
        rewrite ^/performance/(.*?)/api/? /\$1 break;

        proxy_set_header Host ${backdropread};
        proxy_set_header X-API-PREFIX performance/licensing/api;

        proxy_pass http://${backdropread};
      }
    "
  }
}
