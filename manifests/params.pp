class rancid::params {

  # Determines which passwords are filtered from configs by the
  # value set (NO | YES | ALL).  see rancid.conf(5).
  $rancid_filterpwds            = 'yes'

  # if NOCOMMSTR is set, snmp community strings will be stripped from the configs
  $rancid_nocommstr             = 'yes'

  # How many times failed collections are retried (for each run) before
  # giving up.  Minimum: 1
  $rancid_maxrounds             = 1

  # How many hours should pass before complaining about routers that
  # can not be reached.  The value should be greater than the number
  # of hours between your rancid-run cron job.  Default: 24
  $rancid_oldtime               = 4

  # How many hours should pass before complaining that a group's collection
  # (the age of it's lock file) is hung.
  $rancid_locktime              = 4

  # The number of devices to collect simultaneously.
  $rancid_parcount              = 5

  # list of rancid groups
  $rancid_groups                = [ 'routers', 'switches', 'firewalls' ]


  # OS specific parameters
  case $::operatingsystem {
    'debian', 'ubuntu': {
      $rancid_supported         = 'true'
      $rancid_packages          = [ 'rancid' ]
      $rancid_main_config       = '/etc/rancid/rancid.conf'
      $rancid_main_config_tpl   = 'rancid.conf.debian.erb'
      $rancid_router_db_tpl     = 'router.db.erb'
      $rancid_cron_tpl          = 'rancid-cron.debian.erb'
      $rancid_uid               = 'rancid'
      $rancid_gid               = 'rancid'
      $rancid_shell             = '/bin/bash'
      $rancid_homedir           = '/var/lib/rancid'
      $rancid_logdir            = '/var/log/rancid'
    }

    default: {
      notify { "${module_name} is unsupported for ${::operatingsystem}": }
    }
  }

}
