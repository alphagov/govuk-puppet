require_relative '../../../../spec_helper'

describe 'apt::repository', :type => :define do
  let(:title) { 'foo' }

  context 'with no type and url' do
    let(:params) { { :url => 'http://foo.bar' } }

    it do
      should contain_apt__repository__deb('foo')
        .with_url('http://foo.bar')
        .with_repo('main')
        .with_dist('lucid')
    end
  end

  context 'with type ppa and owner' do
    let(:params) do
      {
        :type => 'ppa',
        :owner => 'bar'
      }
    end

    it do
      should contain_apt__repository__ppa('foo')
        .with_owner('bar')
        .with_repo('main')
        .with_dist('lucid')
    end
  end

  context 'with repo' do
    let(:params) do
      {
        :url => 'http://foo.bar',
        :repo => 'myrepo'
      }
    end

    it do
      should contain_apt__repository__deb('foo')
        .with_repo('myrepo')
    end
  end

  context 'with dist' do
    let(:params) do
      {
        :url => 'http://foo.bar',
        :dist => 'monkey'
      }
    end

    it do
      should contain_apt__repository__deb('foo')
        .with_dist('monkey')
    end
  end

  context 'with dist set by facter' do
    let(:facts) { { :lsbdistcodename => 'precise' } }
    let(:params) { { :url => 'http://foo.bar' } }

    it do
      should contain_apt__repository__deb('foo')
        .with_dist('precise')
    end
  end

  context 'with key' do
    let(:params) do
      {
        :url => 'http://foo.bar',
        :key => 'fingerprint'
      }
    end

    it do
      should contain_apt__key('fingerprint')
    end
  end

end
