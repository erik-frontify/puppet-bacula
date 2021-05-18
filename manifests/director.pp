# == Class: bacula::director
#
# This class manages the Bacula director component
#
# === Parameters
#
# [*backup_catalog*]
#   Perform a nightly backup of the catalog database from the director server. You may wish to set this to
#   <code>false</code> if you are maintaining your own database backups.
#
# [*clients*]
#   For directors, <tt>$clients</tt> is a hash of clients.  The keys are the clients while the value is a hash of parameters. The
#   parameters accepted are the same as the <tt>bacula::client::config</tt> define.
#
# [*console_password*]
#   The console's password
#
# [*db_backend*]
#   The database backend to use
#
# [*db_database*]
#   The db database to connect to on <tt>$db_host</tt>
#
# [*db_host*]
#   The db server host to connect to
#
# [*db_password*]
#   The password to authenticate <tt>$db_user</tt> with
#
# [*db_port*]
#   The port to connect to the database server on
#
# [*db_user*]
#   The user to authenticate to <tt>$db_db</tt> with.
#
# [*db_user_host*]
#   The host string used by MySQL to allow connections from
#
# [*director_password*]
#   The director's password
#
# [*director_server*]
#   The FQDN of the bacula director
#
# [*director_template*]
#   The ERB template to use for configuring the director instead of the one
#   included with the module
#
# [*mail_command*]
#   The {command}[http://www.bacula.org/5.0.x-manuals/en/main/main/Messages_Resource.html#12970] bacula will use to send mail. Defaults to <code>"/usr/sbin/bsmtp -h localhost -f bacula@${::fqdn} -s \"Bacula %t %e (for %c)\" %r"</code>.
#
# [*mail_to*]
#   Send the message to this email address for all jobs. Will default to <code>root@${::fqdn}</code> if it and
#   <code>mail_to_on_error</code> are left undefined.
#
# [*mail_to_daemon*]
#   Send daemon messages to this email address. Will default to either <code>$mail_to</code> or <code>$mail_to_on_error</code>
#   in that order if left undefined.
#
# [*mail_to_on_error*]
#   Send the message to this email address if the Job terminates with an error condition.
#
# [*mail_to_operator*]
#   Send the message to this email address. Will default to either <code>$mail_to</code> or <code>$mail_to_on_error</code> in
#   that order if left undefined.
#
# [*manage_config_dir*]
#   Whether to purge all non-managed files from the bacula config directory
#
# [*max_concurrent_jobs*]
#   The Maxumum number of Concurrent Jobs, defaults to 5
#
# [*manage_console*]
#   Whether bconsole should be managed on the node
#
# [*manage_db*]
#   Whether to manage the existence of the database.  If true, the <tt>$db_user</tt>
#   must have privileges to create databases on <tt>$db_host</tt>
#
# [*manage_db_tables*]
#   Whether to create the DB tables during install
#
# [*operator_command*]
#   The {command}[http://www.bacula.org/5.0.x-manuals/en/main/main/Messages_Resource.html#12997] bacula will use to send mail for Operator messages. Defaults to <code>"/usr/sbin/bsmtp -h localhost -f bacula@${::fqdn} -s \"Bacula Intervention Required (for %c)\" %r"</code>.
#
# [*plugin_dir*]
#   The directory Bacula plugins are stored in. Use this parameter if you are providing Bacula plugins for use. Only use if the package in the distro repositories supports plugins or you have included a respository with a newer Bacula packaged for your distro. If this is anything other than `undef` and you are not providing any plugins in this directory Bacula will throw an error every time it starts even if the package supports plugins.
#
# [*storage_server*]
#   The FQDN of the storage server
#
# [*tls_allowed_cn*]
#   Array of common name attribute of allowed peer certificates. If this directive is specified, all server
#   certificates will be verified against this list. This can be used to ensure that only the CA-approved Director
#   may connect.
#
# [*tls_ca_cert*]
#   The full path and filename specifying a PEM encoded TLS CA certificate(s). Multiple certificates are permitted in
#   the file. One of <tt>TLS CA Certificate File</tt> or <tt>TLS CA Certificate Dir</tt> are required in a server context if
#   <tt>TLS Verify Peer</tt> is also specified, and are always required in a client context.
#
# [*tls_ca_cert_dir*]
#   Full path to TLS CA certificate directory. In the current implementation, certificates must be stored PEM
#   encoded with OpenSSL-compatible hashes, which is the subject name's hash and an extension of .0. One of
#   <tt>TLS CA Certificate File</tt> or <tt>TLS CA Certificate Dir</tt> are required in a server context if <tt>TLS Verify Peer</tt>
#   is also specified, and are always required in a client context.
#
# [*tls_cert*]
#   The full path and filename of a PEM encoded TLS certificate. It can be used as either a client or server
#   certificate. PEM stands for Privacy Enhanced Mail, but in this context refers to how the certificates are
#   encoded. It is used because PEM files are base64 encoded and hence ASCII text based rather than binary. They may
#   also contain encrypted information.
#
# [*tls_key*]
#   The full path and filename of a PEM encoded TLS private key. It must correspond to the TLS certificate.
#
# [*tls_require*]
#   Require TLS connections. This directive is ignored unless <tt>TLS Enable</tt> is set to yes. If TLS is not required,
#   and TLS is enabled, then Bacula will connect with other daemons either with or without TLS depending on what the
#   other daemon requests. If TLS is enabled and TLS is required, then Bacula will refuse any connection that does
#   not use TLS. Valid values are <tt>true</tt> or <tt>false</tt>.
#
# [*tls_verify_peer*]
#   Verify peer certificate. Instructs server to request and verify the client's x509 certificate. Any client
#   certificate signed by a known-CA will be accepted unless the <tt>TLS Allowed CN</tt> configuration directive is used, in
#   which case the client certificate must correspond to the Allowed Common Name specified. Valid values are <tt>true</tt>
#   or <tt>false</tt>.
#
# [*use_tls*]
#   Whether to use {Bacula TLS - Communications
#   Encryption}[http://www.bacula.org/en/dev-manual/main/main/Bacula_TLS_Communications.html].
#
# [*use_vol_purge_script*]
#   Run a script to automatically clean up old volumes from the default file pool after the BackupCatalog job is run each day. It
#   is only valid if the Director and the Storage daemon are running on the same host. <tt>true</tt> or <tt>false</tt> (default).
#
# [*use_vol_purge_mvdir*]
#   The volume purge script can move volume files to a side directory for further inspection instead of removing the volume files.
#   Bacula has a tendency (at least as of version 5.0.x) to occasionally label volume files incorrectly or store jobs in a volume
#   labeled differently than the job name. Takes an absolute file file path to a directory or <tt>undef</tt> the default.
#
# [*volume_autoprune*]
#   {Auto prune volumes}[http://www.bacula.org/5.0.x-manuals/en/main/main/Configuring_Director.html#AutoPrune] in
#   the default pool.
#
# [*volume_autoprune_diff*]
#   {Auto prune volumes}[http://www.bacula.org/5.0.x-manuals/en/main/main/Configuring_Director.html#AutoPrune] in
#   the default differential pool.
#
# [*volume_autoprune_full*]
#   {Auto prune volumes}[http://www.bacula.org/5.0.x-manuals/en/main/main/Configuring_Director.html#AutoPrune] in
#   the default full pool.
#
# [*volume_autoprune_incr*]
#   {Auto prune volumes}[http://www.bacula.org/5.0.x-manuals/en/main/main/Configuring_Director.html#AutoPrune] in
#   the default incremental pool.
#
# [*volume_retention*]
#   Length of time to {retain volumes}[http://www.bacula.org/5.0.x-manuals/en/main/main/Configuring_Director.html#VolRetention] in
#   the default pool.
#
# [*volume_retention_diff*]
#   Length of time to {retain volumes}[http://www.bacula.org/5.0.x-manuals/en/main/main/Configuring_Director.html#VolRetention] in
#   the default differential pool.
#
# [*volume_retention_full*]
#   Length of time to {retain volumes}[http://www.bacula.org/5.0.x-manuals/en/main/main/Configuring_Director.html#VolRetention] in
#   the default full pool.
#
# [*volume_retention_incr*]
#   Length of time to {retain volumes}[http://www.bacula.org/5.0.x-manuals/en/main/main/Configuring_Director.html#VolRetention] in
#   the default incremental pool.
#
# === Copyright
#
# Copyright 2021 Michael Watters
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

