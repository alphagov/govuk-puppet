require_relative '../../../../spec_helper'

describe 'hosts::production', :type => :class do
  describe 'apt_mirror_internal' do
    context 'false (default)' do
      let(:params) {{ }}

      it { should contain_govuk__host('apt-1').with_legacy_aliases([]) }
    end

    context 'true' do
      let(:params) {{
        :apt_mirror_hostname => 'apt.example.com',
        :apt_mirror_internal => true,
      }}

      it { should contain_govuk__host('apt-1').with_legacy_aliases('apt.example.com') }
    end
  end
end 
