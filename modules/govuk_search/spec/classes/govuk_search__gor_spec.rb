require_relative '../../../../spec_helper'

describe 'govuk_search::gor', :type => :class do
  let(:args_default) {{
    '-input-raw'          => ':3009',
    '-output-file-append' => true,
    '-http-allow-method'  => %w{POST DELETE},
    '-output-http'        => [],
    '-http-original-host' => '',
  }}

  context 'default (disabled)' do
    let(:params) {{ }}

    it {
      is_expected.not_to contain_class('govuk_gor').with({
        :enable => false,
      })
    }
  end

  context '#enabled' do
    let(:output_path) { '/output/path' }
    let(:params) {{
      :enabled => true,
      :output_path => output_path,
    }}

    it {
      is_expected.to contain_class('govuk_gor').with(
        :enable => true,
        :args           => args_default.merge({
          '-output-file' => "#{output_path}/%Y%m%d.log",
        }),
        :envvars => {
          'GODEBUG' => 'netdns=go',
        }
      )
    }


    it {
      is_expected.to contain_file(output_path).with(
        :ensure   => 'directory',
        :owner    => 'root',
        :group    => 'root',
        :mode     => '0755',
      )
    }
  end

  context 'enabled but missing output path' do
    let(:params) {{
      :enabled => true,
      :output_path => nil
    }}

    it {
      is_expected.to raise_error(Puppet::Error, /does not match "\^\/\.\*" at/)
    }
  end

  context 'enabled but output path is invalid' do
    let(:params) {{
      :enabled => true,
      :output_path => 'invalid/path'
    }}

    it {
      is_expected.to raise_error(Puppet::Error, /does not match "\^\/\.\*" at/)
    }
  end
end
