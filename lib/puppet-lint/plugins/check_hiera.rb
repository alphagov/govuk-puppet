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
PuppetLint.new_check(:hiera_explicit_lookup) do
  # Do NOT add to this whitelist without good reason.
  HIERA_WHITELIST = [
    # Used outside of module classes.
    'HIERA_SAFETY_CHECK',
    'HIERA_EYAML_GPG_CHECK',
    'lv',
    'mount',

    # Legacy, used everywhere.
    'app_domain',

    # disk noops due to defined classes not doing magical hiera lookups
    'govuk_mount::no_op',
    'govuk_lvm::no_op',

    # govuk::app::nginx_vhost defined type needs a global disable flag for
    # asset pipeline on dev vm
    'govuk::app::nginx_vhost::asset_pipeline_enabled',

    # FIXME: Existing violations. These should be refactored.
    'govuk_app_enable_capistrano_layout',
    'govuk_app_enable_services',

    # logstream defined type needs a global disable flag for dev vm
    'govuk_logging::logstream::disabled',

    'mysql_replica_password',
    'mysql_root',
    'nginx_enable_ssl',
    'wildcard_publishing_certificate',
    'wildcard_publishing_key',
    'www_crt',
    'www_key',
  ]
  def check
    tokens.select { |t| t.type == :NAME and t.value == 'hiera' }.each do |func_token|
      next unless func_token.next_code_token.type == :LPAREN
      key_token = func_token.next_code_token.next_code_token

      notify :error, {
        :message    => "explicit hiera() lookup for '#{key_token.value}'",
        :line       => key_token.line,
        :column     => key_token.column,
      } unless HIERA_WHITELIST.include?(key_token.value)
    end
  end
end
