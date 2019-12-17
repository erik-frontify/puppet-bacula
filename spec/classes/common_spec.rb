require 'spec_helper'

describe 'bacula::common' do
  opensuse = {
    :hardwaremodels => 'x86_64',
    :supported_os   => [
      {
        'operatingsystem'        => 'openSUSE',
      },
    ],
  }

  sles = {
    :hardwaremodels => 'x86_64',
    :supported_os   => [
      {
        'operatingsystem'        => 'SLES',
        'operatingsystemrelease' => ['12'],
      },
    ],
  }

  redhat = {
    :hardwaremodels => 'x86_64',
    :supported_os   => [
      {
        'operatingsystem'        => 'RedHat',
        'operatingsystemrelease' => ['7', '8'],
      },
    ],
  }


  on_supported_os(sles).each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      baseurl = 'http://download.opensuse.org/repositories/home:/dschossig/SLE_12_SP3'

      it do
        is_expected.to contain_zypprepo('home_dschossig_SLE_12_SP3')
          .with({
            :baseurl       => baseurl,
            :enabled       => '1',
            :autorefresh   => '1',
            :name          => 'home:dschossig (SLE_12_SP3)',
            :gpgcheck      => '1',
            :gpgkey        => "#{baseurl}/repodata/repomd.xml.key",
            :priority      => '99',
            :keeppackages  => '1',
            :type          => 'rpm-md',
          })
      end
    end
  end

  #on_supported_os(opensuse).each do |os, facts|
  #  context "on #{os}" do
  #    let(:facts) do
  #      facts
  #    end

  #    context "OpenSUSE zypper repository" do
  #      let(:facts) {
  #        facts.merge({ :lsbdistdescription => 'openSUSE Leap 42.3' })
  #      }

  #      baseurl = 'http://download.opensuse.org/repositories/home:/Ximi1970:/openSUSE:/Extra/openSUSE_Leap_42.3'

  #      it do
  #        is_expected.to contain_zypprepo('home_Ximi1970_openSUSE_Extra')
  #            .with({
  #              :baseurl      => baseurl,
  #              :enabled      => '1',
  #              :autorefresh  => '1',
  #              :name         => 'home_Ximi1970_openSUSE_Extra',
  #              :gpgcheck     => '1',
  #              :gpgkey       => "#{baseurl}/repodata/repomd.xml.key",
  #              :priority     => '99',
  #              :keeppackages => '1',
  #              :type         => 'rpm-md',
  #            })
  #      end
  #    end
  #  end
  #end

  on_supported_os(redhat).each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it do
        is_expected.to contain_package('bacula-common') .with({ 'ensure' => 'installed', })
      end

      it do
        is_expected.to contain_file('/usr/lib64/bacula')
      end

      it do
        is_expected.to contain_file('/etc/bacula')
            .with({
              :ensure  => 'directory',
              :owner   => 'bacula',
              :group   => 'bacula',
              :mode    => '0750',
              :purge   => false,
              :force   => false,
              :recurse => false,
              :source  => nil,
            })
            .that_requires('Package[bacula-common]')
      end

      it do
        is_expected.to contain_file('/etc/bacula/scripts')
            .with({
              'ensure' => 'directory',
              'owner' => 'bacula',
              'group' => 'bacula',
            })
            .that_requires('Package[bacula-common]')
      end

      it do
        is_expected.to contain_file('/var/lib/bacula')
            .with({
              :ensure  => 'directory',
              :owner   => 'bacula',
              :group   => 'bacula',
              :mode    => '0775',
            })
            .that_requires('Package[bacula-common]')
      end

      it do
        is_expected.to contain_file('/var/spool/bacula')
            .with({
              'ensure' => 'directory',
              'owner' => 'bacula',
              'group' => 'bacula',
              'mode' => '0755',
            })
            .that_requires('Package[bacula-common]')
      end

      it do
        is_expected.to contain_file('/var/log/bacula')
            .with({
              'ensure' => 'directory',
              'recurse' => true,
              'owner' => 'bacula',
              'group' => 'bacula',
              'mode' => '0755',
            })
            .that_requires('Package[bacula-common]')
      end
    end
  end
end
