module Puppet::Parser::Functions
  newfunction(:monitoring_docs_url, :type => :rvalue, :doc => <<-EOS
Return a URL for documentation about one of our monitoring alerts

The first argument should be an anchor where the docs can be found

If the optional second argument is true, the first argument should be the
name of a page rather than a slug.
    EOS
  ) do |args|

    if args.size < 1 or args.size > 2
      raise(ArgumentError, "monitoring_docs_url: Wrong number of arguments " +
      "(given #{args.size})")
    end

    key = args[0]
    base_path = 'https://github.gds/pages/gds/opsmanual/2nd-line'

    if args[1]
      url = "#{base_path}/alerts/#{key}.html"
    else
      url = "#{base_path}/nagios.html##{key}"
    end

    return url
  end
end
