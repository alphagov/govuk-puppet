require_relative '../../../../spec_helper'

# Put module's plugins on LOAD_PATH.
dir = File.expand_path('../../', File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

describe 'govuk_node_class' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should raise an error when passed arguments' do
    expect { scope.function_govuk_node_class([:gruffalo]) }.to raise_error(Puppet::ParseError, /given 1 for 0/)
  end

  context 'clientcert not set' do
    it 'should raise an error' do
      scope.should_receive(:lookupvar).with('::clientcert').and_return()
      expect { scope.function_govuk_node_class([]) }.to raise_error(Puppet::ParseError, /Unable to lookup \$::clientcert/)
    end
  end

  {
    'gruffalo'                               => 'gruffalo',
    'gruffalo-1'                             => 'gruffalo',
    'gruffalo-1.example'                     => 'gruffalo',
    'gruffalo-cave-1.example.com'            => 'gruffalo_cave',
    'gruffalo-terrible-tusks-99.example.com' => 'gruffalo_terrible_tusks',
  }.each do |clientcert, result|
    context "clientcert #{clientcert}" do
      it {
        scope.should_receive(:lookupvar).with('::clientcert').and_return(clientcert)
        scope.function_govuk_node_class([]).should == result
      }
    end
  end
end
