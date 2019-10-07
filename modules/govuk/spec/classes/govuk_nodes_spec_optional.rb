require 'tempfile'
require 'yaml'

require_relative '../../../../spec_helper'

# This spec test has been renamed so as not to be caught by the default
# `rake spec` task. It is called explicitly by `rake spec:nodes`. Tag
# filtering was not appropriate because the glob and loop below get
# eagerly evaluated.

hosting = ENV['hosting']
case hosting
when 'carrenza'
  hiera_yml_name = 'hiera.yml'
  datadir = 'hieradata'
  aws_migration = false
when 'aws'
  hiera_yml_name = 'hiera_aws.yml'
  datadir = 'hieradata_aws'
  aws_migration = true
else
  raise "Unknown hosting: #{hosting}"
end

standard_hiera_config = YAML.load_file(
  File.expand_path("../../../../../#{hiera_yml_name}", __FILE__)
)

standard_hiera_config[:yaml][:datadir] = datadir
standard_hiera_config[:eyaml][:datadir] = datadir
standard_hiera_config[:eyaml][:gpg_gnupghome] = 'gpg'

temporary_hiera_file = Tempfile.new('hiera_yml')
temporary_hiera_file.write(standard_hiera_config.to_yaml)
temporary_hiera_file.close

ENV.fetch('classes').split(",").each do |class_name|
  node_hostname = class_name.tr("_", "-")

  describe "govuk::node::s_#{class_name}", :type => :class do
    let(:node) { "#{node_hostname}-1.example.com" }
    let(:facts) do
      {
        :environment => (class_name =~ /^development$/ ? "development" : 'vagrant'),
        :concat_basedir => '/var/lib/puppet/concat/',
        :kernel => 'Linux',
        :memorysize =>  '3.86 GB',
        :memorysize_mb => 3953.43,
        :aws_migration => aws_migration,
        :vdc => 'example',
      }
    end

    let(:hiera_config) { temporary_hiera_file.path }

    # Pull in some required bits from top-level site.pp
    let(:pre_condition) do
      <<-EOT
        $govuk_node_class = "#{class_name}"

        $lv = hiera('lv',{})
        create_resources('govuk_lvm', $lv)
        $mount = hiera('mount',{})
        create_resources('govuk_mount', $mount)
      EOT
    end

    it "should compile in #{hosting}" do
      expect { subject.call }.not_to raise_error
    end
  end
end
