Facter.add(:couchbase_hostgroup) do
      setcode do
        if File.exist? '/usr/local/bin/couchbase-cluster-server-list'
          output = Facter::Core::Execution.exec('/usr/local/bin/couchbase-cluster-server-list | cat ')
          server = Facter.value(:fqdn)
          last_group = ''
          hostgrp = ''
          output.each_line do |line|
            if /^\w+/.match(line)
              last_group = line.strip
            end
            if /#{server}/.match(line)
              hostgrp = last_group
            end
          end
          hostgrp
        end
      end
end

Facter.add(:couchbase_hostgroup) do
  setcode do
    ''
  end
end
