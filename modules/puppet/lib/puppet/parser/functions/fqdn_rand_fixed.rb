module Puppet::Parser::Functions
  newfunction(:fqdn_rand_fixed, :type => :rvalue, :doc =>
"like fqdn_rand from puppet core, but with bug #8814 fixed") do |args|
    require 'digest/md5'
    max = args.shift.to_i
    srand(Digest::MD5.hexdigest([lookupvar('::fqdn'),args].join(':')).hex)
    rand(max).to_s
  end
end
