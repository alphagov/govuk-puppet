require_relative '../../../spec_helper'

describe 'govuk_etcd', :type => :class do
  context 'When specifying a list of peers' do
    let(:params) { {
      :peers => [ 'foo.example.com:7001', 'bar.example.com:7001', 'not.a.peer.example.com:7001' ],
    } }

    describe 'the first peer receives an empty list to allow the cluster to bootstrap' do
      let(:facts) { {
        :fqdn     => 'foo.example.com',
        :domain   => 'example.com',
        :hostname => 'foo',
      } }

      it {
        should contain_class('etcd').with_peers([])
      }
    end

    describe 'all other peers receive a peer list' do
      let(:facts) { {
        :fqdn     => 'bar.example.com',
        :domain   => 'example.com',
        :hostname => 'bar',
      } }

      it {
        should  contain_class('etcd').with_peers(['foo.example.com:7001', 'bar.example.com:7001', 'not.a.peer.example.com:7001'])
      }
    end
  end
end
