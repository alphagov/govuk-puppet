require_relative '../../../../spec_helper'

  describe 'govuk_elasticsearch::backup', :type => :class do

    let(:params){{
        :es_indices => [
            'cagney',
            'lacey'
        ]
    }}

    context 'Check file' do

      it { is_expected.to contain_file('es-backup-s3').with_content(/"cagney","lacey"/) }

    end


  end
