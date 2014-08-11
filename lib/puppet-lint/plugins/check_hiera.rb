# Check for explicit use of the `hiera()` function. We frown upon these
# because they result in arbitrarily namespaced keys and a splattering of
# places where data enters a manifest. They also require a third-party
# library to perform rspec tests with different contexts/datasets.
#
# We should instead use class params and rely on Puppet's automatic
# parameter lookup. Key names will always be namespaced to the module/class,
# so it's easy to see what's used where. Variables always appear at the top
# of the class. Testing can be performed with an ordinary `let(:params)`.
#
# http://docs.puppetlabs.com/hiera/1/puppet.html#automatic-parameter-lookup
#
# The `heira_hash()` and `hiera_array()` functions are exempt from this
# because of the current limitations with merge lookups:
#
# http://docs.puppetlabs.com/hiera/1/puppet.html#limitations
#
class PuppetLint::Plugins::CheckHiera < PuppetLint::CheckPlugin
  # Do NOT add to this whitelist without good reason.
  HIERA_WHITELIST = [
    # Used outside of module classes.
    'HIERA_SAFETY_CHECK',
    'lv',
    'mount',

    # Legacy, used everywhere.
    'app_domain',
    'asset_root',
    'website_root',

    # global var for gemfury, could do better
    'govuk_gemfury_source_url',

    # disk noops due to defined classes not doing magical hiera lookups
    'govuk::mount::no_op',
    'govuk::lvm::no_op',

    # logstream defined type needs a global disable flag for dev vm
    'govuk::logstream::disabled',
    # govuk::app::nginx_vhost defined type needs a global disable flag for
    # asset pipeline on dev vm
    'govuk::app::nginx_vhost::asset_pipeline_enabled',

    # FIXME: Existing violations. These should be refactored.
    'ci_alphagov_crt',
    'ci_alphagov_key',
    'deploy_ssh_keys',
    'efg_domain',
    'github_ca_cert',
    'govuk_app_enable_capistrano_layout',
    'govuk_app_enable_services',
    'http_password',
    'http_username',
    'internal_tld',
    'monitoring_domain_suffix',
    'monitoring_protected',
    'mirror::enable_checks',
    'mysql_nagios',
    'mysql_replica_password',
    'mysql_root',
    'mysql_whitehall_frontend',
    'nginx_enable_basic_auth',
    'nginx_enable_ssl',
    'smokey_bearer_token',
    'smokey_signon_email',
    'smokey_signon_password',
    'wildcard_alphagov_crt',
    'wildcard_alphagov_key',
    'wildcard_alphagov_mgmt_crt',
    'wildcard_alphagov_mgmt_key',
    'www_crt',
    'www_key',
  ]

  check 'hiera_explicit_lookup' do
    tokens.select { |t| t.type == :NAME and t.value == 'hiera' }.each do |func_token|
      next unless func_token.next_code_token.type == :LPAREN
      key_token = func_token.next_code_token.next_code_token

      notify :error, {
        :message    => "explicit hiera() lookup for '#{key_token.value}'",
        :linenumber => key_token.line,
        :column     => key_token.column,
      } unless HIERA_WHITELIST.include?(key_token.value)
    end
  end
end
