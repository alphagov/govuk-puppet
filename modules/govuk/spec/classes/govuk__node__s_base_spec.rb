require_relative '../../../../spec_helper'

describe 'govuk::node::s_base', :type => :class do
  let(:pre_condition) {[
    'class govuk::apps::some_null_class { }',
    'class govuk::apps::calc_null_class { }',
    # Setting this as a null class enables us to test the logic, but not
    # break on unrelated error handling
    'class hosts{}'
  ]}

  let(:params) {{
    :node_apps => {
      'backend' => {
        'apps' => [
          'some-null-class',
        ]
      },
      'calculators_frontend' => {
        'apps' => [
          'calc-null-class',
        ]
      }
    }
  }}

  context 'if node in AWS' do
    let(:facts) {{
      :aws_migration => 'backend',
      :fqdn_short => 'backend-1.backend.foo',
      :vdc => 'dummy-vdc',
    }}
    it 'it includes all apps that run on backend' do
      is_expected.to contain_class('govuk::apps::some_null_class')
    end
  end

  context 'if node not in AWS' do
    let(:facts) {{
      :fqdn_short => 'backend-1.backend',
      :vdc => 'dummy-vdc',
    }}
    it 'it includes all apps that run on backend' do
      is_expected.to contain_class('govuk::apps::some_null_class')
    end
  end

  context 'if we do not set an app for the class' do
    let(:facts) {{
      :aws_migration => 'some_fake_node_class',
      :vdc => 'dummy-vdc',
    }}
    it 'we should not include anything' do
      is_expected.to_not contain_class('govuk::apps::some_null_class')
    end
  end

  context 'if node class name has an underscore and hostname has a hyphen' do
    let(:facts) {{
      :fqdn_short => 'calculators-frontend-1.api',
      :vdc => 'dummy-vdc',
    }}
    it 'it includes all apps that run on calculators_frontend' do
      is_expected.to contain_class('govuk::apps::calc_null_class')
    end
  end
end
