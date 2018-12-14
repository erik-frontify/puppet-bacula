require 'hiera'
require 'spec_helper'

describe 'bacula::client' do
  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }
  hiera = Hiera.new(:config => 'spec/fixtures/hiera/hiera.yaml')

  on_supported_os.each do |os, facts|
    let(:node) { 'example-host.example.com' }

    context "on #{os}" do

      let(:facts) do
        facts
      end

      package = hiera.lookup('bacula::client::client_package', nil, nil)
      conf_file = '/etc/bacula/bacula-fd.conf'

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
        is_expected.to contain_file(conf_file)
            .with({
              :ensure    => 'file',
              :owner     => 'root',
              :group     => 'root',
              :mode      => '0640',
              :content   => /.*/,
              :show_diff => false,
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
            .that_requires("File[#{conf_file}]")
      end
    end
  end

end
