require 'spec_helper'

describe 'bacula::director::custom_config' do
  let(:title) { 'client-config' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:params) {{
          #:ensure => 'file',
          #:director_server => :undef,
          #:content => :undef,
          :source => 'puppet:///modules/bacula/custom-config.conf',
      }}

      it do
        is_expected.to contain_file('/etc/bacula/bacula-dir.d/custom-client-config.conf')
            .with({
              'ensure' => 'file',
              'owner' => 'bacula',
              'group' => 'bacula',
              'mode' => '0640',
              #'content' => [],
              :source => 'puppet:///modules/bacula/custom-config.conf',
            })
            .that_requires('File[/etc/bacula/bacula-dir.conf]')
            .that_comes_before('Service[bacula-dir]')
            .that_notifies('Exec[bacula-dir reload]')
      end
    end
  end
end
