require_relative '../../../../spec_helper'

describe 'govuk::host', :type => :define do
  let(:title) { 'giraffe' }
  let(:params) { { :ip => '1.2.3.4', :vdc => 'foobar' } }

  it do
    should contain_host('giraffe.foobar.test')
      .with_ip('1.2.3.4')
      .with_host_aliases(['giraffe.foobar'])
  end

  context 'with legacy aliases' do
    let(:params) do
      {
        :ip => '1.2.3.4',
        :vdc => 'foobar',
        :legacy_aliases => ['foo', 'bar', 'baz'],
      }
    end

    it do
      should contain_host('giraffe.foobar.test')
        .with_ip('1.2.3.4')
        .with_host_aliases(['giraffe.foobar', 'foo', 'bar', 'baz'])
    end
  end

  context 'with service aliases' do
    let(:params) do
      {
        :ip => '1.2.3.4',
        :vdc => 'foobar',
        :service_aliases => ['foo', 'bar', 'baz'],
        :service_suffix => 'donkeys',
      }
    end

    it do
      should contain_host('giraffe.foobar.test')
        .with_ip('1.2.3.4')
        .with_host_aliases(['giraffe.foobar', 'foo.donkeys', 'bar.donkeys', 'baz.donkeys'])
    end
  end
end
