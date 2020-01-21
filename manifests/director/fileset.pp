# == Define: bacula::director::fileset
#
# Configure an additional basic file set to be used by the Bacula clients. See the {FileSet
# Resource}[http://www.bacula.org/5.0.x-manuals/en/main/main/Configuring_Director.html#SECTION001870000000000000000] documentation
# for information on the options.
#
# === Parameters
#
# [*ensure*]
#   Ensure the file is present or absent.  The only valid values are <tt>file</tt> or
#   <tt>absent+. Defaults to <tt>file</tt>.
#
# [*enable_vss*]
#   This parameter controls whether bacula will use the VSS service in windows.  Default value is false.
#
# [*exclude_files*]
#   An array of strings consisting of one file or directory name per entry. Directory names should be specified without
#   a trailing slash with Unix path notation.  Default value is undefined.
#
# [*include_files*]
#   *Required*: An array of strings consisting of one file or directory name per entry. Directory names should be specified without
#   a trailing slash with Unix path notation.
#
# [*options*]
#   A hash of options for the fileset.
#
# === Examples
#
#   $servicename_include_files = [
#     '/etc/servicename',
#     '/var/lib/servicename',
#     '/var/log/servicename',
#     '/var/spool/servicename',
#   ]
#
#   $servicename_exclude_files = [
#     '/var/lib/servicename/tmp'
#   ]
#
#   bacula::director::fileset { 'servicename' :
#     ensure         => file,
#     include_files => $servicename_include_files,
#     exclude_files => $servicename_exclude_files,
#   }

define bacula::director::fileset (
  String $ensure = 'file',
  Array[String] $include_files,
  Boolean $enable_vss = false,
  Optional[Array[String]] $exclude_files = undef,
  Optional[Hash] $options = { "Signature" => "SHA1", "Compression" => "GZIP" },
  ) {

  include 'bacula::director'

  # Sterilize the name.
  $sterile_name = regsubst($name, '[^\w]+', '-', 'G')

  file { "/etc/bacula/bacula-dir.d/fileset-${sterile_name}.conf":
    ensure  => $ensure,
    owner   => 'bacula',
    group   => 'bacula',
    mode    => '0640',
    content => template('bacula/fileset.conf.erb'),
    require => File['/etc/bacula/bacula-dir.conf'],
    before  => Service['bacula-dir'],
    notify  => Exec['bacula-dir reload'],
  }
}
