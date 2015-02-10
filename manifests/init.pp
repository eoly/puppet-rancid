# == Class: rancid
#
# Full description of class rancid here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class rancid (
  $filterpwds       = 'ALL', # yes, no, all
  $nocommstr        = 'YES', # yes or no
  $maxrounds        = '4',
  $oldtime          = '4',
  $locktime         = '4',
  $parcount         = '5',
  $maildomain       = undef,
  $groups           = [ 'routers', 'switches', 'firewalls' ],
  $devices          = undef,
  $package          = $::rancid::params::package,
  $rancid_config    = $::rancid::params::rancid_config,
  $user             = $::rancid::params::user,
  $group            = $::rancid::params::group,
  $shell            = $::rancid::params::shell,
  $homedir          = $::rancid::params::homedir,
  $logdir           = $::rancid::params::logdir,
  $cron_d_file      = $::rancid::params::cron_d_file,
  $cloginrc_content = $::rancid::params::cloginrc_content,
  $rancid_path_env  = $::rancid::params::rancid_path_env
) inherits rancid::params {

  validate_re($filterpwds, '^(yes|YES|no|NO|all|ALL)$')
  validate_re($nocommstr, '^(yes|YES|no|NO)$')
  validate_re($maxrounds, '^[1-9]+(\d)?$')
  validate_re($oldtime, '^(\d)+$')
  validate_re($locktime, '^(\d)+$')
  validate_re($parcount, '^(\d)+$')
  if ($maildomain != undef ) {
    validate_re($maildomain,'^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}$')
  }

  validate_array($groups)
  validate_string($package)

  validate_absolute_path($rancid_config)
  validate_absolute_path($homedir)
  validate_absolute_path($logdir)
  validate_absolute_path($shell)
  validate_absolute_path($cron_d_file)

  $cloginrc_path = "${homedir}/.cloginrc"
  validate_absolute_path($cloginrc_path)


  class { 'rancid::install': } ->
  class { 'rancid::config': } ~>
  Class['rancid']
}
