require_relative '../../../../spec_helper'

describe 'mysql::server::master', :type => :define do
  let (:title) { 'explicit_db_name' }
  let (:params) {{
      "database"         => "realname",
      "user"             => "bob",
      "password"         => "fred",
      "host"             => "bruce-forsyth",
      "root_password"    => "1337fr3d",
      "replica_password" => "fredfredfred",
    }}

  it { should contain_mysql__server__db('realname').with({
      "user"          => "bob",
      "password"      => "fred",
      "host"          => "bruce-forsyth",
      "root_password" => "1337fr3d",
      "remote_host"   => "%",
    })
  }
end

describe 'mysql::server::master', :type => :define do
  let (:title) { 'implicit_db_name' }
  let (:params) {{
      "user"             => "bob",
      "password"         => "fred",
      "host"             => "bruce-forsyth",
      "root_password"    => "1337fr3d",
      "replica_password" => "fredfredfred",
    }}

  it { should contain_mysql__server__db('implicit_db_name').with({
      "user"          => "bob",
      "password"      => "fred",
      "host"          => "bruce-forsyth",
      "root_password" => "1337fr3d",
      "remote_host"   => "%",
    })
  }
end
