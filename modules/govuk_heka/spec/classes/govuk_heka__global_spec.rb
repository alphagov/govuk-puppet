require_relative '../../../../spec_helper'

describe 'govuk_heka::global' do
  describe 'maxprocs' do
    {
      1 => 1,
      4 => 4,
      8 => 8,
    }.each do |processors, maxprocs|
      context "#{processors} processors" do
        let(:facts) {{
          :processorcount => processors,
        }}

        it "maxprocs should match processors" do
          should contain_heka__plugin('global').with_content(/^maxprocs = #{maxprocs}$/)
        end
      end
    end
  end
end
