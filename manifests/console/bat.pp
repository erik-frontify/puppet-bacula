# == Class: bacula::console::bat
#
# This class installs the BAT (Bacula Admin Tool) package
#
# === Parameters
#
# [*package*]
#  The name of the package that provides the bat tool.
#
# === Actions:
#
# * Ensure the BAT package is installed
# * Ensure <tt>/etc/bacula/bat.conf</tt> points to <tt>/etc/bacula/bconsole.conf</tt>
#
# === Sample Usage:
#
#  include 'bacula::console::bat'
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

class bacula::console::bat (
  String $package = 'bacula-console-bat',
  ) {

  include 'bacula::console'

  package { $package:
    ensure => present,
  }

  file { '/etc/bacula/bat.conf':
    ensure  => 'symlink',
    target  => '/etc/bacula/bconsole.conf',
    require => Package[$package],
  }
}
