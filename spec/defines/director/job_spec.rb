require 'spec_helper'

describe 'bacula::director::job' do
  let(:title) { 'File_Server_Easily_Compressed' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:params) {{
        :ensure   => 'file',
        :client   => 'host.example.com',
        :jobdefs  => 'Default',
        :fileset  => 'File Server Easily Compressed',
        :schedule => 'ThirdWeeklyCycle',
      }}

      it do
        is_expected.to contain_file("/etc/bacula/bacula-dir.d/custom-job-#{title}.conf")
            .with({
              :ensure => 'file',
              :owner  => 'bacula',
              :group  => 'bacula',
              :mode   => '0640',
            })
            .that_requires('File[/etc/bacula/bacula-dir.conf]')
            .that_comes_before('Service[bacula-dir]')
            .that_notifies('Exec[bacula-dir reload]')
      end
    end
  end
end
