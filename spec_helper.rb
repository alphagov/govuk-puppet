require 'rspec-puppet'
require 'puppet'
require 'puppetlabs_spec_helper/module_spec_helper'

HERE = File.expand_path(File.dirname(__FILE__))

RSpec.configure do |c|
  c.mock_framework = :rspec
  c.hiera_config = 'spec/fixtures/hiera/hiera.yaml'

  c.manifest    = File.join(HERE, 'manifests')
  c.module_path = [
    File.join(HERE, 'modules'),
    File.join(HERE, 'vendor', 'modules')
  ].join(':')

  c.order = 'rand'

  c.strict_variables = ENV['PUPPET_RSPEC_STRICT_VARIABLES'] == '1'

  if ENV['PUPPET_RSPEC_FUTURE_PARSER'] == '1'
    c.parser = 'future'
  end

  possible_releases = {
    'precise' => '12.04',
    'trusty'  => '14.04',
  }

  dist_preferred = ENV.fetch('DIST_PREFERRED', 'trusty')

  unless possible_releases.has_key?(dist_preferred)
    raise "DIST_PREFERRED must be one of " + possible_releases.keys.join(', ')
  end

  # Sensible defaults to satisfy modules that perform OS checking. These
  # keys can be overridden by more specific `let(:facts)` in spec contexts.
  c.default_facts = {
    :osfamily                => 'Debian',
    :operatingsystem         => 'Ubuntu',
    :operatingsystemrelease  => possible_releases[dist_preferred],
    :lsbdistid               => 'Debian',
    :lsbdistcodename         => dist_preferred.capitalize,
    :lsbmajdistrelease       => 14,
    :architecture            => 'amd64',
    :fqdn_metrics            => 'fakehost-1_management',
    :puppetversion           => '3.8.6',
    :kernel                  => 'Linux',
    :ipaddress_eth0          => '127.0.0.1',
  }

  c.after(:suite) do
    if ENV.fetch('FULL_COVERAGE_REPORT', false)
      RSpec::Puppet::Coverage.report!
    else
      # The report! method is hard-coded to use `puts` so the only way to
      # modify its behaviour is to capture STDOUT and re-write it here.
      captured_stdout = StringIO.new
      $stdout = captured_stdout

      RSpec::Puppet::Coverage.report!

      lines = $stdout.string.split("\n")

      # Only match the three lines we care about
      summary = lines.select{ |l| /^(?:Total|Touched|Resource)/ =~ l }.join("\n")
      STDOUT.puts "\n\n#{summary}"
    end
  end
end
