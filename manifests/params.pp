# == Class rancid::params
#
# This class is meant to be called from rancid
# It sets variables according to platform
#
class rancid::params {

  $cloginrc_content = "# This file is being maintained by Puppet.\n# DO NOT EDIT\nConsult man page for cloginrc(5) for help."

  case $::osfamily {
    default: {
      notify { "Rancid is unsupported for ${::operatingsystem}.": }
    }
    'Debian': {
      $package         = 'rancid'
      $rancid_config   = '/etc/rancid/rancid.conf'
      $user            = 'rancid'
      $group           = 'rancid'
      $shell           = '/bin/bash'
      $homedir         = '/var/lib/rancid'
      $logdir          = '/var/log/rancid'
      $cron_d_file     = '/etc/cron.d/rancid'
      $rancid_path_env = '/usr/lib/rancid/bin:/bin:/usr/bin:/usr/local/bin'
    }
    'RedHat': {
      case $::operatingsystemmajrelease {
        '6': {
          $package         = 'rancid'
          $rancid_config   = '/etc/rancid/rancid.conf'
          $user            = 'rancid'
          $group           = 'rancid'
          $shell           = '/bin/bash'
          $homedir         = '/var/rancid'
          $logdir          = '/var/log/rancid'
          $cron_d_file     = '/etc/cron.d/rancid'
          $rancid_path_env = '/usr/libexec/rancid:/bin:/usr/bin:/usr/local/bin'
        }
        default: {
          fail("Rancid supports osfamily RedHat release 6. Detected operatingsystemmajrelease is <${::operatingsystemmajrelease}>.")
        }
      }
    }
  }
}
