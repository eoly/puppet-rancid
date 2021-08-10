require 'spec_helper'
describe 'rancid::router_db' do
  let(:title) { 'group1' }

  let(:facts) { { :osfamily => 'Debian' } }

  context 'Use correct field separator' do
    let(:params) {
      { :devices => {
          'group1' => {
            'foo.mydomain' => {
              'hostname' => 'foo.mydomain',
              'type' => 'cisco',
              'status' => 'up',
            }
          }
        },
        :router_db_mode => 0123,
      }
    }

    it {
      should contain_file('/var/lib/rancid/group1/router.db')
               .with_content(/^foo.mydomain;cisco;up$/)
               .with_owner('rancid')
               .with_group('rancid')
               .with_mode(0123)
    }
  end

  context 'router.db should be stable with multiple entries' do
    let(:params) {
      { :devices => {
          'group1' => {
            'foo.mydomain' => {
              'hostname' => 'foo.mydomain',
              'type' => 'cisco',
              'status' => 'up',
            },
            'bar.mydomain' => {
              'hostname' => 'bar.mydomain',
              'type' => 'dnos10',
              'status' => 'up',
            }
          }
        },
        :router_db_mode => 0123,
      }
    }

    it {
      should contain_file('/var/lib/rancid/group1/router.db')
               .with_content(/\Abar.mydomain;dnos10;up\nfoo.mydomain;cisco;up\Z/)
               .with_owner('rancid')
               .with_group('rancid')
               .with_mode(0123)
    }
  end
end
