require_relative '../../../../spec_helper'

describe 'govuk::app::envvar::mongodb_uri', :type => :define do
  let(:title) { 'giraffe' }

  context "with some good parameters" do
    let(:params) {{
      :hosts => ["db-1.example.com", "db-2.example.com"],
      :database => "foo_production",
    }}

    it "constructs a MONGODB_URI env var" do
      expect(subject).to contain_govuk__app__envvar('giraffe-MONGODB_URI')
        .with_app('giraffe')
        .with_varname('MONGODB_URI')
        .with_value('mongodb://db-1.example.com,db-2.example.com/foo_production')
    end
  end

  context "with username and password" do
    let(:params) {{
      :hosts => ["db-1.example.com", "db-2.example.com"],
      :database => "foo_production",
      :username => "jeff",
      :password => "secret",
    }}

    it "constructs a MONGODB_URI env var with authentication" do
      expect(subject).to contain_govuk__app__envvar('giraffe-MONGODB_URI')
        .with_app('giraffe')
        .with_varname('MONGODB_URI')
        .with_value('mongodb://jeff:secret@db-1.example.com,db-2.example.com/foo_production')
    end
  end

  context "with params" do
    let(:params) {{
      :hosts => ["db-1.example.com", "db-2.example.com"],
      :database => "foo_production",
      :username => "jeff",
      :password => "secret",
      :params => "ssl=true"
    }}

    it "constructs a MONGODB_URI env var with auth and ssl param" do
      expect(subject).to contain_govuk__app__envvar('giraffe-MONGODB_URI')
        .with_app('giraffe')
        .with_varname('MONGODB_URI')
        .with_value('mongodb://jeff:secret@db-1.example.com,db-2.example.com/foo_production?ssl=true')
    end
  end

  context "validating hosts" do
    let(:params) {{
      :database => "foo_production",
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
