module Puppet::Parser::Functions
  newfunction(:ec2_aws_hostname, :type => :rvalue, :doc => <<EOS
Return the value of the aws_hostname tag in aws.
EOS
  ) do |args|

    aws_hostname = lookupvar('::aws_hostname')

    # Puppet apply on AWS
    if authenticated == "local"
      return aws_hostname unless (aws_hostname.nil? || aws_hostname.empty?)
    end

    return "none"
    end
  end
end
