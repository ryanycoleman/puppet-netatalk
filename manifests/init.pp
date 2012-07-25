# Class: netatalk
#
# This class manages netatalk
#
# Parameters:
#   none.
#   File,Package,Service params are set in netatalk::params
#
# Actions:
#  This class establishes a netatalk (afp) service by
#    * Installing the netatalk package
#    * Delivering a default netatalk config
#    * Establishing the netatalk service
#
# Requires:
#  The concat module by RI Pienaar
#
# Sample Usage:
#   include netatalk
class netatalk {

  include concat::setup
  include netatalk::params

  package { $netatalk::params::package_name:
    ensure => present,
  }

  file { $netatalk::params::config_dir:
    ensure  => directory,
    require => Package[$netatalk::params::package_name],
    notify  => Service[$netatalk::params::service_name],
  }

  file { $netatalk::params::global_config:
    ensure => file,
    content => template('netatalk/netatalk.conf.erb'),
    require => Package[$netatalk::params::package_name],
    notify  => Service[$netatalk::params::service_name],
  }

  service { $netatalk::params::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  concat { 'volumes':
    name  => $netatalk::params::volumes_config,
    owner => 'root',
    group => 'root',
  }

  concat { 'servers':
    name  => $netatalk::params::afpd_config,
    owner => 'root',
    group => 'root',
  }

  concat::fragment { 'volumes_default':
    target => $netatalk::params::volumes_config,
    source => 'puppet:///modules/netatalk/AppleVolumes.default',
    order => '01',
  }

  concat::fragment { 'afpd_conf':
    target => $netatalk::params::afpd_config,
    source => 'puppet:///modules/netatalk/afpd.conf',
    order => '01',
  }

}
