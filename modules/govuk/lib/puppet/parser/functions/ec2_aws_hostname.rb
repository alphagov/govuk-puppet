module Puppet::Parser::Functions
  newfunction(:ec2_aws_hostname, :type => :rvalue, :doc => <<EOS
Return the value of the aws_hostname tag in aws.
EOS
  ) do |args|

    aws_hostname = lookupvar('::aws_hostname')

    if (aws_hostname.nil? || aws_hostname.empty?)
      return "none"
    else
      return aws_hostname
    end
  end
end
