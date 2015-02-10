# == Class rancid::config
#
# This class is called from rancid
#
class rancid::config {

  file { $::rancid::rancid_config:
    ensure  => present,
    owner   => $::rancid::user,
    group   => $::rancid::user,
    mode    => '0640',
    content => template('rancid/rancid.conf.erb'),
    require => Package[$::rancid::package],
  }

  file { $::rancid::cron_d_file:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('rancid/rancid-cron.erb'),
    require => Package[$::rancid::package],
  }

  if ( $::rancid::devices ) {
    rancid::router_db { $::rancid::groups:
      devices         => $::rancid::devices,
      rancid_cvs_path => $::rancid::rancid_path_env,
      subscribe       => File[$::rancid::rancid_config],
      require         => Package[$::rancid::package],
    }
  }

  file { $::rancid::cloginrc_path:
    ensure  => file,
    owner   => $::rancid::user,
    group   => $::rancid::group,
    mode    => '0600',
    content => $::rancid::cloginrc_content,
  }

}
