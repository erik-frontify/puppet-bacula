require 'hiera'
require 'spec_helper'

describe 'bacula::director::sqlite' do
  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }
  hiera = Hiera.new(:config => 'spec/fixtures/hiera/hiera.yaml')

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({ :osfamily => 'RedHat' })
      end

      p = hiera.lookup('bacula::director::sqlite::db_package', nil, nil)

      it do
        is_expected.to contain_package(p)
            .with({
              :ensure => 'installed',
            })
      end

      it do
        is_expected.to contain_sqlite__db("bacula")
            .with({
              "ensure" => "present",
              "location" => "/var/lib/bacula/bacula.db",
              "owner" => "bacula",
              "group" => "bacula",
              })
              #"require" => "File[/var/lib/bacula]",
              #"notify" => "Exec[make_db_tables]",
      end

      it do
        is_expected.to contain_file("/usr/local/libexec/bacula")
            .with({
              "ensure" => "directory",
              "owner" => "root",
              "group" => "root",
              "mode" => "0755",
              })
      end

      it do
        is_expected.to contain_file("/usr/local/libexec/bacula/make_sqlite3_tables.sh")
            .with({
              "owner" => "root",
              "group" => "root",
              "mode" => "0755",
              })
              .that_requires("Package[#{p}]")
      end

      it do
        is_expected.to contain_exec("make_db_tables")
          .with({
            "command" => '/usr/local/libexec/bacula/make_sqlite3_tables.sh',
            "refreshonly" => true,
          })
          #.that_requires("File[/usr/local/libexec/bacula/make_sqlite3_tables.sh]")
          #.that_comes_before("Service[bacula-dir]")
      end
    end
  end
end
