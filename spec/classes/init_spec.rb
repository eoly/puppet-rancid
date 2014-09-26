require 'spec_helper'
describe 'rancid' do

  context 'with default params on EL 6' do
    let(:facts) do
      { :osfamily                   => 'RedHat',
        :operatingsystemmajrelease  => '6',
      }
    end

    it { should compile.with_all_deps }
  end

  context 'with default params on osfamily Debian' do
    let(:facts) { { :osfamily => 'Debian' } }

    it { should compile.with_all_deps }
  end
end
