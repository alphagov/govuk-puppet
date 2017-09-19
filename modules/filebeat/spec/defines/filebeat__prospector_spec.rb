require_relative '../../../../spec_helper'

describe 'filebeat::prospector', :type => :define do
  let(:title) { 'apple' }
  let (:default_params) {{
    :paths => ['/path/to/file'],
  }}

  context 'with minimal settings' do
    let(:params) { default_params }

    it { should contain_file('filebeat-apple').with_path(
      '/etc/filebeat/conf.d/apple.yml'
    ).with_content(
      /---\nfilebeat:\n  prospectors:\n    - input_type: log\n      paths:\n        - \/path\/to\/file/
    ) }
  end

  context 'if add_error_key set to true' do
    let(:params) { default_params.merge({
      :json => {'add_error_key' => true}
    })}

    it { should contain_file('filebeat-apple').with_path(
      '/etc/filebeat/conf.d/apple.yml'
    ).with_content(
      /add_error_key: true/
    ) }
  end

  context 'if add_error_key set to undef' do
    let(:params) { default_params.merge({
      :json => {'add_error_key' => 'undef'}
    })}

    it { should_not contain_file('filebeat-apple').with_path(
      '/etc/filebeat/conf.d/apple.yml'
    ).with_content(
      /add_error_key: true/
    ) }
  end
end
