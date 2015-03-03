Facter.add(:cluster_size) do
      setcode do
        if File.exist? '/usr/local/bin/couchbase-cluster-server-list'
          Facter::Core::Execution.exec('/usr/local/bin/couchbase-cluster-server-list | wc --lines')
        end
      end
    end

    # If this server doesn't look like a server, it must be a desktop
         Facter.add(:cluster_size) do
           setcode do
                      '0'
                            end
                                end
