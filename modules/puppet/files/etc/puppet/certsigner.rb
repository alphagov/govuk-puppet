#!/usr/bin/env ruby

require 'etc'

ENV['HOME'] = Etc.getpwuid(Process.uid).dir

require 'puppet'
require 'puppet/ssl/certificate_request'
require 'aws-sdk-ec2'

certname = ARGV.pop
csr = Puppet::SSL::CertificateRequest.from_s(STDIN.read)

# because we aren't loading all of puppet we don't have the full mappings
# keeping it simple, just using their OID numbers
# https://docs.puppetlabs.com/puppet/latest/reference/ssl_attributes_extensions.html#puppet-specific-registered-ids

instance_id = csr.request_extensions.find { |a| a['oid'] == 'pp_instance_id' }['value']
ami_id = csr.request_extensions.find { |a| a['oid'] == 'pp_image_name' }['value']
aws_region = csr.request_extensions.find { |a| a['oid'] == '1.3.6.1.4.1.34380.1.1.18' }['value']

returncode = 100

ec2 = Aws::EC2::Client.new( region: aws_region )

server = ec2.describe_instances({
  instance_ids: [instance_id],
  filters: [
    {
      name: 'instance-state-name',
      values: ['running']
    },
  ],
})

tags = server.reservations[0].instances[0].tags
image_id = server.reservations[0].instances[0].image_id

# we are checking to see if this instance has already been signed
signed = false
tags.each do |tag|
  if tag.key == 'puppet_cert_signed'
    signed = true
  end
end

# lets make sure we can get a positive match also, this assumes you are using
# pp_image_name in csr_attributes.yaml
if image_id == ami_id
  ami_match = true
else
  ami_match = false
end

# the only time we can sign this cert is if this instance hasn't been given a signed
# cert before and we match on the instance in AWS also
if signed != true && ami_match == true
  ec2.create_tags({
    resources: [instance_id],
    tags: [
      {
        key: 'puppet_cert_signed',
        value: certname,
      },
    ],
  })
  returncode = 0
else
  returncode = 200
end

exit returncode
