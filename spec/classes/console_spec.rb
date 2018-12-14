require 'hiera'
require 'spec_helper'

describe 'bacula::console' do
  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }
  hiera = Hiera.new(:config => 'spec/fixtures/hiera/hiera.yaml')

  package = hiera.lookup('bacula::console::package', nil, nil)

  it do
    is_expected.to contain_package(package)
        .with({
          :ensure => 'present',
        })
  end

  it do
    is_expected.to contain_file('/etc/bacula/bconsole.conf')
        .with({
          :ensure    => 'file',
          :owner     => 'bacula',
          :group     => 'bacula',
          :mode      => '0640',
          :content   => %r{\w{32}},
          :show_diff => false,
        })
        .that_requires("Package[#{package}]")
  end

  it do
    is_expected.to contain_exec('bacula-dir reload')
        .with({
          'command' => '/bin/echo reload | /usr/sbin/bconsole',
          'logoutput' => 'on_failure',
          'refreshonly' => true,
          'timeout' => '10',
        })
        .that_requires("Package[#{package}]")
  end

end
