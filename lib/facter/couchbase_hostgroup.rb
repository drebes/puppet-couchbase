Facter.add(:couchbase_hostgroup) do
  if File.exist? '/usr/local/bin/couchbase-cluster-server-list'
    output = `/usr/local/bin/couchbase-cluster-server-list`
    last_group = ''
    server = Facter.value(:fqdn)
    output.each_line do |line|
      if /^\w+/.match(line)
        last_group = line
      end
      if /#{server}/.match(line)
        group = last_group
      end
  end
  setcode group
end

# If this server doesn't look like a server, it must be a desktop
Facter.add(:couchbase_hostgroup) do
  setcode do
    ''
  end
end
