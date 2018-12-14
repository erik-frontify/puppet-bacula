require 'hiera'
require 'spec_helper'

describe 'bacula::director::mysql' do
  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }
  hiera = Hiera.new(:config => 'spec/fixtures/hiera/hiera.yaml')

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({ :osfamily => 'RedHat' })
      end

      p = hiera.lookup('bacula::director::mysql::db_package', nil, nil)

      it do
        is_expected.to contain_package(p)
      end

      it do
        is_expected.to contain_mysql__db('bacula')
            .with({
              'user'     => 'bacula',
              'password' => %r{\w{32}},
              'host'     => 'localhost',
              'grant'    => ['ALL'],
            })
            .that_comes_before('Exec[make_db_tables]')
      end

      it do
        is_expected.to contain_exec('make_db_tables')
            .with({
              #'command'     => %r{--host=localhost --user= --password=\w* --port=3306 --database=bacula},
              'refreshonly' => true,
              'logoutput'   => true,
            })
            #'require' => 'Package[$::bacula::params::director_mysql_package]',
            #'before' => 'Service[bacula-dir]',
      end

    end
  end
end
