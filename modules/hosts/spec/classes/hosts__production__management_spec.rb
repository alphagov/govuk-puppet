require_relative '../../../../spec_helper'

describe 'hosts::production::management', :type => :class do
  describe 'validation of apt mirror params' do
    context 'fails when mirror is requested but not set' do
      let(:params) {{
        :apt_mirror_internal => true,
      }}

      it do
        is_expected.to raise_error(Puppet::Error, /Host alias for APT mirror was requested but not defined/)
      end
    end
  end
end
