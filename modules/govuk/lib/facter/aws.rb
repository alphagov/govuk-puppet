# Produces a bunch of AWS facts specific to each instance:
#
# availabilityzone
# instanceid
# instancetype
# imageid
# accountid
# region
#
# Fact name will be the key above prefixed with "aws_"
#
require 'net/http'
require 'json'

# Lazily loads all the following information into JSON object:
#   devpayproductcodes
#   privateip
#   availabilityzone
#   version
#   instanceid
#   billingproducts
#   instancetype
#   imageid
#   accountid
#   kernelid
#   ramdiskid
#   architecture
#   pendingtime
#   region
#
def aws_facts
  uri = URI.parse("http://169.254.169.254/latest/dynamic/instance-identity/document")
  body = Net::HTTP.get_response(uri).body
  JSON.parse(body)
end

if Facter.value(:aws_migration)
  # Choose the facts we think are useful
  facts = [
    'availabilityzone',
    'instanceid',
    'instancetype',
    'imageid',
    'accountid',
    'region',
  ]

  # Loop through every fact but only add it if it's in our list
  aws_facts.each do |key,val|
  factname = key.downcase
    if facts.include?(factname)
      Facter.add("aws_#{factname}") do
        setcode do
          val
        end
      end
    end
  end
end
