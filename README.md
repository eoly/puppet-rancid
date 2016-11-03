[![Build Status](https://travis-ci.org/eoly/puppet-rancid.png?branch=master)](https://travis-ci.org/eoly/puppet-rancid)

# puppet-rancid

Rancid Puppet Module

This module will install the Rancid package, manage Rancid groups, initialize
per group router.db files, create the rancid-run cron job, and has the
capability to add router entries to your router.db file with Hiera. Also manages
.cloginrc.

===

# Compatibility

Compatible with Puppet v3 (starting at version 3.2.0) with and without
the future parser and Puppet v4 with Ruby versions 1.8.7, 1.9.3, 2.0.0,
2.1.0 and 2.3.1 on the following platforms.

* EL 6 (rancid package from [EPEL](https://fedoraproject.org/wiki/EPEL))
* Ubuntu 12.04 LTS

===

# class rancid

## Parameters

    'USE_DEFAULTS' denotes that defaults are made based on osfamily and other such factors.

filterpwds
----------
Determines which passwords are filtered from configs.

    NO – does not filter any password. All passwords are included in configs in RANCID repository

    YES – passwords which are stored in plain-text or using reversible enryption method will be removed from configs.

    ALL – all password will be removed from configs

NOTE: When setting password filtering be aware that RANCID is sending
configuration and changes via email, so including any passwords is not
recommended. String can be 'ALL', 'YES', or 'NO'.

- *Default*: 'ALL'

nocommstr
---------
Optionally strip snmp community strings from the configs. String can be 'YES'
or 'NO'.

- *Default*: 'YES'

maxrounds
---------
Defines how many times rancid should retry collection of
devices that fail. The minimum is 1.

- *Default*: '4'

oldtime
-------
Specified as a number of hours, OLDTIME defines how many hours should pass
since a successful collection of a device’s configuration and when
control_rancid(1) should start complaining about failures. The value should be
greater than the number of hours between rancid-run cron runs.

- *Default*: '4'

locktime
--------
Defines the number of hours a group’s lock file may age before rancid starts to
complain about a hung collection. String that must be a digit.

- *Default*: '4'

parcount
--------
Defines the number of rancid processes that par(1) will start simultaneously as
control_rancid(1) attempts to perform collections. Raising this value will
decrease the amount of time necessary for a complete collection of a (or all)
rancid groups at the expense of system load. The default is relatively
cautious. If collections are not completing quickly enough for users, use trial
and error of speed versus system load to find a suitable value. String that
must be a digit.

- *Default*: '5'

groups
------
Array of rancid groups.

- *Default*: [ 'routers', 'switches', 'firewalls' ]

devices
-------
Hash of devices. See Sample Hiera Structure.

- *Default*: undef

packages
--------
- *Default*: 'USE_DEFAULTS'

rancid_config
-------------
Path to rancid.conf.

- *Default*: 'USE_DEFAULTS'

rancid_path_env
---------------
PATH to use in rancid.conf.

- *Default*: 'USE_DEFAULTS'

homedir
-------
Rancid user's home directory.

- *Default*: 'USE_DEFAULTS'

logdir
------
Directory for storing rancid logs.

- *Default*: 'USE_DEFAULTS'

user
----
Rancid user.

- *Default*: 'USE_DEFAULTS'

group
-----
Rancid group

- *Default*: 'USE_DEFAULTS'

shell
-----
Rancid user's shell.

- *Default*: 'USE_DEFAULTS'

cron_d_file
-----------
Path to file in cron.d that will periodically execute rancid.

- *Default*: '/etc/cron.d/rancid'

cloginrc_content
----------------
Content of <tt>~rancid/.cloginrc</tt>

- *Default*: 'USE_DEFAULTS'

show_cloginrc_diff
------------------
Whether to show diffs of <tt>~rancid/.cloginrc</tt> during puppet runs.

- *Default*: true

===

# define rancid::router_db

## Example Usage
If you specify a hash in Hiera, you will not need to call this define directly.

## Parameters

devices
-------
Hash of devices. See Sample Hiera Structure.

- *Default*: undef

rancid_cvs_path
---------------
PATH for finding <tt>rancid-cvs</tt> and <tt>test</tt> programs.

- *Default*: '/bin:/usr/bin',

router_db_mode
--------------
Mode of <tt>router.db</tt> files.

- *Default*: '0640',

===

Sample Hiera Structure
----------------------
<pre>
rancid::cloginrc_content: |
  add autoenable * 1
  add method * ssh
  add user * rancid
  add password * mypassword

rancid::groups:
  - 'routers'
  - 'switches'
  - 'firewalls'

rancid::devices:
  routers:
    cr1.example.com: {
      hostname: 'cr1.example.com',
      type: 'juniper',
      status: 'up'
    }
    cr2.example.com: {
      hostname: 'cr2.example.com',
      type: 'juniper',
      status: 'up'
    }
  switches:
    as1.example.com: {
      hostname: 'as1.example.com',
      type: 'cisco',
      status: 'up'
    }
    as2.example.com: {
      hostname: 'as2.example.com',
      type: 'cisco',
      status: 'up'
    }
  firewalls:
    fw1.example.com: {
      hostname: 'fw1.example.com',
      type: 'cisco',
      status: 'up'
    }
</pre>

===

# License

[Apache Software License v2.0](http://www.apache.org/licenses/LICENSE-2.0.html)

===

# Support

Please log tickets and issues at our [Projects site](https://github.com/eoly/puppet-rancid)
