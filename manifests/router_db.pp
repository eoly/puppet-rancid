# == Define: rancid::router_db
#
define rancid::router_db (
  $devices         = undef,
  $rancid_cvs_path = '/bin:/usr/bin',
  $router_db_mode  = '0640',
) {

  exec { "rancid-cvs-${name}":
    command => "rancid-cvs ${name}",
    path    => $rancid_cvs_path,
    user    => $::rancid::user,
    unless  => "test -d ${::rancid::homedir}/${name}/CVS",
  }

  if ( $devices[$name] ) {
    file { "${::rancid::homedir}/${name}/router.db":
      ensure  => 'present',
      owner   => $::rancid::user,
      group   => $::rancid::group,
      mode    => $router_db_mode,
      content => template('rancid/router.db.erb'),
      require => Exec["rancid-cvs-${name}"],
    }
  } else {
    notify { "rancid::router_db -- ${name} not found in devices hash.": }
  }
}
