require_relative '../../../../spec_helper'

# This spec test has been renamed so as not to be caught by the default
# `rake spec` task. It is called explicitly by `rake spec:nodes`. Tag
# filtering was not appropriate because the glob and loop below get
# eagerly evaluated.

def class_list
  if ENV["classes"]
    ENV["classes"].split(",")
  else
    class_dir = File.expand_path("../../../manifests/node", __FILE__)
    Dir.glob("#{class_dir}/*.pp").collect { |dir|
      dir.gsub(/^#{class_dir}\/s_(.+)\.pp$/, '\1')
    }
  end
end

describe "govuk::node classes" do
  pending "FIXME: This was broken by the upgrade to rspec-puppet 1.x"

  class_list.each do |govuk_class|
    fqdn = "#{govuk_class.gsub('_', '-')}-1.example.com"

    describe fqdn, :type => :host do
      let(:node) { fqdn }
      let(:facts) {{
        :clientcert     => fqdn,
        :memtotalmb     => "1024",
      }}

      it { should contain_class("govuk::node::s_#{govuk_class}") }
    end
  end
end
