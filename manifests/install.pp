# == Class rancid::install
#
class rancid::install {

  package { $::rancid::package:
    ensure => present,
  }

  group { $::rancid::group:
    ensure  => present,
    system  => true,
    require => Package[$::rancid::package],
  }

  user { $::rancid::user:
    ensure  => present,
    gid     => $::rancid::group,
    shell   => $::rancid::shell,
    home    => $::rancid::homedir,
    require => Package[$::rancid::package],
  }

  file { $::rancid::logdir:
    ensure => directory,
    owner  => $::rancid::user,
    group  => $::rancid::group,
    mode   => '0750',
  }

  file { $::rancid::homedir:
    ensure => directory,
    owner  => $::rancid::user,
    group  => $::rancid::group,
    mode   => '0750',
  }

}
