class rancid (
  $rancid_supported         = $rancid::params::rancid_supported,
  $rancid_packages          = $rancid::params::rancid_packages,
  $rancid_main_config       = $rancid::params::rancid_main_config,
  $rancid_main_config_tpl   = $rancid::params::rancid_main_config_tpl,
  $rancid_router_db_tpl     = $rancid::params::rancid_router_db_tpl,
  $rancid_uid               = $rancid::params::rancid_uid,
  $rancid_gid               = $rancid::params::rancid_gid,
  $rancid_shell             = $rancid::params::rancid_shell,
  $rancid_homedir           = $rancid::params::rancid_homedir,
  $rancid_logdir            = $rancid::params::rancid_logdir,
  $rancid_filterpwds        = $rancid::params::rancid_filterpwds,
  $rancid_nocommstr         = $rancid::params::rancid_nocommstr,
  $rancid_maxrounds         = $rancid::params::rancid_maxrounds,
  $rancid_oldtime           = $rancid::params::rancid_oldtime,
  $rancid_locktime          = $rancid::params::rancid_locktime,
  $rancid_parcount          = $rancid::params::rancid_parcount,
  $rancid_groups            = $rancid::params::rancid_groups,
) inherits rancid::params {

  include rancid::package

}
