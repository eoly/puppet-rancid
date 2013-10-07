# == Class: rancid
#
# Manage RANCID - http://www.shrubbery.net/rancid/
#
class rancid (
  $filterpwds       = 'ALL', # yes, no, all
  $nocommstr        = 'YES', # yes or no
  $maxrounds        = '4',
  $oldtime          = '4',
  $locktime         = '4',
  $parcount         = '5',
  $groups           = [ 'routers', 'switches', 'firewalls' ],
  $devices          = undef,
  $packages         = 'USE_DEFAULTS',
  $rancid_config    = 'USE_DEFAULTS',
  $rancid_path_env  = 'USE_DEFAULTS',
  $homedir          = 'USE_DEFAULTS',
  $logdir           = 'USE_DEFAULTS',
  $user             = 'USE_DEFAULTS',
  $group            = 'USE_DEFAULTS',
  $shell            = 'USE_DEFAULTS',
  $cron_d_file      = '/etc/cron.d/rancid',
  $cloginrc_content = 'USE_DEFAULTS',
) {

  # set default parameters

  $default_cloginrc_content = '# This file is being maintained by Puppet.\n# DO NOT EDIT\nConsult man page for cloginrc(5) for help.'

  case $::osfamily {
    default: {
      notify { "Rancid is unsupported for ${::operatingsystem}.": }
    }
    'Debian': {
      $default_packages        = [ 'rancid' ]
      $default_rancid_config   = '/etc/rancid/rancid.conf'
      $default_user            = 'rancid'
      $default_group           = 'rancid'
      $default_shell           = '/bin/bash'
      $default_homedir         = '/var/lib/rancid'
      $default_logdir          = '/var/log/rancid'
      $default_rancid_path_env = '/usr/lib/rancid/bin:/bin:/usr/bin:/usr/local/bin'
    }
    'RedHat': {
      case $::lsbmajdistrelease {
        '6': {
          $default_packages        = [ 'rancid' ]
          $default_rancid_config   = '/etc/rancid/rancid.conf'
          $default_user            = 'rancid'
          $default_group           = 'rancid'
          $default_shell           = '/bin/bash'
          $default_homedir         = '/var/rancid'
          $default_logdir          = '/var/log/rancid'
          $default_rancid_path_env = '/usr/libexec/rancid:/bin:/usr/bin:/usr/local/bin'
        }
        default: {
          fail("Rancid supports osfamily RedHat release 6. Detected operatingsystemmajrelease is <${::operatingsystemmajrelease}>.")
        }
      }
    }
  }

  if $packages == 'USE_DEFAULTS' {
    $packages_real = $default_packages
  } else {
    $packages_real = $packages
  }

  if $rancid_config == 'USE_DEFAULTS' {
    $rancid_config_real = $default_rancid_config
  } else {
    $rancid_config_real = $rancid_config
  }

  if $user == 'USE_DEFAULTS' {
    $user_real = $default_user
  } else {
    $user_real = $user
  }

  if $group == 'USE_DEFAULTS' {
    $group_real = $default_group
  } else {
    $group_real = $group
  }

  if $shell == 'USE_DEFAULTS' {
    $shell_real = $default_shell
  } else {
    $shell_real = $shell
  }

  if $homedir == 'USE_DEFAULTS' {
    $homedir_real = $default_homedir
  } else {
    $homedir_real = $homedir
  }

  if $logdir == 'USE_DEFAULTS' {
    $logdir_real = $default_logdir
  } else {
    $logdir_real = $logdir
  }

  if $cloginrc_content == 'USE_DEFAULTS' {
    $cloginrc_content_real = $default_cloginrc_content
  } else {
    $cloginrc_content_real = $cloginrc_content
  }

  if $rancid_path_env == 'USE_DEFAULTS' {
    $rancid_path_env_real = $default_rancid_path_env
  } else {
    $rancid_path_env_real = $rancid_path_env
  }

  # validate parameters
  validate_re($filterpwds, '^(yes|YES|no|NO|all|ALL)$',
    "rancid::filterpwds is <${filterpwds}> which does not match the regex of \'YES\', \'NO\', or \'ALL\'.")
  validate_re($nocommstr, '^(yes|YES|no|NO)$', "rancid::nocommstr is <${nocommstr}> which does not match the regex of \'YES\' or \'NO\'.")
  validate_re($maxrounds, '^[1-9]+(\d)?$', "rancid::maxrounds is ${maxrounds} and must be a number greater than zero.")
  validate_re($oldtime, '^(\d)+$', "rancid::oldtime is ${oldtime} and must match the regex of a number.")
  validate_re($locktime, '^(\d)+$', "rancid::locktime is ${locktime} and must match the regex of a number.")
  validate_re($parcount, '^(\d)+$', "rancid::parcount is ${parcount} and must match the regex of a number.")

  $groups_type = type($groups)
  if $groups_type != 'array' {
    fail("rancid::groups must be an array. Detected type is ${groups_type}.")
  }

  $packages_type = type($packages)
  if $packages_type != 'array' and $packages_type != 'string' {
    fail("rancid::packages must be an array or a string. Detected type is ${packages_type}.")
  }

  validate_absolute_path($rancid_config_real)
  validate_absolute_path($homedir_real)
  validate_absolute_path($logdir_real)
  validate_absolute_path($shell_real)
  validate_absolute_path($cron_d_file)

  $cloginrc_path = "${homedir_real}/.cloginrc"
  validate_absolute_path($cloginrc_path)

  package { 'rancid_packages':
    ensure => present,
    name   => $packages_real,
  }

  group { 'rancid_group':
    ensure  => present,
    name    => $group_real,
    system  => true,
    require => Package['rancid_packages'],
  }

  user { 'rancid_user':
    ensure  => present,
    name    => $user_real,
    gid     => $group_real,
    shell   => $shell_real,
    home   => $homedir_real,
    require => Package['rancid_packages'],
  }

  file { 'logdir':
    ensure  => directory,
    path    => $logdir_real,
    owner   => $user_real,
    group   => $group_real,
    mode    => '0750',
  }

  file { 'homedir':
    ensure  => directory,
    path    => $homedir_real,
    owner   => $user_real,
    group   => $group_real,
    mode    => '0750',
  }

  file { 'rancid_config':
    ensure  => present,
    path    => $rancid_config_real,
    owner   => $user_real,
    group   => $group_real,
    mode    => '0640',
    content => template('rancid/rancid.conf.erb'),
    require => Package['rancid_packages'],
  }

  file { 'rancid_cron_d_file':
    ensure  => present,
    path    => $cron_d_file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('rancid/rancid-cron.erb'),
    require => Package['rancid_packages'],
  }

  rancid::router_db { $groups:
    devices   => $devices,
    subscribe => File['rancid_config'],
    require   => Package['rancid_packages'],
  }

  file { 'rancid_cloginrc':
    ensure  => file,
    path    => $cloginrc_path,
    owner   => $user_real,
    group   => $group_real,
    mode    => '0600',
    content => $cloginrc_content_real,
  }
}
