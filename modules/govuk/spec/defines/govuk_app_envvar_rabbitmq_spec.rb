require_relative '../../../../spec_helper'

describe 'govuk::app::envvar::rabbitmq', :type => :define do
  let(:title) { 'giraffe' }

  context "with some good parameters" do
    let(:params) {{
      :user => "postgresql",
      :password => "super_secret",
      :hosts => ["db-1.example.com", "db-2.example.com"],
    }}

    it "combines the hosts into RABBITMQ_HOSTS" do
      expect(subject).to contain_govuk__app__envvar("giraffe-RABBITMQ_HOSTS")
        .with_app('giraffe')
        .with_varname('RABBITMQ_HOSTS')
        .with_value("db-1.example.com,db-2.example.com")
    end

    it "sets the vhost to / by default" do
      expect(subject).to contain_govuk__app__envvar("giraffe-RABBITMQ_VHOST")
        .with_app('giraffe')
        .with_varname('RABBITMQ_VHOST')
        .with_value("/")
    end

    it "allows overriding the vhost" do
      params[:vhost] = '/other-vhost'
      expect(subject).to contain_govuk__app__envvar("giraffe-RABBITMQ_VHOST")
        .with_app('giraffe')
        .with_varname('RABBITMQ_VHOST')
        .with_value("/other-vhost")
    end
  end

  context "validating hosts" do
    let(:params) {{
      :user => "postgresql",
      :password => "super_secret",
    }}

    it "errors if not given an array of hosts" do
      params[:hosts] = "foo.example.com"

      expect(subject).to compile.and_raise_error(/is not an Array/)
    end

    it "errors if not given any hosts" do
      params[:hosts] = []

      expect(subject).to compile.and_raise_error(/must pass hosts/)
    end
  end
end
