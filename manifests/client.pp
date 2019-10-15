# == Class: bacula::client
#
# This class manages the bacula client (bacula-fd)
#
# === Parameters
#
# All <tt>bacula+ classes are called from the main <tt>::bacula</tt> class.  Parameters
# are documented there.
#
# === Actions:
# * Enforce the client package package be installed
# * Manage the <tt>/etc/bacula/bacula-fd.conf</tt> file
# * Enforce the <tt>bacula-fd</tt> service to be running
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

class bacula::client (
  String $var_dir                   = '/var/lib/bacula',
  String $bacula_fd_conf            = '/etc/bacula/bacula-fd.conf',
  String $client_package            = 'bacula-client',
  String $director_password         = cache_data('bacula', 'director_password', extlib::random_password(32)),
  String $director_server           = "bacula.${facts['domain']}",
  String $plugin_dir                = '/usr/lib64/bacula',
  Array[String] $tls_allowed_cn     = [],
  String $tls_ca_cert               = "${var_dir}/ssl/certs/ca.pem",
  String $tls_key                   = "${var_dir}/ssl/private_keys/${::fqdn}.pem",
  String $tls_cert                  = "${var_dir}/ssl/certs/${::fqdn}.pem",
  Optional[String] $tls_ca_cert_dir = undef,
  Boolean $tls_require              = true,
  Boolean $tls_verify_peer          = true,
  Boolean $use_tls                  = true,
  ) {

  include 'bacula::common'

  package { $client_package:
    ensure => installed,
  }

  file { $bacula_fd_conf:
    ensure    => file,
    owner     => $operatingsystem ? { windows => 'Administrator', default => 'root'},
    group     => $operatingsystem ? { windows => 'Administrators', default => 'root'},
    mode      => '0640',
    content   => template('bacula/bacula-fd.conf.erb'),
    require   => [ Package[$client_package], Class['bacula::common'] ],
    notify    => Service['bacula-fd'],
    show_diff => false,
  }

  if $::operatingsystem =~ /(?i:opensuse)/ {
    file { '/etc/systemd/system/bacula-fd.service.d':
        ensure => directory,
    } ->

    file { '/etc/systemd/system/bacula-fd.service.d/override.conf':
        source => 'puppet:///modules/bacula/systemd/override.conf',
        before => Service['bacula-fd'],
    }
  }

  service { 'bacula-fd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => File[$bacula_fd_conf],
  }
}
