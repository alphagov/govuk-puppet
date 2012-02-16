module Puppet::Parser::Functions
  newfunction(:facility_from_host, :type => :rvalue) do |args|
    args[0].split('.').first
  end
end
