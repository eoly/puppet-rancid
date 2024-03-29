require 'spec_helper'
describe 'rancid' do

  context 'with default params on EL 6' do
    let(:facts) do
      { :osfamily                   => 'RedHat',
        :operatingsystemmajrelease  => '6',
      }
    end

    it { should compile.with_all_deps }

    context 'with show_cloginrc_diff unset' do
      it {should contain_file('rancid_cloginrc').with_show_diff('true')}
    end

    context 'with show_cloginrc_diff set to true' do
      let(:params) { {:show_cloginrc_diff => true} }
      it {should contain_file('rancid_cloginrc').with_show_diff('true')}
    end

    context 'with show_cloginrc_diff set to false' do
      let(:params) { {:show_cloginrc_diff => false} }
      it {should contain_file('rancid_cloginrc').with_show_diff('false')}
    end
  end

  context 'with default params on osfamily Debian' do
    let(:facts) { { :osfamily => 'Debian' } }

    it { should compile.with_all_deps }

    context 'with show_cloginrc_diff unset' do
      it {should contain_file('rancid_cloginrc').with_show_diff('true')}
    end

    context 'with show_cloginrc_diff set to true' do
      let(:params) { {:show_cloginrc_diff => true} }
      it {should contain_file('rancid_cloginrc').with_show_diff('true')}
    end

    context 'with show_cloginrc_diff set to false' do
      let(:params) { {:show_cloginrc_diff => false} }
      it {should contain_file('rancid_cloginrc').with_show_diff('false')}
    end
  end

  context 'version control systems' do
    let(:facts) { { :osfamily => 'Debian' } }
    context 'cvs' do
      let(:params) { {:vcs => 'cvs'} }
      it { is_expected.to contain_file('rancid_config')
                            .with_content(/^RCSSYS=cvs;/)
                            .with_content(/^CVSROOT=\$BASEDIR\/CVS;/)
      }
    end

    context 'cvs with a root' do
      let(:params) { {:vcs => 'cvs', :vcsroot => '/my/repo'} }
      it { is_expected.to contain_file('rancid_config')
                            .with_content(/^RCSSYS=cvs;/)
                            .with_content(/^CVSROOT=\/my\/repo;/)
      }
    end

    context 'svn' do
      let(:params) { {:vcs => 'svn'} }
      it { is_expected.to contain_file('rancid_config')
                            .with_content(/^CVSROOT=\$BASEDIR\/svn;/)
                            .with_content(/^RCSSYS=svn;/)
      }
    end

    context 'svn with a root' do
      let(:params) { {:vcs => 'svn', :vcsroot => '/my/repo'} }
      it { is_expected.to contain_file('rancid_config')
                            .with_content(/^RCSSYS=svn;/)
                            .with_content(/^CVSROOT=\/my\/repo;/)
      }
    end

    context 'git' do
      let(:params) { {:vcs => 'git'} }
      it { is_expected.to contain_file('rancid_config')
                            .with_content(/^CVSROOT=\$BASEDIR\/.git;/)
                            .with_content(/^RCSSYS=git;/)
      }
    end

    context 'git with a root' do
      let(:params) { {:vcs => 'git', :vcsroot => '/my/repo'} }
      it { is_expected.to contain_file('rancid_config')
                            .with_content(/^RCSSYS=git;/)
                            .with_content(/^CVSROOT=\/my\/repo;/)
      }
    end

    context 'manage_packages' do
      context 'true - git' do
        let(:params) { {:vcs => 'git', :manage_vcs_packages => true} }
        it { is_expected.to contain_package('git') }
        it { is_expected.not_to contain_package('subversion') }
        it { is_expected.not_to contain_package('cvs') }
      end

      context 'true - svn' do
        let(:params) { {:vcs => 'svn', :manage_vcs_packages => true} }
        it { is_expected.not_to contain_package('git') }
        it { is_expected.to contain_package('subversion') }
        it { is_expected.not_to contain_package('cvs') }
      end

      context 'true - cvs' do
        let(:params) { {:vcs => 'cvs', :manage_vcs_packages => true} }
        it { is_expected.not_to contain_package('git') }
        it { is_expected.not_to contain_package('subversion') }
        it { is_expected.to contain_package('cvs') }
      end

      context 'false' do
        let(:params) { {:vcs => 'git', :manage_vcs_packages => false} }
        it { is_expected.not_to contain_package('git') }
        it { is_expected.not_to contain_package('subversion') }
        it { is_expected.not_to contain_package('cvs') }
      end
    end

  end

end
