class bacula::ssl::puppet (
    String $puppet_ssl_dir = '/etc/puppetlabs/puppet/ssl',
    String $tls_ca_cert    = '/var/lib/bacula/ssl/certs/ca.pem',
    String $tls_cert       = "/var/lib/bacula/ssl/certs/${fqdn}.pem",
    String $tls_key        = "/var/lib/bacula/ssl/private_keys/${fqdn}.pem",
    ) {

    # Use certs signed by the puppet CA as the default bacula certificates
    # These files must be copied into place due to SELinux restrictions.
    $tls_cert_path = dirname($tls_ca_cert)
    $tls_key_path  = regsubst($tls_cert_path, 'certs', 'private_keys')
    $tls_parent_dir = dirname($tls_cert_path)

    file {
      default:
          ensure => directory,
      ;

      $tls_parent_dir:
      ;

      [$tls_cert_path, $tls_key_path]:
        require => File[$tls_parent_dir],
      ;
    }

    file {
      default:
          show_diff => false,
      ;

      $tls_ca_cert:
          source  => "file://${puppet_ssl_dir}/certs/ca.pem",
          require => File["${tls_cert_path}"],
      ;

      $tls_cert:
          source  => "file://${puppet_ssl_dir}/certs/${fqdn}.pem",
          require => File["${tls_cert_path}"],
      ;

      $tls_key:
          source  => "file://${puppet_ssl_dir}/private_keys/${fqdn}.pem",
          require => File["${tls_key_path}"],
      ;
    }
}
