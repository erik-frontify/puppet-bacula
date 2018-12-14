require 'spec_helper'

describe 'bacula::director::postgresql' do
  redhat = {
    :hardwaremodels => 'x86_64',
    :supported_os   => [
      {
        'operatingsystem'        => 'RedHat',
        'operatingsystemrelease' => ['6', '7', '8'],
      },
      {
        'operatingsystem'        => 'Fedora',
        'operatingsystemrelease' => ['30'],
      },
    ],
  }

  on_supported_os(redhat).each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({ :osfamily => 'RedHat' })
      end

      let(:pre_condition) { include 'bacula::director' }

      it { is_expected.to contain_class('postgresql::server') }

      p = 'bacula-director-postgresql'

      it do
        is_expected.to contain_package(p)
            .with({
              :ensure => 'installed',
            })
      end

      it do
        is_expected.to contain_postgresql__server__role('bacula') .with({ :password_hash => %r{^md5\w{32}}, })
      end

      it do
        is_expected.to contain_postgresql__server__db('bacula')
      end

      it do
        is_expected.to contain_exec('make_db_tables')
            .with({
              :command     => '/usr/libexec/bacula/make_postgresql_tables',
              :user        => 'postgres',
              :refreshonly => true,
              :logoutput   => true,
            })
            .that_requires('Postgresql::Server::Db[bacula]')
      end
    end

  end
end
