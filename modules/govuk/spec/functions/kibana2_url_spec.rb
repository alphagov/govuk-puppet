require_relative '../../../../spec_helper'

# Put module's plugins on LOAD_PATH.
dir = File.expand_path('../../', File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

require 'json'
require 'base64'

describe 'kibana2_url' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }
  let(:base_url) { 'https://kibana.example.com' }

  it 'should raise an error for less than 2 arguments' do
    expect { scope.function_kibana2_url([:gruffalo]) }.to raise_error(ArgumentError, /given 1 for 2.$/)
  end

  it 'should raise an error if hash does not contain search' do
    expect { scope.function_kibana2_url([base_url, {}]) }.to raise_error(ArgumentError, /No 'search' key found/)
  end

  it 'should convert a hash to a URL with base64' do
    in_hash = {
      'search'    => '@tags:tusks AND @fields.prickles:"purple"',
      'fields'    => [],
      'offset'    => 0,
      'timeframe' => '86400',
      'graphmode' => 'count',
    }

    res = scope.function_kibana2_url([base_url, in_hash])
    res.should == 'https://kibana.example.com/#eyJmaWVsZHMiOltdLCJzZWFyY2giOiJAdGFnczp0dXNrcyBBTkQgQGZpZWxkcy5wcmlja2xlczpcInB1cnBsZVwiIiwib2Zmc2V0IjowLCJ0aW1lZnJhbWUiOiI4NjQwMCIsImdyYXBobW9kZSI6ImNvdW50In0='

    out_b64 = res.gsub(/^#{Regexp.escape(base_url)}\/+#/, "")
    JSON.parse(Base64.decode64(out_b64)).should == in_hash
  end

  it 'should add default search param(s)' do
    in_hash = {
      'search' => '@tags:claws AND @fields.eyes:"orange"',
    }

    res = scope.function_kibana2_url([base_url, in_hash])
    res.should == 'https://kibana.example.com/#eyJmaWVsZHMiOltdLCJzZWFyY2giOiJAdGFnczpjbGF3cyBBTkQgQGZpZWxkcy5leWVzOlwib3JhbmdlXCIifQ=='

    out_b64 = res.gsub(/^#{Regexp.escape(base_url)}\/+#/, "")
    JSON.parse(Base64.decode64(out_b64)).should == {
      'search' => '@tags:claws AND @fields.eyes:"orange"',
      'fields' => [],
    }
  end
end
