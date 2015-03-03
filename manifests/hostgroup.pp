# == Class: couchbase::host_group
#
# Couchbase host_group script. This allows you to create new host_groups for couchbase
# installation. Through this you can define the size of the host_group, type,
# replica count, etc.
#
# === Parameters
# [*port*]
# The port to use for the couchbase host_group
# [*size*]
# Initial size (in megabytes) of memory to use for the defined host_group
# [*user*]
# Login user for the couchbase cluster
# [*password*]
# Password for the couchbase cluster
# [*type*]
# The type of the host_group to create (memcached/couchbase)
# [*replica*]
# Count of replicas for host_group
# [*host_group_password*]
# The password to use for the new host_group. Note that per the couchbase docs
# only host_groups on port 11211 can use SASL authentication.

# === Examples
#
# couchbase::host_group { 'host_groupname':
#   port            => 11211,
#   size            => 1024,
#   user            => 'couchbase',
#   password        => 'password',
#   type            => 'memcached',
#   host_group_password => 'somepw'
# }
#
# === Authors
#
# Justice London <jlondon@syrussystems.com>
# Portions of code by Lars van de Kerkhof <contact@permanentmarkers.nl>
#
# === Copyright
#
# Copyright 2013 Justice London, unless otherwise noted.
#
define couchbase::hostgroup (
  $host_groupname      = $title,
  $user            = 'couchbase',
  $password        = 'password',
) {

  include couchbase::params

  if $::couchbase::ensure == present {
    # all this has to be done before we can create host_groups.
    Class['couchbase::install'] -> Couchbase::Hostgroup[$title]
    Class['couchbase::config'] -> Couchbase::Hostgroup[$title]
    Class['couchbase::service'] -> Couchbase::Hostgroup[$title]

    exec {"host_group-create-${host_groupname}":
      path      => ['/opt/couchbase/bin/', '/usr/bin/', '/bin', '/sbin', '/usr/sbin'],
      command   => "couchbase-cli group-manage -c 127.0.0.1 -u ${user} -p '${password}' --list --group-name=${host_groupname}}",
      unless    => "couchbase-cli group-manage -c 127.0.0.1 -u ${user} -p '${password}' --list --group-name=${host_groupname} | grep ^${host_groupname}",
      require   => Class['couchbase::config'],
      returns   => [0, 2],
      logoutput => true
    }
  }
  else {
    notify {'Couchbase is configured to be absent. Host group can not be configured.':}
  }
  

}
