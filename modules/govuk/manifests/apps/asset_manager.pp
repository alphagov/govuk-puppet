# class: govuk::apps::asset_manager
#
# Asset Manager manages uploaded assets (images, PDFs, etc.) for
# various applications, as an API and an asset-serving mechanism.
#
# === Parameters
#
# [*port*]
#   The port that Asset Manager is served on.
#   Default: 3037
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker
#   Default: true
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*oauth_id*]
#   Sets the OAuth ID
# [*oauth_secret*]
#   Sets the OAuth Secret Key
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
# [*mongodb_nodes*]
#   An array of MongoDB instance hostnames
# [*mongodb_name*]
#   The name of the MongoDB database to use
# [*aws_s3_bucket_name*]
#   The name of the AWS S3 bucket to use for storing/serving assets
# [*aws_region*]
#   AWS region of the S3 bucket
# [*aws_access_key_id*]
#   AWS access key for a user with permission to write to the S3 bucket
# [*aws_secret_access_key*]
#   AWS secret key for a user with permission to write to the S3 bucket
# [*proxy_percentage_of_asset_requests_to_s3_via_nginx*]
#   Value between 0 and 100 controlling the percentage of traffic that should
#   be served by proxying the asset from S3
# [*proxy_percentage_of_whitehall_asset_requests_to_s3_via_nginx*]
#   Value between 0 and 100 controlling the percentage of traffic that should
#   be served by proxying the Whitehall asset from S3
# [*redis_host*]
#   Redis host for Sidekiq.
#   Default: undef
# [*redis_port*]
#   Redis port for Sidekiq.
#   Default: undef
#
class govuk::apps::asset_manager(
  $enabled = true,
  $port = '3037',
  $enable_procfile_worker = true,
  $sentry_dsn = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $secret_key_base = undef,
  $mongodb_nodes,
  $mongodb_name = 'govuk_assets_production',
  $aws_s3_bucket_name = undef,
  $aws_region = undef,
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $proxy_percentage_of_asset_requests_to_s3_via_nginx = '0',
  $proxy_percentage_of_whitehall_asset_requests_to_s3_via_nginx = '0',
  $redis_host = undef,
  $redis_port = undef
) {

  $app_name = 'asset-manager'

  if $enabled {
    include assets
    include clamav

    $app_domain = hiera('app_domain')

    govuk::app::envvar {
      "${title}-PRIVATE_ASSET_MANAGER_HOST":
        app     => 'asset-manager',
        varname => 'PRIVATE_ASSET_MANAGER_HOST',
        value   => "private-asset-manager.${app_domain}";
    }

    Govuk::App::Envvar {
      app => $app_name,
    }

    # The X-Frame-Options response header is set explicitly in the
    # relevant location blocks.
    $deny_framing = false

    $nginx_extra_config = inline_template('
      client_max_body_size 500m;

      # Instruct Nginx to set "Sendfile" headers for both Mainstream and
      # Whitehall public asset URLs. The Rails app will respond with the
      # X-Accel-Redirect header set to a path prefixed with /raw/ which will
      # be handled by the internal `/raw/(.*)` location block below.
      location ~ ^/(media|government/uploads)/(.*) {
         proxy_set_header X-Sendfile-Type X-Accel-Redirect;
         proxy_set_header X-Accel-Mapping /var/apps/asset-manager/uploads/assets/=/raw/;

         proxy_pass http://asset-manager.intentionally-broken-<%= @app_domain %>-proxy;
       }

      # /raw/(.*) is the path mapping sent from the rails application to
      # nginx and is immediately picked up. /raw/(.*) is not available
      # publicly as it is an internal path mapping.
      location ~ /raw/(.*) {
        internal;
        add_header GOVUK-Asset-Manager-File-Store NFS;

        # Control whether the asset can be embedded in other pages[1] by
        # respecting X-Frame-Options from the Rails application.
        # [1]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options
        add_header X-Frame-Options $upstream_http_x_frame_options;

        alias /var/apps/asset-manager/uploads/assets/$1;
      }

      # Store values from Rails response headers for use in the
      # cloud-storage-proxy location block below.
      set $etag_from_rails $upstream_http_etag;
      set $last_modified_from_rails $upstream_http_last_modified;
      set $content_type_from_rails $upstream_http_content_type;
      set $x_frame_options_from_rails $upstream_http_x_frame_options;

      location ~ /cloud-storage-proxy/(.*) {
        # Prevent requests to this location from outside nginx
        internal;

        # Construct download URL from:
        # $1:       Host + path from regexp match in location
        # $is_args: Optional ? delimiter
        # $args:    Optional querystring params
        set $download_url $1$is_args$args;

        add_header GOVUK-Asset-Manager-File-Store S3;

        # The X-CLOUD-STORAGE-URL header contains a signed URL for the asset on
        # S3. The signature of this URL is based in part on the request headers
        # set in the asset-manager Rails app at the time the URL is generated.
        # The headers we send now must match otherwise nginx will not be
        # allowed to make the request. Since this location block inherits
        # `proxy_set_header` directives from previous levels[1], we explicitly
        # set the Host so that the inherited headers are over-written.
        #
        # [1] http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_header
        proxy_set_header Host $proxy_host;

        # Set response headers in the proxied response based on values stored
        # from the Rails response headers. This is so that the Rails app can
        # remain the canonical source of response headers, even though we are
        # proxying the request to S3. This is particularly relevant in the case
        # of ETag & Last-Modified, because we want keep these the same as when
        # Nginx serves the files from NFS to avoid unnecessary cache
        # invalidation. Note that Cache-Control & Content-Disposition headers
        # are copied from the Rails response into the proxied response by
        # default, so we do not have to do that explicitly here.
        add_header ETag $etag_from_rails;
        add_header Last-Modified $last_modified_from_rails;
        add_header Content-Type $content_type_from_rails;

        # Control whether the asset can be embedded in other pages[1] by
        # respecting X-Frame-Options from the Rails application.
        # [1]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options
        add_header X-Frame-Options $x_frame_options_from_rails;

        # Remove S3 HTTP headers including those listed in:
        # http://docs.aws.amazon.com/AmazonS3/latest/API/RESTCommonResponseHeaders.html
        # This keeps this HTTP response as similar as possible to the response
        # sent when using Sendfile to serve files from NFS
        proxy_hide_header x-amz-delete-marker;
        proxy_hide_header x-amz-id-2;
        proxy_hide_header x-amz-request-id;
        proxy_hide_header x-amz-version-id;
        proxy_hide_header x-amz-replication-status;
        proxy_hide_header x-amz-meta-md5-hexdigest;

        # Add Google DNS server to avoid "no resolver defined to resolve"
        # errors when trying to connect to S3
        resolver 8.8.8.8;

        # Download the file and send it to client
        proxy_pass $download_url;
      }
    ')

    govuk::app { $app_name:
      app_type           => 'rack',
      port               => $port,
      sentry_dsn         => $sentry_dsn,
      vhost_ssl_only     => true,
      health_check_path  => '/healthcheck',
      vhost_aliases      => ['private-asset-manager'],
      log_format_is_json => true,
      deny_framing       => $deny_framing,
      depends_on_nfs     => true,
      nginx_extra_config => $nginx_extra_config,
    }

    govuk::app::envvar {
      "${title}-OAUTH_ID":
        varname => 'OAUTH_ID',
        value   => $oauth_id;
      "${title}-OAUTH_SECRET":
        varname => 'OAUTH_SECRET',
        value   => $oauth_secret;
    }

    govuk::app::envvar::redis { $app_name:
      host => $redis_host,
      port => $redis_port,
    }

    if $secret_key_base {
      govuk::app::envvar {
        "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
      }
    }

    govuk::app::envvar::mongodb_uri { $app_name:
      hosts    => $mongodb_nodes,
      database => $mongodb_name,
    }

    govuk::procfile::worker { $app_name:
      enable_service => $enable_procfile_worker,
    }

    govuk::app::envvar {
      "${title}-AWS_S3_BUCKET":
        varname => 'AWS_S3_BUCKET_NAME',
        value   => $aws_s3_bucket_name;
      "${title}-AWS_REGION":
        varname => 'AWS_REGION',
        value   => $aws_region;
      "${title}-AWS_ACCESS_KEY":
        varname => 'AWS_ACCESS_KEY',
        value   => $aws_access_key_id;
      "${title}-AWS_SECRET_KEY":
        varname => 'AWS_SECRET_KEY',
        value   => $aws_secret_access_key;
    }

    # Write the environment variable to configure the percentage of requests
    # that should be served by proxying the request to S3 via nginx
    govuk::app::envvar {
      "${title}-PROXY_PERCENTAGE_OF_ASSET_REQUESTS_TO_S3_VIA_NGINX":
        varname => 'PROXY_PERCENTAGE_OF_ASSET_REQUESTS_TO_S3_VIA_NGINX',
        value   => $proxy_percentage_of_asset_requests_to_s3_via_nginx;
    }

    # Write the environment variable to configure the percentage of Whitehall
    # asset requests that should be served by proxying the request to S3 via
    # nginx
    govuk::app::envvar {
      "${title}-PROXY_PERCENTAGE_OF_WHITEHALL_ASSET_REQUESTS_TO_S3_VIA_NGINX":
        varname => 'PROXY_PERCENTAGE_OF_WHITEHALL_ASSET_REQUESTS_TO_S3_VIA_NGINX',
        value   => $proxy_percentage_of_whitehall_asset_requests_to_s3_via_nginx;
    }
  }
}
