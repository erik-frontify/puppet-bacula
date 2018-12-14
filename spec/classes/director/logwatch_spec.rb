require 'spec_helper'

describe 'bacula::director::logwatch' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context "logwatch_enable => true" do
        let(:params) {{
          :logwatch_enabled => true,
        }}

        it do
          is_expected.to contain_file('/etc/logwatch/conf/logfiles/bacula.conf')
              .with({
                :ensure  => 'file',
                :owner   => 'root',
                :group   => 'root',
                :mode    => '0644',
              })
        end

        it do
          is_expected.to contain_file('/etc/logwatch/scripts/services/bacula')
              .with({
                'ensure' => 'file',
                'owner' => 'root',
                'group' => 'root',
                'mode' => '0755',
                'source' => nil,
              })
        end

        it do
          is_expected.to contain_file('/etc/logwatch/scripts/shared/applybaculadate')
              .with({
                'ensure' => 'file',
                'owner' => 'root',
                'group' => 'root',
                'mode' => '0755',
                'source' => nil,
              })
        end
      end

      context "logwatch_enable => false" do
        let(:params) {{
          :logwatch_enabled => false,
        }}

        it do
          is_expected.to contain_file('/etc/logwatch/conf/services/bacula.conf')
              .with({
                'ensure' => 'absent',
              })
        end
      end

    end
  end
end
