# == Define: rancid::router_db
#
define rancid::router_db (
  Hash $devices         = {},
  $rancid_cvs_path      = '/bin:/usr/bin',
  $router_db_mode       = '0640',
  Hash $vcs_remote_urls = {},
) {
  include rancid

  exec { "rancid-cvs-${name}":
    command => "rancid-cvs ${name}",
    path    => $rancid_cvs_path,
    user    => $rancid::user_real,
    unless  => "test -d ${rancid::homedir_real}/${name}/CVS",
  }

  if ( $vcs_remote_urls[$name] ) {
    $remote_url = $vcs_remote_urls[$name]
    exec { "setup git remote ${name}":
      command => "git remote set-url origin ${remote_url}",
      cwd     => "${rancid::homedir_real}/${name}",
      path    => $rancid_cvs_path,
      user    => $rancid::user_real,
      unless  => "git remote -v | grep ${remote_url}"
    }

    file { "post-commit hook for ${name}":
      path    => "${rancid::homedir_real}/${name}/.git/hooks/post-commit",
      content => "git push origin\n",
      owner   => $rancid::user_real,
      group   => $rancid::group_real,
      mode    => '0755',
    }

    file { "rancid default git remote ${name}":
      path   => "${rancid::homedir_real}/.git/${name}",
      ensure => absent,
      force  => true,
      backup => false,
    }
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
