module Puppet::Parser::Functions
  newfunction(:monitoring_docs_url, :type => :rvalue, :doc => <<-EOS
Return a URL for documentation about one of our monitoring alerts

The argument should be the anchor that the documentation is located at
    EOS
  ) do |args|

    raise(ArgumentError, "monitoring_docs_url: Wrong number of arguments " +
      "given #{args.size} for 1") unless args.size == 1

    monitoring_docs_location = 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html'
    monitoring_docs_anchor = args[0]

    return "#{monitoring_docs_location}##{monitoring_docs_anchor}"
  end
end
