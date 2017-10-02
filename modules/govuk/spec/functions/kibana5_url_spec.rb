require './spec_helper'

# Put module's plugins on LOAD_PATH.
dir = File.expand_path('../../', File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

describe 'kibana5_url' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }
  let(:base_url) { 'https://kibana.logit.io' }
  let(:dash_url) { "#{base_url}/app/kibana#/discover" }

  it 'should raise an error for less than 2 arguments' do
    expect { scope.function_kibana5_url([:gruffalo]) }.to raise_error(ArgumentError, /given 1 for 2$/)
  end

  it 'should raise an error if hash does not contain query' do
    expect { scope.function_kibana5_url([base_url, {}]) }.to raise_error(ArgumentError, /No 'query' key found/)
  end

  # https://github.com/elasticsearch/kibana/issues/1284
  it 'should raise an error if query contains double quotes' do
    in_hash = {
      'query' => '@fields.tongue:"black"',
    }
    expect { scope.function_kibana5_url([base_url, in_hash]) }.to raise_error(ArgumentError, /single quotes instead of double/)
  end

  it 'should convert a hash with query to a URL with + characters rather than spaces' do
    in_hash = {
      'query' => 'tags:bella AND cat:furry',
    }

    res = scope.function_kibana5_url([base_url, in_hash])
    expect(res).to eq("#{dash_url}?_g=()&_a=(columns:!(_source),index:'*-*',interval:auto,query:(query_string:(analyze_wildcard:!t,query:'tags:bella+AND+cat:furry')),sort:!('@timestamp',desc))")
  end

  it 'should convert a hash with query and from to a URL' do
    in_hash = {
      'query' => 'host:cache*',
      'from'  => '24h',
    }

    res = scope.function_kibana5_url([base_url, in_hash])
    expect(res).to eq("#{dash_url}?_g=(refreshInterval:(display:Off,pause:!f,value:0),time:(from:now-24h,mode:quick,to:now))&_a=(columns:!(_source),index:'*-*',interval:auto,query:(query_string:(analyze_wildcard:!t,query:'host:cache*')),sort:!('@timestamp',desc))")
  end
end
