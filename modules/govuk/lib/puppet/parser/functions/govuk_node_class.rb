module Puppet::Parser::Functions
  newfunction(:govuk_node_class, :type => :rvalue, :doc => <<EOS
Return the name to construct a `govuk::node::s_` class based on a client's
`$::clientcert` fact. Takes no arguments.

For `puppet agent` this fact will be the FQDN on the certificate signed by
the master. However it is currently spoofable; see FIXME below.

For `puppet apply` the fact will just be the machine's FQDN, but will always
be spoofable.

It does so by taking the first part (the unqualified hostname), stripping
any numeric suffixes, and replacing hyphens (valid for DNS) with underscores
(valid for Puppet class names).
EOS
  ) do |args|

    raise(
      Puppet::ParseError,
      "govuk_node_class: Wrong number of arguments given #{args.size} for 0."
    ) unless args.size == 0

    # FIXME: Use $trusted variable in Puppet 3.4 to prevent spoofing:
    # http://docs.puppetlabs.com/puppet/latest/reference/lang_variables.html#trusted-node-data
    clientcert = lookupvar('::clientcert')

    raise(
      Puppet::ParseError,
      "govuk_node_class: Unable to lookup $::clientcert"
    ) if clientcert.nil?

    hostname = clientcert.split('.').first
    class_name = hostname.gsub(/-\d+$/, '')
    class_name.gsub!('-', '_')

    class_name
  end
end
