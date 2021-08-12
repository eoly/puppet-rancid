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

  context 'managing remote urls' do
    context 'we are managing them' do
      let(:params) {
        { :vcs_remote_urls => {
            'group1' => 'http://my-server/my-path.git',
          },
        }
      }

      it 'should point at the requested remote url' do
        should contain_exec('setup git remote group1')
                 .with_command('git remote set-url origin http://my-server/my-path.git')
                 .with_cwd('/var/lib/rancid/group1')
      end

      it 'should deploy a post commit hook to auto-push to the remote' do
        should contain_file('post-commit hook for group1')
      end

      it 'should remove the default (local) remote' do
        should contain_file('rancid default git remote group1')
      end
    end

    context 'we are not managing them' do
      let(:params) {
        {}
      }

      it {
        should_not contain_exec(/setup git remote/)
      }
    end
  end
end
