module Puppet::Parser::Functions
  newfunction(:kibana3_url, :type => :rvalue, :doc => <<-EOS
Craft a URL for a Kibana3 search. Positional arguments:

1. Base URL: the root of your Kibana installation.
2. Search hash: containing `query` and (optionally) `from` period.

It assumes that the logstash dashboard is available as default.json
    EOS
  ) do |args|

    raise(ArgumentError, "kibana3_url: Wrong number of arguments " +
      "given #{args.size} for 2") unless args.size == 2

    base_url = args[0]
    search_hash = args[1]
    logstash_dash_path = "/kibana/#/dashboard/file/default.json"

    raise(ArgumentError, "kibana3_url: No 'query' key found in hash") \
      unless search_hash.has_key?('query')

    # https://github.com/elasticsearch/kibana/issues/1284
    raise(ArgumentError, "kibana3_url: Query must use single quotes instead of double") \
      if search_hash['query'].include?('"')

    base_url.chomp!('/')
    query_params = URI.encode_www_form(search_hash)
    # Convert spaces because not application/x-www-form-urlencoded
    query_params.gsub!('+', '%20')

    return "#{base_url}#{logstash_dash_path}?#{query_params}"
  end
end
