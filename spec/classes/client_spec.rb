require 'spec_helper'

describe 'bacula::client' do
  redhat = {
    :hardwaremodels => 'x86_64',
    :supported_os   => [
      {
        'operatingsystem'        => 'CentOS',
        'operatingsystemrelease' => ['6', '7', '8'],
      },
      {
        'operatingsystem'        => 'RedHat',
        'operatingsystemrelease' => ['6', '7', '8'],
      },
      {
        'operatingsystem'        => 'Fedora',
      },
     ],
  }

  on_supported_os(redhat).each do |os, facts|
    let(:node) { 'example-host.example.com' }

    context "on #{os}" do
      let(:facts) do
        facts
      end

      context "SELinux enabled" do
        let(:facts) {
          facts.merge({ :selinux => true })
        }

        it do
          is_expected.to contain_selboolean('domain_can_mmap_files')
            .with({
              :value      => 'on',
              :persistent => true,
            })
            .that_comes_before('Service[bacula-fd]')
            .that_notifies('Service[bacula-fd]')
        end

        it do
          is_expected.to contain_selinux__module('bacula_fd_fix')
            .with({
              :source_te => 'puppet:///modules/bacula/selinux/bacula_fd_fix.te',
            })
            .that_comes_before('Service[bacula-fd]')
            .that_notifies('Service[bacula-fd]')
        end
      end
    end
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:node) { 'example-host.example.com' }

      let(:facts) do
        facts
      end

      case facts[:osfamily]
        when 'RedHat'
          package = 'bacula-client'
        when 'FreeBSD'
          package = 'bacula9-client'
        when 'windows'
          package = 'bacula'
      end

      it do
        is_expected.to contain_class('bacula::common')
      end

      it do
        is_expected.to contain_package(package) .with({ :ensure => 'installed' })
      end

      it do
        is_expected.to contain_file('bacula-fd.conf')
            .with({
              :ensure => 'file',
            })
            .that_notifies('Service[bacula-fd]')
            .that_requires("Package[#{package}]")
      end

      it do
        is_expected.to contain_service('bacula-fd')
            .with({
              :ensure     => 'running',
              :enable     => true,
              :hasstatus  => true,
              :hasrestart => true,
            })
            .that_requires('File[bacula-fd.conf]')
      end

      context 'Use Puppet certificates by default' do
        let(:params) {{
          :use_puppet_certs => true,
        }}

        it do
          is_expected.to contain_class('bacula::ssl::puppet')
        end
      end

      context 'Do not use Puppet certificates by default' do
        let(:params) {{
          :use_puppet_certs => false,
        }}

        it do
          is_expected.not_to contain_class('bacula::ssl::puppet')
        end
      end
    end
  end
end
