require_relative '../../../../spec_helper'

describe 'collectd::plugin::elasticsearch', :type => :class do

  let(:pre_condition) { <<EOS
Collectd::Plugin <||>
EOS
  }
  let(:default_params) {{
    :es_port              => 1234,
    :log_index_type_count => {},
  }}

  context 'no types logged' do
    let (:params) { default_params }

    it { should contain_collectd__plugin('elasticsearch')
      .with_content(/<URL>/)
    }

    it { should contain_collectd__plugin('elasticsearch')
      .without_content(/<URL>.*<URL>/)
    }
  end

  context 'types logged' do
    let(:params) { default_params.merge({
      :log_index_type_count => { "index": ['type1', 'type2'] }
    })

    it { should contain_collectd__plugin('elasticsearch')
      .with_content(/<URL>.*<URL>.*<URL>/)
    }
  end

  context 'log_index_type_count bad param type' do
    let(:params) { default_params.merge({
      :log_index_type_count => ''
    })

    it do
      expect {
        should contain_collectd__plugin('elasticsearch')
      }.to raise_error(Puppet::Error)
    end
  end
  
end
