#!/usr/bin/env ruby


def hostgroup(user, password, server)
  output = `/opt/couchbase/bin/couchbase-cli group-manage -u #{user} -p #{password} -c localhost:8091 --list`
  last_group = ''
  output.each_line do |line|
    if /^\w+/.match(line)
      last_group = line
    end
    if /#{server}/.match(line)
    print last_group
  end
end
end

module Puppet::Parser::Functions
  newfunction(:hostgroup, :type => :rvalue, :doc => <<-EOS
This function takes the uri of the api endpoint and returns the ip and port of the service registry

*Examples:*

    hostgroup()

Would return: [ip,port]
    EOS
  ) do |arguments|
    return hostgroup()
  end
end
