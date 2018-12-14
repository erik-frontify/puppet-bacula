require 'hiera'
require 'spec_helper'

describe 'bacula::console::bat' do
  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }
  hiera = Hiera.new(:config => 'spec/fixtures/hiera/hiera.yaml')

  package = hiera.lookup('bacula::console::bat::package', nil, nil)

  it do
    is_expected.to contain_package(package)
        .with({
          :ensure => 'present',
        })
  end

  it do
    is_expected.to contain_file('/etc/bacula/bat.conf')
        .with({
          :ensure  => 'symlink',
          :target  => '/etc/bacula/bconsole.conf',
        })
        .that_requires("Package[#{package}]")
  end

end
