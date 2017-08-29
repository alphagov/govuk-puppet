require_relative '../../../../spec_helper'

# Put module's plugins on LOAD_PATH.
dir = File.expand_path('../../', File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

describe 'govuk_node_class' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should raise an error when passed arguments' do
    expect { scope.function_govuk_node_class([:gruffalo]) }.to raise_error(Puppet::ParseError, /given 1 for 0/)
  end

  context '$::trusted not set' do
    it 'should raise an error' do
      expect(scope).to receive(:lookupvar).with('::trusted').and_return(nil)
      expect { scope.function_govuk_node_class([]) }.to raise_error(
        Puppet::ParseError,
        /Unable to lookup \$::trusted/
      )
    end
  end

  context 'puppet apply and aws_migration set' do
    it 'should return aws_migration' do
      aws_migration_name = 'chicken'
      expect(scope).to receive(:lookupvar).with('::aws_migration').and_return(aws_migration_name)
      expect(scope).to receive(:lookupvar).with('::trusted').and_return({
        'authenticated' => 'local',
        'certname'      => 'cat',
        'extensions'    => {},
      })
      expect(scope.function_govuk_node_class([])).to eq(aws_migration_name)
    end
  end

  context 'puppet apply and aws_migration nil' do
    it 'should return certname' do
      certname = 'chicken'
      expect(scope).to receive(:lookupvar).with('::aws_migration').and_return(nil)
      expect(scope).to receive(:lookupvar).with('::trusted').and_return({
        'authenticated' => 'local',
        'certname'      => certname,
        'extensions'    => {},
      })
      expect(scope.function_govuk_node_class([])).to eq(certname)
    end
  end

  context 'puppet apply and aws_migration empty' do
    it 'should return certname' do
      certname = 'chicken'
      expect(scope).to receive(:lookupvar).with('::aws_migration').and_return('')
      expect(scope).to receive(:lookupvar).with('::trusted').and_return({
        'authenticated' => 'local',
        'certname'      => certname,
        'extensions'    => {},
      })
      expect(scope.function_govuk_node_class([])).to eq(certname)
    end
  end

  context '$::trusted["extensions"]["1.3.6.1.4.1.34380.1.1.13"] set' do
    it 'should return $::trusted["extensions"]["1.3.6.1.4.1.34380.1.1.13"]' do
      pp_role = 'chicken'
      expect(scope).to receive(:lookupvar).with('::aws_migration').and_return('cat')
      expect(scope).to receive(:lookupvar).with('::trusted').and_return({
        'authenticated' => false,
        'certname'      => 'cat',
        'extensions'    => {
          'pp_instance_id'           => 'dog',
          'pp_image_name'            => 'mouse',
          '1.3.6.1.4.1.34380.1.1.18' => 'eu-west-0',
          '1.3.6.1.4.1.34380.1.1.13' => pp_role,
        },
      })
      expect(scope.function_govuk_node_class([])).to eq(pp_role)
    end
  end

  context '$::trusted["extensions"]["1.3.6.1.4.1.34380.1.1.13"] empty' do
    it 'should return $::trusted["certname"]' do
      certname = 'chicken'
      expect(scope).to receive(:lookupvar).with('::aws_migration').and_return('cat')
      expect(scope).to receive(:lookupvar).with('::trusted').and_return({
        'authenticated' => false,
        'certname'      => certname,
        'extensions'    => {
          'pp_instance_id'           => 'beef',
          'pp_image_name'            => 'duck',
          '1.3.6.1.4.1.34380.1.1.18' => 'eu-west-0',
          '1.3.6.1.4.1.34380.1.1.13' => '',
        },
      })
      expect(scope.function_govuk_node_class([])).to eq(certname)
    end
  end

  context '$::trusted["extensions"]["1.3.6.1.4.1.34380.1.1.13"] nil' do
    it 'should return $::trusted["certname"]' do
      certname = 'chicken'
      expect(scope).to receive(:lookupvar).with('::aws_migration').and_return('cat')
      expect(scope).to receive(:lookupvar).with('::trusted').and_return({
        'authenticated' => false,
        'certname'      => certname,
        'extensions'    => {},
      })
      expect(scope.function_govuk_node_class([])).to eq(certname)
    end
  end

  context '$::trusted["extensions"]["1.3.6.1.4.1.34380.1.1.13"] not set and $::trusted["certname"] nil' do
    it 'should raise an error' do
      expect(scope).to receive(:lookupvar).with('::aws_migration').and_return('cat')
      expect(scope).to receive(:lookupvar).with('::trusted').and_return({
        'authenticated' => false,
        'certname'      => nil,
        'extensions'    => {},
      })
      expect { scope.function_govuk_node_class([]) }.to raise_error(
        Puppet::ParseError,
        /Unable to lookup \$::trusted\['certname'\]/
      )
    end
  end

  context '$::trusted["extensions"]["1.3.6.1.4.1.34380.1.1.13"] not set and $::trusted["certname"] empty' do
    it 'should raise an error' do
      expect(scope).to receive(:lookupvar).with('::aws_migration').and_return('cat')
      expect(scope).to receive(:lookupvar).with('::trusted').and_return({
        'authenticated' => false,
        'certname'      => '',
        'extensions'    => {},
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
        'extensions'    => {},
      }}

      it {
        expect(scope).to receive(:lookupvar).with('::aws_migration').and_return('cat')
        expect(scope).to receive(:lookupvar).with('::trusted').and_return(trusted_hash)
        expect(scope.function_govuk_node_class([])).to eq(result)
      }
    end
  end
end
