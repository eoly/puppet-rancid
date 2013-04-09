define rancid::router_db ($groupname = $title) {
  
  exec { "rancid-cvs-${groupname}":
    command => "rancid-cvs ${groupname}",
    path    => '/usr/bin:/usr/lib/rancid/bin',
    user    => $rancid::params::rancid_uid,
    unless  => "find /var/lib/rancid/${groupname} -type f -name router.db"
  }

  $rancid_devices = hiera("rancid::rancid_devices",undef)
  if ( $rancid_devices["${groupname}"] ) {
    file { "/var/lib/rancid/${groupname}/router.db":
      ensure  => 'present',
      owner   => $rancid_uid,
      group   => $rancid_gid,
      mode    => '0644',
      content => template("${module_name}/${rancid_router_db_tpl}"),
      require => Exec[ "rancid-cvs-${groupname}" ],
    }
  }
}
