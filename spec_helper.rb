require 'csv'
require 'rspec-puppet'

# Mock out extdata for the purposes of testing. The actual solution (below) is
# astonishingly ugly, and involves monkeypatching pieces of ruby stdlib that
# the extant extlookup function relies on.
#
# Ideally, we could do something like this:
#
#     require 'puppet/parser/functions/extlookup'
#
#     module Puppet::Parser::Functions
#       newfunction(:extlookup, :type => :rvalue) do |args|
#         key, default = args
#         {
#           'app_domain' => 'test.gov.uk',
#         }[key] || default or raise Puppet::ParseError, "No match found for '#{key}' in any data file during extlookup()"
#       end
#     end
#
# and indeed it looks like this should work in Puppet >= 3.0.0, where the
# appropriate line in puppet/parser/functions.rb reads
#
#     Puppet.warning "Overwriting previous definition for function #{name}" if get_function(name)
#
# but unfortunately, the same line in 2.7.x reads
#
#     raise Puppet::DevError, "Function #{name} already defined" if functions.include?(name)
#
# In summary: FIXME -- remove the monstrosity that is MockExtdata.
#
#  - NS 2012-10-31

module MockExtdata

  def set_extdata(h)
    @mock_extdata = h
  end

  def update_extdata(h)
    @mock_extdata.merge!(h)
  end

  def setup_extdata_stubs
    @mock_extdata ||= {}

    old_exists = File.method(:exists?)
    File.stub(:exists?) do |f|
      if f =~ /extdata\/[^\/]*\.csv$/
        true
      else
        old_exists.call(f)
      end
    end

    old_read = CSV.method(:read)
    CSV.stub(:read) do |f, *args|
      if f =~ /extdata\/[^\/]*\.csv$/
        @mock_extdata.to_a
      else
        old_read.call(f, *args)
      end
    end
  end

end

HERE = File.expand_path(File.dirname(__FILE__))

RSpec.configure do |c|
  c.module_path = File.join(HERE, 'modules')
  c.manifest    = File.join(HERE, 'manifests', 'site.pp')

  c.include MockExtdata

  c.before do
    setup_extdata_stubs
    set_extdata({
      'app_domain'    => 'test.gov.uk',
      'http_username' => 'test_username',
      'http_password' => 'test_password'
    })
  end
end
