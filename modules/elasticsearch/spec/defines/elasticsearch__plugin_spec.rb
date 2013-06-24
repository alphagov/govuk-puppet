require_relative '../../../../spec_helper'

describe 'elasticsearch::plugin', :type => :define do
  let(:title) { 'giraffe' }
  let(:exec_title) { 'elasticsearch install plugin giraffe' }

  context 'install_from is user/component/version' do
    let(:params) {{
      :install_from => 'mobz/elasticsearch-head',
    }}

    it {
      should contain_exec(exec_title).with(
        :command => /plugin -install 'mobz\/elasticsearch-head'$/
      )
    }
  end

  context 'install_from is URL' do
    let(:params) {{
      :install_from => 'https://example.com/elasticsearch-redis-river-0.0.4.zip',
    }}

    it {
      should contain_exec(exec_title).with(
        :command => /plugin -install 'giraffe' \
-url 'https:\/\/example.com\/elasticsearch-redis-river-0.0.4.zip'$/
      )
    }
  end
end
