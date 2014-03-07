module Puppet::Parser::Functions
  newfunction(:kibana2_url, :type => :rvalue, :doc => <<-EOS
Craft a URL for a Kibana 2 search. Takes two positional arguments:
    Base URL: That you would normally use to visit Kibana.
    Search hash: Search terms which will be converted to JSON and then base64 encoded.
    EOS
  ) do |args|

    raise(ArgumentError, "kibana2_url: Wrong number of arguments " +
      "given #{args.size} for 2.") unless args.size == 2

    base_url = args[0]
    search_hash = args[1]

    raise(ArgumentError, "kibana2_url: No 'search' key found in hash.") \
      unless args[1].has_key?('search')

    require 'json'
    require 'base64'

    search_defaults = {
      'fields' => [],
    }

    base_url.chomp!('/')
    search_b64 = Base64.urlsafe_encode64(
      search_defaults.merge(search_hash).to_json
    )

    return "#{base_url}/##{search_b64}"
  end
end
