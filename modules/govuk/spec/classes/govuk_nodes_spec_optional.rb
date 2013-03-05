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
  class_list.each do |govuk_class|
    describe govuk_class, :type => :host do
      let(:facts) {{
        :govuk_class => govuk_class,
        :govuk_platform => "test",
        :osfamily => "Debian",
        :operatingsystem => "Ubuntu",
        :lsbdistcodename => "Precise",
        :memtotalmb => "1024",
      }}

      it { should include_class("govuk::node::s_#{govuk_class}") }
    end
  end
end
