# == Class: bacula::common
#
# This class enforces common resources needed by all bacula components
#
# === Parameters
#
# All <tt>bacula+ classes are called from the main <tt>::bacula</tt> class.  Parameters
# are documented there.
#
# === Actions:
# * Enforce the bacula user and groups exist
# * Enforce the <tt>/var/spool/bacula+ is a director and <tt>/var/lib/bacula</tt>
#   points to it
#
# === Copyright
#
# Copyright 2019 Michael Watters
#
# === License
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class bacula::common (
  Boolean $manage_config_dir = false,
  Boolean $manage_db_tables  = true,
  String $plugin_dir         = '/usr/lib64/bacula',
  ) {

  if $facts['operatingsystem'] =~ /(?i:opensuse)/ {
    $dist_name = regsubst($facts['lsbdistdescription'], ' ', '_', 'G')
    $baseurl = "http://download.opensuse.org/repositories/home:/Ximi1970:/openSUSE:/Extra/${dist_name}"

    zypprepo { 'home_Ximi1970_openSUSE_Extra':
      baseurl      => $baseurl,
      enabled      => 1,
      autorefresh  => 1,
      name         => 'home_Ximi1970_openSUSE_Extra',
      gpgcheck     => 1,
      gpgkey       => "${baseurl}/repodata/repomd.xml.key",
      priority     => 99,
      keeppackages => 1,
      type         => 'rpm-md',
    }
  }

  if $facts['operatingsystem'] == 'SLES' {
    $baseurl = 'http://download.opensuse.org/repositories/home:/dschossig/SLE_12_SP3'

    zypprepo { 'home_dschossig_SLE_12_SP3':
      baseurl      => $baseurl,
      enabled      => 1,
      autorefresh  => 1,
      name         => 'home:dschossig (SLE_12_SP3)',
      gpgcheck     => 1,
      gpgkey       => "${baseurl}/repodata/repomd.xml.key",
      priority     => 99,
      keeppackages => 1,
      type         => 'rpm-md',
    }
  }

  # Specify the user and group are present before we create files.
  #group { 'bacula':
  #  ensure => present,
  #}

  #user { 'bacula':
  #  ensure  => present,
  #  gid     => 'bacula',
  #  require => Group['bacula'],
  #}

  $config_dir_source = $manage_config_dir ? {
    true    => 'puppet:///modules/bacula/bacula-empty.dir',
    default => undef,
  }

  file {
    default:
        ensure  => directory,
        owner   => 'bacula',
        group   => 'bacula',
    ;

    $plugin_dir:
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    ;

    '/etc/bacula':
        mode    => '0750',
        purge   => $manage_config_dir,
        force   => $manage_config_dir,
        recurse => $manage_config_dir,
        source  => $config_dir_source,
    ;

    # This is necessary to prevent the object above from deleting the supplied scripts
    '/etc/bacula/scripts':
    ;

    # To avoid SELinux denials this directory must belong to the root group.
    # See https://danwalsh.livejournal.com/69478.html for more details on
    # the root cause of this failure
    '/var/lib/bacula':
        mode    => '0775',
    ;

    '/var/spool/bacula':
        mode    => '0755',
    ;

    '/var/log/bacula':
        recurse => true,
        mode    => '0755',
    ;
  }
}
