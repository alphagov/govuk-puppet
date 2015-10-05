<% require 'json' %>

function replicaSetMembers() {
  var members = <%= @members_hostnames.to_json %>;
  var i = 0;
  return members.map(function(member) {
    return {
      _id: i++,
      host: member
    };
  })
}

function replicaSetConfig() {
  return {
    _id: "<%= @replicaset_name %>",
    members: replicaSetMembers()
  };
}

res = rs.initiate(replicaSetConfig());
if (res.ok != 1) {
  throw res.errmsg;
}
