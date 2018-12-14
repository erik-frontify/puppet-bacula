require 'spec_helper'

describe 'bacula::director::fileset' do
  let(:title) { 'bacula-fileset' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

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
            .that_notifies('Exec[bacula-dir reload]')
      end
    end
  end

end
