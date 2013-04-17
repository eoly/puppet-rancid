puppet-rancid
=============

Rancid Puppet Module

This module will install the Rancid package, manage Rancid groups, initialize per group router.db files, create the rancid-run cron job, and has the capability to add router entries to your router.db file via Hiera. Currently you must handle your .cloginrc file with methods outside of this module.

Currently only tested on Puppet 3.x and Ubuntu Server.

Sample Hiera Structure
----------------------

rancid::rancid_groups:
  - 'routers'
  - 'switches'
  - 'firewalls'

rancid::rancid_devices:
  routers:
    rtr-edge-01: {
      hostname: 'nab-rtr-edge-01.example.com',
      type: 'cisco',
      status: 'up'
    }
    rtr-edge-02: {
      hostname: 'rtr-edge-02.example.com',
      type: 'cisco',
      status: 'up'
    }
  switches:
    swt-dc-01: {
      hostname: 'swt-dc-01.example.com',
      type: 'cisco',
      status: 'up'
    }
    swt-campus-01: {
      hostname: 'swt-campus-01.example.com',
      type: 'cisco',
      status: 'up'
    }
  firewalls:
    fw-01: {
      hostname: 'fw-01.example.com',
      type: 'cisco',
      status: 'up'
    }


License
-------
Apache 2.0

Contact
-------
eric@ericolsen.net

Support
-------

Please log tickets and issues at our [Projects site](https://github.com/eoly/puppet-rancid)