class bacula::director (
  Boolean $backup_catalog                   = true,
  Optional[Hash] $clients                   = undef,
  String $console_password                  = extlib::cache_data('bacula', 'console_password', extlib::random_password(32)),
  String $db_backend                        = 'sqlite',
  String $db_database                       = 'bacula',
  String $db_host                           = 'localhost',
  String $db_password                       = extlib::cache_data('bacula', 'db_password', extlib::random_password(32)),
  Optional[String] $db_port                 = undef,
  String $db_user                           = 'bacula',
  Optional[String] $db_user_host            = undef,
  String $dir_template                      = 'bacula/bacula-dir.conf.erb',
  String $director_package                  = 'bacula-director',
  String $director_password                 = extlib::cache_data('bacula', 'director_password', extlib::random_password(32)),
  String $director_server                   = $facts['fqdn'],
  String $director_service                  = 'bacula-dir',
  String $mail_command                      = "/usr/sbin/bsmtp -h localhost -f bacula@${::fqdn} -s \\\"Bacula %t %e (for %c)\\\" %r",
  Optional[String] $mail_to                 = undef,
  Optional[String] $mail_to_daemon          = undef,
  Optional[String] $mail_to_on_error        = undef,
  Optional[String] $mail_to_operator        = undef,
  Boolean $manage_config_dir                = false,
  Boolean $manage_db                        = true,
  Boolean $manage_db_tables                 = true,
  String $operator_command                  = "/usr/sbin/bsmtp -h localhost -f bacula@${::fqdn} -s \\\"Bacula Intervention Required (for %c)\\\" %r",
  String $var_dir                           = '/var/lib/bacula',
  String $pid_dir                           = $var_dir,
  Optional[String] $plugin_dir              = '/usr/lib64/bacula',
  String $working_dir                       = $var_dir,
  String $storage_server                    = "bacula.${facts['domain']}",
  Array[String] $tls_allowed_cn             = [],
  String $tls_cert                          = "/var/lib/bacula/ssl/certs/${::fqdn}.pem",
  String $tls_key                           = "/var/lib/bacula/ssl/private_keys/${::fqdn}.pem",
  Optional[String] $tls_ca_cert_dir         = undef,
  String $tls_ca_cert                       = '/var/lib/bacula/ssl/certs/ca.pem',
  Boolean $tls_require                      = true,
  Boolean $tls_verify_peer                  = true,
  Boolean $use_tls                          = true,
  Boolean $use_vol_purge_script             = false,
  Boolean $use_vol_purge_mvdir              = false,
  Boolean $volume_autoprune                 = true,
  Boolean $volume_autoprune_diff            = true,
  Boolean $volume_autoprune_full            = true,
  Boolean $volume_autoprune_incr            = true,
  String $volume_max_bytes                  = '10G',
  String $volume_max_volumes                = '2000',
  String $volume_retention                  = '1 Year',
  String $volume_retention_diff             = '40 Days',
  String $volume_retention_full             = '1 Year',
  String $volume_retention_incr             = '10 Days',
  String $storage_default_mount             = '/mnt/bacula',
  Integer $max_concurrent_jobs              = 5,
  Boolean $use_puppet_certs                 = true,
  ) {

  include 'bacula::common'
  include 'bacula::console'

  package { $director_package:
    ensure => installed,
  }

  if $use_puppet_certs {
    include 'bacula::ssl::puppet'
  }

  if $clients {
    # This function takes each client specified in <tt>$clients</tt>
    # and generates a <tt>bacula::client</tt> resource for each
    create_resources('bacula::client::config', $clients)
  }

  file { '/etc/bacula/bacula-dir.d/empty.conf':
    ensure  => file,
    owner   => 'bacula',
    group   => 'bacula',
    mode    => '0640',
    content => '',
  }

  $config_dir_source = $manage_config_dir ? {
    true    => 'puppet:///modules/bacula/bacula-empty.dir',
    default => undef,
  }

  # Create the configuration for the Director and make sure the directory for
  # the per-Client configuration is created before we run the realization for
  # the exported files below
  file { '/etc/bacula/bacula-dir.d':
    ensure  => directory,
    owner   => 'bacula',
    group   => 'bacula',
    mode    => '0750',
    purge   => $manage_config_dir,
    force   => $manage_config_dir,
    recurse => $manage_config_dir,
    source  => $config_dir_source,
    notify  => Exec['bconsole reload'],
    require => Package[$director_package],
  }

  #if defined('$plugin_dir') {
  #  $file_requires = File[
  #    '/etc/bacula/bacula-dir.d',
  #    '/etc/bacula/bacula-dir.d/empty.conf',
  #    $var_dir,
  #    '/var/log/bacula',
  #    '/var/spool/bacula',
  #    $plugin_dir]
  #}

  #else {
  #  $file_requires = File[
  #    '/etc/bacula/bacula-dir.d',
  #    '/etc/bacula/bacula-dir.d/empty.conf',
  #    #'/var/lib/bacula',
  #    '/var/log/bacula',
  #    '/var/spool/bacula']
  #}

  $purge_script_ensure = $use_vol_purge_script ? {
    true    => file,
    default => absent,
  }

  file { '/usr/local/bin/bacula-prune-all-volumes.sh':
    ensure  => $purge_script_ensure,
    owner   => 'bacula',
    group   => 'bacula',
    mode    => '0750',
    content => template('bacula/bacula-prune-all-volumes.sh.erb'),
    before  => File['/etc/bacula/bacula-dir.conf'],
  }

  $purge_script_command = $use_vol_purge_mvdir ? {
    undef   => "/usr/local/bin/bacula-prune-all-volumes.sh -s ${storage_default_mount}/default",
    default => "/usr/local/bin/bacula-prune-all-volumes.sh -s ${storage_default_mount}/default -m ${use_vol_purge_mvdir}",
  }

  $db_driver = $db_backend ? {
    'postgresql' => 'PostgreSQL',
    'mysql'      => 'MySQL',
    'sqlite'     => 'dbi:sqlite',
  }

  file { '/etc/bacula/bacula-dir.conf':
    ensure    => file,
    owner     => 'bacula',
    group     => 'bacula',
    mode      => '0640',
    content   => template($dir_template),
    before    => Service['bacula-dir'],
    notify    => Exec['bconsole reload'],
    show_diff => false,
  }

  if $manage_db or $manage_db_tables {
    case $db_backend {
      'mysql'  : {
        class { 'bacula::director::mysql':
          db_database   => $db_database,
          db_host       => $db_host,
          db_password   => $db_password,
          db_port       => $db_port,
          db_user       => $db_user,
          db_user_host  => $db_user_host,
          manage_db     => $manage_db,
        }
      }

      'postgresql' : {
        include 'bacula::director::postgresql'
      }

      'sqlite' : {
        include 'bacula::director::sqlite'
      }

      default  : {
        fail "The bacula module does not support the ${db_backend} database backend."
      }
    }
  }

  # Register the Service so we can manage it through Puppet
  if $manage_db_tables {
    $service_require = [
      Exec['make_db_tables'],
      File['/etc/bacula/bacula-dir.conf'],
    ]
  } else {
    $service_require = File['/etc/bacula/bacula-dir.conf']
  }

  service { 'bacula-dir':
    ensure     => running,
    name       => $director_service,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => $service_require,
  }
}
