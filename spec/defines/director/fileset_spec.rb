require 'spec_helper'

describe 'bacula::director::fileset' do
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
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:title) { 'bacula-fileset' }

      let(:params) {{
        :ensure => 'file',
        :exclude_files => ['/excluded'],
        :include_files => ['/included'],
      }}

      it do
        is_expected.to contain_file('/etc/bacula/bacula-dir.d/fileset-bacula-fileset.conf')
            .with({
              'ensure' => 'file',
              'owner'  => 'bacula',
              'group'  => 'bacula',
              'mode'   => '0640',
            })
            .that_requires('File[/etc/bacula/bacula-dir.conf]')
            .that_comes_before('Service[bacula-dir]')
            .that_notifies('Exec[bconsole reload]')
      end

      context "name with spaces" do
        let(:title) { 'File Server Projects' }

        it do
          is_expected.to contain_file('/etc/bacula/bacula-dir.d/fileset-File-Server-Projects.conf')
            .with({
              'ensure' => 'file',
              'owner'  => 'bacula',
              'group'  => 'bacula',
              'mode'   => '0640',
            })
            .that_requires('File[/etc/bacula/bacula-dir.conf]')
            .that_comes_before('Service[bacula-dir]')
            .that_notifies('Exec[bconsole reload]')
        end
      end
    end
  end
end
