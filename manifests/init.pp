# Class: netatalk
#
# This class manages netatalk
#
# Parameters:
#   none.
#   File,Package,Service params are set in netatalk
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
class netatalk(
  $package_name,
  $service_name,
  $config_dir,
  $global_config,
  $volumes_config,
  $afpd_config,
  $afp_service = true,
  $afp_port    = '548',
) {

  include concat::setup

  package { $netatalk::package_name:
    ensure => present,
  }

  file { $netatalk::config_dir:
    ensure  => directory,
    require => Package[$netatalk::package_name],
    notify  => Service[$netatalk::service_name],
  }

  file { $netatalk::global_config:
    ensure => file,
    content => template('netatalk/netatalk.conf.erb'),
    require => Package[$netatalk::package_name],
    notify  => Service[$netatalk::service_name],
  }

  service { $netatalk::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  concat { 'volumes':
    name  => $netatalk::volumes_config,
    owner => 'root',
    group => 'root',
  }

  concat { 'servers':
    name  => $netatalk::afpd_config,
    owner => 'root',
    group => 'root',
  }

  concat::fragment { 'volumes_default':
    target => $netatalk::volumes_config,
    source => 'puppet:///modules/netatalk/AppleVolumes.default',
    order => '01',
  }

  concat::fragment { 'afpd_conf':
    target => $netatalk::afpd_config,
    source => 'puppet:///modules/netatalk/afpd.conf',
    order => '01',
  }

}
