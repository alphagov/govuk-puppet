require_relative '../../../../spec_helper'

describe 'java::set_defaults', :type => :class do

  context 'with no params' do
    it do
      should contain_exec('java-set-default-jdk')
        .with_command(/java-6-sun/)
        .with_unless(/java-6-sun/)
      should contain_exec('java-set-default-jre')
        .with_command(/java-1.6.0-openjdk/)
        .with_unless(/java-6-openjdk/)
    end
  end

  context 'with java7 jdk/jre' do
    let(:params) do
      {
        :jdk => 'oracle7',
        :jre => 'oracle7'
      }
    end

    it do
      should contain_exec('java-set-default-jdk')
        .with_command(/java-7-oracle/)
        .with_unless(/java-7-oracle/)
      should contain_exec('java-set-default-jre')
        .with_command(/java-7-oracle/)
        .with_unless(/java-7-oracle/)
    end
  end
  
end
