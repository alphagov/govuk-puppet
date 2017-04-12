module Puppet::Parser::Functions
  newfunction(:monitoring_docs_url, :type => :rvalue, :doc => <<-EOS
Return a URL for documentation about one of our monitoring alerts

The argument should be the filename where the docs can be found
    EOS
  ) do |args|

    if args.size != 1
      raise(ArgumentError, "monitoring_docs_url: Wrong number of arguments " +
      "(given #{args.size})")
    end

    key = args[0]

    return "https://docs.publishing.service.gov.uk/manual/alerts/#{key}.html"
  end
end
