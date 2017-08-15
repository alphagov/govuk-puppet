module Puppet::Parser::Functions
  newfunction(:govuk_node_class, :type => :rvalue, :doc => <<EOS
Return the name to construct a `govuk::node::s_` class based on the variable
`$::trusted['extensions']['1.3.6.1.4.1.34380.1.1.13']` or `$::trusted['certname']`
if the first one is null. Requires `trusted_node_data` to be enabled. Takes no
arguments.

For `puppet agent` on VCLoud, this fact will be the FQDN on the certificate signed by
the master. On AWS, this will be the value of the '1.3.6.1.4.1.34380.1.1.13'
extension of the certificate. It cannot be spoofed to obtain the catalog/class of
another node.

For `puppet apply` on VCloud, the fact will just be the machine's FQDN. It will always
be spoofable because there is no SSL involved. On AWS, the fact will be the value
of the fact 'aws_migration', if it's present and not null.

When the class is extracted from the certname, it does so by taking the first part
(the unqualified hostname), stripping any numeric suffixes, and replacing hyphens
(valid for DNS) with underscores (valid for Puppet class names).
EOS
  ) do |args|

    raise(
      Puppet::ParseError,
      "govuk_node_class: Wrong number of arguments given #{args.size} for 0."
    ) unless args.size == 0

    # http://docs.puppetlabs.com/puppet/3/reference/lang_variables.html#trusted-node-data
    trusted_hash = lookupvar('::trusted')
    raise(
      Puppet::ParseError,
      "govuk_node_class: Unable to lookup $::trusted - is trusted_node_data enabled?"
    ) if trusted_hash.nil? or trusted_hash.empty?

    pp_role = trusted_hash['extensions']['1.3.6.1.4.1.34380.1.1.13']
    certname = trusted_hash['certname']
    authenticated = trusted_hash['authenticated']
    aws_migration = lookupvar('::aws_migration')

    # Puppet apply on AWS
    if authenticated == "local"
      return aws_migration unless (aws_migration.nil? || aws_migration.empty?)
    end

    # Puppet agent
    if (pp_role.nil? || pp_role.empty?)
      raise(
        Puppet::ParseError,
        "govuk_node_class: Unable to lookup $::trusted['certname']"
      ) if certname.nil? or certname.empty?

      hostname = certname.split('.').first
      class_name = hostname.gsub(/-\d+$/, '')
      class_name.gsub!('-', '_')
 
      return class_name
    else
      # From Puppet 4.1, use 'pp_role' extension name instead of the OID
      # https://docs.puppet.com/puppet/4.1/ssl_attributes_extensions.html
      return pp_role
    end 
  end
end
