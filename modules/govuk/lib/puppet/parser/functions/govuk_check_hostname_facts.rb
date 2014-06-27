module Puppet::Parser::Functions
  newfunction(:govuk_check_hostname_facts, :doc => <<EOS
Verify that the follow facts are present:

  - hostname
  - domain
  - fqdn

If not, raise an error which will fail the catalog.

TODO: Can this be replaced by `strict_variables`?
EOS
  ) do |args|
    %w{hostname domain fqdn}.each do |fact_name|
      fact = lookupvar("::#{fact_name}")
      if fact.nil? or fact.empty?
        raise(Puppet::Error, "govuk_check_hostname_facts: Cannot proceed without '#{fact_name}' fact")
      end
    end
  end
end
