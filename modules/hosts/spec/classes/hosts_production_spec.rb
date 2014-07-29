require_relative '../../../../spec_helper'

describe 'hosts::production', :type => :class do
  context 'with website_host => www.gov.uk (default)' do
    let(:hiera_data) {{
        'app_domain'   => 'test.gov.uk',
      }}

    it { should contain_govuk__host('cache').with_legacy_aliases(['cache', "www.gov.uk", "www.test.gov.uk", "www-origin.test.gov.uk", "assets-origin.test.gov.uk"]) }
  end

  context 'with website_host => www.doesnt.exist' do
    let(:hiera_data) {{
        'app_domain'   => 'test.gov.uk',
        'website_host' => 'www.doesnt.exist',
      }}

    #force refresh of the hieradata - yes its a hack
    let(:facts) {{ :foo => "bar" }}

    it { should contain_govuk__host('cache').with_legacy_aliases(['cache', "www.doesnt.exist", "www.test.gov.uk", "www-origin.test.gov.uk", "assets-origin.test.gov.uk"]) }
  end

  describe 'apt_mirror_internal' do
    let(:hiera_data) {{
      'app_domain' => 'test.gov.uk',
    }}

    context 'false (default)' do
      let(:params) {{ }}

      it { should contain_govuk__host('apt-1').with_legacy_aliases([]) }
    end

    context 'true' do
      let(:params) {{
        :apt_mirror_internal => true,
      }}

      it { should contain_govuk__host('apt-1').with_legacy_aliases('apt.production.alphagov.co.uk') }
    end
  end
end 
