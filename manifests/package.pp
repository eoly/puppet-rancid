class rancid::package {

  if ( $rancid_supported == 'true' ) {

    group { $rancid_gid:
      ensure  => 'present',
      system  => true,
    }

    user { $rancid_uid:
      ensure  => 'present',
      gid     => $rancid_gid,
      shell   => $rancid_shell,
      home    => $rancid_homedir,
      system  => true,
      require => Group[ $rancid_gid ],
    }

    file { 'logdir':
      ensure  => 'directory',
      path    => $rancid_logdir,
      owner   => $rancid_uid,
      group   => $rancid_gid,
      mode    => '0750',
      require => User[ 'rancid' ],
    }

    file { 'homedir':
      ensure  => 'directory',
      path    => $rancid_homedir,
      owner   => $rancid_uid,
      group   => $rancid_uid,
      mode    => '0750',
      require => User[ 'rancid' ],
    }

    package { $rancid_packages:
      ensure  => 'present',
      require => [ File[ 'logdir' ], File[ 'homedir' ], User[ 'rancid' ], Group[ 'rancid' ] ]
    }

    file { $rancid_main_config:
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${module_name}/${rancid_main_config_tpl}"),
      require => Package[ $rancid_packages ],
    }

    rancid::router_db { $rancid_groups:
      subscribe => File[ $rancid_main_config ],
      require   => Package[ $rancid_packages ],
    }

    file { '/etc/cron.d/rancid-cron':
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${module_name}/${rancid_cron_tpl}"),
      require  => Package[ $rancid_packages ],
    }

  }

}
