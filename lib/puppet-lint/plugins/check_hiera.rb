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
    'use_hiera_disks',

    # Legacy, used everywhere.
    'app_domain',
    'asset_root',
    'website_host',
    'website_root',

    # disk noops due to defined classes not doing magical hiera lookups
    'govuk::mount::no_op',
    'govuk::lvm::no_op',

    # FIXME: Existing violations. These should be refactored.
    'aws_ses_smtp_host',
    'aws_ses_smtp_username',
    'aws_ses_smtp_password',
    'deploy_ssh_keys',
    'mirror::enable_checks',
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
