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

end
