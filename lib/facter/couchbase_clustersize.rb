Facter.add(:couchbase_clustersize) do
      setcode do
        if File.exist? '/usr/local/bin/couchbase-cluster-server-list'
          Facter::Core::Execution.exec('/usr/local/bin/couchbase-cluster-server-list | grep \'server:\' | wc --lines')
        end
      end
end

# If this server doesn't look like a server, it must be a desktop
Facter.add(:couchbase_clustersize) do
  setcode do
    '0'
  end
end
