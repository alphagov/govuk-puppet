module Puppet::Parser::Functions
  newfunction(:kibana5_url, :type => :rvalue, :doc => <<-EOS
Craft a URL for a Kibana5 search. Positional arguments:

1. BaseURL of your Kibana instance
2. Search hash: containing `query` and (optionally) `from` period.
    EOS
  ) do |args|

    raise(ArgumentError, "kibana5_url: Wrong number of arguments " +
      "given #{args.size} for 2") unless args.size == 2

    base_url = args[0]
    search_hash = args[1]
    logstash_dash_path = "/app/kibana#/discover"

    raise(ArgumentError, "kibana5_url: No 'query' key found in hash") \
      unless search_hash.has_key?('query')

    # https://github.com/elasticsearch/kibana/issues/1284
    raise(ArgumentError, "kibana5_url: Query must use single quotes instead of double") \
      if search_hash['query'].include?('"')

    if search_hash.has_key?('from')
      query_prefix = URI.encode("_g=(refreshInterval:(display:Off,pause:!f,value:0),time:(from:now-#{search_hash['from']},mode:quick,to:now))")
    else
      query_prefix = URI.encode("_g=()")
    end

    query_middle = URI.encode("&_a=(columns:!(_source),index:'*-*',interval:auto,query:(query_string:(analyze_wildcard:!t,query:'")
    query_suffix = URI.encode("')),sort:!('@timestamp',desc))")

    base_url.chomp!('/')
    query_params = search_hash['query']
    # Convert spaces because not application/x-www-form-urlencoded
    #query_params.gsub!('+', '%20')
    query_params.gsub!(' ', '+')

    "#{base_url}#{logstash_dash_path}?#{query_prefix}#{query_middle}#{query_params}#{query_suffix}"
  end
end
