require 'spec_helper'

describe 'bacula::ssl::puppet' do
  on_supported_os().each do |os, facts|
    context "on #{os}" do
      let(:node) { 'example-host.example.com' }

      let(:facts) do
        facts
      end

      case facts[:operatingsystem]
        when 'Fedora'
          puppet_ssl_dir  = '/etc/puppet/ssl'
          tls_cert_path   = '/var/lib/bacula/ssl/certs'
          tls_key_path    = '/var/lib/bacula/ssl/private_keys'
          tls_parent_path = '/var/lib/bacula/ssl'
        when 'windows'
          puppet_ssl_dir  = 'C:/ProgramData/PuppetLabs/puppet/etc/ssl'
          tls_cert_path   = 'C:/ProgramData/Bacula/lib/ssl/certs'
          tls_key_path    = 'C:/ProgramData/Bacula/lib/ssl/private_keys'
          tls_parent_path = 'C:/ProgramData/Bacula/lib/ssl'
        else
          puppet_ssl_dir  = '/etc/puppetlabs/puppet/ssl'
          tls_cert_path   = '/var/lib/bacula/ssl/certs'
          tls_key_path    = '/var/lib/bacula/ssl/private_keys'
          tls_parent_path = '/var/lib/bacula/ssl'
      end

      tls_ca_cert = "#{tls_cert_path}/ca.pem"
      tls_cert    = "#{tls_cert_path}/example-host.example.com.pem"
      tls_key     = "#{tls_key_path}/example-host.example.com.pem"

      it do
        is_expected.to contain_file(tls_parent_path) .with({ :ensure => 'directory' })
      end

      it do
        is_expected.to contain_file(tls_cert_path) .with({ :ensure => 'directory' })
      end

      it do
        is_expected.to contain_file(tls_key_path) .with({ :ensure => 'directory' })
      end

      it do
        is_expected.to contain_file(tls_ca_cert)
            .with({
              :show_diff => false,
              :source => "file://#{puppet_ssl_dir}/certs/ca.pem",
            })
            .that_requires("File[#{tls_cert_path}]")
            .that_notifies('Service[bacula-fd]')
      end

      it do
        is_expected.to contain_file(tls_cert)
            .with({
              :show_diff => false,
              :source => "file://#{puppet_ssl_dir}/certs/#{node}.pem",
            })
            .that_requires("File[#{tls_cert_path}]")
            .that_notifies('Service[bacula-fd]')
      end

      it do
        is_expected.to contain_file(tls_key)
            .with({
              :show_diff => false,
              :source => "file://#{puppet_ssl_dir}/private_keys/#{node}.pem",
            })
            .that_requires("File[#{tls_key_path}]")
            .that_notifies('Service[bacula-fd]')
      end
    end
  end
end
