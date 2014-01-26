Vagrant-managed Aerospike instance
==================================

Tested with VirtualBox 4.3.6 on Mac OS X 10.9.1, Vagrant 1.4.2 provisioning
with Puppet 3.4.1, and Aerospike 3.1.3 on Ubuntu 12.04.2 LTS.

To start up the Aerospike instance:

% vagrant up aerospike --provider=virtualbox

The Debian packages used to install Aerospike aren't included. The packages
can be loaded from here: http://www.aerospike.com/free-aerospike-3-community-edition/.
Depending on the version, it may be necessary to modify the configuration in 
modules/aerospike/manifests/init.pp. The Debian packages should be placed in
modules/aerospike/files.

The script to install a specific version of Aerospike has been taken from here: https://gist.github.com/dol/5776169.
Hat tip to Dominic Lüchinger. :)

The Aerospike instance has a single in-memory namespace called 'test'. The
configuration file modules/aerospike/files/aerospike.conf contains the
namespace configuration, and also a fix for the pidfile location, which seems
to be incorrect for the server version I tested against. (This stops the init
scripts from detecting if the asd process is active.)

The configuration also sets the directory for Aerospike Lua scripts to
/vagrant/lua; this is mapped to the lua directory in the base directory.
