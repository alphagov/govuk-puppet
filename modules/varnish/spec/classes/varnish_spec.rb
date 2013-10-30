require_relative '../../../../spec_helper'

describe 'varnish', :type => :class do
  context 'Varnish 3.x on Precise' do
    let(:facts) {{
      :lsbdistcodename => 'precise',
      :cache_bust      => Time.now
    }}

    it { should contain_file('/etc/varnish/default.vcl') }
    it { should contain_file('/etc/default/varnish') }
    it { should contain_package('varnish').with_ensure('installed') }
    it { should contain_service('varnish') }

    context 'govuk_enable_router_varnish true' do
      before(:each) { update_extdata({'govuk_enable_router_varnish' => 'yes'}) }
      it {
        should_not contain_file('/etc/varnish/default.vcl').with(
          :content => /req\.http\.GOVUK-Feature-New-Router/
        )
      }
    end

    context 'govuk_enable_router_varnish false (default)' do
      it {
        should contain_file('/etc/varnish/default.vcl').with(
          :content => /req\.http\.GOVUK-Feature-New-Router/
        )
      }
    end
  end

  context 'Varnish 2.x on Lucid' do
    let(:facts) {{
      :lsbdistcodename => 'lucid',
    }}

    it do
      expect { should }.to raise_error(Puppet::Error, /not supported/)
    end
  end
end
