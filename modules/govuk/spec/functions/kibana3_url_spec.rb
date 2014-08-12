require_relative '../../../../spec_helper'

# Put module's plugins on LOAD_PATH.
dir = File.expand_path('../../', File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

describe 'kibana3_url' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }
  let(:base_url) { 'https://kibana.example.com' }
  let(:dash_url) { "#{base_url}/kibana/#/dashboard/file/default.json" }

  it 'should raise an error for less than 2 arguments' do
    expect { scope.function_kibana3_url([:gruffalo]) }.to raise_error(ArgumentError, /given 1 for 2$/)
  end

  it 'should raise an error if hash does not contain query' do
    expect { scope.function_kibana3_url([base_url, {}]) }.to raise_error(ArgumentError, /No 'query' key found/)
  end

  # https://github.com/elasticsearch/kibana/issues/1284
  it 'should raise an error if query contains double quotes' do
    in_hash = {
      'query' => '@fields.tongue:"black"',
    }
    expect { scope.function_kibana3_url([base_url, in_hash]) }.to raise_error(ArgumentError, /single quotes instead of double/)
  end

  it 'should convert a hash with query to a URL with %20 encoded spaces' do
    in_hash = {
      'query' => '@tags:tusks AND @fields.prickles:\'purple\'',
    }

    res = scope.function_kibana3_url([base_url, in_hash])
    res.should == "#{dash_url}?query=%40tags%3Atusks%20AND%20%40fields.prickles%3A%27purple%27"
  end

  it 'should convert a hash with query and from to a URL' do
    in_hash = {
      'query' => '@fields.eyes:orange',
      'from'  => '24h',
    }

    res = scope.function_kibana3_url([base_url, in_hash])
    res.should == "#{dash_url}?query=%40fields.eyes%3Aorange&from=24h"
  end
end
