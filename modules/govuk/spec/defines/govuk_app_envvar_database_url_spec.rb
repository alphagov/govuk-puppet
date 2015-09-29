require_relative '../../../../spec_helper'

describe 'govuk::app::envvar::database_url', :type => :define do
  let(:title) { 'giraffe' }

  context "with some good parameters" do
    let(:params) {{
      :type => "postgresql",
      :username => "test",
      :password => "super_secret",
      :host => "db.example.com",
      :database => "foo_production",
    }}

    it "constructs a DATABASE_URL env var" do
      expect(subject).to contain_govuk__app__envvar('giraffe-DATABASE_URL')
        .with_app('giraffe')
        .with_varname('DATABASE_URL')
        .with_value('postgresql://test:super_secret@db.example.com/foo_production')
    end

    it "escapes special characters in the password" do
      params[:password] = "s%up:er/sec@r+et"
      expect(subject).to contain_govuk__app__envvar('giraffe-DATABASE_URL')
        .with_app('giraffe')
        .with_varname('DATABASE_URL')
        .with_value('postgresql://test:s%25up%3Aer%2Fsec%40r%2Bet@db.example.com/foo_production')
    end
  end
end
