require 'hiera'
require 'spec_helper'

describe 'bacula::client' do
  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }
  hiera = Hiera.new(:config => 'spec/fixtures/hiera/hiera.yaml')

  linux = {
    :hardwaremodels => 'x86_64',
    :supported_os   => [
      {
        'operatingsystem'        => 'CentOS',
      },
      {
        'operatingsystem'        => 'RedHat',
      },
      {
        'operatingsystem'        => 'Fedora',
      },
     ],
  }

  on_supported_os(linux).each do |os, facts|
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
          is_expected.to contain_selinux__module('bacula_fd_fix')
            .with({
              :source_te => 'puppet:///modules/bacula/selinux/bacula_fd_fix.te',
            })
            .that_comes_before('Service[bacula-fd]')
        end
      end
    end
  end

  on_supported_os.each do |os, facts|
    let(:node) { 'example-host.example.com' }

    context "on #{os}" do
      let(:facts) do
        facts
      end

      package = hiera.lookup('bacula::client::client_package', nil, nil)

      it do
        is_expected.to contain_class('bacula::common')
      end

      it do
        is_expected.to contain_package(package)
            .with({
              :ensure => 'installed',
            })
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
    end
  end
end
