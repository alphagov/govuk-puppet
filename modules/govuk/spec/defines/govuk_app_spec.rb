require_relative '../../../../spec_helper'

describe 'govuk::app', :type => :define do
  let(:title) { 'planner' }
  let(:params) {{
    "port" => 8080,
  }}
  it { should contain_file('/var/run/planner') }
end
