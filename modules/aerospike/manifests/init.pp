class aerospike (
  $server_version = '3.1.3.ubuntu12.04',
  $tools_version  = '3.0.46.ubuntu12.04',
  $working_dir    = '/tmp/aerospike',
) {

  # Create working directory
  file { "$working_dir":
    ensure => directory,
  }

  # Copy Debian packages to working directory
  file { "$working_dir/aerospike-community-server-$server_version.x86_64.deb":
    ensure => present,
    source => "puppet:///modules/aerospike/aerospike-community-server-$server_version.x86_64.deb",
  }

  file { "$working_dir/aerospike-tools-$tools_version.x86_64.deb":
    ensure => present,
    source => "puppet:///modules/aerospike/aerospike-tools-$tools_version.x86_64.deb",
  }

  # Install Aerospike tools package
  package { "aerospike-tools":
    name     => 'aerospike-tools',
    ensure   => installed,
    provider => dpkg,
    source   => "$working_dir/aerospike-tools-$tools_version.x86_64.deb",
    require  => File["$working_dir/aerospike-tools-$tools_version.x86_64.deb"],
  }

  # Install Aerospike server package
  package { "aerospike-community-server":
    name     => 'aerospike-community-server',
    ensure   => installed,
    provider => dpkg,
    source   => "$working_dir/aerospike-community-server-$server_version.x86_64.deb",
    require  => [
      Package["aerospike-tools"],
      File["$working_dir/aerospike-community-server-$server_version.x86_64.deb"],
    ],
  }

  # Set Aerospike defaults to use
  file { "/etc/aerospike/aerospike.conf":
    ensure => present,
    source => "puppet:///modules/aerospike/aerospike.conf",
    force  => true,
    require => Package['aerospike-community-server'],
    notify  => Service["aerospike-community-server"],
  }

  service { "aerospike-community-server":
    name    => "aerospike",
    ensure  => running,
    enable  => true,
    require => Package["aerospike-community-server"],
  }

}
