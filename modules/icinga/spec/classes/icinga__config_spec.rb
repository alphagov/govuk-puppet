require_relative '../../../../spec_helper'

describe 'icinga::config', :type => :class do

  context 'when enable_event_handlers is enabled' do
    let (:params) {{
      'enable_event_handlers' => true,
    }}

    it { is_expected.to contain_file('/etc/icinga/icinga.cfg').with_content(/^enable_event_handlers=1$/)}
  end

  context 'when enable_event_handlers is disabled' do
    let (:params) {{
      'enable_event_handlers' => false,
    }}

    it { is_expected.to contain_file('/etc/icinga/icinga.cfg').with_content(/^enable_event_handlers=0$/)}
  end
end
