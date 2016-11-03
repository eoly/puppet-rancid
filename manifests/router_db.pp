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
    user    => $rancid::user_real,
    unless  => "test -d ${rancid::homedir_real}/${name}/CVS",
  }

  if ( $devices[$name] ) {
    file { "${rancid::homedir_real}/${name}/router.db":
      ensure  => 'file',
      owner   => $rancid::user_real,
      group   => $rancid::group_real,
      mode    => $router_db_mode,
      content => template('rancid/router.db.erb'),
      require => Exec["rancid-cvs-${name}"],
    }
  } else {
    notify { "rancid::router_db -- ${name} not found in devices hash.": }
  }
}
