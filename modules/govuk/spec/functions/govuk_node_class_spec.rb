require_relative '../../../../spec_helper'

# Put module's plugins on LOAD_PATH.
dir = File.expand_path('../../', File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

describe 'govuk_node_class' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should raise an error when passed arguments' do
    expect { scope.function_govuk_node_class([:gruffalo]) }.to raise_error(Puppet::ParseError, /given 1 for 0/)
  end

  context 'aws_migration set' do
    it 'should return aws_migration' do
      aws_migration_name = 'chicken'
      expect(scope).to receive(:lookupvar).with('aws_migration').and_return(aws_migration_name)
      expect(scope.function_govuk_node_class([])).to eq(aws_migration_name)
    end

    it 'should not return aws_migration its an empty string' do
      aws_migration_name = 'chicken'
      expect(scope).to receive(:lookupvar).with('aws_migration').and_return('')
      expect(scope).to receive(:lookupvar).with('::trusted').and_return(nil)
      expect { scope.function_govuk_node_class([]) }.to raise_error(
        Puppet::ParseError,
        /Unable to lookup \$::trusted/
      )
    end
  end

  context '$::trusted not set' do
    it 'should raise an error' do
      expect(scope).to receive(:lookupvar).with('aws_migration').and_return(nil)
      expect(scope).to receive(:lookupvar).with('::trusted').and_return(nil)
      expect { scope.function_govuk_node_class([]) }.to raise_error(
        Puppet::ParseError,
        /Unable to lookup \$::trusted/
      )
    end
  end

  context '$::trusted["certname"] nil' do
    it 'should raise an error' do
      expect(scope).to receive(:lookupvar).with('aws_migration').and_return(nil)
      expect(scope).to receive(:lookupvar).with('::trusted').and_return({
        'authenticated' => false,
        'certname'      => nil,
      })
      expect { scope.function_govuk_node_class([]) }.to raise_error(
        Puppet::ParseError,
        /Unable to lookup \$::trusted\['certname'\]/
      )
    end
  end

  context '$::trusted["certname"] empty' do
    it 'should raise an error' do
      expect(scope).to receive(:lookupvar).with('aws_migration').and_return(nil)
      expect(scope).to receive(:lookupvar).with('::trusted').and_return({
        'authenticated' => false,
        'certname'      => '',
      })
      expect { scope.function_govuk_node_class([]) }.to raise_error(
        Puppet::ParseError,
        /Unable to lookup \$::trusted\['certname'\]/
      )
    end
  end

  {
    'gruffalo'                               => 'gruffalo',
    'gruffalo-1'                             => 'gruffalo',
    'gruffalo-1.example'                     => 'gruffalo',
    'gruffalo-cave-1.example.com'            => 'gruffalo_cave',
    'gruffalo-terrible-tusks-99.example.com' => 'gruffalo_terrible_tusks',
  }.each do |certname, result|
    context "certname #{certname}" do
      let(:trusted_hash) {{
        'authenticated' => true,
        'certname'      => certname,
      }}

      it {
        expect(scope).to receive(:lookupvar).with('aws_migration').and_return(nil)
        expect(scope).to receive(:lookupvar).with('::trusted').and_return(trusted_hash)
        expect(scope.function_govuk_node_class([])).to eq(result)
      }
    end
  end
end
