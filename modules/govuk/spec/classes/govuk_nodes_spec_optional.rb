require_relative '../../../../spec_helper'

# This spec test has been renamed so as not to be caught by the default
# `rake spec` task. It is called explicitly by `rake spec:nodes`. Tag
# filtering was not appropriate because the glob and loop below get
# eagerly evaluated.

# Don't attempt to instantiate these classes as they aren't concrete
# machine classes, and therefore aren't intended to be instantiated directly.
blacklist_classes = %w(
  asset_base
  base
  postgresql_base
  redis_base
  ruby_app_server
  test
  transition_postgresql_base
)

hiera_conf = YAML.load_file(File.expand_path("../../../../../hiera.yml", __FILE__))
hiera_conf[:yaml][:datadir] = File.expand_path("../../../../../hieradata", __FILE__)
hiera_conf[:eyaml][:datadir] = hiera_conf[:yaml][:datadir]
hiera_conf[:eyaml][:gpg_gnupghome] = File.expand_path("../../../../../gpg", __FILE__)

Dir.glob(File.expand_path("../../../manifests/node/s_*.pp", __FILE__)).each do |filepath|
  class_name = File.basename(filepath, ".pp")[2..-1] # Strip leading s_
  next if blacklist_classes.include?(class_name)

  node_hostname = class_name.tr("_", "-")

  describe "govuk::node::s_#{class_name}", :type => :class do
    let(:node) { "#{node_hostname}-1.example.com" }
    let(:facts) {{
      :environment => (class_name == "development" ? "development" : 'vagrant'),
      :concat_basedir => '/var/lib/puppet/concat/',
      :kernel => 'Linux',
      :memorysize =>  '3.86 GB',
      :memtotalmb => 3953,
    }}

    let(:hiera_config) { hiera_conf }

    # Pull in some required bits from top-level site.pp
    let(:pre_condition) { <<-EOT
$govuk_node_class = "#{class_name}"

$lv = hiera('lv',{})
create_resources('govuk::lvm', $lv)
$mount = hiera('mount',{})
create_resources('govuk::mount', $mount)
      EOT
    }

    it "should compile" do
      expect { subject }.not_to raise_error
    end
  end
end
