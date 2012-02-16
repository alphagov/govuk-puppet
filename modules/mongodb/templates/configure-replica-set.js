<% require 'json' %>

function replicaSetMembers() {
  var members = <%= members.to_json %>;
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
    _id: "<%= govuk_platform %>",
    members: replicaSetMembers()
  };
}

rs.initiate(replicaSetConfig());
