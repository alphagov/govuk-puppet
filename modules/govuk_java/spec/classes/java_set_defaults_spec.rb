require_relative '../../../../spec_helper'

describe 'govuk_java::set_defaults', :type => :class do

  context 'with no params' do
    it do
      should contain_exec('java-set-default-jdk')
        .with_command(/java-1.6.0-openjdk/)
        .with_unless(/java-6-openjdk/)
      should contain_exec('java-set-default-jre')
        .with_command(/java-1.6.0-openjdk/)
        .with_unless(/java-6-openjdk/)
    end
  end

  context 'with oracle java7 jdk/jre' do
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

  context 'with openjdk7 java7 jdk/jre' do
    let(:params) do
      {
        :jdk => 'openjdk7',
        :jre => 'openjdk7'
      }
    end

    it do
      should contain_exec('java-set-default-jdk')
        .with_command(/java-1\.7\.0-openjdk/)
        .with_unless(/java-7-openjdk/)
      should contain_exec('java-set-default-jre')
        .with_command(/java-1\.7\.0-openjdk/)
        .with_unless(/java-7-openjdk/)
    end
  end

end
