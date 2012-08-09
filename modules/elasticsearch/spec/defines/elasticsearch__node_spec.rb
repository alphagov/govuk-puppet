require_relative '../../../../spec_helper'

describe 'elasticsearch::node', :type => :define do
  let(:title) { 'foocluster' }
  home = '/var/apps/elasticsearch-foocluster'

  it do
    should contain_file(home)
      .with_ensure('directory')

    should contain_file("#{home}/config/logging.yml")

    should contain_file("#{home}/config/elasticsearch.yml")
      .with_content(/^\s*cluster.name: foocluster/)
      .with_content(/multicast.enabled: false/)
      .with_content(/mlockall: false/)
      .with_content(/unicast.hosts: \["localhost"\]/)

    should contain_file("/etc/init/elasticsearch-foocluster.conf")
      .with_content(/ES_HOME="#{home}"/)
      .with_content(/ES_HEAP_SIZE="512m"/)
  end

  context "with a list of cluster_hosts" do
    let(:params) { { :cluster_hosts => ['one', 'two', 'three'] } }

    it do
      should contain_file("#{home}/config/elasticsearch.yml")
        .with_content(/unicast.hosts: \["one", "two", "three"\]/)
    end
  end

  context "with mlock_all set to true" do
    let(:params) { { :mlock_all => true } }

    it do
      should contain_file("#{home}/config/elasticsearch.yml")
        .with_content(/mlockall: true/)
    end
  end

  context "with heap_size set to '4g'" do
    let(:params) { { :heap_size => '4g' } }

    it do
      should contain_file("/etc/init/elasticsearch-foocluster.conf")
        .with_content(/ES_HEAP_SIZE="4g"/)
    end
  end

end
