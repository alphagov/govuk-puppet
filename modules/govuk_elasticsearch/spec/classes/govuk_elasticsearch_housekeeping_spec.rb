require_relative '../../../../spec_helper'

  describe 'govuk_elasticsearch::housekeeping', :type => :class do

    let(:params) {{
        :es_repo => [
            'kibana-lint',
            'kibana-mint',
            'kibana_tint'
        ]
    }}

    context 'Checking what repositories variable expands like' do

      it { is_expected.to contain_file('es-prune-snapshots').with_path('/usr/local/bin/es-prune-snapshots').with_content(/"kibana-lint"\s"kibana-mint"\s"kibana_tint"/) }
    end


  end
