require_relative '../../../../spec_helper'

  describe 'govuk_elasticsearch::backup', :type => :class do

    let(:params){{
        :es_indices => [
            'cagney',
            'lacey'
        ],
        :aws_secret_access_key => 'foo',
        :aws_access_key_id => 'bar',
        :s3_bucket => 'mybucket',
    }}

    context 'Check file' do

      it { is_expected.to contain_file('es-backup-s3').with_content(/"cagney","lacey"/) }

    end


  end
